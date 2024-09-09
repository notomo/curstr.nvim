local helper = require("curstr.test.helper")
local curstr = helper.require("curstr")
local assert = helper.typed_assert(assert)

describe("vim/entire/around", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("select", function()
    helper.set_lines([[ hoge 
 foo ]])

    local got = helper.selected(function()
      curstr.execute("vim/entire/around")
    end)
    assert.same({ " hoge ", " foo " }, got)
  end)
end)
