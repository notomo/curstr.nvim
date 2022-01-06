local M = {}

function M.action_join(self)
  if not vim.bo.modifiable then
    return
  end

  local last_line = self.last
  if self.first == last_line then
    last_line = self.first + 1
  end
  local bufnr = 0
  local old_lines = vim.api.nvim_buf_get_lines(bufnr, self.first - 1, last_line, false)
  local first = table.remove(old_lines, 1)
  local others = vim.tbl_map(function(line)
    return line:gsub("^%s*", "")
  end, old_lines)

  local lines = { first }
  vim.list_extend(
    lines,
    vim.tbl_filter(function(line)
      return line ~= ""
    end, others)
  )

  local separator = self.opts.separator
  if separator == nil then
    separator = vim.fn.input("Separator: ")
  end
  local joined = { table.concat(lines, separator) }

  vim.api.nvim_buf_set_lines(bufnr, self.first - 1, self.last, false, joined)

  if vim.fn.line(".") ~= self.first then
    vim.api.nvim_win_set_cursor(0, { self.first, 0 })
  end
end

M.default_action = "join"

M.opts = { separator = nil }

return M
