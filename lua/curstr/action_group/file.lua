local filelib = require("curstr.lib.file")

local M = {}

function M._adjust_cursor(self)
  if self.position == nil then
    return
  end
  local count = vim.api.nvim_buf_line_count(0)
  local row = self.position[1]
  if row > count then
    row = count
  end
  vim.api.nvim_win_set_cursor(0, { row, self.position[2] - 1 })
end

function M.action_open(self)
  vim.cmd.edit(filelib.escape(self.path))
  self:_adjust_cursor()
end

function M.action_tab_open(self)
  vim.cmd.tabedit(filelib.escape(self.path))
  self:_adjust_cursor()
end

function M.action_vertical_open(self)
  vim.cmd.vsplit(filelib.escape(self.path))
  self:_adjust_cursor()
end

function M.action_horizontal_open(self)
  vim.cmd.split(filelib.escape(self.path))
  self:_adjust_cursor()
end

M.default_action = "open"

return M
