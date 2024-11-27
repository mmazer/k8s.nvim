local resourcespecs = require("kubectl.views.resourcespecs")
local lib = require("kubectl.lib")
local M = {}

M.setup = function(options)
  options = options or {}
  resourcespecs.init(options.resource_specs)

  vim.api.nvim_create_user_command("Kubectl", function(opts)

    if #opts.fargs == 0 then
      local view = resourcespecs.get_resource_view("pods")
      view()
      return
    end

    local action = opts.fargs[1]
    if action == "set-namespace" then
      local ns = opts.fargs[2]
      if ns == nil then
        vim.notify("set-namespace: namespace required", vim.log.levels.ERROR)
        return
      end
      require("kubectl.views").set_view_namespace(ns)
      vim.notify("namespace:"..require("kubectl.views").view_namespace(), vim.log.levels.INFO)
      return
    end

    if action == "unset-namespace" then
      require("kubectl.views").set_view_namespace(nil)
      return
    end

    if action == "get-namespace" then
      local ns = require("kubectl.views").view_namespace() or "*all*"
      vim.notify("namespace:"..ns, vim.log.levels.INFO)
      return
    end

    if action == "context-ns" then
      if #opts.fargs < 2 then
        print("Current namespace: " .. require("kubectl.commands.namespaces").current())
      else
        require("kubectl.commands.namespaces").set(opts.fargs[2])
      end
      return
    end

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
          return
        end

        vim.notify("no view found for "..resource..": running user command", vim.log.levels.INFO)
        require("kubectl.views.user").view(opts.fargs)
        end
    else
      require("kubectl.views.user").view(opts.fargs)
    end
  end,
  { nargs = "*"})
end

return M
