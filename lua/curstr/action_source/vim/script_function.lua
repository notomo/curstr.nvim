local M = {}

M.create = function(self)
  local cword = self.cursor:word(":<>")
  local position = self._search(cword)
  if position == nil then
    return nil
  end
  local abs_path = vim.fn.expand("%:p")
  if not self.filelib.readable(abs_path) then
    return nil
  end
  return self:to_group("file", {path = abs_path, position = position})
end

M._search = function(name)
  local pattern = "\\v(s:|<SID>|<sid>)\\zs\\S+\\ze"
  local regex = vim.regex(pattern)
  local s, e = regex:match_str(name)
  if s == nil then
    return nil
  end
  local func_name = name:sub(s + 1, e)
  local func_pattern = ("\\v\\s*fu%%[nction]!?\\s*s:\\zs%s\\("):format(func_name)
  local position = vim.fn.searchpos(func_pattern, "nw")
  if position[1] == 0 then
    return nil
  end
  return position
end

M.filetypes = {"vim"}

return M
