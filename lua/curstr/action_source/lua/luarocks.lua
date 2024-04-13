local M = {}

function M.create()
  if vim.fn.executable("luarocks") == 0 then
    return nil
  end
  local cword = require("curstr.lib.cursor").word("./")
  local name = cword:gsub("%.", "/")
  local path = vim.fn.systemlist({ "luarocks", "which", name })[1]
  if require("curstr.lib.file").readable(path) then
    return { group_name = "file", path = path }
  end
  return nil
end

M.filetypes = {
  "lua",
  "vim",
}

M.description = [[uses `luarocks which` command outputs]]

return M
