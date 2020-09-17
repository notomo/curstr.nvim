local M = {}

M._adjust_cursor = function(self)
  if self.position == nil then
    return
  end
  local count = vim.api.nvim_buf_line_count(0)
  local row = self.position[1]
  if row > count then
    row = count
  end
  vim.api.nvim_win_set_cursor(0, {row, self.position[2] - 1})
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
