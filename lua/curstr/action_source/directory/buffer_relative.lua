local M = {}

M.create = function(self)
  local path = self.cursor:file_path()
  local abs_path = self.pathlib.join(vim.fn.expand("%:p:h"), path)
  return self:to_group("directory", {path = abs_path})
end

return M
