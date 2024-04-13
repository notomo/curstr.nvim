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
  return {
    name = name,
    opts = vim.tbl_deep_extend("force", action_group.opts or {}, custom_group.opts or {}),
    args = args,
    origin = action_group,
  }
end

local ACTION_PREFIX = "action_"
function ActionGroup.execute(group, action_name)
  vim.validate({ action_name = { action_name, "string", true } })

  action_name = action_name or group.origin.default_action
  local key = ACTION_PREFIX .. action_name
  local action = group.origin[key]
  if not action then
    return "not found action: " .. action_name
  end

  local ctx = {
    args = group.args,
    opts = group.opts,
  }
  return action(ctx)
end

function ActionGroup.actions(group)
  local keys = vim.tbl_keys(group.origin)
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

function ActionGroup.all()
  return vim
    .iter(vim.api.nvim_get_runtime_file("lua/curstr/action_group/**/*.lua", true))
    :map(function(path)
      local file = vim.split(vim.fs.normalize(path), "lua/curstr/action_group/", { plain = true })[2]
      local name = file:sub(1, #file - 4)
      return ActionGroup.new(name, {})
    end)
    :totable()
end

return ActionGroup
