local M = {}

M.join = function(...)
  return table.concat({...}, "/")
end

return M
