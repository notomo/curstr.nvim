local M = {}

function M.create(self)
  local path = self.cursor:file_path()
  local abs_path = vim.fs.joinpath(vim.fn.expand("%:p:h"), path)
  if not self.filelib.is_directory(abs_path) then
    return nil
  end
  return self:to_group("directory", { path = abs_path })
end

M.description = [[uses relative directory path with current buffer]]

return M
