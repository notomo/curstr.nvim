local M = {}

function M.readable(file_path)
  return vim.fn.filereadable(file_path) ~= 0
end

function M.is_directory(file_path)
  return vim.fn.isdirectory(file_path) ~= 0
end


function M.lcd(path)
  vim.fn.chdir(path, "window")
end

return M
