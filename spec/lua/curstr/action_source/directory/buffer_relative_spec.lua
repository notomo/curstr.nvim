local helper = require("curstr.test.helper")
local curstr = helper.require("curstr")

describe("directory/buffer_relative source", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("can open default", function()
    helper.test_data:create_dir("opened")
    helper.set_lines([[opened]])

    curstr.execute("directory/buffer_relative")

    assert.current_dir("opened")
  end)
end)
