#!/bin/bash
start=$(date +%s)         # register start time
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

# ---- helpers without awk ----
# convert a decimal seconds string (e.g., "2.5") to integer nanoseconds
to_ns() {
  local d="$1" sec frac frac9
  if [[ "$d" == *.* ]]; then
    sec="${d%%.*}"
    frac="${d#*.}"
  else
    sec="$d"
    frac="0"
  fi
  # right-pad fractional to 9 digits, then truncate to 9
  frac9="$(printf '%-9s' "$frac" | tr ' ' '0')"
  frac9="${frac9:0:9}"
  printf '%s' $(( 10#$sec*1000000000 + 10#$frac9 ))
}

# return min(remaining, 0.03) as a string suitable for `sleep`,
# computed using integer nanoseconds to avoid float math
min_sleep_str() {
  local rem_ns="$1"
  local step_ns=30000000   # 0.03s in ns
  if (( rem_ns <= 0 )); then
    printf '0'
    return
  fi
  if (( rem_ns < step_ns )); then
    # produce "S.NNNNNNNNN"
    local s=$(( rem_ns/1000000000 ))
    local ns=$(( rem_ns%1000000000 ))
    printf '%d.%09d' "$s" "$ns"
  else
    printf '0.03'
  fi
}

# duration in seconds (can be a decimal)
duration="2.5"

# start and end in nanoseconds
start_ns=$(date +%s%N)
end_ns=$(( start_ns + $(to_ns "$duration") ))

while :; do
  now_ns=$(date +%s%N)
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

  remaining_ns=$(( end_ns - now_ns ))
  sleep "$(min_sleep_str "$remaining_ns")"
done

# clear
end=$(date +%s)           # register end time
echo $((end - start))     # total execution time in seconds