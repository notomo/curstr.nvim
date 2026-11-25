local M = {}

function M.create()
  for _, e in ipairs(require("curstr.lib.cursor").file_paths_with_position()) do
    local abs_path = vim.fs.joinpath(vim.fn.expand("%:p:h"), e.path)
    if require("curstr.lib.file").readable(abs_path) then
      return "file", { path = abs_path, position = e.position }
    end
  end
  return nil
end

M.description = [[uses a relative file path with current buffer]]

return M
