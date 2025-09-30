import os
import sys
#from pathlib import Path
import argparse
#import validators
#import re
from hcl import load

sensitive_ports = ["22", "3389"]

failed_tests = []

def fail_test(tests, error):
    #sys.stderr.write(error + "\r\n")
    tests.append(error)
    #exit(1)

parser = argparse.ArgumentParser()
parser.add_argument('--tfvars', help='The path to your tfvars file')
args = parser.parse_args()

tfvars = args.tfvars

if not type(tfvars) == str:
    fail_test(failed_tests, "Error: a path to a valid tfvars file must be supplied with the --tfvars arg")
else :
    if not os.path.isfile(tfvars): fail_test(failed_tests, "Error: " + tfvars + " does not exist")

#check if prerequisite tests failed
if len(failed_tests) >= 1:
    for test in failed_tests:
        sys.stderr.write(test + "\r\n")
    exit(1)

with open(tfvars, 'r') as fp:
    tf = load(fp)

    ### NETWORK TESTS
    for network in tf["networks"]:
        #make sure the resource group specified for each vnet is defined
        if tf["networks"][network]["resource_group"] not in tf["rgs"]: fail_test(failed_tests, "Invalid resource group \"" + tf["networks"][network]["resource_group"] + "\" specified for network \"" + network + "\"")
        # make sure all peerings are for defined networks
        for peering in tf["networks"][network]["peerings"]:
            if peering not in tf["networks"]: fail_test(failed_tests, "Invalid peering network \"" + peering + "\" specified for network \"" + network + "\"")
        for subnet in tf["networks"][network]["subnets"]:
            if "network_security_group" in tf["networks"][network]["subnets"][subnet] and tf["networks"][network]["subnets"][subnet]["network_security_group"] not in tf["nsgs"]: fail_test(failed_tests, "Invalid network_security_group \"" + tf["networks"][network]["subnets"][subnet]["network_security_group"] + "\" specified for subnet \"" + subnet + "\"")

    ### VM tests
    vm_types = ["windows_vms", "linux_vms"]
    for vm_type in vm_types:
        #print(vm_type)
        if vm_type in tf:
            for vm in tf[vm_type]:
                #servername can only be specified for VMs with a count of less than 2
                if "names" in tf[vm_type][vm] and "count" in tf[vm_type][vm] : fail_test(failed_tests, "\"names\" and \"count\" are both defined for \"" + vm + ".\" Only one should be defined.")
                if "names" not in tf[vm_type][vm] and "count" not in tf[vm_type][vm] : fail_test(failed_tests, "Neither \"names\" nor \"count\" are defined for \"" + vm + ".\" One must be defined.")
                #make sure nics are associated with valid subnets
                #print(tf["vms"][vm])
                for nic in tf[vm_type][vm]["nics"]:
                    for i in range(0, len(tf[vm_type][vm]["nics"][nic]["ip_configuration"])):
                        netsub = tf[vm_type][vm]["nics"][nic]["ip_configuration"][i]["subnet"].split(".")
                        network = netsub[0]
                        subnet = netsub[1]
                        if network not in tf["networks"] or subnet not in tf["networks"][network]["subnets"]: fail_test(failed_tests, "Invalid subnet \"" + tf[vm_type][vm]["nics"][nic]["ip_configuration"][i]["subnet"] + "\" specified for ip_configuration " + str(i) + " on vm \"" + vm + "\" (Subnet must be specified in format <network>.<subnet>)")


    ### NSG TESTS
    for nsg in tf["nsgs"]:
        #make sure all nsgs have a resource_group attribute defined
        if "resource_group" not in tf["nsgs"][nsg]: fail_test(failed_tests, "NSG \"" + nsg + "\" has no resource_group attribute")
        #make sure the resource group specified for each nsg is defined
        if tf["nsgs"][nsg]["resource_group"] not in tf["rgs"]: fail_test(failed_tests, "Invalid resource group \"" + tf["nsgs"][nsg]["resource_group"] + "\" specified for nsg \"" + nsg + "\"")
        #make sure all nsgs have a rules attribute defined
        #print(type(tf["nsgs"][nsg]["rules"]))
        if "rules" not in tf["nsgs"][nsg] or type(tf["nsgs"][nsg]["rules"]) is not dict or len(tf["nsgs"][nsg]["rules"]) <= 0:
            fail_test(failed_tests, "NSG \"" + nsg + "\" has no rules defined")
        else:
            #make sure the list of rules specified for each nsg is defined
            for rule in tf["nsgs"][nsg]["rules"]:
                if rule not in tf["rules"]: fail_test(failed_tests, "Invalid rule \"" + rule + "\" specified for nsg \"" + nsg + "\"")

    ### RULE TESTS
    for rule in tf["rules"]:
        #make sure all rules have a destination_port_ranges attribute defined
        if "destination_port_ranges" not in tf["rules"][rule] and "destination_port_range" not in tf["rules"][rule]: fail_test(failed_tests, "Rule \"" + rule + "\" has no resource_group attribute")
        #make sure sensitive ports have source_address_prefixes defined
        if "destination_port_ranges" in tf["rules"][rule]:
            for port in tf["rules"][rule]['destination_port_ranges']:
                rule_fail = False
                if "access" in tf["rules"][rule]:
                    if tf["rules"][rule]["access"] != "Deny":
                        rule_fail = True
                elif "direction" in tf["rules"][rule]:
                    if tf["rules"][rule]["direction"] != "Outbound":
                        rule_fail = True
                else:
                    rule_fail = True
                if rule_fail:
                    if port in sensitive_ports and ("source_address_prefixes" not in tf["rules"][rule] or tf["rules"][rule]["source_address_prefixes"][0] == "*") and (tf["rules"][rule]["direction"] != "Outbound"): fail_test(failed_tests, "Rule \"" + rule + "\" allows port " + port + " and should only allow specific source_address_prefixes")
    ##Add check for destination_port_range
            
if len(failed_tests) >= 1:
    for test in failed_tests:
        sys.stderr.write(test + "\r\n")
    sys.stderr.write(str(len(failed_tests)) + " test(s) failed 💩\r\n")
    exit(1)
else:
    print("All tests passed 😊")