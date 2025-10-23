#!/bin/bash

# Remove pre existing containers
docker compose -f docker-compose-prod.yaml down --remove-orphans

# Reload the apparmor profile
[ ! -e /etc/apparmor.d/terminal-app ] && sudo ln -s /home/admin/terminal-app/apparmor/terminal-app /etc/apparmor.d/terminal-app
if ! sudo apparmor_parser -r -W /etc/apparmor.d/terminal-app; then
  echo "❌ Failed to reload AppArmor profile. Aborting."
  exit 1
fi

# Spawn new container
if ! docker compose -f docker-compose-prod.yaml up --build; then
  echo "❌ Failed to spawn terminal-app container. Aborting."
  exit 1
fi

