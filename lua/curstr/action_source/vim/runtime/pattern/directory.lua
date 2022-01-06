local M = {}

function M.create(self)
  local path = self.cursor:file_path("*")

  local runtime_paths = vim.split(vim.o.runtimepath, ",", true)
  for _, rpath in ipairs(runtime_paths) do
    local pattern = self.pathlib.join(rpath, path)
    local targets = vim.fn.glob(pattern, false, true)
    for _, target in ipairs(targets) do
      if self.filelib.is_directory(target) then
        return self:to_group("directory", { path = target })
      end
    end
  end

  return nil
end

M.description = [[searches a vim runtime directory by glob pattern]]

return M
