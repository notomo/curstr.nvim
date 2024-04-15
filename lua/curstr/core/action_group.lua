local modulelib = require("curstr.vendor.misclib.module")

local M = {}

local find_group = function(group_name)
  local group = modulelib.find("curstr.action_group." .. group_name)
  if not group then
    return "not found action group: " .. group_name
  end
  group.name = group_name
  return group
end

local ACTION_PREFIX = "action_"

local find_action = function(group, action_name)
  action_name = action_name or group.default_action
  local key = ACTION_PREFIX .. action_name
  local action = group[key]
  if not action then
    return "not found action: " .. action_name
  end
  return action
end

function M.execute(raw_group, action_name, action_opts)
  vim.validate({ action_name = { action_name, "string", true } })

  local group = find_group(raw_group.group_name)
  if type(group) == "string" then
    local err = group
    return err
  end

  local action = find_action(group, action_name)
  if type(action) == "string" then
    local err = action
    return err
  end

  local custom = require("curstr.core.custom").config.groups[group.name] or {}
  local opts = vim.tbl_deep_extend("force", group.opts or {}, custom.opts or {}, action_opts)

  local ctx = {
    args = raw_group,
    opts = opts,
  }
  return action(ctx)
end

local collect_action_names = function(group)
  local keys = vim.tbl_keys(group)
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

function M.all()
  return vim
    .iter(vim.api.nvim_get_runtime_file("lua/curstr/action_group/**/*.lua", true))
    :map(function(path)
      local file = vim.split(vim.fs.normalize(path), "lua/curstr/action_group/", { plain = true })[2]
      local name = file:sub(1, #file - 4)
      local group = find_group(name)
      return {
        name = group.name,
        action_names = collect_action_names(group),
      }
    end)
    :totable()
end

return M
