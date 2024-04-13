local M = {}

function M.create(self)
  local path = require("curstr.core.cursor").file_path()
  local abs_path = vim.fn.fnamemodify(path, ":p")
  if not require("curstr.lib.file").is_directory(abs_path) then
    return nil
  end
  return self:to_group("directory", { path = abs_path })
end

M.description = [[uses a directory path]]

return M
