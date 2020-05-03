# builder
FROM promstack-base-image
ARG promversion=2.17.2
ARG promarch=linux-amd64
ENV promdl="https://github.com/prometheus/prometheus/releases/download/v${promversion}/prometheus-${promversion}.${promarch}.tar.gz"

RUN groupadd prometheus && \
    useradd -s /sbin/nologin --system -g prometheus prometheus

RUN mkdir -p /etc/prometheus/rules && \
    mkdir -p /etc/prometheus/rules.d && \
    mkdir -p /etc/prometheus/files_sd && \
    mkdir -p /var/lib/prometheus && \
    mkdir -p /svc/prometheus && \
    chown prometheus:prometheus /var/lib/prometheus && \
    chown prometheus:prometheus /svc/prometheus

WORKDIR /svc/prometheus
ADD $promdl  .
RUN tar -xzf prometheus-$promversion.$promarch.tar.gz && \
    mv prometheus*/prometheus /usr/local/bin/ && \
    mv prometheus*/promtool /usr/local/bin/ && \
    mv prometheus*/prometheus.yml /etc/prometheus/ && \
    mv prometheus*/consoles* /etc/prometheus/ && \
    chown -R prometheus:prometheus /etc/prometheus && \
    chown prometheus:prometheus /usr/local/bin/prometheus && \
    chown prometheus:prometheus /usr/local/bin/promtool && \
    rm -rf prometheus*

COPY prometheus-entrypoint.sh /usr/local/bin/
RUN chown prometheus:prometheus /usr/local/bin/prometheus-entrypoint.sh && \
    chmod +x /usr/local/bin/prometheus-entrypoint.sh && \
    ln -s /usr/local/bin/prometheus-entrypoint.sh /

USER prometheus
EXPOSE 9090
ENTRYPOINT [ "prometheus-entrypoint.sh" ]
CMD ["prometheus"]
