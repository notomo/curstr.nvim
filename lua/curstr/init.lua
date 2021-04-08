local Command = require("curstr.command").Command

local curstr = {}

function curstr.execute(source_name, opts)
  return Command.new("execute", source_name, opts)
end

return curstr
