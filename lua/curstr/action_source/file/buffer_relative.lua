local M = {}

M.create = function(self)
  local path, position = self.cursor:file_path_with_position()
  local abs_path = self.pathlib.join(vim.fn.expand("%:p:h"), path)
  return self:to_group("file", {path = abs_path, position = position})
end

return M
