#!/usr/bin/env bash
set -ex

# promtool
[ "$1" == 'promtool' ] && shift && exec gosu prometheus /usr/local/bin/promtool "$@"

# run prometheus by default
if [ "$1" == 'prometheus' ]; then
    shift
    chown -R prometheus:prometheus /etc/prometheus
    exec gosu prometheus /usr/local/bin/prometheus              \
      --config.file=/etc/prometheus/prometheus.yml              \
      --storage.tsdb.path=/var/lib/prometheus                   \
      --web.console.templates=/etc/prometheus/consoles          \
      --web.console.libraries=/etc/prometheus/console_libraries \
      --web.listen-address=0.0.0.0:9090                         \
      --web.external-url=                                       \
      "$@"
fi

# else
exec "$@"
