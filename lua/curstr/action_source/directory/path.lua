local M = {}

M.create = function(self)
  local path = self.cursor:file_path()
  local abs_path = vim.fn.fnamemodify(path, ":p")
  return self:to_group("directory", {path = abs_path})
end

return M
