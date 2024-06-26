local M = {}

function M.create()
  local path = require("curstr.lib.cursor").file_path("*")
  local paths = vim.api.nvim_get_runtime_file(path, false)
  local target = paths[1]
  if target == nil then
    return nil
  end
  return "file", { path = target }
end

M.description = [[searches a vim runtime file by glob pattern]]

return M
