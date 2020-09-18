local M = {}

M.create = function(self)
  local source_pattern = self.opts.source_pattern
  local flags = self.opts.flags

  local path = self.cursor:file_path()
  local target_path = vim.fn.substitute(path, source_pattern, self.opts.result_pattern, flags)
  local abs_path = vim.fn.fnamemodify(target_path, ":p")
  if not self.filelib.readable(abs_path) then
    return nil
  end

  local search_pattern = self.opts.search_pattern
  local position = nil
  if search_pattern ~= "" then
    local pattern = vim.fn.substitute(path, source_pattern, search_pattern, flags)
    position = self._search(pattern, abs_path)
  end
  return self:to_group("file", {path = abs_path, position = position})
end

M._search = function(pattern, path)
  local f = io.open(path, "r")
  local row = 1
  local regex = vim.regex(pattern)
  for line in f:lines() do
    local s = regex:match_str(line)
    if s ~= nil then
      f:close()
      return {row, s + 1}
    end
    row = row + 1
  end
  f:close()
  return nil
end

M.opts = {source_pattern = "", result_pattern = "", search_pattern = "", flags = "g"}

return M
