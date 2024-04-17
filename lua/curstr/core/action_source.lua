local modulelib = require("curstr.vendor.misclib.module")

local M = {}

local new = function(source_name)
  local source = modulelib.find("curstr.action_source." .. source_name)
  if source == nil then
    return "not found action source: " .. source_name
  end
  source.name = source_name
  return source
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

local enabled = function(filetypes)
  return vim.tbl_contains(filetypes, "_") or vim.tbl_contains(filetypes, vim.bo.filetype)
end

local create_group = function(resolved)
  local source = new(resolved.source_name)
  if type(source) == "string" then
    local err = source
    return err
  end

  local custom = require("curstr.core.custom").config.sources[source.name] or {}

  local filetypes = resolved.filetypes or custom.filetypes or source.filetypes or { "_" }
  if not enabled(filetypes) then
    return nil
  end

  local opts = vim.tbl_extend("force", source.opts or {}, resolved.source_opts, custom.opts or {})
  local ctx = {
    opts = opts,
  }

  local group_name, args = source.create(ctx)
  if not group_name then
    return nil
  end

  return {
    name = group_name,
    args = args,
  }
end

function M.resolve(name)
  for _, resolved in ipairs(_resolve(name, {}, nil)) do
    local raw_group = create_group(resolved)
    if type(raw_group) == "string" then
      local err = raw_group
      return err
    end

    if raw_group then
      return raw_group
    end
  end
end

function M.all()
  return vim
    .iter(vim.api.nvim_get_runtime_file("lua/curstr/action_source/**/*.lua", true))
    :map(function(path)
      local file = vim.split(vim.fs.normalize(path), "lua/curstr/action_source/", { plain = true })[2]
      local name = file:sub(1, #file - 4)
      return new(name)
    end)
    :totable()
end

return M
