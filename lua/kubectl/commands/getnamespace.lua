local M = {}

M.exec = function()
  local ns = require("kubectl.views").view_namespace() or "*all*"
  vim.notify("namespace:"..ns, vim.log.levels.INFO)
end

return M
