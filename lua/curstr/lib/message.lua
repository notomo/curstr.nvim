local M = {}

M.error = function(err)
  vim.api.nvim_err_write("[curstr] " .. err .. "\n")
end

M.echo = function(msg)
  vim.api.nvim_out_write("[curstr] " .. msg .. "\n")
end

return M
