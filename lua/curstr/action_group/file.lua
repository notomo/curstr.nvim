local M = {}

M._adjust_cursor = function(self)
  if self.row == nil then
    return
  end
  local count = vim.api.nvim_buf_line_count(0)
  local row = self.row
  if self.row > count then
    row = count
  end
  local range = self.range or {s = {column = 0}}
  vim.api.nvim_win_set_cursor(0, {row, range.s.column})
end

M.action_open = function(self)
  vim.api.nvim_command("edit " .. self.path)
  self:_adjust_cursor()
end

M.action_tab_open = function(self)
  vim.api.nvim_command("tabedit " .. self.path)
  self:_adjust_cursor()
end

M.action_vertical_open = function(self)
  vim.api.nvim_command("vsplit " .. self.path)
  self:_adjust_cursor()
end

M.action_horizontal_open = function(self)
  vim.api.nvim_command("split " .. self.path)
  self:_adjust_cursor()
end

M.default_action = "open"

return M
