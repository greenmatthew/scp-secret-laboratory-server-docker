# Configuration
IMAGE_NAME := greenmatthew/scp-secret-laboratory-server
VERSION := 1.0.0
CONTAINER_NAME := scp-sl-server
PORT := 7777

# Set this to your Docker Hub username before pushing
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
run:
	@echo "Running container: $(CONTAINER_NAME)"
	docker run -d --name $(CONTAINER_NAME) \
		-p $(PORT):$(PORT)/udp \
		-v $(PWD)/config:/home/steam/.config/SCP\ Secret\ Laboratory/config/$(PORT) \
		--restart unless-stopped \
		$(IMAGE_NAME):latest

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

# Tag and push with current date
.PHONY: tag-date
tag-date:
	$(eval DATE := $(shell date +%Y%m%d))
	@echo "Tagging with date: $(IMAGE_NAME):$(DATE)"
	docker tag $(IMAGE_NAME):latest $(IMAGE_NAME):$(DATE)
	docker push $(IMAGE_NAME):$(DATE)

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
	@echo "  stop          - Stop and remove the container"
	@echo "  restart       - Restart the container"
	@echo "  push          - Push the image to Docker Hub"
	@echo "  tag-date      - Tag and push image with current date"
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
	@echo "  DOCKER_USERNAME = $(DOCKER_USERNAME)"

# View container logs
.PHONY: logs
logs:
	docker logs -f $(CONTAINER_NAME)