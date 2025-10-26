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
  lines=$(tput lines 2>/dev/null || echo 24)
  cols=$(tput cols 2>/dev/null || echo 80)
}
get_size

trail=6
step=1
speed=2
colors=(118 46 40 34 28 22)

declare -a y
declare -a active
for ((x=0; x<cols; x+=step)); do
  if (( RANDOM % 3 == 0 )); then
    active[$x]=1
    y[$x]=$(( - (RANDOM % lines) ))
  else
    active[$x]=0
  fi
done

printf '%s' "${CSI}2J${CSI}H"

start=$(date +%s%3N)

while (( $(date +%s%3N) - start < duration_ms )); do
  get_size
  for ((x=0; x<cols; x+=step)); do
    (( active[$x] == 0 )) && continue
    y[$x]=$(( y[$x] + speed ))
    for ((k=0; k<trail; k++)); do
      row=$(( y[$x] - k ))
      (( row < 0 || row >= lines )) && continue
      printf '%s' "${CSI}$((row+1));$((x+1))H"
      cidx=$k; (( cidx >= ${#colors[@]} )) && cidx=$((${#colors[@]}-1))
      printf '%s' "${CSI}38;5;${colors[$cidx]}m"
      printf '%d' $((RANDOM%2))
    done
    for ((d=0; d<speed; d++)); do
      clear_row=$(( y[$x] - trail - d ))
      (( clear_row >= 0 && clear_row < lines )) && \
        printf '%s' "${CSI}$((clear_row+1));$((x+1))H${CSI}0m "
    done
    (( y[$x] - trail >= lines )) && y[$x]=$(( - (RANDOM % lines) ))
    printf '%s' "${CSI}0m"
  done
  sleep 0.1
done

clear
