local M = {}

function M.create()
  local path = require("curstr.lib.cursor").file_path("*")

  local runtime_paths = vim.split(vim.o.runtimepath, ",", { plain = true })
  for _, rpath in ipairs(runtime_paths) do
    local pattern = vim.fs.joinpath(rpath, path)
    local targets = vim.fn.glob(pattern, false, true)
    for _, target in ipairs(targets) do
      if require("curstr.lib.file").is_directory(target) then
        return { group_name = "directory", path = target }
      end
    end
  end

  return nil
end

M.description = [[searches a vim runtime directory by glob pattern]]

return M
