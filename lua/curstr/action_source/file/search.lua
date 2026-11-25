local M = {}

function M.create(ctx)
  local source_pattern = ctx.opts.source_pattern
  local flags = ctx.opts.flags

  local path, abs_path
  for _, candidate in ipairs(require("curstr.lib.cursor").file_paths()) do
    local target_path = vim.fn.substitute(candidate, source_pattern, ctx.opts.result_pattern, flags)
    local target_abs_path = vim.fn.fnamemodify(target_path, ":p")
    if require("curstr.lib.file").readable(target_abs_path) then
      path = candidate
      abs_path = target_abs_path
      break
    end
  end
  if abs_path == nil then
    return nil
  end

  local search_pattern = ctx.opts.search_pattern
  local position = nil
  if search_pattern ~= "" then
    local pattern = vim.fn.substitute(path, source_pattern, search_pattern, flags)
    position = M._search(pattern, abs_path)
  end
  return "file", { path = abs_path, position = position }
end

function M._search(pattern, path)
  local f = io.open(path, "r")
  assert(f, "cannot open file: " .. path)
  local row = 1
  local regex = vim.regex(pattern)
  for line in f:lines() do
    local s = regex:match_str(line)
    if s ~= nil then
      f:close()
      return { row, s + 1 }
    end
    row = row + 1
  end
  f:close()
  return nil
end

M.opts = {
  source_pattern = "",
  result_pattern = "",
  search_pattern = "",
  flags = "g",
}

M.description = [[searches a file matched with `s/{source_pattern}/{result_pattern}/{flags}` result]]

return M
