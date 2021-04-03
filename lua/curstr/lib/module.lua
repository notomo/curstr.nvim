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

function M.find_action_group(name)
  return find("curstr/action_group/" .. name)
end

function M.find_action_source(name)
  return find("curstr/action_source/" .. name)
end

local plugin_name = vim.split((...):gsub("%.", "/"), "/", true)[1]
function M.cleanup()
  local dir = plugin_name .. "/"
  local dot = plugin_name .. "."
  for key in pairs(package.loaded) do
    if (vim.startswith(key, dir) or vim.startswith(key, dot) or key == plugin_name) then
      package.loaded[key] = nil
    end
  end
  vim.cmd("doautocmd User CurstrSourceLoad")
end

return M
