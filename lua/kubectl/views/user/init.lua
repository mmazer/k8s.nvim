local kubectl = require("kubectl.commands").cmd
local views= require("kubectl.views")
local namespace = views.view_namespace
local BufferView = require("kubectl.views.bufferview")

local M = {}

M.view = function(args)
  local ns = namespace()
  if ns ~= nil and ns ~= '' then
    vim.list_extend(args, {"--namespace", ns})
  end
  local cmd = kubectl(args)
  local view_name = cmd.args
  local view = BufferView:new(view_name, cmd)
  view:open()
end

return M
