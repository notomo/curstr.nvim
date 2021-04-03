local M = {}

function M.error(err)
  vim.api.nvim_err_write("[curstr] " .. err .. "\n")
end

function M.echo(msg)
  vim.api.nvim_out_write("[curstr] " .. msg .. "\n")
end

return M
