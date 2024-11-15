local kubectl = require("kubectl.commands")
local events = require("kubectl.commands.events")
local views= require("kubectl.views")
local namespace = views.view_namespace
local set_current_namespace = views.set_current_namespace
local lib = require("kubectl.lib")

local ResourceView = {}

ResourceView.__index = ResourceView

function ResourceView:create(kind, cmd, opts)
  local instance = {}
  setmetatable(instance, ResourceView)

  instance.kind = kind
  instance.cmd = cmd
  instance.opts = opts or {}
  instance.namespace = namespace
  instance.keymap = {
    gd=function()
      local name = lib.current_word()
      local cmd = kubectl.describe(kind, name, namespace())
      views.buffer_view({kind, name}, cmd)
    end,
    ge=function()
      local name = lib.current_word()
      local cmd = events.for_resource(kind, name, namespace())
      views.buffer_view({"Events for", name}, cmd)
    end,
    gj=function()
      local name = lib.current_word()
      local cmd = kubectl.json(kind, name, namespace())
      views.buffer_view({kind, name}, cmd, {filetype="json"})
    end,
    gl=function()
      local name = lib.current_word()
      local ns = namespace()
      local args = {"logs", kind.."/"..name, "--all-containers=true"}
      if ns ~= nil and ns ~= '' then
        vim.list_extend(args, {"--namespace", ns})
      end
      local cmd = kubectl.cmd(args)
      views.buffer_view({"logs", kind.."/"..name}, cmd, {filetype="json"})
    end,
    gy=function()
      local name = lib.current_word()
      local cmd = kubectl.yaml(kind, name, namespace())
      views.buffer_view({kind, name}, cmd, {filetype="yaml"})
    end
  }

  return instance
end

function ResourceView:view()
  local ns = namespace()
  local kind = self.kind
  local cmd = self.cmd
  local scope = self.scope
  local keymap = self.keymap
  local opts = self.opts
  if ns == nil or ns == '' then
    keymap = {
      gn=function()
        set_current_namespace()
      end,
      gN=function()
        views.set_view_namespace(nil)
      end,
      gd=function()
       set_current_namespace()
       self.keymap["gd"]()
      end,
      ge=function()
       set_current_namespace()
       self.keymap["ge"]()
      end,
      gl=function()
        set_current_namespace()
        self.keymap["gl"]()
      end,
      gy=function()
       set_current_namespace()
       self.keymap["gy"]()
      end,
      gj=function()
       set_current_namespace()
       self.keymap["gj"]()
      end
    }
    if opts.keymap then
      lib.table_extend(keymap, opts.keymap)
    end
  end

  local view_name = {kind}
  local view_ns = ns
  if view_ns == nil or view_ns == '' then
    view_ns = "*all*"
  end
  vim.list_extend(view_name, {"namespace="..view_ns})

  views.buffer_view(view_name, cmd, { keymap = keymap, namespace=ns})
end

return ResourceView
