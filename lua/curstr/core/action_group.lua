local modulelib = require("curstr.lib.module")
local custom = require("curstr.custom")

local M = {}

local ActionGroup = {}
M.ActionGroup = ActionGroup

function ActionGroup.new(name, args)
  vim.validate({name = {name, "string"}, args = {args, "table"}})

  local action_group = modulelib.find("curstr.action_group." .. name)
  if action_group == nil then
    return nil, "not found action group: " .. name
  end

  local custom_group = custom.groups[name] or {}
  local tbl = {
    name = name,
    opts = vim.tbl_deep_extend("force", action_group.opts or {}, custom_group.opts or {}),
    _action_group = action_group,
  }
  tbl = vim.tbl_deep_extend("keep", tbl, args)

  return setmetatable(tbl, ActionGroup), nil
end

local ACTION_PREFIX = "action_"
function ActionGroup.execute(self, name)
  vim.validate({name = {name, "string", true}})

  name = name or self.default_action
  local key = ACTION_PREFIX .. name
  local action = self[key]
  if action == nil then
    return nil, "not found action: " .. name
  end

  return action(self)
end

local base = require("curstr.action_group.base")
function ActionGroup.__index(self, k)
  return rawget(ActionGroup, k) or self._action_group[k] or base[k]
end

return M
