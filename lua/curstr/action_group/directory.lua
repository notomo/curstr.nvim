local M = {}

function M.after(_, _) end

function M.action_open(self)
  vim.cmd.lcd(self.path)
  self:after(self.path)
end

function M.action_tab_open(self)
  vim.cmd.tabedit(self.path)
  vim.cmd.lcd(self.path)
  self:after(self.path)
end

function M.action_vertical_open(self)
  vim.cmd.vsplit(self.path)
  vim.cmd.lcd(self.path)
  self:after(self.path)
end

function M.action_horizontal_open(self)
  vim.cmd.split(self.path)
  vim.cmd.lcd(self.path)
  self:after(self.path)
end

M.default_action = "open"

return M
