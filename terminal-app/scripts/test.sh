#!/bin/bash

text="Hello there, welcome to my terminal!"
for ((i=0; i<${#text}; i++)); do
  printf "%s" "${text:$i:1}"
  sleep 0.03   # delay between letters (in seconds)
done
echo
