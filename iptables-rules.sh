#!/bin/bash

# Get container IP
CONTAINER_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' terminal-app)

# Block all outbound traffic from the ip of terminal-app
sudo iptables -I DOCKER-USER -s $CONTAINER_IP -j DROP -m comment --comment "block terminal-app outbound connections"
