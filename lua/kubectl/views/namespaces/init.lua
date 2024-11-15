local kubectl = require("kubectl.commands")
local view = require("kubectl.views").buffer_view
local lib = require("kubectl.lib")

local M = {
  resource = "namespace"
}

M.view = function()
  local cmd = kubectl.get(M.resource)
  local view_name = {"Namespaces"}
  view(view_name, cmd, {
    keymap = {
      gd = function()
        local namespace = lib.current_word()
        local cmd = kubectl.describe(M.resource, namespace)
        view({"namespace", namespace}, cmd)
      end,
      gy = function()
        local namespace = lib.current_word()
        local cmd = kubectl.yaml(M.resource, namespace)
        view({"namespace", namespace}, cmd, {filetype="yaml"})
      end,
      gj = function()
        local namespace = lib.current_word()
        local cmd = kubectl.json(M.resource, namespace)
        view({"namespace", namespace}, cmd, {filetype="json"})
      end,
    }
  })
end

return M
