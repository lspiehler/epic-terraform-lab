# Generate an SSH Key Pair for the Linux VM, update tfvars and store keys
```
python .\tools\gen_aws_ssh_keys.py
```

# Deploy the Ansible VM and login to the console

# Install prerequisites
```
sudo apt update
sudo apt install build-essential python3-dev libkrb5-dev git gh python3-venv
```

# Install VSCode
```
wget "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64" -O vscode.deb
sudo apt install ./vscode.deb

curl -Lk 'https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-x64' --output vscode_cli.tar.gz
tar -xf vscode_cli.tar.gz
sudo cp code /usr/bin/
```

# Create user(s) and switch to the user account
```
sudo adduser --disabled-password --shell /bin/bash <firstlast>
sudo su <firstlast>
```

# Create working directories and python venv. Install Ansible in the venv
```
cd ~
mkdir -p source/dev
cd source/dev
mkdir ~/venvs
python3 -m venv ~/venvs/ansible
source ~/venvs/ansible/bin/activate
pip3 install botocore boto3 "ansible-core>=2.18,<2.19" ansible-lint
```

# Launch VSCode Tunnel
```
screen -S vscode_tunnel
code tunnel user login --provider microsoft
code tunnel
```