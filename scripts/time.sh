start_script_time=$(date +%s%3N)   # take start time in ms

timeout 2.5s bash scripts/rain2.sh 

end_script_time=$(date +%s%3N)     # take end time in ms

echo $((end_script_time - start_script_time)) "ms"   # this is the runtime in ms
