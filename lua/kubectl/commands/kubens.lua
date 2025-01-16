local kubectl = require("kubectl.commands")

local M = {}

local current = function()
  local result = kubectl.cmd({
    "config", "view", "--minify", "-o", "jsonpath='{..namespace}'"},
    {silent=true})
  return result.exec()

end

local setnamespace = function(ns)
  local cmd = kubectl.cmd({"config", "set-context", "--current", "--namespace", ns})
  cmd.exec()
end

M.exec = function(args)
  if #args < 1 then
    vim.notify("Current namespace: ".. current(), vim.log.levels.INFO)
  else
    setnamespace(args[1])
  end
end

return M
