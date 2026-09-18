local M = {}

local function collect_starts(ctx, current_row, only_current_row)
  local starts = {}
  for _, target in ipairs(ctx.opts.targets) do
    local stopline
    if only_current_row then
      stopline = current_row
    else
      stopline = target.single_line and current_row - 1 or nil
    end

    local end_pattern = target.e:gsub("\\zs", "")

    local start_pos = vim.fn.searchpairpos(target.s, "", end_pattern, "bnW", "", stopline)
    if start_pos[1] ~= 0 and (only_current_row or start_pos[1] ~= current_row) then
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

  return starts
end

local function find_end(ctx, starts, current_row)
  for _, s in ipairs(starts) do
    local target = s.target
    local stopline = target.single_line and current_row or nil

    vim.api.nvim_win_set_cursor(0, s.pos)

    local start_pattern = target.s:gsub("\\zs", "")

    local end_pos = vim.fn.searchpairpos(start_pattern, "", target.e, "nW", "", stopline)
    if end_pos[1] ~= 0 then
      return {
        visual_mode = "v",
        start_pos = s.pos,
        end_pos = { end_pos[1], end_pos[2] - 2 + ctx.opts._end_offset },
      }
    end
  end
end

function M.create(ctx)
  local current_row, current_col = unpack(vim.api.nvim_win_get_cursor(0))
  local restore_cursor = function()
    vim.api.nvim_win_set_cursor(0, { current_row, current_col })
  end

  for _, only_current_row in ipairs({ true, false }) do
    local starts = collect_starts(ctx, current_row, only_current_row)
    local range = find_end(ctx, starts, current_row)
    restore_cursor()
    if range then
      return "textobject", range
    end
  end
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
