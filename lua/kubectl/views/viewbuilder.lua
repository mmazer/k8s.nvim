local kubectl = require("kubectl.commands")
local ResourceView = require("kubectl.views.resourceview")
local views= require("kubectl.views")
local namespace = views.view_namespace

local ViewBuilder = {}

function ViewBuilder:new(resource_kind)
  ViewBuilder.__index = ViewBuilder
  local instance = {}
  setmetatable(instance, ViewBuilder)
  instance.resource_kind = resource_kind

  return instance
end

function ViewBuilder:create()
  local kind = self.resource_kind
  local ns = self:get_namespace()
  local view_opts = self:view_options()
  local cmd_opts = self:kubectl_options()
  local view_name = self:view_name()
  local cmd = kubectl.get(kind, nil, ns, cmd_opts)

  return ResourceView:new(kind, view_name, cmd, view_opts)

end

function ViewBuilder:view_options()
  return {}
end

function ViewBuilder:kubectl_options()
  local opts = {}
  local ns = self:get_namespace()
  if ns == nil or ns == '' then
    vim.list_extend(opts, {"-A"})
  end

  return opts
end

function ViewBuilder:get_namespace()
  return namespace()
end

function ViewBuilder:create_view_name()
  local view_name = {self.resource_kind}
  local ns = self:get_namespace()
  if ns == nil or ns == '' then
    ns = "*all*"
  end
  vim.list_extend(view_name, {"namespace="..ns})

  return view_name
end

function ViewBuilder:view_name()
  local name_parts = self:create_view_name()
  return table.concat(name_parts, ' ')
end

return ViewBuilder
