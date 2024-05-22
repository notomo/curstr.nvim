local M = {}

function M.create()
  local is_visual, mode = require("curstr.vendor.misclib.visual_mode").leave()

  local original_pos = vim.api.nvim_win_get_cursor(0)

  vim.cmd.normal({ args = { "0" }, bang = true })
  local start_pos = vim.api.nvim_win_get_cursor(0)

  vim.cmd.normal({ args = { "$" }, bang = true })
  local end_pos = vim.api.nvim_win_get_cursor(0)

  vim.api.nvim_win_set_cursor(0, original_pos)
  if is_visual then
    vim.cmd.normal({ args = { "gv" }, bang = true })
  end

  return "textobject", {
    mode = mode,
    start_pos = start_pos,
    end_pos = end_pos,
  }
end

M.description = [[uses a buffer's around line]]

return M
