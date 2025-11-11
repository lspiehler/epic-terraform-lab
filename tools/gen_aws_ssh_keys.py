from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import ec
import argparse
from cryptography.hazmat.primitives.asymmetric import rsa

def convert_pkcs1_to_openssh(input_key_path, output_key_path):
    with open(input_key_path, "rb") as key_file:
        private_key = serialization.load_pem_private_key(
            key_file.read(), password=None, backend=default_backend()
        )

    # Convert to OpenSSH private key format
    openssh_private_key = private_key.private_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PrivateFormat.OpenSSH,
        encryption_algorithm=serialization.NoEncryption(),
    )

    with open(output_key_path, "wb") as key_out:
        key_out.write(openssh_private_key)
    
    print(f"Converted OpenSSH private key saved to {output_key_path}")

# Parse command line arguments
parser = argparse.ArgumentParser(description='Generate SSH keys.')
parser.add_argument('--type', choices=['rsa', 'ecc'], default='rsa', help='Type of key to generate (rsa or ecc)')
args = parser.parse_args()

# Generate the appropriate key based on the type argument
if args.type == 'rsa':
    private_key = rsa.generate_private_key(
        public_exponent=65537,
        key_size=2048
    )
elif args.type == 'ecc':
    private_key = ec.generate_private_key(ec.SECP256R1())

# Serialize the private key to PEM format
pem = private_key.private_bytes(
    encoding=serialization.Encoding.PEM,
    format=serialization.PrivateFormat.TraditionalOpenSSL,
    encryption_algorithm=serialization.NoEncryption()
)

pem_private_key = pem.decode('utf-8')

# Serialize the private key to OpenSSH format
openssh = private_key.private_bytes(
    encoding=serialization.Encoding.PEM,
    format=serialization.PrivateFormat.OpenSSH,
    encryption_algorithm=serialization.NoEncryption()
)

openssh_private_key = openssh.decode('utf-8')

ssh_public_key = private_key.public_key().public_bytes(
    encoding=serialization.Encoding.OpenSSH,
    format=serialization.PublicFormat.OpenSSH
).decode()

print('OpenSSH format (for connecting with SSH):')
print(openssh_private_key)
print('OpenSSL/PEM format (for use with the AWS/Azure portals):')
print(pem_private_key)
print('Public key (for use in Terraform code):')
print(ssh_public_key)