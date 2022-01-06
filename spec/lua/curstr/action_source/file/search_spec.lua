local helper = require("curstr.lib.testlib.helper")
local curstr = helper.require("curstr")

describe("file/search", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("file_one", function()
    curstr.setup({
      sources = {
        ["file/search"] = { opts = { source_pattern = "\\v^([^#]*)#(\\w+)$", result_pattern = "\\1" } },
      },
    })

    helper.new_file("pattern.txt")
    helper.open_new_file("entry", "./pattern.txt#target_pattern")
    helper.cd()

    curstr.execute("file/search")

    assert.file_name("pattern.txt")
    assert.current_row(1)
  end)

  it("file_with_position", function()
    curstr.setup({
      sources = {
        ["file/search"] = {
          opts = {
            source_pattern = "\\v^([^#]*)#(\\w+)$",
            result_pattern = "\\1",
            search_pattern = "\\2:",
          },
        },
      },
    })

    helper.new_file(
      "pattern.txt",
      [[

test:

    target_pattern:
]]
    )
    helper.open_new_file("entry", "./pattern.txt#target_pattern")
    helper.cd()

    curstr.execute("file/search")

    assert.file_name("pattern.txt")
    assert.cursor_word("target_pattern")
  end)

  it("not_found", function()
    helper.open_new_file("entry", "./pattern.txt#target_pattern")

    curstr.execute("file/search")

    assert.file_name("entry")
  end)

  it("file_not_found", function()
    helper.open_new_file("entry", "./not_found.txt")

    curstr.execute("file/search")

    assert.file_name("entry")
  end)
end)
