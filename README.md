
__________
# install go
```
# download file from https://go.dev/dl/go1.24.7.linux-amd64.tar.gz
# Full tutorial https://go.dev/doc/install
rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.23.0.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
source ~/.bashrc
```
________________
# Connect app with my local terminal
```
export $(grep -v '^#' .env.dev | xargs)
$HOME/repos/terminal-app/terminal-app 
```
__________________
# Create compiled bash script
`shc -r -f easter-egg.sh -o easter-egg`


__________________
# Install docker and git on AWS Debian machine
```
# Update package list
sudo apt update -y

# Install dependencies for apt over HTTPS
sudo apt install -y ca-certificates curl gnupg git

# Add Docker’s official GPG key
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package list again
sudo apt update -y

# Install Docker
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start and enable Docker
sudo systemctl start docker
sudo systemctl enable docker

# Add your user to the Docker group (to run without sudo)
sudo usermod -aG docker $USER

# Apply the new group without logging out
newgrp docker

# Clone repo
git clone https://github.com/elielberra/terminal-app.git
cd terminal-app

# Create SSL Certs
sudo apt install certbot python3-certbot-nginx -y
sudo certbot --nginx -d elielberra.com -d www.elielberra.com

# Start app
bash up-prod.sh
```

________________
# Docker RAM usage
`docker stats`