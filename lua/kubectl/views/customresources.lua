local kubectl = require("kubectl.commands")
local views= require("kubectl.views")
local ResourceView = require("kubectl.views.resourceview")
local namespace = views.view_namespace

local M = {}
M._customresources = {}

M.create_view = function(resource)
  local fn = function(opts)
    local ns = namespace()
    opts = opts or {}
    if ns == nil or ns == '' then
      vim.list_extend(opts, {"-A"})
    end
    local cmd = kubectl.get(resource, nil, ns, opts)
    ResourceView:new(resource, cmd):view()
  end
  return fn
end

M.register = function(resource, view)
  view = view or M.create_view(resource)
  M._customresources[resource] = view
end

M.get_customresource = function(resource)
  return M._customresources[resource]
end

return M
