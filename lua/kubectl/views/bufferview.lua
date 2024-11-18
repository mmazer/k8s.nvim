local lib = require("kubectl.lib")
local BufferView = {}

function BufferView:new(view_name, cmd, opts)
  BufferView.__index = BufferView
  local instance = setmetatable({}, BufferView)
  instance.view_name = view_name
  instance.cmd = cmd
  instance.opts = opts or {}

  return instance
end

function BufferView:open()
  local data = self.cmd.exec()
  if data == nil or data == '' then
    data = "No resources found"
  end
  local opts = self.opts or {}
  if opts.namespace then
    self:set_view_namespace(opts.namespace)
  end
  vim.api.nvim_cmd({cmd="enew"}, {})
  if opts.namespace then
    self:set_view_namespace(opts.namespace)
  end
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf })
  vim.api.nvim_set_option_value("swapfile", false, { buf = buf })
  vim.api.nvim_buf_set_name(buf, "Kubectl:"..table.concat(self.view_name, " "))
  vim.api.nvim_buf_set_lines(buf, 0, -1, true, vim.split(data, "\n", {plain=true}))
  vim.opt_local.iskeyword:append("-")
  vim.opt_local.iskeyword:append(".")
  vim.opt_local.iskeyword:append(":")

  if opts.filetype ~= nil then
    vim.api.nvim_set_option_value("filetype", opts.filetype, { buf = buf })
  end

  vim.api.nvim_win_set_cursor(0, {1,0})
  if opts.keymap ~= nil then
    for k,v in pairs(opts.keymap) do
    vim.keymap.set({"n"}, k, v, {buffer=buf, silent=true})
    end
  end

  local view = self
  vim.keymap.set({"n"}, "gq", function()
    view:delete_buffer()
  end, {buffer=buf})

  vim.keymap.set({"n"}, "gr", function()
    view:refresh()
  end, {buffer=buf})
end

function BufferView:refresh()
    local current_buf = vim.api.nvim_get_current_buf()
    local data = self.cmd.exec()
    vim.api.nvim_buf_set_lines(current_buf, 0, -1, true, vim.split(data, "\n", {plain=true}))
end

function BufferView:delete_buffer()
    local current_buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_delete(current_buf, {force=true})
end

function BufferView:view_namespace()
  return vim.b.kubectl_namespace
end

function BufferView:set_view_namespace(ns)
  vim.b.kubectl_namespace = ns
end

function BufferView:set_current_namespace()
  local ns = lib.first_word_current_line()
  self:set_view_namespace(ns)
end

return BufferView
