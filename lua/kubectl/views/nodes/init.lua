local NodeViewBuilder = require("kubectl.views.nodes.viewbuilder")

local M = {}

M.view = function()
  local view_builder = NodeViewBuilder:new()
  local view = view_builder:create()
  view:view()
end

return M
