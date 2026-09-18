local M = {}

local function collect_starts(ctx, current_row, window_start, tried_start)
  local starts = {}
  for _, target in ipairs(ctx.opts.targets) do
    local stopline = window_start
    if target.single_line then
      stopline = math.max(window_start or 1, current_row - 1)
    end

    local end_pattern = target.e:gsub("\\zs", "")

    local start_pos = vim.fn.searchpairpos(target.s, "", end_pattern, "bnW", "", stopline)
    if start_pos[1] ~= 0 and (tried_start == nil or start_pos[1] < tried_start) then
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

  local window_starts = { current_row }
  local size = 100
  while size * 4 < current_row do
    table.insert(window_starts, current_row - size)
    size = size * 10
  end

  local tried_start = nil
  local search = function(window_start)
    local starts = collect_starts(ctx, current_row, window_start, tried_start)
    local range = find_end(ctx, starts, current_row)
    restore_cursor()
    tried_start = window_start
    return range
  end

  for _, window_start in ipairs(window_starts) do
    local range = search(window_start)
    if range then
      return "textobject", range
    end
  end

  local range = search(nil)
  if range then
    return "textobject", range
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
