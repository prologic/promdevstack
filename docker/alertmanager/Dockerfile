# builder
FROM promstack-base-image
ARG version=0.20.0
ARG arch=linux-amd64
ENV dl="https://github.com/prometheus/alertmanager/releases/download/v${version}/alertmanager-${version}.${arch}.tar.gz"

RUN groupadd alertmanager && \
    useradd -s /sbin/nologin --system -g alertmanager alertmanager

RUN mkdir -p /etc/alertmanager/template && \
    mkdir -p /svc/alertmanager && \
    chown -R alertmanager:alertmanager /etc/alertmanager && \
    chown alertmanager:alertmanager /svc/alertmanager

WORKDIR /svc/alertmanager
ADD $dl  .
RUN tar -xzf "alertmanager-${version}.${arch}.tar.gz" && \
    mv alertmanager*/alertmanager /usr/local/bin/ && \
    mv alertmanager*/amtool /usr/local/bin/ && \
    chown alertmanager:alertmanager /usr/local/bin/alertmanager && \
    chown alertmanager:alertmanager /usr/local/bin/amtool && \
    rm -rf alertmanager*

COPY alertmanager-entrypoint.sh /usr/local/bin/
RUN chown alertmanager:alertmanager /usr/local/bin/alertmanager-entrypoint.sh && \
    chmod +x /usr/local/bin/alertmanager-entrypoint.sh && \
    ln -s /usr/local/bin/alertmanager-entrypoint.sh /

EXPOSE 9090
ENTRYPOINT [ "alertmanager-entrypoint.sh" ]
CMD ["alertmanager"]
