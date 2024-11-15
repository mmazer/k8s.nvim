local kubectl = require("kubectl.commands")
local views= require("kubectl.views")
local ResourceView = require("kubectl.views.resourceview")
local namespace = views.view_namespace
local lib = require("kubectl.lib")

local M = {
  resource = "node"
}

M.view = function()
  local cmd = kubectl.get(M.resource, nil)
  local ns = namespace()
  local opts = {}
  local keymap = {
    gp=function()
      local name = lib.current_word()
      local opts = {"-A","-o", "wide", "--field-selector", "spec.nodeName="..name}
      local cmd = kubectl.get("pods", nil, nil, opts)
      local view = ResourceView:create("pod", cmd, {view_name={"pod", "node="..name}})
      view:view()
    end
  }
  opts.keymap = keymap
  local view = ResourceView:create(M.resource, cmd, opts)
  view:view()
end

return M
