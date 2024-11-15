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

M.buffer_view = function(name, cmd, opts)
  local data = cmd.exec()
  if data == nil or data == '' then
    data = "No resources found"
  end
  local opts = opts or {}
  if opts.namespace then
    M.set_view_namespace(opts.namespace)
  end
  vim.api.nvim_cmd({cmd="enew"}, {})
  if opts.namespace then
    M.set_view_namespace(opts.namespace)
  end
  local buf = vim.api.nvim_get_current_buf()
  vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf })
  vim.api.nvim_set_option_value("swapfile", false, { buf = buf })
  vim.api.nvim_buf_set_name(buf, "Kubectl:"..name)
  vim.api.nvim_buf_set_lines(buf, 0, -1, 1, vim.split(data, "\n", {plain=true}))
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

  vim.keymap.set({"n"}, "gq", function()
    local buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_delete(buf, {force=true})
  end, {buffer=buf})

  vim.keymap.set({"n"}, "gr", function()
    local buf = vim.api.nvim_get_current_buf()
    local data = cmd.exec()
    vim.api.nvim_buf_set_lines(buf, 0, -1, 1, vim.split(data, "\n", {plain=true}))
  end, {buffer=buf})
end

return M
