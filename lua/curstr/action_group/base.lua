local M = {}

local action_prefix = "action_"

M.execute = function(self, name)
  local action_name = action_prefix .. name
  local action = self[action_name]
  if action == nil then
    return nil, "not found action: " .. name
  end
  return action()
end

return M
