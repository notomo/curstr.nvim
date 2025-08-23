local filelib = require("curstr.lib.file")

local M = {}

function M.action_open(ctx)
  filelib.lcd(ctx.args.path)
  ctx.opts.after(ctx.args.path)
end

function M.action_tab_open(ctx)
  vim.cmd.tabedit({ args = { ctx.args.path }, magic = { file = false } })
  filelib.lcd(ctx.args.path)
  ctx.opts.after(ctx.args.path)
end

function M.action_vertical_open(ctx)
  vim.cmd.vsplit({ args = { ctx.args.path }, magic = { file = false } })
  filelib.lcd(ctx.args.path)
  ctx.opts.after(ctx.args.path)
end

function M.action_horizontal_open(ctx)
  vim.cmd.split({ args = { ctx.args.path }, magic = { file = false } })
  filelib.lcd(ctx.args.path)
  ctx.opts.after(ctx.args.path)
end

M.opts = {
  after = function(_) end,
}

M.default_action = "open"

return M
