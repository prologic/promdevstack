#!/usr/bin/env bash
# removes stack containers
stack=( prometheusdev grafanadev alertmanagerdev)

for i in "${stack[@]}"; do
  printf "Removing container $i... "
  docker rm $i >/dev/null 2>&1
  echo "OK"
done
