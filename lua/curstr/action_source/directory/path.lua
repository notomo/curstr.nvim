local M = {}

function M.create()
  local path = require("curstr.lib.cursor").file_path()
  local abs_path = vim.fn.fnamemodify(path, ":p")
  if not require("curstr.lib.file").is_directory(abs_path) then
    return nil
  end
  return "directory", { path = abs_path }
end

M.description = [[uses a directory path]]

return M
