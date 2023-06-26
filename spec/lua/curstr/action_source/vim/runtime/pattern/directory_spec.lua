local helper = require("curstr.test.helper")
local curstr = helper.require("curstr")

describe("vim/runtime/pattern/directory", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("open", function()
    helper.set_lines(helper.test_data:relative_path("dir/*/child2"))
    helper.test_data:create_dir("dir/child/child2")

    curstr.execute("vim/runtime/pattern/directory")

    assert.current_dir("dir/child/child2")
  end)
end)
