local M = {}

function M.create()
  local original_pos = vim.api.nvim_win_get_cursor(0)

  vim.cmd.normal({ args = { "G$" }, mods = { keepjumps = true }, bang = true })
  local end_pos = vim.api.nvim_win_get_cursor(0)

  vim.api.nvim_win_set_cursor(0, original_pos)

  return "textobject", {
    start_pos = { 1, 0 },
    end_pos = end_pos,
  }
end

M.description = [[uses a buffer's entire lines]]

return M
