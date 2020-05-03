#!/usr/bin/env bash
# brings up the monitoring stock
stack=( prometheusdev grafanadev alertmanagerdev )

# display links and exit
function exit_0 () {
  echo
  echo "Links:"
  echo "  prometheus   => http://localhost:9090"
  echo "  grafana      => http://localhost:?"
  echo "  alertmanager => http://localhost:?"  
  exit 0
}

function tryresume () {
  # check if it's running already
  running=$(docker inspect -f '{{.State.Running}}' "$1" 2>&1)
  [ "$running" == "true" ] && echo "  - ${1} already running" && return 0

  # try to resume
  exit_code=$(docker inspect -f '{{.State.ExitCode}}' "$1" 2>&1)
  [ "$running" == "false" ] && [ $exit_code -eq 0 ] && printf "  - resuming ${1}... " && $(docker start $1 >/dev/null 2>&1) && echo "OK" && return 0

  #else
  return 1
}

function trystart () {
  case "$1" in
    prometheusdev)
      printf "  - starting prometheus... "
      prom_cmd="docker run -d --name prometheusdev -p 9090:9090 -v $(pwd)/configs/prometheus.yml:/etc/prometheus/prometheus.yml prometheusdev"
      $prom_cmd >/dev/null 2>&1 && echo "OK" && return 0
      # failed.. run the command again so they can see the issue
      echo FAIL
      echo "    try removing any existing failed prometheusdev containers (ie.. \`docker ps -a\` && \`docker rm <containername>\`)"
      return 1
    ;;
    grafanadev)
      printf "  - starting grafana... " && echo OK
    ;;
    alertmanagerdev)
      printf "  - starting alertmanager... " && echo OK
    ;;
  esac
}

# is docker running?
docker info >/dev/null 2>&1
[ $? -ne 0 ] && echo "Error launching stack.. is Docker running?" && exit 1

echo "Bringing up the stack:"
for i in "${stack[@]}"; do
  # first try to start/resume stopped containers
  tryresume $i || trystart $i
done

exit_0