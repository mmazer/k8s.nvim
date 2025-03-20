local ResourceView = require("kubectl.views.resourceview")
local views = require("kubectl.views")
local namespace = views.view_namespace
local kubectl = require("kubectl.commands")
local M = {}

M.shortnames = {}
M.resourceviews = {}

M.resource_specs = {
  apiservices = { shortnames = { "apis" } },
  clusterroles = { shortnames = { "cr" } },
  clusterrolebindings = { shortnames = { "crb" } },
  configmaps = { shortnames = { "cm" } },
  customresourcedefinitions = { shortnames = { "crd", "crds" } },
  deployments = { shortnames = { "deploy" } },
  daemonsets = { shortnames = { "ds" } },
  endpoints = { shortnames = { "ep" } },
  events = { shortnames = { "ev" }, view = require("kubectl.views.events").view },
  gateways = { shortnames = { "gtw" } },
  horizontalpodautoscalers = { shortnames = { "hpa" } },
  httproutes = {},
  ingresses = { shortnames = { "ing" } },
  jobs = {},
  cronjobs = { shortnames = { "cj" } },
  namespaces = { shortnames = { "ns" } },
  nodes = { shortnames = { "no" }, view = require("kubectl.views.nodes").view },
  pods = { shortnames = { "po" } },
  poddisruptionbudgets = { shortnames = { "pdb" } },
  persistentvolumes = { shortnames = { "pv" } },
  persistentvolumeclaims = { shortnames = { "pvc" } },
  replicationcontrollers = { shortnames = { "rc" } },
  replicasets = { shortnames = { "rs" } },
  roles = {},
  rolebindings = { shortnames = { "rb" } },
  services = { shortnames = { "svc" } },
  serviceaccounts = { shortnames = { "sa" } },
  secrets = {},
  statefulsets = { shortnames = { "sts" } },
}

M.create_default_view = function(resource)
  local fn = function(opts)
    local ns = namespace()
    opts = opts or {}
    if ns == nil or ns == '' then
      vim.list_extend(opts, { "-A" })
    end
    local cmd = kubectl.get(resource, nil, ns, opts)
    ResourceView:new(resource, cmd):view()
  end
  return fn
end

M.register_spec = function(name, opts)
  local shortnames = opts.shortnames
  if shortnames ~= nil and #shortnames >= 0 then
    for _, sname in ipairs(shortnames) do
      M.shortnames[sname] = name
    end
  end
  local view = opts.view or M.create_default_view(name)
  M.resourceviews[name] = view
end

M.get_resource_view = function(name)
  name = M.shortnames[name] or name
  return M.resourceviews[name]
end

M.init = function(ext_specs)
  -- register builtin specs
  for name, opts in pairs(M.resource_specs) do
    M.register_spec(name, opts)
  end
  ext_specs = ext_specs or {}
  -- register external specs
  for name, opts in pairs(ext_specs) do
    M.register_spec(name, opts)
  end
end

return M
