#!/usr/bin/env bash
set -ex

# amtool
[ "$1" == 'amtool' ] && shift && gosu alertmanager /usr/local/bin/amtool "$@"

# alertmanager (default)
if [ "$1" == 'alertmanager' ]; then
    shift
    chown -R alertmanager:alertmanager /etc/alertmanager
    exec gosu alertmanager /usr/local/bin/alertmanager    \
      --config.file=/etc/alertmanager/alertmanager.yml    \
      "$@"
fi

# else
exec "$@"
