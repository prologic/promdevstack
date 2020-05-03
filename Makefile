.DEFAULT_GOAL := help
.PHONY: help build build-base build-prometheus start up stop down reload local-exporter clean purge status ps
help: ## Displays help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build: build-base build-prometheus ## (Re)builds all the docker images (you can also build individually by running 'make build-prometheus' etc)

build-base:
	docker build --no-cache -t promstack-base-image -f docker/Dockerfile.base ./docker

build-prometheus:
	docker build -t prometheusdev -f docker/prometheus/Dockerfile ./docker/prometheus

up: start ## Bring the stack up.
start:
	@./scripts/up.sh

stop: down ## Bring the stack down.
down: 
	@./scripts/down.sh

reload: ## Run this after making configuration changes (sends SIGHUP instead of restarting containers).
	@docker kill --signal=SIGHUP prometheusdev > /dev/null 2>&1

status: ps ## Display status of the docker containers.
ps: ## alias for status
	@docker ps --filter "name=prometheusdev" --filter "name=grafanadev" --filter "name=alertmanagerdev"

local-exporter: ## Installs a local node-exporter if on Mac, Linux, or inside a Windows WSL session
	@:

clean: down ## Stops the stack if running and removes containers.
	@./scripts/clean.sh

purge: clean ## Stops the stack if running, removes containers, and removes any images built with 'make build'
	@./scripts/purge.sh
