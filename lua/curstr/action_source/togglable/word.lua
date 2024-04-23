local M = {}

function M.create(ctx)
  local word, word_range = require("curstr.lib.cursor").word_with_range(ctx.opts.char_pattern)

  local candidates = { ctx.opts.words }
  if ctx.opts.normalized then
    candidates = {
      vim
        .iter(ctx.opts.words)
        :map(function(w)
          return w:lower()
        end)
        :totable(),
      vim
        .iter(ctx.opts.words)
        :map(function(w)
          return w:upper()
        end)
        :totable(),
      vim
        .iter(ctx.opts.words)
        :map(function(w)
          local head = w:sub(1, 1)
          if head == nil then
            return w
          end
          return head:upper() .. w:sub(2)
        end)
        :totable(),
    }
  end

  for _, words in ipairs(candidates) do
    local new_word = M._select_word(words, word)
    if new_word ~= nil then
      return "togglable/word", { value = new_word, range = word_range }
    end
  end

  return nil
end

function M._select_word(words, word)
  for i, w in ipairs(words) do
    if w == word then
      return words[(i % #words) + 1]
    end
  end
  return nil
end

M.opts = {
  words = {},
  normalized = false,
  char_pattern = "[:alnum:]_",
}

M.description = [[uses a word matched with words option]]

return M
