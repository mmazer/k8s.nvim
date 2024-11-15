local M = {}

M.short_names = {
  cm      = "configmaps",
  crd     = "customresourcedefinitions",
  deploy  = "deployments",
  ds      = "daemonsets",
  ks      = "kustomizations",
  no      = "nodes",
  ns      = "namespaces",
  po      = "pods",
  pv      = "persistentvolumes",
  pvc     = "persistentvolumeclaims",
  rc      = "replicationcontrollers",
  rs      = "replicasets",
  sa      = "serviceaccounts",
  svc     = "services"
}

return M
