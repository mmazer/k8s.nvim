local kubectl = require("kubectl.commands")

local M = {}

M.exec = function()
  local cmd = kubectl.cmd({"config", "current-context"})
  local ctx = cmd.exec()
  vim.notify(ctx, vim.log.levels.INFO)
end

return M
