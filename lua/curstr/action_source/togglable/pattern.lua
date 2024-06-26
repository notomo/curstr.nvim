local M = {}

function M.create(ctx)
  local word, word_range
  if ctx.opts.is_line then
    word, word_range = require("curstr.lib.cursor").line_with_range()
  else
    word, word_range = require("curstr.lib.cursor").word_with_range(ctx.opts.char_pattern)
  end

  for _, args in ipairs(ctx.opts.patterns) do
    local pattern = args[1]
    local new_pattern = args[2]
    local option = "g"
    if #args == 3 then
      option = args[3]
    end

    if vim.fn.match(word, pattern) ~= -1 then
      local new_word = vim.fn.substitute(word, pattern, new_pattern, option)
      if ctx.opts.is_line then
        return "togglable/line", { value = new_word }
      end
      return "togglable/word", { value = new_word, range = word_range }
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
