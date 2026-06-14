local ntf = require("ntf")
local describe, it, before_each, after_each = ntf.describe, ntf.it, ntf.before_each, ntf.after_each
local helper = require("curstr.test.helper")
local curstr = require("curstr")
local assert = helper.typed_assert(ntf.assert)

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
