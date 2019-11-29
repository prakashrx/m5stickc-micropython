include make_env

NS ?= prakashr1984
VERSION ?= latest
IMAGE_NAME ?= m5stickc-idf
CONTAINER_NAME ?= m5stickc-idf
CONTAINER_INSTANCE ?= default

.PHONY: build push shell run start stop rm release clean

default: build

build:
	@docker build -t $(NS)/$(IMAGE_NAME):$(VERSION) .

push:
	@docker push $(NS)/$(IMAGE_NAME):$(VERSION)

shell:
	@docker run -it --rm --name $(CONTAINER_NAME)-$(CONTAINER_INSTANCE) $(PORTS) $(DEVICES) $(VOLUMES) $(ENV) $(NS)/$(IMAGE_NAME):$(VERSION) /bin/bash

execshell:
	@docker exec -it $(CONTAINER_NAME)-$(CONTAINER_INSTANCE) /bin/bash

run:
	@docker run --rm --name $(CONTAINER_NAME)-$(CONTAINER_INSTANCE) $(PORTS) $(DEVICES) $(VOLUMES) $(ENV) $(NS)/$(IMAGE_NAME):$(VERSION)

start:
	@docker run -d --name $(CONTAINER_NAME)-$(CONTAINER_INSTANCE) $(PORTS) $(VOLUMES) $(ENV) $(NS)/$(IMAGE_NAME):$(VERSION)

stop:
	@docker stop $(CONTAINER_NAME)-$(CONTAINER_INSTANCE)

rm:
	@docker rm $(CONTAINER_NAME)-$(CONTAINER_INSTANCE)

release: build
	@make push -e VERSION=$(VERSION)

clean:
	@docker rmi -f $(shell docker images -a --filter=dangling=true -q) || true
	@docker rm $(shell docker ps -a -f status=exited -q) || true	

