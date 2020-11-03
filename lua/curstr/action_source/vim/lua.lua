local M = {}

M.create = function(self)
  local cword = self.cursor:word("./")
  local name = cword:gsub("%.", "/")

  local pattern = ("lua/%s.lua"):format(name)
  local paths = vim.api.nvim_get_runtime_file(pattern, true)
  for _, path in ipairs(paths) do
    if self.filelib.readable(path) then
      return self:to_group("file", {path = path})
    end
  end

  return nil
end

M.filetypes = {"lua", "vim"}

return M
