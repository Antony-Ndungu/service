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
# Kind cluster
KIND_CLUSTER = k0

kind-up: zarf/k8s/kind/kind-config.yaml
	kind create cluster \
		--name $(KIND_CLUSTER) \
		--config zarf/k8s/kind/kind-config.yaml
	kubectl config set-context --current --namespace=sales-system

kind-down: 
	kind delete cluster --name $(KIND_CLUSTER)

kind-load:
	kind load docker-image service-amd64:$(VERSION) --name $(KIND_CLUSTER)

kind-apply: zarf/k8s/base/service/service.yaml
	cat zarf/k8s/base/service/service.yaml | kubectl apply -f -

kind-logs:
	kubectl logs -l app=service --all-containers=true -f --tail=100

kind-restart:
	kubectl rollout restart deployment service

kind-update: all kind-load kind-apply kind-restart

#==================================================================================



