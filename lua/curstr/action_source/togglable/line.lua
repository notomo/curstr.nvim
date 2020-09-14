local M = {}

M.create = function(self)
  local line = self.cursor:line()

  for _, args in ipairs(self.opts.patterns) do
    local pattern, new_pattern
    local option = "g"
    if #args == 3 then
      pattern, new_pattern, option = unpack(args)
    end

    if vim.fn.match(line, pattern) ~= -1 then
      local new_line = vim.fn.substitute(line, pattern, new_pattern, option)
      return self:to_group("togglable/line", {value = new_line})
    end
  end

  return nil
end

M.opts = {patterns = {}}

return M
