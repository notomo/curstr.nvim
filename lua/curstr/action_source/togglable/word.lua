local M = {}

M.create = function(self)
  local word, word_range = self.cursor:word_with_range(self.opts.char_pattern)

  local candidates = {self.opts.words}
  if self.opts.normalized then
    candidates = {
      vim.tbl_map(function(w)
        return w:lower()
      end, self.opts.words),
      vim.tbl_map(function(w)
        return w:upper()
      end, self.opts.words),
      vim.tbl_map(function(w)
        local head = w:sub(1, 1)
        if head == nil then
          return w
        end
        return head:upper() .. w:sub(2)
      end, self.opts.words),
    }
  end

  for _, words in ipairs(candidates) do
    local new_word = self._select_word(words, word)
    if new_word ~= nil then
      return self:to_group("togglable/word", {value = new_word, range = word_range})
    end
  end

  return nil
end

M._select_word = function(words, word)
  for i, w in ipairs(words) do
    if w == word then
      return words[(i % #words) + 1]
    end
  end
  return nil
end

M.opts = {words = {}, normalized = false, char_pattern = "[:alnum:]_"}

return M
