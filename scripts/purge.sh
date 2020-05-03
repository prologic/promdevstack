#!/usr/bin/env bash
# removes stack images
stack=( promstack-base-image prometheusdev grafanadev alertmanagerdev)

for i in "${stack[@]}"; do
  printf "Removing container $i... "
  docker rmi $i >/dev/null 2>&1
  echo "OK"
done
echo "DONE"