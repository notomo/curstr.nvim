local M = {}

M.readable = function(file_path)
  return vim.fn.filereadable(file_path) ~= 0
end

M.is_directory = function(file_path)
  return vim.fn.isdirectory(file_path) ~= 0
end

return M
