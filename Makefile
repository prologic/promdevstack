.DEFAULT_GOAL := help
.PHONY: help build base prometheus grafana alertmanager start up stop down reload local-exporter clean purge status ps
help: ## Displays help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

rebuild: build
build: clean base prometheus grafana alertmanager ## (Re)builds all the docker images (you can also build individually by running 'make build-prometheus' etc)

base: ## (Re)build the promstack-base-image (runs os package updates)
	docker build --no-cache -t promstack-base-image -f docker/Dockerfile.base ./docker

prometheus: ## (Re)build the prometheusdev image
	docker build -t prometheusdev -f docker/prometheus/Dockerfile ./docker/prometheus

grafana: ## (Re)build the grafanadev image
	docker build -t grafanadev -f docker/grafana/Dockerfile ./docker/grafana

alertmanager: ## (Re)build the alertmanagerdev image
	docker build -t alertmanagerdev -f docker/alertmanager/Dockerfile ./docker/alertmanager

up: start ## Bring the stack up.
start:
	@./scripts/up.sh

stop: down ## Bring the stack down.
down: 
	@./scripts/down.sh

reload: ## Run this after making configuration changes (sends SIGHUP instead of restarting containers).
	@docker kill --signal=SIGHUP prometheusdev > /dev/null 2>&1
	@docker kill --signal=SIGHUP alertmanagerdev > /dev/null 2>&1
	@docker kill --signal=SIGHUP grafanadev > /dev/null 2>&1

status: ps ## Display status of the docker containers.
ps: ## alias for status
	@docker ps --filter "name=cadvisor" --filter "name=prometheusdev" --filter "name=grafanadev" --filter "name=alertmanagerdev"
	@echo
	@echo "Links:"
	@echo "  grafana       => http://localhost:3000 user 'admin' password 'grafana'"
	@echo "  prometheus    => http://localhost:9090"
	@echo "  alertmanager  => http://localhost:9093"
	@echo "  cadvisor      => http://localhost:9080"

local-exporter: ## Installs a local node-exporter if on Mac, Linux, or inside a Windows WSL session
	@echo TODO

clean: down ## Stops the stack if running and removes containers.
	@./scripts/clean.sh

purge: clean ## Stops the stack if running, removes containers, and removes any images built with 'make build'
	@./scripts/purge.sh
