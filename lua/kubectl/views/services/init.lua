local kubectl = require("kubectl.commands")
local views= require("kubectl.views")
local ResourceView = require("kubectl.views.resourceview")
local namespace = views.view_namespace

local M = {
  resource = "service"
}

M.view = function()
  local ns = namespace()
  local opts = {}
  if ns == nil or ns == '' then
    vim.list_extend(opts, {"-A"})
  end
  local cmd = kubectl.get(M.resource, nil, ns, opts)
  ResourceView:new(M.resource, cmd):view()
end

return M
