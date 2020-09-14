local group_core = require("curstr/action/group")

local M = {}

M.opts = {}

M.create = function()
  return nil
end

M.group = function(_, name, args)
  local group, err = group_core.create(name, args)
  if err ~= nil then
    return nil, err
  end
  return group, nil
end

return M
