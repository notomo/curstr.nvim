local M = {}

function M.readable(file_path)
  return vim.fn.filereadable(file_path) ~= 0
end

function M.is_directory(file_path)
  return vim.fn.isdirectory(file_path) ~= 0
end

function M._escape(path)
  return ([[`='%s'`]]):format(path:gsub("'", "''"))
end

function M.lcd(path)
  vim.cmd.lcd({ args = { M._escape(path) }, mods = { silent = true } })
end

return M
