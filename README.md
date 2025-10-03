sudo ln -sf "$HOME/repos/terminal-app/terminal-app" /etc/apparmor.d/terminal-app
sudo ln -s /home/eliel/repos/terminal-app/apparmor/terminal-app-compiled /etc/apparmor.d/terminal-app-compiled

sudo apparmor_parser -r -W /etc/apparmor.d/terminal-app
sudo apparmor_parser -r -W /etc/apparmor.d/terminal-app-compiled

__________
install go
# download file from https://go.dev/dl/go1.24.7.linux-amd64.tar.gz
# Full tutorial https://go.dev/doc/install
rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.23.0.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
source ~/.bashrc


________________
# Connect app with my local terminal

export $(grep -v '^#' .env.dev | xargs)
$HOME/repos/terminal-app/terminal-app 


__________________
# Create ASCII art
# Install packages
sudo apt install mpv libcaca0
# Display video
mpv --vo=caca --ao=alsa --really-quiet media/escaloni.mp4
mpv --vo=caca --no-audio --really-quiet media/escaloni.mp4
mpv --vo=caca --no-audio --really-quiet media/arg-fnc.mp4
mpv --ao=alsa media/music --really-quiet

