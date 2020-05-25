#!/usr/bin/env bash
set -ex

# grafana-cli
[ "$1" == "grafana-cli" ] && shift && gosu grafana grafana-cli "$@"

# grafana (default)
if [ "$1" == 'grafana' ]; then
    chown -R grafana:grafana /etc/grafana
    chown -R grafana:grafana /var/lib/grafana
    chown -R grafana:grafana /usr/share/grafana
    
    exec gosu grafana /usr/sbin/grafana-server                \
      --config=${CONF_FILE}                                   \
      --packaging=deb                                         \
      cfg:default.paths.data=${DATA_DIR}                      \
      cfg:default.paths.plugins=${PLUGINS_DIR}                \
      cfg:default.paths.provisioning=${PROVISIONING_CFG_DIR}  \
      cfg:default.log.mode=console
fi

# else
exec "$@"
