local M = {}

M.create = function(self, opts)
  return self:to_group("range", {first = opts.range.first, last = opts.range.last})
end

return M