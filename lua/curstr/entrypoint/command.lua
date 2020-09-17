local wraplib = require("curstr/lib/wrap")
local messagelib = require("curstr/lib/message")
local cmdparse = require("curstr/lib/cmdparse")
local source_core = require("curstr/core/action_source")

local M = {}

local default_opts = {action = nil}

M.execute_by_excmd = function(raw_args, first_row, last_row)
  local args = vim.split(raw_args, "%s+")
  local source_name, opts, _, parse_err = cmdparse.args(args, vim.tbl_extend("force", default_opts, {}))
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

M._execute = function(source_name, opts)
  local action_opts = vim.fn["curstr#custom#get_action_options"]()
  local source_opts = vim.fn["curstr#custom#get_source_options"](source_name)
  local sources, source_err = source_core.all(source_name, source_opts, action_opts)
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

  return nil, messagelib.echo("not found metched source: " .. source_name)
end

return M
