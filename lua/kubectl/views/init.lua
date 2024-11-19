local lib = require("kubectl.lib")
local M = {}

M.view_namespace = function()
  return vim.b.kubectl_namespace
end

M.set_view_namespace = function(ns)
  vim.b.kubectl_namespace = ns
end

M.set_current_namespace = function()
  local ns = lib.first_word_current_line()
  M.set_view_namespace(ns)
end

return M
