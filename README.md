
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