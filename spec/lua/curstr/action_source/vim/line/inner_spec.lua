local ntf = require("ntf")
local describe, it, before_each, after_each = ntf.describe, ntf.it, ntf.before_each, ntf.after_each
local helper = require("curstr.test.helper")
local curstr = require("curstr")
local assert = helper.typed_assert(ntf.assert)

describe("vim/line/inner", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("select", function()
    helper.set_lines([[ hoge foo ]])

    local got = helper.selected(function()
      curstr.execute("vim/line/inner")
    end)
    assert.same({ "hoge foo" }, got)
  end)
end)
