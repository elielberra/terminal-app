#!/bin/bash
# binary-rain.sh — 0/1 rain with falling streams

tput civis            # hide cursor
trap 'tput cnorm; printf "\e[0m\e[2J\e[H"; exit' INT

cols=$(tput cols)
lines=$(tput lines)

trail=6                              # tail length (bigger = longer trails)
step=2                               # use every Nth column (density)
colors=(118 46 40 34 28 22)          # bright -> dark greens (one per tail step)

# one drop per column we use
for ((x=0; x<cols; x+=step)); do
  y[$x]=$((RANDOM % lines))
done

printf "\e[2J"       # clear
while :; do
  for ((x=0; x<cols; x+=step)); do
    # advance this column's head
    y[$x]=$(( (y[$x]+1) % lines ))

    # draw head + fading tail
    for ((k=0; k<trail; k++)); do
      row=$(( (y[$x]-k+lines) % lines ))
      col=$x
      printf "\e[%d;%dH" $((row+1)) $((col+1))      # move cursor

      # pick color for this tail segment
      cidx=$k
      (( cidx >= ${#colors[@]} )) && cidx=$((${#colors[@]}-1))
      printf "\e[38;5;%sm" "${colors[$cidx]}"

      # draw a random 0/1
      printf "%d" $((RANDOM%2))
    done

    # clear the very last trail cell to keep tail length constant
    clear_row=$(( (y[$x]-trail+lines) % lines ))
    printf "\e[%d;%dH\e[0m " $((clear_row+1)) $((x+1))
  done

  sleep 0.03   # speed (smaller = faster)
done
