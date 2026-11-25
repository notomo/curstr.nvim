local M = {}

function M.word(added_iskeyword)
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

function M.word_with_range(char_pattern)
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

local narrow_to_ascii = function(file_path)
  if not file_path:find("[\128-\255]") then
    return nil
  end

  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1

  local offset = nil
  local init = 1
  while true do
    local s, e = line:find(file_path, init, true)
    if s == nil then
      break
    end
    if s <= col and col <= e then
      offset = col - s + 1
      break
    end
    if offset == nil and col < s then
      offset = 0
    end
    init = s + 1
  end

  local segments = {}
  for segment, e in file_path:gmatch("([\1-\127]+)()") do
    -- only separators: a rest of multibyte path, not a path
    if trim_prefix(segment):find("[^/]") then
      table.insert(segments, { e = e - 1, str = segment })
    end
  end
  if #segments == 0 then
    return nil
  end
  if offset == nil then
    return segments[1].str
  end

  local last
  for _, segment in ipairs(segments) do
    if offset <= segment.e then
      return segment.str
    end
    last = segment
  end
  return last.str
end

local expand_cfile = function(added_isfname)
  if added_isfname == nil then
    return vim.fn.expand("<cfile>")
  end

  local origin_isfname = vim.o.isfname
  local splitted = vim.split(origin_isfname, ",", { plain = true })
  vim.list_extend(splitted, vim.split(added_isfname, "", { plain = true }))
  local new_isfname = table.concat(splitted, ",")

  vim.o.isfname = new_isfname
  local path = vim.fn.expand("<cfile>")
  vim.o.isfname = origin_isfname

  return path
end

--- Returns path candidates in order of priority.
function M.file_paths(added_isfname)
  local cfile = expand_cfile(added_isfname)
  local paths = { trim_prefix(cfile) }

  local ascii = narrow_to_ascii(cfile)
  if ascii ~= nil then
    table.insert(paths, trim_prefix(ascii))
  end

  return paths
end

local parse_position = function(str, s, e)
  local position = str:sub(s + 1, e)
  local row, col = unpack(vim.split(position, "[,:]"))
  return { tonumber(row), tonumber(col or 1) }
end

local file_path_regex = vim.regex("\\v[^:]+:\\zs(\\d+)([,:]\\d+)?")

local split_position = function(file_path)
  do
    local s, e = file_path_regex:match_str(file_path)
    if s ~= nil then
      local path = file_path:sub(1, s - 1)
      local position = parse_position(file_path, s, e)
      return path, position
    end
  end

  local cword = trim_prefix(vim.fn.expand("<cWORD>"))
  local pattern = ("\\V%s:\\zs\\v(\\d+)([,:]\\d+)?"):format(vim.fn.escape(file_path, "\\"))
  local s, e = vim.regex(pattern):match_str(cword)
  if s == nil then
    return file_path, nil
  end
  return file_path, parse_position(cword, s, e)
end

--- Returns path candidates with position in order of priority.
function M.file_paths_with_position(added_isfname)
  return vim
    .iter(M.file_paths(added_isfname))
    :map(function(file_path)
      local path, position = split_position(file_path)
      return { path = path, position = position }
    end)
    :totable()
end

function M.line_with_range()
  local line = vim.api.nvim_get_current_line()
  return line, { 1, #line }
end

return M
