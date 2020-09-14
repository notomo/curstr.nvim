local M = {}

M.error = function(err)
  vim.api.nvim_err_write("[curstr] " .. err .. "\n")
end

return M
