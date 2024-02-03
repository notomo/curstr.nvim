local M = {}

function M.create(self)
  local path, position = self.cursor:file_path_with_position()
  local modified_path = self.opts.modify(path)
  if not self.filelib.readable(modified_path) then
    return nil
  end
  return self:to_group("file", { path = modified_path, position = position })
end

M.opts = {
  modify = function(path)
    return vim.fn.fnamemodify(vim.fn.expand(path), ":p")
  end,
}

M.description = [[uses a relative file path]]

return M
