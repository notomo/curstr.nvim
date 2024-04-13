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
  require("curstr.command").setup(config)
end

return curstr
