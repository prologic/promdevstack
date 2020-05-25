#!/usr/bin/env bash
# removes stack images
stack=( cadvisor promstack-base-image prometheusdev grafanadev alertmanagerdev)

for i in "${stack[@]}"; do
  printf "Removing container $i... "
  docker rmi $i >/dev/null 2>&1
  echo "OK"
done

printf "Removing container network from docker.. "
docker network rm promstack >/dev/null 2>&1
echo "OK"

echo "DONE"
