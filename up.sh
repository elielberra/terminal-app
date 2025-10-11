#!/bin/bash

# Close Chrome Window with terminal-app
wmctrl -c "Web Terminal"

# Remove pre existing containers
docker compose down --remove-orphans

# Build the Go App
cd terminal-app
if ! go build -o terminal-app main.go; then
  echo "❌ Failed to build Go App. Aborting."
  exit 1
fi
sudo chmod 0100 terminal-app
# Ownsership to app-user (id 1000)
sudo chown 1000:1000 terminal-app
# Add change UID and GUI capabilities to build file
sudo setcap cap_setuid,cap_setgid+ep terminal-app
cd ..

# Reload the apparmor profile
if ! sudo apparmor_parser -r -W /etc/apparmor.d/terminal-app; then
  echo "❌ Failed to reload AppArmor profile. Aborting."
  exit 1
fi

# Open new Chromw Window with terminal-app URL
# Run in background so docker compose stays attached and shows logs
# Wait 1 second for the container to run 
(sleep 2 && google-chrome --new-window http://localhost) &

# Spawn new container
if ! docker compose up --build; then
  echo "❌ Failed to spawn terminal-app container. Aborting."
  exit 1
fi

