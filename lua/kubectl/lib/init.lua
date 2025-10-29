local M = {}

M.current_word = function()
  return vim.fn.expand("<cword>")
end

M.current_line = function()
  return vim.api.nvim_get_current_line()
end

M.first_word = function(s)
  if s ~= nil then
    return s:match("^([%w-]+)")
  end
  return ""
end

M.first_word_current_line = function()
  return M.first_word(M.current_line())
end

M.filter = function(t,predicate)
  for i = #t, 1, -1 do
    if predicate(t[i], i) then
      table.remove(t, i)
    end
  end
  return t
end

M.endswith = function(str, subs)
  local ends = string.sub(str, -(#subs))
  return ends == subs
end

M.tail = function(t)
  local function helper(head, ...) return #{...} > 0 and {...} or nil end
  return helper((table.unpack or unpack)(t))
end

M.table_slice = function(tb, start, stop)
  local sliced = {}
  start = start or 1
  stop = stop or #tb
  for i,value in ipairs(tb) do
    if i >= start and i <= stop then
      table.insert(sliced, value)
    end
  end

  return sliced
end

M.table_extend = function(dst, src)
  for k,v in pairs(src) do
    dst[k] = v
  end
end

M.table_defaults = function(dst, defaults)
  for k,v in pairs(defaults) do
    if dst[k] == nil then
      dst[k] = v
    end
  end
  return dst
end

M.find_buffer_by_name = function(view_name)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local buf_name = vim.api.nvim_buf_get_name(buf)
    print("found bufnum "..buf.." name="..buf_name)
    if M.endswith(buf_name,  view_name) then
      return buf
    end
  end
  return -1
end

return M
