local helper = require("curstr/lib/testlib/helper")
local command = helper.command
local assert = helper.assert

describe("vim/runtime/file", function()

  before_each(helper.before_each)
  after_each(helper.after_each)

  it("open", function()
    helper.set_lines(helper.test_data_path .. "file")
    helper.new_file("file")

    command("Curstr vim/runtime/file")

    assert.path(helper.test_data_path .. "file")
  end)

end)
