local modulelib = require("curstr.lib.module")
local filelib = require("curstr.lib.file")
local pathlib = require("curstr.lib.path")
local base = require("curstr.action_source.base")
local cursor = require("curstr.core.cursor")
local group_core = require("curstr.core.action_group")
local custom = require("curstr.custom")

local M = {}

function M._create(source_name, source_opts, filetypes)
  local origin
  if source_name == "base" then
    origin = base
  else
    local found = modulelib.find_action_source(source_name)
    if found == nil then
      return nil, "not found action source: " .. source_name
    end
    origin = setmetatable(found, base)
    origin.__index = origin
  end

  local tbl = {}
  tbl.name = source_name
  tbl.cursor = cursor
  tbl.filelib = filelib
  tbl.pathlib = pathlib

  local custom_source = custom.sources[source_name] or {}
  tbl.opts = vim.tbl_extend("force", origin.opts, source_opts, custom_source.opts or {})
  tbl.filetypes = filetypes or custom_source.filetypes or origin.filetypes

  local source = setmetatable(tbl, origin)

  source.to_group = function(_, group_name, args)
    local group, err = group_core.create(group_name, args)
    if err ~= nil then
      return nil, err
    end
    return group, nil
  end

  source.enabled = function(self)
    return vim.tbl_contains(self.filetypes, "_") or vim.tbl_contains(self.filetypes, vim.bo.filetype)
  end

  return source, nil
end

local function _resolve(source_name, source_opts, filetypes)
  local resolved = {}

  local ailias = custom.source_aliases[source_name] or {}
  local opts = vim.tbl_extend("force", source_opts, ailias.opts or {})
  local ailias_filetypes = filetypes or ailias.filetypes
  local source_names = ailias.names or {}
  if #source_names == 0 then
    return {{source_name = source_name, source_opts = opts, filetypes = ailias_filetypes}}
  end

  for _, name in ipairs(source_names) do
    vim.list_extend(resolved, _resolve(name, opts, ailias_filetypes))
  end
  return resolved
end

function M.all(name)
  local sources = {}
  for _, resolved in ipairs(_resolve(name, {}, nil)) do
    local source, err = M._create(resolved.source_name, resolved.source_opts, resolved.filetypes)
    if err ~= nil then
      return nil, err
    end
    if source:enabled() then
      table.insert(sources, source)
    end
  end
  return sources, nil
end

return M
