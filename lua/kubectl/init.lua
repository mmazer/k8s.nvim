local resource_aliases = require("kubectl.views.types").resource_aliases
local customresources = require("kubectl.views.customresources")
local M = {}

local get_resource_for_alias = function(alias)
  local resource = resource_aliases[alias]
  if resource == nil or resource == '' then
    resource = alias
  end

  return resource

end

M.setup = function(options)
  options = options or {}
  local custom_resources = options.custom_resources
  if custom_resources ~= nil then
    for _,cr in ipairs(custom_resources) do
      customresources.register(cr)
    end
  end

  vim.api.nvim_create_user_command("Kubectl", function(opts)
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
        local resource_type = get_resource_for_alias(opts.fargs[2])
        -- check for customresource
        local customresource = customresources.get_customresource(resource_type)
        if customresource ~= nil then
            customresource()
            return
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
end

return M
