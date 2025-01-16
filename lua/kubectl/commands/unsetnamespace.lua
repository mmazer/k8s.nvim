local M = {}

M.exec = function()
  require("kubectl.views").set_view_namespace(nil)
end

return M
