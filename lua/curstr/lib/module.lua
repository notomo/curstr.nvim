local M = {}

local find = function(path)
  local ok, module = pcall(require, path)
  if not ok then
    return nil
  end
  return module
end

local function set_base(target, base)
  local meta = getmetatable(target)
  if meta == nil then
    return setmetatable(target, base)
  end
  if target == meta then
    return target
  end
  return setmetatable(target, set_base(meta, base))
end
M.set_base = set_base

-- for app

M.find_action_group = function(name)
  return find("curstr/action_group" .. name)
end

M.find_action_source = function(name)
  return find("curstr/action_source" .. name)
end

M.cleanup = function(name)
  local dir = name .. "/"
  for key in pairs(package.loaded) do
    if vim.startswith(key, dir) or key == name then
      package.loaded[key] = nil
    end
  end
  vim.api.nvim_command("doautocmd User CurstrSourceLoad")
end

return M
