local helper = require("curstr.lib.testlib.helper")
local curstr = helper.require("curstr")

describe("vim/runtime/pattern/directory", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("open", function()
    helper.set_lines(helper.test_data_path .. "dir/*/child2")
    helper.new_directory("dir")
    helper.new_directory("dir/child")
    helper.new_directory("dir/child/child2")

    curstr.execute("vim/runtime/pattern/directory")

    assert.current_dir("dir/child/child2")
  end)
end)
