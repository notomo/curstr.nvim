local helper = require("curstr/lib/testlib/helper")
local command = helper.command
local assert = helper.assert

describe("vim/runtime/pattern/file", function()

  before_each(helper.before_each)
  after_each(helper.after_each)

  it("open", function()
    helper.set_lines(helper.test_data_path .. "dir/*/file")
    helper.new_directory("dir")
    helper.new_directory("dir/child")
    helper.new_file("dir/child/file")

    command("Curstr vim/runtime/pattern/file")

    assert.path(helper.test_data_path .. "dir/child/file")
  end)

end)
