local M = {}

local action_prefix = "action_"

M.execute = function(self, name)
  name = name or self.default_action
  local action_name = action_prefix .. name
  local action = self[action_name]
  if action == nil then
    return nil, "not found action: " .. name
  end
  return action(self)
end

M.action_nothing = function()
end

M.default_action = "nothing"

M.__index = M

return M
