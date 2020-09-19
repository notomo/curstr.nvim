local helper = require("curstr/lib/testlib/helper")
local command = helper.command
local assert = helper.assert

describe("vim/runtime/directory", function()

  before_each(helper.before_each)
  after_each(helper.after_each)

  it("open", function()
    helper.set_lines(helper.test_data_path .. "dir/child")
    helper.new_directory("dir")
    helper.new_directory("dir/child")

    command("Curstr vim/runtime/directory")

    assert.current_dir("dir/child")
  end)

end)
