local M = {}

function M.create()
  local path = require("curstr.lib.cursor").file_path()
  local abs_path = vim.fs.joinpath(vim.fn.expand("%:p:h"), path)
  if not require("curstr.lib.file").is_directory(abs_path) then
    return nil
  end
  return "directory", { path = abs_path }
end

M.description = [[uses relative directory path with current buffer]]

return M
