local modulelib = require("curstr.vendor.misclib.module")
local ActionGroup = require("curstr.core.action_group")

local Source = {}

--- @return CurstrActionSource|string
function Source.new(name, source_opts, filetypes)
  vim.validate({
    name = { name, "string" },
    source_opts = { source_opts, "table" },
    filetypes = { filetypes, "table", true },
  })

  local source = modulelib.find("curstr.action_source." .. name)
  if source == nil then
    return "not found action source: " .. name
  end

  local custom_source = require("curstr.core.custom").config.sources[name] or {}
  local tbl = {
    name = name,
    opts = vim.tbl_extend("force", source.opts or {}, source_opts, custom_source.opts or {}),
    filetypes = filetypes or custom_source.filetypes or source.filetypes,
    _source = source,
  }
  return setmetatable(tbl, Source)
end

function Source.to_group(_, group_name, args)
  return ActionGroup.new(group_name, args)
end

function Source.enabled(self)
  return vim.tbl_contains(self.filetypes, "_") or vim.tbl_contains(self.filetypes, vim.bo.filetype)
end

local base = require("curstr.action_source.base")
function Source.__index(self, k)
  return rawget(Source, k) or self._source[k] or base[k]
end

local function _resolve(source_name, source_opts, filetypes)
  local ailias = require("curstr.core.custom").config.source_aliases[source_name] or {}
  local opts = vim.tbl_extend("force", source_opts, ailias.opts or {})
  local ailias_filetypes = filetypes or ailias.filetypes
  local source_names = ailias.names or {}
  if #source_names == 0 then
    local resolved_one = {
      source_name = source_name,
      source_opts = opts,
      filetypes = ailias_filetypes,
    }
    return { resolved_one }
  end

  local resolved = {}
  for _, name in ipairs(source_names) do
    vim.list_extend(resolved, _resolve(name, opts, ailias_filetypes))
  end
  return resolved
end

--- @return CurstrActionSource[]|string
function Source.resolve(name)
  local sources = {}
  for _, resolved in ipairs(_resolve(name, {}, nil)) do
    local source = Source.new(resolved.source_name, resolved.source_opts, resolved.filetypes)
    if type(source) == "string" then
      local err = source
      return err
    end

    if source:enabled() then
      table.insert(sources, source)
    end
  end
  return sources
end

function Source.all()
  return vim
    .iter(vim.api.nvim_get_runtime_file("lua/curstr/action_source/**/*.lua", true))
    :map(function(path)
      local file = vim.split(vim.fs.normalize(path), "lua/curstr/action_source/", { plain = true })[2]
      local name = file:sub(1, #file - 4)
      if name == "base" then
        return nil
      end
      return Source.new(name, {})
    end)
    :totable()
end

return Source
