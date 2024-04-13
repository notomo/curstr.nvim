--- @meta

--- @class CurstrActionSource
local ActionSource = {}

--- @class CurstrActionGroup
local ActionGroup = {}

--- @param opts table
--- @return CurstrActionGroup|string|nil
function ActionSource.create(self, opts) end

--- @return boolean
function ActionSource.enabled(self) end
