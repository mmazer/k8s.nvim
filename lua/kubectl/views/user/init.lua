local kubectl = require("kubectl.commands").cmd
local views= require("kubectl.views")
local view = views.buffer_view
local namespace = views.view_namespace

local M = {}

M.view = function(args)
  local ns = namespace()
  if ns ~= nil and ns ~= '' then
    vim.list_extend(args, {"--namespace", ns})
  end
  local cmd = kubectl(args)
  local view_name = table.concat(cmd.args, " ")
  view(view_name, cmd)
end

return M
