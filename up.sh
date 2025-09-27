#!/usr/bin/bash

# Close Chrome Window with terminal-app
wmctrl -c "Web Terminal"

# Remove pre existing containers
docker compose down --remove-orphans

# Build the Go App
cd terminal-app
go build -o terminal-app main.go
cd ..

# Reload the apparmor profile
if ! sudo apparmor_parser -r -W /etc/apparmor.d/terminal-app-compiled; then
  echo "❌ Failed to reload AppArmor profile. Aborting."
  exit 1
fi

# Open new Chromw Window with terminal-app URL
# Run in background so docker compose stays attached and shows logs
# Wait 1 second for the container to run 
(sleep 1 && google-chrome --new-window http://localhost:8080) &

# Spawn new container
docker compose up
