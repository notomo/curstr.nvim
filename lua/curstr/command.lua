local Source = require("curstr.core.action_source").Source
local messagelib = require("curstr.lib.message")
local cmdparse = require("curstr.lib.cmdparse")
local modelib = require("curstr.lib.mode")

local M = {}

local Command = {}
Command.__index = Command
M.Command = Command

function Command.new(name, ...)
  local args = {...}
  local f = function()
    return Command[name](unpack(args))
  end

  local ok, result, msg = xpcall(f, debug.traceback)
  if not ok then
    return messagelib.error(result)
  elseif msg then
    return messagelib.warn(msg)
  end
  return result
end

function Command.execute(source_name, opts)
  vim.validate({source_name = {source_name, "string"}, opts = {opts, "table", true}})

  local sources, source_err = Source.all(source_name)
  if source_err ~= nil then
    return nil, source_err
  end

  opts = opts or {}
  opts.range = opts.range or modelib.visual_range() or {
    first = vim.fn.line("."),
    last = vim.fn.line("."),
  }

  for _, source in ipairs(sources) do
    local group, err = source:create(opts)
    if err ~= nil then
      return nil, err
    end
    if group ~= nil then
      return group:execute(opts.action)
    end
  end

  return nil, "not found matched source: " .. source_name
end

function Command.execute_by_excmd(raw_args, first_row, last_row)
  local source_name, opts, _, parse_err = cmdparse.args(raw_args, {})
  if parse_err ~= nil then
    return nil, parse_err
  end
  opts.range = {first = first_row, last = last_row}

  local result, err = Command.execute(source_name, opts)
  if err ~= nil then
    return nil, err
  end

  return result, nil
end

vim.cmd("doautocmd User CurstrSourceLoad")

return M
