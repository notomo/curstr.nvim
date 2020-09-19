local M = {}

M.create = function(self)
  local path = self.cursor:file_path()
  local abs_path = self.pathlib.join(vim.fn.expand("%:p:h"), path)
  if not self.filelib.is_directory(abs_path) then
    return nil
  end
  return self:to_group("directory", {path = abs_path})
end

return M
