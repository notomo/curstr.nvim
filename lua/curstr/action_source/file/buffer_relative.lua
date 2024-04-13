local M = {}

function M.create(self)
  local path, position = require("curstr.core.cursor").file_path_with_position()
  local abs_path = vim.fs.joinpath(vim.fn.expand("%:p:h"), path)
  if not require("curstr.lib.file").readable(abs_path) then
    return nil
  end
  return self:to_group("file", { path = abs_path, position = position })
end

M.description = [[uses a relative file path with current buffer]]

return M
