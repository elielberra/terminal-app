#!/usr/bin/bash

docker compose down --remove-orphans

cd terminal-app
go build -o terminal-app main.go
source .env.dev
cd ..

if ! sudo apparmor_parser -r -W /etc/apparmor.d/terminal-app-compiled; then
  echo "❌ Failed to reload AppArmor profile. Aborting."
  exit 1
fi

docker compose up
