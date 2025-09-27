#!/usr/bin/bash

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

# Spawn new containers
docker compose up
