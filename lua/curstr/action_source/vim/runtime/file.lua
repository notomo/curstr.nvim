local M = {}

function M.create()
  for _, path in ipairs(require("curstr.lib.cursor").file_paths()) do
    local target = vim.api.nvim_get_runtime_file(path, false)[1]
    if target ~= nil then
      return "file", { path = target }
    end
  end
  return nil
end

M.description = [[searchs a file from vim runtime]]

return M
