local M = {}

function M.create(self)
  if vim.fn.executable("luarocks") == 0 then
    return nil
  end
  local cword = self.cursor:word("./")
  local name = cword:gsub("%.", "/")
  local path = vim.fn.systemlist({ "luarocks", "which", name })[1]
  if self.filelib.readable(path) then
    return self:to_group("file", { path = path })
  end
  return nil
end

M.filetypes = { "lua", "vim" }

M.description = [[uses `luarocks which` command outputs]]

return M
