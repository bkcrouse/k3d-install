#!/bin/bash

k3d cluster create --volume /etc/machine-id:/etc/machine-id \
    --volume $HOME/.k3d-container-image-cache:/var/lib/rancher/k3s/agent/containerd/io.containerd.content.v1.content \
    --k3s-arg "--disable=traefik@server:0" \
    --port 80:80@loadbalancer \
    --port 443:443@loadbalancer \
    --api-port 6443