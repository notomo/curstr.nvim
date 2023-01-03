local modulelib = require("curstr.vendor.misclib.module")
local pathlib = require("curstr.vendor.misclib.path")

local ActionGroup = {}

function ActionGroup.new(name, args)
  vim.validate({ name = { name, "string" }, args = { args, "table" } })

  local action_group = modulelib.find("curstr.action_group." .. name)
  if action_group == nil then
    return nil, "not found action group: " .. name
  end

  local custom_group = require("curstr.core.custom").config.groups[name] or {}
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
  vim.validate({ name = { name, "string", true } })

  name = name or self.default_action
  local key = ACTION_PREFIX .. name
  local action = self[key]
  if action == nil then
    return nil, "not found action: " .. name
  end

  return action(self)
end

function ActionGroup.actions(self)
  local names = {}
  local keys = vim.tbl_keys(self._action_group)
  table.sort(keys, function(a, b)
    return a < b
  end)
  for _, key in ipairs(keys) do
    if vim.startswith(key, ACTION_PREFIX) then
      local name = key:gsub("^" .. ACTION_PREFIX, "")
      table.insert(names, name)
    end
  end
  return names
end

local base = require("curstr.action_group.base")
function ActionGroup.__index(self, k)
  return rawget(ActionGroup, k) or self._action_group[k] or base[k]
end

function ActionGroup.all()
  local paths = vim.api.nvim_get_runtime_file("lua/curstr/action_group/**/*.lua", true)
  local groups = vim.tbl_map(function(path)
    local file = vim.split(pathlib.normalize(path), "lua/curstr/action_group/", {plain = true})[2]
    local name = file:sub(1, #file - 4)
    return ActionGroup.new(name, {})
  end, paths)
  return vim.tbl_filter(function(group)
    return group.name ~= "base"
  end, groups)
end

return ActionGroup
