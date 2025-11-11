local kubectl = require("kubectl.commands")
local events = require("kubectl.commands.events")
local views= require("kubectl.views")
local namespace = views.view_namespace
local set_current_namespace = views.set_current_namespace
local lib = require("kubectl.lib")
local BufferView = require("kubectl.views.bufferview")

local ResourceView = {}

function ResourceView:new(kind, cmd, opts)
  ResourceView.__index = ResourceView
  local instance = setmetatable({}, ResourceView)

  instance.kind = kind
  instance.cmd = cmd
  instance.opts = opts or {}
  instance.namespace = namespace
  instance.keymap = {
    gd=function()
      local name = lib.current_word()
      local cmd = kubectl.describe(kind, name, namespace())
      local view = BufferView:new({kind, name}, cmd)
      view:open()
    end,
    ge=function()
      local name = lib.current_word()
      local cmd = events.for_resource(kind, name, namespace())
      local view = BufferView:new({"Events", kind.."/"..name}, cmd)
      view:open()
    end,
    gj=function()
      local name = lib.current_word()
      local cmd = kubectl.json(kind, name, namespace())
      local view = BufferView:new({kind, name}, cmd, {filetype="json"})
      view:open()
    end,
    gl=function()
      local name = lib.current_word()
      local ns = namespace()
      local args = {"logs", kind.."/"..name, "--all-containers=true"}
      if ns ~= nil and ns ~= '' then
        vim.list_extend(args, {"--namespace", ns})
      end
      local cmd = kubectl.cmd(args)
      local view = BufferView:new({"logs", kind.."/"..name}, cmd)
      view:open()
    end,
    gy=function()
      local name = lib.current_word()
      local cmd = kubectl.yaml(kind, name, namespace())
      local view = BufferView:new({kind, name}, cmd, {filetype="yaml"})
      view:open()
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
  if opts.view_name ~= nil then
    view_name = opts.view_name
  end

  local view_ns = ns
  if view_ns == nil or view_ns == '' then
    view_ns = "*all*"
  end
  if lib.is_table(view_name) then
    vim.list_extend(view_name, {"namespace="..view_ns})
  end

  buffer_view = BufferView:new(view_name, self.cmd, { keymap = keymap, namespace=ns})
  buffer_view:open()
end

return ResourceView
