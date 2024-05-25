local M = {}

M.create = require("curstr.action_source.vim.surrounded.inner").create

M.description = [[uses a buffer's surrounded around text]]

local opts = vim.deepcopy(require("curstr.action_source.vim.surrounded.inner").opts)
M.opts = vim.tbl_deep_extend("force", opts, {
  _start_offset = -1,
  _end_offset = 1,
})

return M
