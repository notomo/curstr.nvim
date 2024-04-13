local M = {}

function M.create(self)
  local path, position = require("curstr.lib.cursor").file_path_with_position()
  local modified_path = self.opts.modify(path)
  if not require("curstr.lib.file").readable(modified_path) then
    return nil
  end
  return { group_name = "file", path = modified_path, position = position }
end

M.opts = {
  modify = function(path)
    return vim.fn.fnamemodify(vim.fn.expand(path), ":p")
  end,
}

M.description = [[uses a relative file path]]

return M
