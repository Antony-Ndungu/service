run: main.go
	go run main.go
#==================================================================================
# Building container
VERSION = 1.0

all: service

service: zarf/docker/Dockerfile
	docker build \
		-f zarf/docker/Dockerfile \
		-t service-amd64:$(VERSION) \
		--build-arg BUILD_REF=$(VERSION) \
		.
#==================================================================================



