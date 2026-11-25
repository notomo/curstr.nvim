local M = {}

function M.create()
  for _, path in ipairs(require("curstr.lib.cursor").file_paths()) do
    local abs_path = vim.fs.joinpath(vim.fn.expand("%:p:h"), path)
    if require("curstr.lib.file").is_directory(abs_path) then
      return "directory", { path = abs_path }
    end
  end
  return nil
end

M.description = [[uses relative directory path with current buffer]]

return M
