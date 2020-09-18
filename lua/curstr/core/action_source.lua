local modulelib = require("curstr/lib/module")
local filelib = require("curstr/lib/file")
local pathlib = require("curstr/lib/path")
local base = require("curstr/action_source/base")
local cursor = require("curstr/core/cursor")

local M = {}

M._create = function(name, source_opts, action_opts)
  local origin
  if name == "base" then
    origin = base
  else
    local found = modulelib.find_action_source(name)
    if found == nil then
      return nil, "not found action source: " .. name
    end
    origin = setmetatable(found, base)
    origin.__index = origin
  end

  local source = {}
  source.name = name
  source.cursor = cursor
  source.filelib = filelib
  source.pathlib = pathlib
  source.opts = vim.tbl_extend("force", origin.opts, source_opts)
  source.action_opts = action_opts

  return setmetatable(source, origin), nil
end

local function _resolve(source_name, source_opts)
  local resolved = {}
  local aliased = vim.fn["curstr#custom#get_source_aliases"](source_name)
  local _opts = vim.fn["curstr#custom#get_source_options"](source_name)
  local opts = vim.tbl_extend("force", source_opts, _opts)
  if #aliased == 0 then
    return {{source_name = source_name, source_opts = opts}}
  end
  for _, name in ipairs(aliased) do
    vim.list_extend(resolved, _resolve(name, opts))
  end
  return resolved
end

M.all = function(name, action_opts)
  local sources = {}
  for _, resolved in ipairs(_resolve(name, {})) do
    local source, err = M._create(resolved.source_name, resolved.source_opts, action_opts)
    if err ~= nil then
      return nil, err
    end
    table.insert(sources, source)
  end
  return sources, nil
end

return M
