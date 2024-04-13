local M = {}

function M.create(self)
  local word, word_range
  if self.opts.is_line then
    word, word_range = require("curstr.lib.cursor").line_with_range()
  else
    word, word_range = require("curstr.lib.cursor").word_with_range(self.opts.char_pattern)
  end

  for _, args in ipairs(self.opts.patterns) do
    local pattern = args[1]
    local new_pattern = args[2]
    local option = "g"
    if #args == 3 then
      option = args[3]
    end

    if vim.fn.match(word, pattern) ~= -1 then
      local new_word = vim.fn.substitute(word, pattern, new_pattern, option)
      if self.opts.is_line then
        return { group_name = "togglable/line", value = new_word }
      end
      return { group_name = "togglable/word", value = new_word, range = word_range }
    end
  end

  return nil
end

M.opts = {
  patterns = {},
  char_pattern = "[:alnum:]_",
  is_line = false,
}

M.description = [[uses string matched with option patterns]]

return M
