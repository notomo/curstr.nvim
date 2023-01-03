local M = {}

function M.create(self)
  local cword = self.cursor:word("./-")
  local name = cword:gsub("%.", "/")

  local lua = ("lua/%s.lua"):format(name)
  local init_lua = ("lua/%s/init.lua"):format(name)
  local paths = vim.api.nvim_get_runtime_file(lua, true)
  vim.list_extend(paths, vim.api.nvim_get_runtime_file(init_lua, true))

  for _, path in ipairs(paths) do
    if self.filelib.readable(path) then
      return self:to_group("file", { path = path })
    end
  end

  local opt_paths = {}
  local pack_path = vim.split(vim.o.packpath, ",", { plain = true })[1]
  pack_path = vim.fn.fnamemodify(pack_path, ":p")
  local pack_pattern = pack_path .. "pack/*/opt/*/"
  vim.list_extend(opt_paths, vim.fn.glob(pack_pattern .. lua, false, true))
  vim.list_extend(opt_paths, vim.fn.glob(pack_pattern .. init_lua, false, true))

  for _, path in ipairs(opt_paths) do
    if self.filelib.readable(path) then
      return self:to_group("file", { path = path })
    end
  end

  return nil
end

M.filetypes = { "lua", "vim" }

M.description = [[searchs a file from vim runtime lua directory]]

return M
