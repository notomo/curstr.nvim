local wraplib = require("curstr.lib.wrap")
local messagelib = require("curstr.lib.message")
local cmdparse = require("curstr.lib.cmdparse")
local Source = require("curstr.core.action_source").Source

local M = {}

local default_opts = {action = nil}

function M.execute_by_excmd(raw_args, first_row, last_row)
  local source_name, opts, _, parse_err = cmdparse.args(raw_args, vim.tbl_extend("force", default_opts, {}))
  if parse_err ~= nil then
    return nil, messagelib.error(parse_err)
  end
  opts.range = {first = first_row, last = last_row}

  local result, err = wraplib.traceback(function()
    return M._execute(source_name, opts)
  end)
  if err ~= nil then
    return nil, messagelib.error(err)
  end
  return result, nil
end

function M._execute(source_name, opts)
  local sources, source_err = Source.all(source_name)
  if source_err ~= nil then
    return nil, source_err
  end

  for _, source in ipairs(sources) do
    local group, err = source:create(opts)
    if err ~= nil then
      return nil, err
    end
    if group ~= nil then
      return group:execute(opts.action)
    end
  end

  return nil, messagelib.echo("not found matched source: " .. source_name)
end

vim.cmd("doautocmd User CurstrSourceLoad")

return M
