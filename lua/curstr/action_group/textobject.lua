local M = {}

function M.action_select(ctx)
  local _, mode = require("curstr.vendor.misclib.visual_mode").leave()
  mode = ctx.args.mode or mode

  if ctx.args.visual_mode then
    vim.cmd.normal({ args = { ctx.args.visual_mode }, bang = true })
    require("curstr.vendor.misclib.visual_mode").leave()
  end

  vim.cmd.normal({ args = { "m'" }, bang = true })

  local start_pos = ctx.args.start_pos
  vim.api.nvim_buf_set_mark(0, "<", start_pos[1], start_pos[2], {})

  local end_pos = ctx.args.end_pos
  local end_row = end_pos[1]
  local end_col = end_pos[2]
  if end_col < 0 then
    local original_pos = vim.api.nvim_win_get_cursor(0)
    end_row = math.max(1, end_row - 1)
    vim.api.nvim_win_set_cursor(0, { end_row, 0 })
    end_col = vim.fn.col("$")
    vim.api.nvim_win_set_cursor(0, original_pos)
  end
  vim.api.nvim_buf_set_mark(0, ">", end_row, end_col, {})

  if mode ~= "n" then
    vim.cmd.normal({ args = { "gv" }, bang = true })
  end
end

M.default_action = "select"

return M
