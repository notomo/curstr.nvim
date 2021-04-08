local helper = require("curstr.lib.testlib.helper")
local curstr = helper.require("curstr")

describe("vim/runtime/file", function()

  before_each(helper.before_each)
  after_each(helper.after_each)

  it("open", function()
    helper.set_lines(helper.test_data_path .. "file")
    helper.new_file("file")

    curstr.execute("vim/runtime/file")

    assert.path(helper.test_data_path .. "file")
  end)

end)
