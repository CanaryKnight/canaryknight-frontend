# Executables (local)
DOCKER_COMP = docker compose

# Docker containers
APP_CONT = $(DOCKER_COMP) exec app

# Executables
YARN     = $(APP_CONT) yarn
VUE      = $(APP_CONT) vue

# Misc
.DEFAULT_GOAL = help
.PHONY        = help build up start down logs sh composer vendor sf cc

## —— Help —————————————————————————————————————————————————————————————————————
help: ## Outputs this help screen
	@grep -E '(^[a-zA-Z0-9_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}{printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'

## —— Docker ———————————————————————————————————————————————————————————————————
dev: ## Build dev Docker images & output logs
	@$(DOCKER_COMP)  -f docker-compose.yml -f docker-compose.dev.yml up --build --remove-orphans

build: ## Builds prod Docker images
	@$(DOCKER_COMP)  -f docker-compose.yml -f docker-compose.prod.yml build --pull --no-cache

up: ## Start the docker container in detached mode (no logs)
	@$(DOCKER_COMP) -f docker-compose.yml -f docker-compose.prod.yml up --detach

start: build up ## Build and start the containers

down: ## Stop the docker hub
	@$(DOCKER_COMP) down --remove-orphans

logs: ## Show live logs
	@$(DOCKER_COMP) logs --tail=0 --follow

sh: ## Connect to shell in APP container
	@$(APP_CONT) sh

## —— NPM ——————————————————————————————————————————————————————————————
yarn: ## Run yarn, pass the parameter "c=" to run a given command, example: make yarn c='yarn add vue'
	@$(eval c ?=)
	@$(NPM) $(c)

vendor: ## Install vendors according to the current composer.lock file
vendor: c=install
vendor: yarn

## —— Vue ———————————————————————————————————————————————————————————————
vue: ## Pass command to vue-cli, example: make vue c=ui
	@$(eval c ?=)
	@$(VUE) $(c)
