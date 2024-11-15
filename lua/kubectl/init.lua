local M = {}
local options = {}

M.setup = function(opts)
  vim.api.nvim_create_user_command("Kubectl", function(opts)
    local short_names = require("kubectl.views.types").short_names
    if #opts.fargs == 0 then
      require("kubectl.views.pods").view()
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

    if action == "get" then
      if #opts.fargs >= 2 then
        local resource_type = opts.fargs[2]
        local rname = short_names[resource_type]
        if rname ~= nil then
          resource_type = rname
        end

        local ok, view = pcall(require, "kubectl.views." .. resource_type)
        if ok then
          view.view()
        else
          vim.notify("no view found for "..resource_type..": running user command", vim.log.levels.INFO)
          require("kubectl.views.user").view(opts.fargs)
        end
      end
    else
      require("kubectl.views.user").view(opts.fargs)
    end
  end,
  { nargs = "*"})

  vim.cmd("cab kube Kubectl")

  vim.api.nvim_create_user_command("Kubens", function(opts)
    if #opts.fargs == 0 then
      print("Current namespace: " .. require("kubectl.commands.namespaces").current())
      return
    end

    require("kubectl.commands.namespaces").set(opts.fargs[1])

  end, {
    nargs = "*"
  })
  vim.cmd("cab kns Kubens")

end

return M
