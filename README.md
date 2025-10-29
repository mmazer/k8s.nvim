# k8s.nvim

A simple buffer based wrapper for [kubectl](https://kubernetes.io/docs/reference/kubectl/).

### Motivation

Clicking back and forth in UI based views of Kubernetes is mildly annoying.

Buffer views allow me to return easily to previous view, e.g running pods
without having to click back and forth.

Easily compare Kubernetes resources (YAML or JSON) side by side.

### Limitations

The plugin provides a read only view of Kubernetes resources. There are no
default key mappings for editing or deleting resources.
