local kubectl = require("kubectl.commands")
local events = require("kubectl.commands.events")
local views= require("kubectl.views")
local namespace = views.view_namespace
local set_current_namespace = views.set_current_namespace
local lib = require("kubectl.lib")

local ResourceView = {}

function ResourceView:new(resource_kind, view_name, cmd, opts)
  ResourceView.__index = ResourceView
  local instance = {}
  setmetatable(instance, ResourceView)
  instance.resource_kind = resource_kind
  instance.view_name = view_name
  instance.cmd = cmd
  instance.opts = opts or {}

  return instance
end

function ResourceView:keymap()
  local kind = self.resource_kind
  local keymap = {
    gd=function()
      local name = lib.current_word()
      local cmd = kubectl.describe(kind, name, namespace())
      views.buffer_view(kind.."/"..name, cmd)
    end,
    ge=function()
      local name = lib.current_word()
      local cmd = events.for_kind(kind, name, namespace())
      views.buffer_view("Events "..kind.."/"..name, cmd)
    end,
    gj=function()
      local name = lib.current_word()
      local cmd = kubectl.json(kind, name, namespace())
      local view_name = kind.."/"..name
      views.buffer_view(view_name, cmd, {filetype="json"})
    end,
    gl=function()
      local name = lib.current_word()
      local ns = namespace()
      local args = {"logs", kind.."/"..name, "--all-containers=true"}
      if ns ~= nil and ns ~= '' then
        vim.list_extend(args, {"--namespace", ns})
      end
      local cmd = kubectl.cmd(args)
      views.buffer_view("logs "..kind.."/"..name, cmd, {filetype="json"})
    end,
    gy=function()
      local name = lib.current_word()
      local cmd = kubectl.yaml(kind, name, namespace())
      views.buffer_view(kind.."/"..name, cmd, {filetype="yaml"})
    end
  }
  return keymap
end

function ResourceView:view()
  local ns = namespace()
  local view_name = self.view_name
  local cmd = self.cmd
  local keymap = self:keymap()
  local opts = self.opts
  local base_keymap = self:keymap()
  -- TODO: what is the purpose of this keymap?
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
       base_keymap["gd"]()
      end,
      ge=function()
       set_current_namespace()
       base_keymap["ge"]()
      end,
      gl=function()
        set_current_namespace()
        base_keymap["gl"]()
      end,
      gy=function()
       set_current_namespace()
       base_keymap["gy"]()
      end,
      gj=function()
       set_current_namespace()
       base_keymap["gj"]()
      end
    }
    if opts.keymap then
      lib.table_extend(keymap, opts.keymap)
    end
  end

  views.buffer_view(view_name, cmd, { keymap = keymap, namespace=ns})
end

return ResourceView
