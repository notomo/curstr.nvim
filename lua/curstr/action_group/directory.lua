local M = {}

M.after = function(_)
end

M.action_open = function(self)
  vim.api.nvim_command("lcd " .. self.path)
  self:after(self.path)
end

M.action_tab_open = function(self)
  vim.api.nvim_command("tabedit " .. self.path)
  vim.api.nvim_command("lcd " .. self.path)
  self:after(self.path)
end

M.action_vertical_open = function(self)
  vim.api.nvim_command("vsplit " .. self.path)
  vim.api.nvim_command("lcd " .. self.path)
  self:after(self.path)
end

M.action_horizontal_open = function(self)
  vim.api.nvim_command("split " .. self.path)
  vim.api.nvim_command("lcd " .. self.path)
  self:after(self.path)
end

M.default_action = "open"

return M
