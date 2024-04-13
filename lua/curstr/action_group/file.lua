local filelib = require("curstr.lib.file")

local M = {}

function M._adjust_cursor(position)
  if position == nil then
    return
  end

  local count = vim.api.nvim_buf_line_count(0)
  local row = position[1]
  if row > count then
    row = count
  end

  vim.api.nvim_win_set_cursor(0, { row, position[2] - 1 })
end

function M.action_open(ctx)
  vim.cmd.edit(filelib.escape(ctx.args.path))
  M._adjust_cursor(ctx.args.position)
end

function M.action_tab_open(ctx)
  vim.cmd.tabedit(filelib.escape(ctx.args.path))
  M._adjust_cursor(ctx.args.position)
end

function M.action_vertical_open(ctx)
  vim.cmd.vsplit(filelib.escape(ctx.args.path))
  M._adjust_cursor(ctx.args.position)
end

function M.action_horizontal_open(ctx)
  vim.cmd.split(filelib.escape(ctx.args.path))
  M._adjust_cursor(ctx.args.position)
end

M.default_action = "open"

return M
