local M = {}

function M.create()
  local cword = require("curstr.lib.cursor").word(":<>")
  local position = M._search(cword)
  if position == nil then
    return nil
  end
  local abs_path = vim.fn.expand("%:p")
  if not require("curstr.lib.file").readable(abs_path) then
    return nil
  end
  return "file", { path = abs_path, position = position }
end

function M._search(name)
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

M.filetypes = {
  "vim",
}

M.description = [[searches vim script local functions]]

return M
