local M = {}

function M.create(_, opts)
  return { group_name = "range", first = opts.range.first, last = opts.range.last }
end

M.description = [[uses the given range]]

return M
