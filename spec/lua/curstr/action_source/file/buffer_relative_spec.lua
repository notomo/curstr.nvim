local helper = require("curstr.lib.testlib.helper")
local command = helper.command

describe("file/buffer_relative source", function()

  before_each(helper.before_each)
  after_each(helper.after_each)

  it("can open default", function()
    helper.new_file("opened")
    helper.set_lines([[opened]])

    command("Curstr file/buffer_relative")

    assert.file_name("opened")
  end)

  it("can open with row", function()
    helper.new_file("opened", [[
1
2
3
4]])
    helper.set_lines([[opened:3]])

    command("Curstr file/buffer_relative")

    assert.file_name("opened")
    assert.current_row(3)
  end)

  it("can open with position", function()
    helper.new_file("opened", [[
12345
12345
12345
12345]])
    helper.set_lines([[opened:3,4]])

    command("Curstr file/buffer_relative")

    assert.file_name("opened")
    assert.current_row(3)
    assert.current_column(4)
  end)

end)
