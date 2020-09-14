local M = {}

M.create = function(self, opts)
  return self:to_group("range", {value = opts.range})
end

return M
