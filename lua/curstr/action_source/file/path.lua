local M = {}

function M.create(ctx)
  for _, e in ipairs(require("curstr.lib.cursor").file_paths_with_position()) do
    local modified_path = ctx.opts.modify(e.path)
    if require("curstr.lib.file").readable(modified_path) then
      return "file", { path = modified_path, position = e.position }
    end
  end
  return nil
end

M.opts = {
  modify = function(path)
    return vim.fn.fnamemodify(vim.fn.expand(path), ":p")
  end,
}

M.description = [[uses a relative file path]]

return M
