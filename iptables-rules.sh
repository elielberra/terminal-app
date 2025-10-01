#!/bin/bash

# Get container IP
CONTAINER_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' terminal-app)

# Block all outbound traffic from the ip of terminal-app
sudo iptables -I DOCKER-USER -s $CONTAINER_IP -j DROP -m comment --comment "block terminal-app outbound connections"

# # Allow inbound traffic only to port 8080
# sudo iptables -I DOCKER-USER -d $CONTAINER_IP -p tcp --dport 8080 -j ACCEPT "allpw terminal-app inbound tcp connections on :8080"

# # Drop all other inbound traffic
# sudo iptables -I DOCKER-USER -d $CONTAINER_IP -j DROP "block terminal-app inbound connections"

## Remove firewall rules
# sudo iptables -F DOCKER-USER
