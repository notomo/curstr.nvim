local M = {}

function M.create(self, opts)
  return self:to_group("range", {first = opts.range.first, last = opts.range.last})
end

M.description = [[uses the given range]]

return M
