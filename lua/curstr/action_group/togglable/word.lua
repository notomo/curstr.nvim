local M = {}

function M.action_toggle(ctx)
  if not vim.bo.modifiable then
    return
  end
  local new_line = M._new_line(ctx.args.range, ctx.args.value)
  vim.api.nvim_set_current_line(new_line)
end

function M.action_append(ctx)
  if not vim.bo.modifiable then
    return
  end
  local new_line = M._new_line(ctx.args.range, ctx.args.value)
  local bufnr = 0
  local row = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(bufnr, row, row + 1, false, { new_line })
end

function M._new_line(range, value)
  local line = vim.api.nvim_get_current_line()
  local prefix = line:sub(1, range[1])
  local suffix = line:sub(range[2] + 1)
  return ("%s%s%s"):format(prefix, value, suffix)
end

M.default_action = "toggle"

return M
