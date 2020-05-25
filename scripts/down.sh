#!/usr/bin/env bash
# bring the stack down
stack=( cadvisor prometheusdev grafanadev alertmanagerdev)

for i in "${stack[@]}"; do
  printf "Stopping $i... "
  docker stop $i >/dev/null 2>&1
  echo "OK"
done
