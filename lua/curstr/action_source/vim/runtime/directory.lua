local M = {}

function M.create(self)
  local path = self.cursor:file_path()

  local runtime_paths = vim.split(vim.o.runtimepath, ",", true)
  for _, rpath in ipairs(runtime_paths) do
    local target = self.pathlib.join(rpath, path)
    if self.filelib.is_directory(target) then
      return self:to_group("directory", {path = target})
    end
  end

  return nil
end

return M
