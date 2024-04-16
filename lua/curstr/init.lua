local curstr = {}

--- Get action from source and execute it.
--- @param source_name string: source name
--- @param opts table|nil: {action = string} |curstr.nvim-ACTIONS|
function curstr.execute(source_name, opts)
  local err = require("curstr.command").execute(source_name, opts)
  if err then
    require("curstr.vendor.misclib.message").error(err)
  end
end

--- Setup configuration.
--- @param config table: |curstr.nvim-setup-config|
function curstr.setup(config)
  require("curstr.core.custom").set(config)
end

--- Returns operator string to use as |curstr.execute()|.
--- @param source_name string: source name
--- @param opts table|nil: {action = string} |curstr.nvim-ACTIONS|
--- @param operator_type string|nil
--- @return string
function curstr.operator(source_name, opts, operator_type)
  if operator_type == nil then
    curstr._operator = function(...)
      require("curstr").operator(source_name, opts, ...)
    end
    vim.o.operatorfunc = "v:lua.require'curstr'._operator"
    return "g@"
  end

  curstr.execute(source_name, opts)

  return ""
end

return curstr
