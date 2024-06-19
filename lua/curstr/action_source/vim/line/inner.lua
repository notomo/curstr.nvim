local M = {}

function M.create()
  local original_pos = vim.api.nvim_win_get_cursor(0)

  vim.cmd.normal({ args = { "^" }, bang = true })
  local start_pos = vim.api.nvim_win_get_cursor(0)

  vim.cmd.normal({ args = { "g_" }, bang = true })
  local end_pos = vim.api.nvim_win_get_cursor(0)

  vim.api.nvim_win_set_cursor(0, original_pos)

  return "textobject", {
    start_pos = start_pos,
    end_pos = end_pos,
    visual_mode = "v",
  }
end

M.description = [[uses a buffer's inner line]]

return M
