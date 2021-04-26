local M = {}

function M.join(...)
  return table.concat({...}, "/")
end

if vim.fn.has("win32") == 1 then
  function M.adjust_sep(path)
    return path:gsub("\\", "/")
  end
else
  function M.adjust_sep(path)
    return path
  end
end

return M
