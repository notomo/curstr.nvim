local M = {}

function M.create(self)
  local cword = self.cursor:word("#")
  if cword:find("#") == nil then
    return nil
  end

  local path_parts = vim.split(cword, "#", { plain = true })
  table.remove(path_parts, #path_parts)
  local target = ("%s.vim"):format(table.concat(path_parts, "/"))
  local paths = vim.api.nvim_get_runtime_file("autoload/" .. target, true)
  for _, path in ipairs(paths) do
    if self.filelib.readable(path) then
      local position = self._search(cword, path)
      return self:to_group("file", { path = path, position = position })
    end
  end

  if not self.opts.include_packpath then
    return nil
  end

  local pack_path = vim.split(vim.o.packpath, ",", { plain = true })[1]
  local package = vim.fn.fnamemodify(pack_path, ":p")
  local pattern = self.pathlib.join(package, "pack/*/opt/*/autoload", target)
  for _, path in ipairs(vim.fn.glob(pattern, false, true)) do
    if self.filelib.readable(path) then
      local position = self._search(cword, path)
      return self:to_group("file", { path = path, position = position })
    end
  end

  return nil
end

function M._search(name, path)
  local f = io.open(path, "r")
  local row = 1
  local pattern = ("\\v\\s*fu(nction)?!?\\s*\\zs%s\\ze\\("):format(name)
  local regex = vim.regex(pattern)
  for line in f:lines() do
    local s = regex:match_str(line)
    if s ~= nil then
      f:close()
      return { row, s + 1 }
    end
    row = row + 1
  end
  f:close()
  return nil
end

M.opts = { include_packpath = false }

M.filetypes = { "vim" }

M.description = [[searches a vim autoload function]]

return M
