# Elixir KV K8s

This repo is an implementation of a distributed key-value store using Kubernetes. Most of the implementation is the same as the one in Elixir's documentation with some extra sauce on top.

## Prerequisites

* [Kind](https://kind.sigs.k8s.io/)
* [Docker](https://www.docker.com/)
* [Elixir](https://elixir-lang.org/)
* [K9s](https://k9scli.io/) (This one is not *that* required but it's nicer than using kubectl)
* Any Linux distro of your choice

## Setting up the cluster

After configuring kubectl, you can use the script: `k8s/kind-setup.sh` to setup the kubernetes cluster with the preconfigured local image registry and ingress.

## Deploying the application
For deploying the application, just run: `make deploy` and everything should built and published to the cluster.

## Generating test data
You will need to port-foward a port using the load-balancer service, or fowarding a port directly from the pod. After that, you can run: `elixir k8s/generate-buckets.exs` to populate the entries.