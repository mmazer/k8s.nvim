local kubectl = require("kubectl.commands")

local M = {
  resource = "namespace"
}

M.set = function(ns)
  local cmd = kubectl.cmd({"config", "set-context", "--current", "--namespace", ns})
  cmd.exec()
end

M.current = function()
  local result = kubectl.cmd({
    "config", "view", "--minify", "-o", "jsonpath='{..namespace}'"},
    {silent=true})
  return result.exec()
end
return M
