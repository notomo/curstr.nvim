local modulelib = require("curstr/lib/module")
local base = require("curstr/action_group/base")

local M = {}

local action_prefix = "action_"

M.create = function(group_name, args, action_opts)
  local origin
  if group_name == "base" then
    origin = base
  else
    local found = modulelib.find_action_group(group_name)
    if found == nil then
      return nil, "not found action group: " .. group_name
    end
    origin = setmetatable(found, base)
    origin.__index = origin
  end

  local tbl = {}
  for key, value in pairs(args) do
    tbl[key] = value
  end
  tbl.name = group_name
  tbl.opts = vim.tbl_extend("force", origin.opts or {}, action_opts)

  local group = setmetatable(tbl, origin)

  group.execute = function(self, name)
    name = name or self.default_action
    local action_name = action_prefix .. name
    local action = self[action_name]
    if action == nil then
      return nil, "not found action: " .. name
    end
    return action(self)
  end

  return group, nil
end

return M
