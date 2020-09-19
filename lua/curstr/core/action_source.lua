local modulelib = require("curstr/lib/module")
local filelib = require("curstr/lib/file")
local pathlib = require("curstr/lib/path")
local base = require("curstr/action_source/base")
local cursor = require("curstr/core/cursor")
local group_core = require("curstr/core/action_group")

local M = {}

M._create = function(source_name, source_opts, action_opts)
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
  tbl.opts = vim.tbl_extend("force", origin.opts, source_opts)
  tbl.action_opts = action_opts

  local source = setmetatable(tbl, origin)

  source.to_group = function(self, group_name, args)
    local group, err = group_core.create(group_name, args, self.action_opts[group_name] or {})
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

M.all = function(name)
  local action_opts = vim.fn["curstr#custom#get_action_options"]()

  local sources = {}
  for _, resolved in ipairs(_resolve(name, {})) do
    local source, err = M._create(resolved.source_name, resolved.source_opts, action_opts)
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
