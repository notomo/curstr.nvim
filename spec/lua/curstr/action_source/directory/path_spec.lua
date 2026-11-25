local ntf = require("ntf")
local describe, it, before_each, after_each = ntf.describe, ntf.it, ntf.before_each, ntf.after_each
local helper = require("curstr.test.helper")
local curstr = require("curstr")
local assert = helper.typed_assert(ntf.assert)

describe("directory/path source", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("can open default", function()
    helper.test_data:create_dir("path/opened")
    helper.set_lines([[./path/../path/opened]])

    curstr.execute("directory/path")

    assert.current_dir("path/opened")
  end)

  it("can open multibyte path", function()
    helper.test_data:create_dir("資料/設計")
    helper.set_lines([[資料/設計]])

    curstr.execute("directory/path")

    assert.current_dir("資料/設計")
  end)

  it("ignores a separator between multibyte characters", function()
    helper.set_lines([[資料/設計]])

    curstr.execute("directory/path")

    assert.current_dir("")
  end)
end)
