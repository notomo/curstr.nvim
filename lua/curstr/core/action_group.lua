local modulelib = require("curstr/lib/module")
local base = require("curstr/action_group/base")

local M = {}

M.create = function(name, args, action_opts)
  local origin
  if name == "base" then
    origin = base
  else
    local found = modulelib.find_action_group(name)
    if found == nil then
      return nil, "not found action group: " .. name
    end
    origin = setmetatable(found, base)
    origin.__index = origin
  end

  local group = {}
  for key, value in pairs(args) do
    group[key] = value
  end
  group.name = name
  group.opts = vim.tbl_extend("force", origin.opts or {}, action_opts)

  return setmetatable(group, origin), nil
end

return M
