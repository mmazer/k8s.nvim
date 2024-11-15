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
  sa      = "serviceaccounts",
  svc     = "services"
}

return M
