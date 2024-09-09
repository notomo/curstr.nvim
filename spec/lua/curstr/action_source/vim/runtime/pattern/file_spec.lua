local helper = require("curstr.test.helper")
local curstr = helper.require("curstr")
local assert = helper.typed_assert(assert)

describe("vim/runtime/pattern/file", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("open", function()
    helper.set_lines(helper.test_data:relative_path("dir/*/file"))
    helper.test_data:create_file("dir/child/file")

    curstr.execute("vim/runtime/pattern/file")

    assert.path(helper.test_data:relative_path("dir/child/file"))
  end)
end)
