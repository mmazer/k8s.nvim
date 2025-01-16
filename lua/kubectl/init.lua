local resourcespecs = require("kubectl.views.resourcespecs")
local lib = require("kubectl.lib")
local M = {}

M.setup = function(options)
  options = options or {}
  resourcespecs.init(options.resource_specs)

  local user_commands = options.user_commands or {}


  vim.api.nvim_create_user_command("Kubectl", function(opts)

    if #opts.fargs == 0 then
      local view = resourcespecs.get_resource_view("pods")
      view()
      return
    end

    local action = opts.fargs[1]

    if action == "get" then
      if #opts.fargs >= 2 then
        local resource = opts.fargs[2]
        local args = {}
        if #opts.fargs > 2 then
          args = lib.table_slice(opts.fargs, 3)
        end
        local view = resourcespecs.get_resource_view(resource)
        if view ~= nil then
          view(args)
        else
          vim.notify("no resource found for "..resource, vim.log.levels.ERROR)
        end
        return
      end
    end

    local user_command = user_commands[action]
    if user_command  ~= nil then
      require("kubectl.views.user").view(user_command)
      return
    end

    local ok, command = pcall(require, "kubectl.commands."..action)
    if ok then
      local args = lib.table_slice(opts.fargs, 2)
      command.exec(args)
      return
    end

  -- otherwise just run user kubectl command
  require("kubectl.views.user").view(opts.fargs)
  end,
  { nargs = "*"})
end

return M
