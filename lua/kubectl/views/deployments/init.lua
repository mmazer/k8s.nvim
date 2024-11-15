local ViewBuilder = require("kubectl.views.viewbuilder")

local M = {}

M.view = function()
  local view_builder = ViewBuilder:new("deployment")
  local view = view_builder:create()
  view:view()
end

return M
