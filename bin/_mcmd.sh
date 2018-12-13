#!/bin/bash

CMD=$1

my_hosts=(10.10.10.130 10.10.10.131 10.10.10.132 10.10.10.133 10.10.10.134)

for i in ${my_hosts[@]}; do
  echo "${i^^}"
  ssh -t $i "$CMD"
  #ssh -T $i "$CMD"
done
