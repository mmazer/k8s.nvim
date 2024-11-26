local M = {}

M.resource_aliases = {
  cm      = "configmaps",
  crd     = "customresourcedefinitions",
  deploy  = "deployments",
  ds      = "daemonsets",
  hr      = "helmreleases",
  helmrepo = "helmrepositories",
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
