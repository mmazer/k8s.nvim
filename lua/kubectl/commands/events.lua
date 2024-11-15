local kubectl = require("kubectl.commands").cmd

local M = {
  resource = "event"
}

M.for_resource = function(resource_type, name, ns)
  local args = {"events", "--for"}
  local resource = resource_type.."/" .. name
  vim.list_extend(args, {resource})
  if ns ~= nil and ns ~= '' then
    vim.list_extend(args, {"--namespace", ns})
  end

  local result = kubectl(args)
  return result
end

return M
