local helper = require("curstr/lib/testlib/helper")
local assert = helper.assert
local command = helper.command

describe("directory/buffer_relative source", function()

  before_each(helper.before_each)
  after_each(helper.after_each)

  it("can open default", function()
    helper.new_directory("opened")
    helper.set_lines([[opened]])

    command("Curstr directory/buffer_relative")

    assert.current_dir("opened")
  end)

end)
