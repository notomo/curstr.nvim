local M = {}

function M.create()
  local path = require("curstr.lib.cursor").file_path()

  local runtime_paths = vim.split(vim.o.runtimepath, ",", { plain = true })
  for _, rpath in ipairs(runtime_paths) do
    local target = vim.fs.joinpath(rpath, path)
    if require("curstr.lib.file").is_directory(target) then
      return { group_name = "directory", path = target }
    end
  end

  return nil
end

M.description = [[searchs a directory from vim runtime]]

return M
