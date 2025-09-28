#!/bin/bash

clear 
CSI=$'\e['
cleanup() {
  printf '%s' "${CSI}?25h${CSI}?7h${CSI}0m${CSI}2J${CSI}H"
}
trap cleanup EXIT INT
printf '%s' "${CSI}?25l${CSI}?7l"   # hide cursor, disable wrap

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

# duration in seconds (can be a decimal)
duration="2.5"

# convert duration to nanoseconds (integer) using awk (portable)
duration_ns=$(awk -v d="$duration" 'BEGIN { printf "%d", d * 1e9 }')

# start and end in nanoseconds
start_ns=$(date +%s%N)
end_ns=$(( start_ns + duration_ns ))

while :; do
  now_ns=$(date +%s%N)
  # stop when we reach or pass end time
  (( now_ns >= end_ns )) && break

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

  # compute remaining time in seconds (float) using awk and sleep a short amount
  remaining_ns=$(( end_ns - now_ns ))
  # if remaining is very small, break to avoid negative sleeps
  if (( remaining_ns <= 0 )); then
    break
  fi

  # choose a sleep duration: min(0.03, remaining)
  # convert remaining_ns to seconds string
  remaining_sec=$(awk -v n="$remaining_ns" 'BEGIN { printf "%.6f", n/1e9 }')
  # small step to keep animation smooth but not overshoot
  step_sleep=0.03
  # if remaining < step_sleep, sleep remaining; else sleep step_sleep
  awk -v rem="$remaining_sec" -v step="$step_sleep" 'BEGIN { if (rem < step) printf "%f", rem; else printf "%f", step }' | xargs sleep

done

clear
