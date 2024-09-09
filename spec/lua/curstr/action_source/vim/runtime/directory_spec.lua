local helper = require("curstr.test.helper")
local curstr = helper.require("curstr")
local assert = helper.typed_assert(assert)

describe("vim/runtime/directory", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("open", function()
    helper.set_lines(helper.test_data:relative_path("dir/child"))
    helper.test_data:create_dir("dir/child")

    curstr.execute("vim/runtime/directory")

    assert.current_dir("dir/child")
  end)
end)
