local helper = require("curstr.lib.testlib.helper")
local command = helper.command

describe("directory/path source", function()

  before_each(helper.before_each)
  after_each(helper.after_each)

  it("can open default", function()
    helper.new_directory("path")
    helper.new_directory("path/opened")
    helper.set_lines([[./path/../path/opened]])

    command("Curstr directory/path")

    assert.current_dir("path/opened")
  end)

end)
