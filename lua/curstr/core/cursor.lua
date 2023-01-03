local M = {}

function M.word(_, added_iskeyword)
  if added_iskeyword == nil then
    return vim.fn.expand("<cword>")
  end

  local origin_iskeyword = vim.bo.iskeyword
  local splitted = vim.split(origin_iskeyword, ",", { plain = true })
  vim.list_extend(splitted, vim.split(added_iskeyword, "", { plain = true }))
  local new_iskeyword = table.concat(splitted, ",")

  vim.bo.iskeyword = new_iskeyword
  local word = vim.fn.expand("<cword>")
  vim.bo.iskeyword = origin_iskeyword

  return word
end

function M.word_with_range(_, char_pattern)
  char_pattern = char_pattern or "\\k"
  local pos = vim.api.nvim_win_get_cursor(0)
  local line = vim.api.nvim_get_current_line()
  local pattern = ("\\v[%s]*%%%sc[%s]+"):format(char_pattern, pos[2] + 1, char_pattern)
  local word, start_byte = unpack(vim.fn.matchstrpos(line, pattern))
  if start_byte == -1 then
    return "", nil
  end
  local after_part = vim.fn.strpart(line, start_byte)
  local s = #line - #after_part
  local e = s + #word
  local word_range = { s, e }
  return word, word_range
end

local trim_prefix = function(file_path)
  file_path = file_path:gsub("^file://", "")
  return file_path
end

function M.file_path(_, added_isfname)
  if added_isfname == nil then
    return trim_prefix(vim.fn.expand("<cfile>"))
  end

  local origin_isfname = vim.o.isfname
  local splitted = vim.split(origin_isfname, ",", { plain = true })
  vim.list_extend(splitted, vim.split(added_isfname, "", { plain = true }))
  local new_isfname = table.concat(splitted, ",")

  vim.o.isfname = new_isfname
  local path = vim.fn.expand("<cfile>")
  vim.o.isfname = origin_isfname

  return trim_prefix(path)
end

local parse_position = function(str, s, e)
  local position = str:sub(s + 1, e)
  local row, col = unpack(vim.split(position, "[,:]"))
  return { tonumber(row), tonumber(col or 1) }
end

local file_path_regex = vim.regex("\\v[^:]+:\\zs(\\d+)([,:]\\d+)?")

function M.file_path_with_position(_, added_isfname)
  local file_path = M.file_path(added_isfname)

  do
    local s, e = file_path_regex:match_str(file_path)
    if s ~= nil then
      local path = file_path:sub(1, s - 1)
      local position = parse_position(file_path, s, e)
      return path, position
    end
  end

  local cword = trim_prefix(vim.fn.expand("<cWORD>"))
  local pattern = ("\\v%s:\\zs(\\d+)([,:]\\d+)?"):format(file_path)
  local ok, regex = pcall(vim.regex, pattern)
  if not ok then
    return file_path, nil
  end
  local s, e = regex:match_str(cword)
  if s == nil then
    return file_path, nil
  end
  return file_path, parse_position(cword, s, e)
end

function M.line_with_range()
  local line = vim.api.nvim_get_current_line()
  return line, { 1, #line }
end

return M
