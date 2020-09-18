local M = {}

M.action_toggle = function(self)
  local new_line = self:_new_line()
  vim.api.nvim_set_current_line(new_line)
end

M.action_append = function(self)
  local new_line = self:_new_line()
  local bufnr = 0
  local row = vim.api.nvim_win_get_cursor(0)[1] - 1
  vim.api.nvim_buf_set_lines(bufnr, row, row + 1, false, {new_line})
end

M._new_line = function(self)
  local line = vim.api.nvim_get_current_line()
  local prefix = line:sub(1, self.range[1])
  local suffix = line:sub(self.range[2] + 1)
  return ("%s%s%s"):format(prefix, self.value, suffix)
end

M.default_action = "toggle"

return M
