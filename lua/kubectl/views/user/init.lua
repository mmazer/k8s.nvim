local kubectl = require("kubectl.commands").cmd
local BufferView = require("kubectl.views.bufferview")

local M = {}

M.view = function(args)
  local cmd = kubectl(args)
  local view_name = cmd.args
  local view = BufferView:new(view_name, cmd)
  view:open()
end

return M
