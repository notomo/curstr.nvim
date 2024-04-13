local modulelib = require("curstr.vendor.misclib.module")

local ActionGroup = {}

--- @return CurstrActionGroup|string
function ActionGroup.new(name, args)
  vim.validate({ name = { name, "string" }, args = { args, "table" } })

  local action_group = modulelib.find("curstr.action_group." .. name)
  if not action_group then
    return "not found action group: " .. name
  end

  local custom_group = require("curstr.core.custom").config.groups[name] or {}
  local tbl = {
    name = name,
    opts = vim.tbl_deep_extend("force", action_group.opts or {}, custom_group.opts or {}),
    _args = args,
    _action_group = action_group,
  }
  tbl = vim.tbl_deep_extend("keep", tbl, args)

  return setmetatable(tbl, ActionGroup)
end

local ACTION_PREFIX = "action_"
function ActionGroup.execute(self, name)
  vim.validate({ name = { name, "string", true } })

  name = name or self.default_action
  local key = ACTION_PREFIX .. name
  local action = self[key]
  if not action then
    return "not found action: " .. name
  end

  local ctx = {
    args = self._args,
    opts = self.opts,
  }
  return action(ctx)
end

function ActionGroup.actions(self)
  local keys = vim.tbl_keys(self._action_group)
  table.sort(keys, function(a, b)
    return a < b
  end)

  return vim
    .iter(keys)
    :filter(function(key)
      return vim.startswith(key, ACTION_PREFIX)
    end)
    :map(function(key)
      local name = key:gsub("^" .. ACTION_PREFIX, "")
      return name
    end)
    :totable()
end

local base = require("curstr.action_group.base")
function ActionGroup.__index(self, k)
  return rawget(ActionGroup, k) or self._action_group[k] or base[k]
end

function ActionGroup.all()
  return vim
    .iter(vim.api.nvim_get_runtime_file("lua/curstr/action_group/**/*.lua", true))
    :map(function(path)
      local file = vim.split(vim.fs.normalize(path), "lua/curstr/action_group/", { plain = true })[2]
      local name = file:sub(1, #file - 4)
      if name == "base" then
        return nil
      end
      return ActionGroup.new(name, {})
    end)
    :totable()
end

return ActionGroup
