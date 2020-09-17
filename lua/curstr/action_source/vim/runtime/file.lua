local M = {}

M.create = function(self)
  local path = self.cursor:file_path()
  local paths = vim.api.nvim_get_runtime_file("*/" .. path, false)
  local target = paths[1]
  if target == nil then
    return nil
  end
  return self:to_group("file", {path = target})
end

return M
