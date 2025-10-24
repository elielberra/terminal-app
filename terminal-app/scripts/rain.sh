#!/bin/bash
# I vibe coded this entire script. I have no idea how it works.
# Credits go to ChatGPT
duration_ms=5000 # Number of miliseconds for which the rain will appear

clear

CSI=$'\e['
cleanup() {
  printf '%s' "${CSI}?25h${CSI}?7h${CSI}0m${CSI}2J${CSI}H"
}
trap cleanup EXIT INT
printf '%s' "${CSI}?25l${CSI}?7l"

get_size() {
  read lines cols < <(stty size 2>/dev/null || echo "24 80")
  cols=$((cols > 1 ? cols - 1 : cols))
}
get_size

trail=6
step=2
colors=(118 46 40 34 28 22)

declare -a y
for ((x=0; x<cols; x+=step)); do
  y[$x]=$((RANDOM % lines))
done

printf '%s' "${CSI}2J${CSI}H"

start=$(date +%s%3N)

while (( $(date +%s%3N) - start < duration_ms )); do
  get_size
  for ((x=0; x<cols; x+=step)); do  
    y[$x]=$(( (y[$x]+1) % lines ))
    for ((k=0; k<trail; k++)); do
      row=$(( (y[$x]-k+lines) % lines ))
      printf '%s' "${CSI}$((row+1));$((x+1))H"
      cidx=$k; (( cidx >= ${#colors[@]} )) && cidx=$((${#colors[@]}-1))
      printf '%s' "${CSI}38;5;${colors[$cidx]}m"
      printf '%d' $((RANDOM%2))
    done
    clear_row=$(( (y[$x]-trail+lines) % lines ))
    printf '%s' "${CSI}$((clear_row+1));$((x+1))H${CSI}0m "
  done
  sleep 0.08 # Set to a high value to prevent the Websocket from getting overloaded causing lag
done

clear
