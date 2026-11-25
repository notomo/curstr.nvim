local M = {}

function M.create()
  for _, path in ipairs(require("curstr.lib.cursor").file_paths()) do
    local abs_path = vim.fn.fnamemodify(path, ":p")
    if require("curstr.lib.file").is_directory(abs_path) then
      return "directory", { path = abs_path }
    end
  end
  return nil
end

M.description = [[uses a directory path]]

return M
