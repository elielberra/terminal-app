#!/bin/bash

# Get container IP
CONTAINER_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' terminal-app)

# Drop stale rules from previous container IPs before adding the current one
while LINE=$(sudo iptables -L DOCKER-USER -n --line-numbers | grep 'block terminal-app outbound connections' | head -1 | awk '{print $1}') && [ -n "$LINE" ]; do
  sudo iptables -D DOCKER-USER "$LINE"
done

# Block all outbound traffic from the ip of terminal-app
sudo iptables -I DOCKER-USER -s "$CONTAINER_IP" -j DROP -m comment --comment "block terminal-app outbound connections"
