local M = {}

function M.join(...)
  return table.concat({...}, "/")
end

return M
