local M = {}

local default_opts = {
  source_opts = {},
  action_opts = {},
}

function M.execute(source_name, raw_opts)
  vim.validate({
    source_name = { source_name, "string" },
    raw_opts = { raw_opts, "table", true },
  })

  local opts = vim.tbl_deep_extend("force", default_opts, raw_opts or {})

  local raw_group = require("curstr.core.action_source").resolve(source_name, opts.source_opts)
  if type(raw_group) == "string" then
    local err = raw_group
    return err
  end

  if raw_group then
    return require("curstr.core.action_group").execute(raw_group, opts.action, opts.action_opts)
  end

  require("curstr.vendor.misclib.message").warn("not found matched source: " .. source_name)
end

return M
