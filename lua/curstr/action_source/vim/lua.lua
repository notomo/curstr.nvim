local M = {}

function M.create(self)
  local cword = self.cursor:word("./")
  local name = cword:gsub("%.", "/")

  local paths = vim.api.nvim_get_runtime_file(("lua/%s.lua"):format(name), true)
  vim.list_extend(paths, vim.api.nvim_get_runtime_file(("lua/%s/init.lua"):format(name), true))
  for _, path in ipairs(paths) do
    if self.filelib.readable(path) then
      return self:to_group("file", {path = path})
    end
  end

  return nil
end

M.filetypes = {"lua", "vim"}

return M
