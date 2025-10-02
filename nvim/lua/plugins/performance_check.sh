#!/bin/bash

total_time=0
iterations=10

for i in $(seq 1 $iterations); do
  nvim -c 'qall!' --startuptime startup.log
  time=$(grep . startup.log | tail -n 1 | awk '{print $1}')
  total_time=$(echo "$total_time + $time" | bc)
  echo "$time"
done

average_time=$(echo "scale=4; $total_time / $iterations" | bc)
echo "Average startup time: $average_time ms"
