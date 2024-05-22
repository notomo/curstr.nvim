local M = {}

function M.action_select(ctx)
  local _, mode = require("curstr.vendor.misclib.visual_mode").leave()
  mode = ctx.args.mode or mode

  vim.cmd.normal({ args = { "m'" }, bang = true })

  local start_pos = ctx.args.start_pos
  vim.api.nvim_buf_set_mark(0, "<", start_pos[1], start_pos[2], {})

  local end_pos = ctx.args.end_pos
  vim.api.nvim_buf_set_mark(0, ">", end_pos[1], end_pos[2], {})

  if mode ~= "n" then
    vim.cmd.normal({ args = { "gv" }, bang = true })
  end
end

M.default_action = "select"

return M
