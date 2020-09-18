local M = {}

M.create = function(self)
  local word, word_range = self.cursor:word_with_range(self.opts.char_pattern)

  for _, args in ipairs(self.opts.patterns) do
    local pattern = args[1]
    local new_pattern = args[2]
    local option = "g"
    if #args == 3 then
      option = args[3]
    end

    if vim.fn.match(word, pattern) ~= -1 then
      local new_word = vim.fn.substitute(word, pattern, new_pattern, option)
      return self:to_group("togglable/word", {value = new_word, range = word_range})
    end
  end

  return nil
end

M.opts = {patterns = {}, char_pattern = "[:alnum:]_"}

return M
