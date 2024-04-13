local M = {}

function M.create(ctx)
  local search_pattern = ctx.opts.search_pattern
  if search_pattern == "" then
    return nil
  end

  local cword = require("curstr.lib.cursor").word()
  local pattern = vim.fn.substitute(cword, ctx.opts.source_pattern, search_pattern, ctx.opts.flags)

  local position = vim.fn.searchpos(pattern, "nw")
  if position[1] == 0 then
    return nil
  end
  local path = vim.fn.expand("%:p")
  return { group_name = "file", path = path, position = position }
end

M.opts = {
  source_pattern = "",
  search_pattern = "",
  flags = "",
}

M.description = [[searchs a file matched with vim.fn.search()]]

return M
