local M = {}

function M.action_toggle(ctx)
  if not vim.bo.modifiable then
    return
  end

  vim.api.nvim_set_current_line(ctx.args.value)
end

function M.action_append(ctx)
  if not vim.bo.modifiable then
    return
  end

  local bufnr = 0
  local row = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(bufnr, row, row, false, { ctx.args.value })
end

M.default_action = "toggle"

return M
