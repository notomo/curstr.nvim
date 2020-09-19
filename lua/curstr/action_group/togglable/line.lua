local M = {}

M.action_toggle = function(self)
  if not vim.bo.modifiable then
    return
  end
  vim.api.nvim_set_current_line(self.value)
end

M.action_append = function(self)
  if not vim.bo.modifiable then
    return
  end
  local bufnr = 0
  local row = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(bufnr, row, row, false, {self.value})
end

M.default_action = "toggle"

return M
