local ViewBuilder = require("kubectl.views.viewbuilder")
local ResourceView = require("kubectl.views.resourceview")
local lib = require("kubectl.lib")
local views= require("kubectl.views")
local kubectl = require("kubectl.commands")

local NodeViewBuilder = {}


function NodeViewBuilder:new()
  NodeViewBuilder.__index = NodeViewBuilder
  setmetatable(NodeViewBuilder, {__index = ViewBuilder})
  local instance = ViewBuilder:new("node")
  setmetatable(instance, NodeViewBuilder)

  return instance
end

function NodeViewBuilder:view_options()
  local view_opts = {}
  view_opts.keymap = {
    gp=function()
      local name = lib.current_word()
      local ns = views.view_namespace() or "*all*"
      local view_name = "pod node="..name.." namespace="..ns
      local cmd_opts = {"-A","-o", "wide", "--field-selector", "spec.nodeName="..name}
      local cmd = kubectl.get("pods", nil, nil, cmd_opts)
      local view = ResourceView:new("pod", view_name, cmd)
      view:view()
    end
  }
  return view_opts
end

return NodeViewBuilder
