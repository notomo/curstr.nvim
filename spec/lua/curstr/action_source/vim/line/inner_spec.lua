local helper = require("curstr.test.helper")
local curstr = helper.require("curstr")

describe("vim/line/inner", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("select", function()
    helper.set_lines([[ hoge foo ]])

    local got = helper.selected(function()
      curstr.execute("vim/line/inner")
    end)
    assert.is_same({ "hoge foo" }, got)
  end)
end)
