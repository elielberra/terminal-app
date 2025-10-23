#!/bin/bash

# Remove pre existing containers
docker compose down --remove-orphans

# Reload the apparmor profile
if ! sudo apparmor_parser -r -W /etc/apparmor.d/terminal-app; then
  echo "❌ Failed to reload AppArmor profile. Aborting."
  exit 1
fi

# Spawn new container
if ! docker compose up --build; then
  echo "❌ Failed to spawn terminal-app container. Aborting."
  exit 1
fi

