local modulelib = require("curstr.vendor.misclib.module")
local filelib = require("curstr.lib.file")
local pathlib = require("curstr.vendor.misclib.path")
local cursor = require("curstr.core.cursor")
local ActionGroup = require("curstr.core.action_group")

local Source = {}

function Source.new(name, source_opts, filetypes)
  vim.validate({
    name = { name, "string" },
    source_opts = { source_opts, "table" },
    filetypes = { filetypes, "table", true },
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
    return { { source_name = source_name, source_opts = opts, filetypes = ailias_filetypes } }
  end

  for _, name in ipairs(source_names) do
    vim.list_extend(resolved, _resolve(name, opts, ailias_filetypes))
  end
  return resolved
end

function Source.resolve(name)
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

function Source.all()
  local paths = vim.api.nvim_get_runtime_file("lua/curstr/action_source/**/*.lua", true)
  local sources = vim.tbl_map(function(path)
    local file = vim.split(pathlib.normalize(path), "lua/curstr/action_source/", true)[2]
    local name = file:sub(1, #file - 4)
    return Source.new(name, {})
  end, paths)
  return vim.tbl_filter(function(source)
    return source.name ~= "base"
  end, sources)
end

return Source
