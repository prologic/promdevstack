FROM promstack-base-image
ENV DEBIAN_FRONTEND=noninteractive
ARG version=6.7.3
ARG arch=amd64
ENV dl="https://dl.grafana.com/oss/release/grafana_${version}_${arch}.deb"
ENV deb="grafana_${version}_${arch}.deb"

# download and install grafana dependencies and the official apt package
ADD $dl  /tmp
RUN apt-get update && \
    apt-get install -y libfontconfig1 && \
    dpkg -i "/tmp/${deb}" && \
    rm "/tmp/${deb}" && \
    rm -rf /var/lib/apt/lists/*

COPY grafana-entrypoint.sh /usr/local/bin/
RUN chown grafana:grafana /usr/local/bin/grafana-entrypoint.sh && \
    chmod +x /usr/local/bin/grafana-entrypoint.sh && \
    ln -s /usr/local/bin/grafana-entrypoint.sh /

WORKDIR /usr/share/grafana
EXPOSE 3090
ENTRYPOINT [ "grafana-entrypoint.sh" ]
CMD ["grafana"]
