local modulelib = require("curstr.lib.module")
local filelib = require("curstr.lib.file")
local pathlib = require("curstr.lib.path")
local cursor = require("curstr.core.cursor")
local ActionGroup = require("curstr.core.action_group").ActionGroup

local M = {}

local Source = {}
M.Source = Source

function Source.new(name, source_opts, filetypes)
  vim.validate({
    name = {name, "string"},
    source_opts = {source_opts, "table"},
    filetypes = {filetypes, "table", true},
  })

  local source = modulelib.find("curstr.action_source." .. name)
  if source == nil then
    return nil, "not found action source: " .. name
  end

  local custom_source = require("curstr.core.custom").config.sources[name] or {}
  local tbl = {
    name = name,
    opts = vim.tbl_extend("force", source.opts or {}, source_opts, custom_source.opts or {}),
    filetypes = filetypes or custom_source.filetypes or source.filetypes,
    cursor = cursor,
    filelib = filelib,
    pathlib = pathlib,
    _source = source,
  }
  return setmetatable(tbl, Source)
end

function Source.to_group(_, group_name, args)
  local group, err = ActionGroup.new(group_name, args)
  if err ~= nil then
    return nil, err
  end
  return group, nil
end

function Source.enabled(self)
  return vim.tbl_contains(self.filetypes, "_") or vim.tbl_contains(self.filetypes, vim.bo.filetype)
end

local base = require("curstr.action_source.base")
function Source.__index(self, k)
  return rawget(Source, k) or self._source[k] or base[k]
end

local function _resolve(source_name, source_opts, filetypes)
  local resolved = {}

  local ailias = require("curstr.core.custom").config.source_aliases[source_name] or {}
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

function Source.all(name)
  local sources = {}
  for _, resolved in ipairs(_resolve(name, {}, nil)) do
    local source, err = Source.new(resolved.source_name, resolved.source_opts, resolved.filetypes)
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
