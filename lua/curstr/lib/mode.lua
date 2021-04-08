local M = {}

local ESC = vim.api.nvim_eval("\"\\<ESC>\"")
function M.visual_range()
  if not M.is_visual() then
    return nil
  end
  vim.cmd("normal! " .. ESC)
  return {first = vim.api.nvim_buf_get_mark(0, "<")[1], last = vim.api.nvim_buf_get_mark(0, ">")[1]}
end

local CTRL_V = vim.api.nvim_eval("\"\\<C-v>\"")
function M.is_visual()
  local mode = vim.api.nvim_get_mode().mode
  return mode == "v" or mode == "V" or mode == CTRL_V
end

return M
