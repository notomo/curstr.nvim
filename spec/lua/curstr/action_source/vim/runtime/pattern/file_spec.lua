local ntf = require("ntf")
local describe, it, before_each, after_each = ntf.describe, ntf.it, ntf.before_each, ntf.after_each
local helper = require("curstr.test.helper")
local curstr = require("curstr")
local assert = helper.typed_assert(ntf.assert)

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
