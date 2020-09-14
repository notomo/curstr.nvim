local M = {}

M.create = function(self)
  local cword = self.cursor:word("#")
  if cword:find("#") == nil then
    return nil
  end

  local path_parts = vim.split(cword, "#", true)
  table.remove(path_parts, #path_parts)
  local target = ("%s.vim"):format(table.concat(path_parts, "/"))
  local paths = vim.api.nvim_get_runtime_file("autoload/" .. target, true)
  for _, path in ipairs(paths) do
    if self.filelib.readable(path) then
      local position = self._search(cword, path)
      return self:to_group("file", {path = path, position = position})
    end
  end

  if not self.opts.include_packpath then
    return nil
  end

  local pack_path = vim.split(vim.o.packpath, ",", true)[1]
  local package = vim.fn.fnamemodify(pack_path, ":p")
  local pattern = self.pathlib.join(package, "pack/*/opt//*/autoload", target)
  for _, path in ipairs(vim.fn.glob(pattern)) do
    if self.filelib.readable(path) then
      local position = self._search(cword, path)
      return self:to_group("file", {path = path, position = position})
    end
  end

  return nil
end

M._search = function(name, path)
  local f = io.open(path, "r")
  local row = 1
  local pattern = ("\\s*fu(nction)?!?\\s*\\zs%s\\ze\\("):format(name)
  local regex = vim.regex(pattern)
  for line in f:lines() do
    local s = regex:match(line)
    if s ~= nil then
      f:close()
      return {row, s}
    end
  end
  f:close()
  return nil
end

M.opts = {include_packpath = false}

M.filetypes = {"vim"}

return M
