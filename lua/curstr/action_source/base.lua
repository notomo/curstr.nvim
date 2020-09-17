local group_core = require("curstr/core/action_group")

local M = {}

M.opts = {}

M.create = function()
  return nil
end

M.to_group = function(_, name, args)
  local group, err = group_core.create(name, args)
  if err ~= nil then
    return nil, err
  end
  return group, nil
end

M.__index = M

return M
