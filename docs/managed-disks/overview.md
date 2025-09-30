## Supported Block Storage Configurations

* [Create and attach storage using only variables nested within the VM](nested.md) - Ideal for stateless VMs that won't require storage to be reconfigured, moved, or reattached in the future. This configuration is required for VM variable blocks that create more than one VM.
* [Create storage independent of any VM that can be detached and reattached as needed](external.md) - Recommended for databases and other VMs that have critical data. This configuration can only be used with VM variable blocks that make a single VM.
* [Reference storage unmanaged by Terraform to attach to an VM](unmanaged.md) - Required when VMs need to be attached to storage not created by Terraform.

**Note:** The different methods of defining block storage may be combined to create a flexible storage configuration.