local M = {}

function M.create(self)
  local search_pattern = self.opts.search_pattern
  if search_pattern == "" then
    return nil
  end

  local cword = self.cursor:word()
  local pattern = vim.fn.substitute(cword, self.opts.source_pattern, search_pattern, self.opts.flags)

  local position = vim.fn.searchpos(pattern, "nw")
  if position[1] == 0 then
    return nil
  end
  local path = vim.fn.expand("%:p")
  return self:to_group("file", {path = path, position = position})
end

M.opts = {source_pattern = "", search_pattern = "", flags = ""}

M.description = [[searchs a file matched with vim.fn.search()]]

return M
