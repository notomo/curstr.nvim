local modulelib = require("curstr/lib/module")
local filelib = require("curstr/lib/file")
local base = require("curstr/action_source/base")
local cursor = require("curstr/core/cursor")

local M = {}

M._create = function(name, source_opts)
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
  source.cursor = cursor
  source.filelib = filelib
  source.opts = vim.tbl_extend("force", origin.opts, source_opts)

  return setmetatable(source, origin), nil
end

M.all = function(name, source_opts)
  local aliased = vim.fn["curstr#custom#get_source_aliases"](name)
  local names = {name}
  if #aliased ~= 0 then
    names = aliased
  end

  local sources = {}
  for _, source_name in ipairs(names) do
    local source, err = M._create(source_name, source_opts)
    if err ~= nil then
      return nil, err
    end
    table.insert(sources, source)
  end
  return sources, nil
end

return M
