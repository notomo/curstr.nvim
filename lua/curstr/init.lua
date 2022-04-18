local curstr = {}

--- Get action from source and execute it.
--- @param source_name string: source name
--- @param opts table|nil: {action = string} |curstr.nvim-ACTIONS|
function curstr.execute(source_name, opts)
  return require("curstr.command").execute(source_name, opts)
end

--- Setup configuration.
--- @param config string: |curstr.nvim-setup-config|
function curstr.setup(config)
  return require("curstr.command").setup(config)
end

return curstr
