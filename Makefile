all: build-cpu
.PHONY: build-cpu build-gpu push-cpu push-gpu clean

user := $(shell whoami)
registry := myungjinlee

project := mlpack
now := $(shell date +"%Y%m%d%H%M%S")
uri := ${project}:${user}-${now}

build-cpu:
	@docker build -f Dockerfile --target cpu --tag ${uri} .

build-gpu:
	@docker build -f Dockerfile --target gpu --tag ${uri} .

push-cpu: build-cpu
	@docker image tag ${uri} ${registry}/${uri}
	@docker image tag ${uri} ${registry}/${project}:cpu
	@docker image push ${registry}/${uri}
	@docker image push ${registry}/${project}:cpu

push-gpu: build-gpu
	@docker image tag ${uri} ${registry}/${uri}
	@docker image tag ${uri} ${registry}/${project}:gpu
	@docker image push ${registry}/${uri}
	@docker image push ${registry}/${project}:gpu

clean:
	@docker image prune --force
