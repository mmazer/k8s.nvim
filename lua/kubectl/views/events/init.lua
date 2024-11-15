local kubectl = require("kubectl.commands")
local views= require("kubectl.views")
local view = views.buffer_view
local namespace = views.view_namespace

local M = {
  resource = "event"
}

M.view = function()
  local ns = namespace()
  local cmd = kubectl.get(M.resource, nil, ns)
  local view_name = {"Events"}
  if ns ~= nil and ns ~= '' then
    vim.list_extend(view_name, {"namespace="..ns})
  end
  view(view_name, cmd)
end

return M
