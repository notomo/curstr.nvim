local M = {}

function M.create()
  local range = require("curstr.vendor.misclib.visual_mode").row_range()
    or { first = vim.fn.line("."), last = vim.fn.line(".") }
  return { group_name = "range", first = range.first, last = range.last }
end

M.description = [[uses the given range]]

return M
