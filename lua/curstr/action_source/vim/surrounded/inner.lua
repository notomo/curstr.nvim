local M = {}

function M.create(ctx)
  local current_row, current_col = unpack(vim.api.nvim_win_get_cursor(0))
  local restore_cursor = function()
    vim.api.nvim_win_set_cursor(0, { current_row, current_col })
  end

  local starts = {}
  for _, target in ipairs(ctx.opts.targets) do
    local stopline = target.single_line and current_row - 1 or nil

    local end_pattern = target.e:gsub("\\zs", "")

    local start_pos = vim.fn.searchpairpos(target.s, "", end_pattern, "bnW", "", stopline)
    if start_pos[1] ~= 0 then
      table.insert(starts, {
        target = target,
        pos = { start_pos[1], start_pos[2] + ctx.opts._start_offset },
      })
    end
  end

  table.sort(starts, function(a, b)
    local row_diff_a = math.abs(a.pos[1] - current_row)
    local row_diff_b = math.abs(b.pos[1] - current_row)
    if row_diff_a ~= row_diff_b then
      return row_diff_a < row_diff_b
    end

    return a.pos[2] > b.pos[2]
  end)

  for _, s in ipairs(starts) do
    local target = s.target
    local stopline = target.single_line and current_row or nil

    vim.api.nvim_win_set_cursor(0, s.pos)

    local start_pattern = target.s:gsub("\\zs", "")

    local end_pos = vim.fn.searchpairpos(start_pattern, "", target.e, "nW", "", stopline)
    if end_pos[1] ~= 0 then
      restore_cursor()

      return "textobject",
        {
          visual_mode = "v",
          start_pos = s.pos,
          end_pos = { end_pos[1], end_pos[2] - 2 + ctx.opts._end_offset },
        }
    end
  end

  restore_cursor()
end

M.description = [[uses a buffer's surrounded inner text]]

M.opts = {
  targets = {
    { s = "(", e = ")" },
    { s = "\\[", e = "\\]" },
    { s = "{", e = "}" },
    { s = "<", e = ">" },
    { s = [=["[^"]]=], e = [=[[^"]\?\zs"]=], single_line = true },
    { s = [=['[^']]=], e = [=[[^']\?\zs']=], single_line = true },
    { s = [=[`[^`]]=], e = [=[[^`]\?\zs`]=], single_line = true },
  },
  _start_offset = 0,
  _end_offset = 0,
}

return M
