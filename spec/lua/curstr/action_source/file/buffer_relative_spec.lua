local helper = require("curstr.lib.testlib.helper")
local curstr = helper.require("curstr")

describe("file/buffer_relative source", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("can open default", function()
    helper.test_data:create_file("opened")
    helper.set_lines([[opened]])

    curstr.execute("file/buffer_relative")

    assert.file_name("opened")
  end)

  it("can open with row", function()
    helper.test_data:create_file(
      "opened",
      [[
1
2
3
4]]
    )
    helper.set_lines([[opened:3]])

    curstr.execute("file/buffer_relative")

    assert.file_name("opened")
    assert.current_row(3)
  end)

  it("can open with position", function()
    helper.test_data:create_file(
      "opened",
      [[
12345
12345
12345
12345]]
    )
    helper.set_lines([[opened:3,4]])

    curstr.execute("file/buffer_relative")

    assert.file_name("opened")
    assert.current_row(3)
    assert.current_column(4)
  end)
end)
