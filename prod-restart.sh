#!/bin/bash

# Remove pre existing containers
docker compose -f docker-compose-prod.yaml down --remove-orphans

# Reload the apparmor profile
[ ! -e /etc/apparmor.d/terminal-app ] && sudo ln -s /home/admin/terminal-app/apparmor/terminal-app /etc/apparmor.d/terminal-app
if ! sudo apparmor_parser -r -W /etc/apparmor.d/terminal-app; then
  echo "❌ Failed to reload AppArmor profile. Aborting."
  exit 1
fi

# Record current image IDs so we can tell after pulling whether they actually changed
OLD_TERMINAL_APP_ID=$(docker images -q elober/terminal-app:latest)
OLD_RAG_CHAIN_ID=$(docker images -q elober/rag-chain:latest)

# Pull latest images and spawn new container
if ! docker compose -f docker-compose-prod.yaml up -d --pull always; then
  echo "❌ Failed to spawn terminal-app container. Aborting."
  exit 1
fi

# Remove the superseded image, but only for services where a new image actually replaced it
NEW_TERMINAL_APP_ID=$(docker images -q elober/terminal-app:latest)
NEW_RAG_CHAIN_ID=$(docker images -q elober/rag-chain:latest)

if [ -n "$OLD_TERMINAL_APP_ID" ] && [ "$OLD_TERMINAL_APP_ID" != "$NEW_TERMINAL_APP_ID" ]; then
  echo "🧹 Pruning superseded terminal-app image ($OLD_TERMINAL_APP_ID)"
  docker rmi "$OLD_TERMINAL_APP_ID"
fi

if [ -n "$OLD_RAG_CHAIN_ID" ] && [ "$OLD_RAG_CHAIN_ID" != "$NEW_RAG_CHAIN_ID" ]; then
  echo "🧹 Pruning superseded rag-chain image ($OLD_RAG_CHAIN_ID)"
  docker rmi "$OLD_RAG_CHAIN_ID"
fi
