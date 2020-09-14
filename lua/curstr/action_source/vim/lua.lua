local M = {}

M.create = function(self)
  local cword = self.cursor:word("./")
  local name = cword:gsub(".", "/")

  local paths = vim.split(package.path, ";", true)
  for _, path in ipairs(paths) do
    local file_path = path:gsub("?", name)
    if self.filelib.readable(file_path) then
      return self:to_group("file", {path = file_path})
    end
  end

  return nil
end

M.filetypes = {"lua", "vim"}

return M
