#!/bin/sh
set -o errexit

reg_port='5000'
reg_name='kind-registry'
running="$(docker inspect -f '{{.State.Running}}' "${reg_name}" 2>/dev/null || true)"

# create registry container unless it already exists
if [ "${running}" != 'true' ]; then
  docker run -d --restart=always -p "127.0.0.1:${reg_port}:5000" --name "${reg_name}" registry:2
fi

# create a cluster with the local registry enabled in containerd
kind create cluster --config cluster.yaml

# connect the registry to the cluster network
docker network connect "kind" "${reg_name}" || true

# Setup ingress controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml