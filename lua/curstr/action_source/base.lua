local group_core = require("curstr/core/action_group")

local M = {}

M.opts = {}

M.create = function()
  return nil
end

M.to_group = function(self, name, args)
  local action_opts = self.action_opts[name] or {}
  local group, err = group_core.create(name, args, action_opts)
  if err ~= nil then
    return nil, err
  end
  return group, nil
end

M.__index = M

return M
