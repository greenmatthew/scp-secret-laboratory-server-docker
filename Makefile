# Configuration
IMAGE_NAME := greenmatthew/scp-secret-laboratory-server
VERSION := 1.0.1
CONTAINER_NAME := scp-sl-server
PORT := 7777
SHELL := /bin/sh
DOCKER_USERNAME ?= greenmatthew

# Default goal
.PHONY: all
all: build

# Build the Docker image
.PHONY: build
build:
	@echo "Building Docker image: $(IMAGE_NAME):$(VERSION)"
	docker build -t $(IMAGE_NAME):$(VERSION) .
	docker tag $(IMAGE_NAME):$(VERSION) $(IMAGE_NAME):latest

# Run the container
.PHONY: run
run: build
	@echo "Running container: $(CONTAINER_NAME)"
	docker run -d --name $(CONTAINER_NAME) \
		-p $(PORT):$(PORT)/udp \
		-v $(PWD)/config:/home/steam/.config \
		-e TZ=America/Chicago \
		-e UID=1001 \
		-e GID=1001 \
		--restart unless-stopped \
		$(IMAGE_NAME):latest

# Get a shell inside the container
.PHONY: shell
shell:
	@echo "Executing shell in container: $(CONTAINER_NAME)"
	docker exec -it $(CONTAINER_NAME) $(SHELL)

# Stop the container
.PHONY: stop
stop:
	@echo "Stopping container: $(CONTAINER_NAME)"
	-docker stop $(CONTAINER_NAME)
	-docker rm $(CONTAINER_NAME)

# Restart the container
.PHONY: restart
restart: stop run

# Push to Docker Hub
.PHONY: push
push:
	@echo "Pushing to Docker Hub: $(IMAGE_NAME):$(VERSION) and $(IMAGE_NAME):latest"
	docker push $(IMAGE_NAME):$(VERSION)
	docker push $(IMAGE_NAME):latest

# Login to Docker Hub
.PHONY: login
login:
	@echo "Logging into Docker Hub..."
	docker login -u $(DOCKER_USERNAME)

# Remove Docker image
.PHONY: clean
clean: stop
	@echo "Removing Docker image: $(IMAGE_NAME)"
	-docker rmi $(IMAGE_NAME):$(VERSION)
	-docker rmi $(IMAGE_NAME):latest

# Show help
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  all (default) - Build the Docker image"
	@echo "  build         - Build the Docker image"
	@echo "  run           - Run the container"
	@echo "  shell         - Get a shell inside the running container"
	@echo "  stop          - Stop and remove the container"
	@echo "  restart       - Restart the container"
	@echo "  push          - Push the image to Docker Hub"
	@echo "  login         - Login to Docker Hub"
	@echo "  clean         - Stop container and remove images"
	@echo "  logs          - View container logs"
	@echo "  help          - Show this help message"
	@echo ""
	@echo "Configuration:"
	@echo "  IMAGE_NAME    = $(IMAGE_NAME)"
	@echo "  VERSION       = $(VERSION)"
	@echo "  CONTAINER_NAME = $(CONTAINER_NAME)"
	@echo "  PORT          = $(PORT)"
	@echo "  SHELL         = $(SHELL)"
	@echo "  DOCKER_USERNAME = $(DOCKER_USERNAME)"

# View container logs
.PHONY: logs
logs:
	docker logs -f $(CONTAINER_NAME)