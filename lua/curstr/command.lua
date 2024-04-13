local M = {}

function M.execute(source_name, raw_opts)
  vim.validate({
    source_name = { source_name, "string" },
    raw_opts = { raw_opts, "table", true },
  })

  local raw_group = require("curstr.core.action_source").resolve(source_name)
  if type(raw_group) == "string" then
    local err = raw_group
    return err
  end

  local opts = raw_opts or {}
  if raw_group then
    return require("curstr.core.action_group").execute(raw_group, opts.action)
  end

  require("curstr.vendor.misclib.message").warn("not found matched source: " .. source_name)
end

return M
