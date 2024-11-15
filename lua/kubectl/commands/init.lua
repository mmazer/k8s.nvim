local M = {}

M.cmd = function(args, opts)
  local opts = opts or {}
  local cmd = {
    command = {"kubectl"},
    args = args
  }
  vim.list_extend(cmd.command, args)

  cmd.exec = function()
    if opts.silent ~= nil and opts.silent == false then
      print(table.concat(cmd.command, ' '))
    end
    return M.run_command(cmd.command)
  end
  return cmd
end

M.get = function(resource, name, ns, opts)
  local args = {"get", resource}
  if name ~= nil and name ~= '' then
    vim.list_extend(args, {name})
  end
  if ns ~= nil and ns ~= '' then
    vim.list_extend(args, {"--namespace", ns})
  end
  if opts ~= nil then
    vim.list_extend(args, opts)
  end

  return M.cmd(args)
end

M.describe = function(resource, name, ns, opts)
  local args = {"describe", resource, name}

  if ns ~= nil and ns ~= '' then
    vim.list_extend(args, {"--namespace", ns})
  end

  if opts ~= nil then
    vim.list_extend(args, opts)
  end

  return M.cmd(args)
end

M.yaml = function(resource, name, ns)
  return M.get(resource, name, ns, {"-o", "yaml"})
end

M.json = function(resource, name, ns)
  return M.get(resource, name, ns, {"-o", "json"})
end

M.run_command = function(cmd)
  local output = ""
  local error = ""
  local job = vim.system(cmd, {
    text = true,
    stdout = function(_, data)
      if data then
        output = output .. data
      end
    end,
    stderr = function(_, data)
      if data then
        error = error .. data
      end
    end
  })

  local exit_code = job:wait()
  if exit_code.code ~= 0 and error ~= "" then
    vim.notify(error, vim.log.levels.ERROR)
  end

  return output
end

return M
