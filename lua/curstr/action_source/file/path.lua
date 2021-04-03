local M = {}

function M.create(self)
  local path, position = self.cursor:file_path_with_position()
  local abs_path = vim.fn.fnamemodify(vim.fn.expand(path), ":p")
  if not self.filelib.readable(abs_path) then
    return nil
  end
  return self:to_group("file", {path = abs_path, position = position})
end

return M
