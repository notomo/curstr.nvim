local M = {}

function M.execute(source_name, opts)
  vim.validate({ source_name = { source_name, "string" }, opts = { opts, "table", true } })

  local sources, source_err = require("curstr.core.action_source").resolve(source_name)
  if source_err ~= nil then
    return nil, source_err
  end

  opts = opts or {}
  opts.range = require("curstr.vendor.misclib.visual_mode").row_range()
    or { first = vim.fn.line("."), last = vim.fn.line(".") }

  for _, source in ipairs(sources) do
    local group, err = source:create(opts)
    if err ~= nil then
      return nil, err
    end
    if group ~= nil then
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
