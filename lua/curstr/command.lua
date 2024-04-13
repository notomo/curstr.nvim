local M = {}

function M.execute(source_name, opts)
  vim.validate({ source_name = { source_name, "string" }, opts = { opts, "table", true } })

  local sources = require("curstr.core.action_source").resolve(source_name)
  if type(sources) == "string" then
    local err = sources
    return err
  end

  opts = opts or {}
  opts.range = require("curstr.vendor.misclib.visual_mode").row_range()
    or { first = vim.fn.line("."), last = vim.fn.line(".") }

  for _, source in ipairs(sources) do
    local group = source:create(opts)
    if type(group) == "string" then
      local err = group
      return err
    end
    if group then
      return group:execute(opts.action)
    end
  end

  require("curstr.vendor.misclib.message").warn("not found matched source: " .. source_name)
end

function M.setup(config)
  vim.validate({ config = { config, "table" } })
  require("curstr.core.custom").set(config)
end

return M
