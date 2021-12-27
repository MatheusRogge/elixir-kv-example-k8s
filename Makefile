.PHONY: all build run push-image apply-manifests deploy

build:
	docker build -t localhost:5000/kv-server --progress=plain .

run: build
	docker run -p 8080:8080 -e POD_IP=192.168.0.10 -it localhost:5000/kv-server

push-image:
	docker push localhost:5000/kv-server:latest

apply-manifests:
	kubectl replace --force -f k8s/service-deployment.yaml

deploy: build push-image apply-manifests
