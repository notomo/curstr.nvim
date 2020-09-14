local M = {}

M.traceback = function(f)
  local ok, result, err = xpcall(f, debug.traceback)
  if not ok then
    error(result)
  end
  return result, err
end

return M
