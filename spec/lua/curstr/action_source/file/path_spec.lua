local helper = require("curstr.test.helper")
local curstr = helper.require("curstr")

describe("file/path", function()
  before_each(function()
    helper.before_each()

    helper.test_data:create_file(
      "opened.txt",
      [[
12345
12345
12345
12345]]
    )
    helper.test_data:create_dir("with_env")
    helper.test_data:create_file("with_env/file")
    helper.open_new_file(
      "entry.txt",
      [[
opened.txt
opened.txt:3
opened.txt:3,4
opened.txt:3:4
file://./opened.txt
$DIR_NAME/file
\v+=
]]
    )
  end)
  after_each(helper.after_each)

  it("default", function()
    curstr.execute("file/path")

    assert.buffer_name_tail("opened.txt")
  end)

  it("open", function()
    curstr.execute("file/path", { action = "open" })

    assert.buffer_name_tail("opened.txt")
  end)

  it("tab_open", function()
    curstr.execute("file/path", { action = "tab_open" })

    assert.buffer_name_tail("opened.txt")
    assert.tab_count(2)
  end)

  it("vertical_open", function()
    curstr.execute("file/path", { action = "vertical_open" })

    assert.buffer_name_tail("opened.txt")
    assert.window_count(2)
    vim.cmd.wincmd("l")
    assert.buffer_name_tail("entry.txt")
  end)

  it("horizontal_open", function()
    curstr.execute("file/path", { action = "horizontal_open" })

    assert.buffer_name_tail("opened.txt")
    assert.window_count(2)
    vim.cmd.wincmd("j")
    assert.buffer_name_tail("entry.txt")
  end)

  it("not_found", function()
    vim.cmd.normal({ args = { "G" }, bang = true })
    local pos = vim.fn.getpos(".")

    curstr.execute("file/path")

    assert.buffer_name_tail("entry.txt")
    assert.same(pos, vim.fn.getpos("."))
  end)

  it("open_with_row", function()
    helper.search("opened.txt:3")

    curstr.execute("file/path")

    assert.buffer_name_tail("opened.txt")
    assert.cursor_row(3)
  end)

  it("open_with_position separated ,", function()
    helper.search("opened.txt:3,4")

    curstr.execute("file/path")

    assert.buffer_name_tail("opened.txt")
    assert.cursor_row(3)
    assert.cursor_column(4)
  end)

  it("open_with_position separated :", function()
    helper.search("opened.txt:3:4")

    curstr.execute("file/path")

    assert.buffer_name_tail("opened.txt")
    assert.cursor_row(3)
    assert.cursor_column(4)
  end)

  it("open with file protocol", function()
    helper.search("file://./opened.txt")

    curstr.execute("file/path")

    assert.buffer_name_tail("opened.txt")
  end)

  it("open_with_env_expand", function()
    vim.env.DIR_NAME = vim.fn.getcwd() .. "/with_env"
    helper.search("/file")

    curstr.execute("file/path")

    assert.buffer_name_tail("file")
  end)

  it("raises no error with invalid regex", function()
    helper.search("+")

    curstr.execute("file/path")
  end)
end)
