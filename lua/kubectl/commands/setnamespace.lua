local M = {}

M.exec = function(args)
  local ns = args[1]
  if ns == nil then
        vim.notify("setnamespace: namespace required", vim.log.levels.ERROR)
  end

  require("kubectl.views").set_view_namespace(ns)
end

return M
