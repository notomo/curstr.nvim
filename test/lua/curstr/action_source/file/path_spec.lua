local helper = require("curstr/lib/testlib/helper")
local command = helper.command
local assert = helper.assert

describe("file/path", function()

  before_each(function()
    helper.before_each()

    helper.new_file("opened.txt", [[
12345
12345
12345
12345]])
    helper.new_directory("with_env")
    helper.new_file("with_env/file")
    helper.open_new_file("entry.txt", [[
opened.txt
opened.txt:3
opened.txt:3,4
$DIR_NAME/file
\v+=
]])

    helper.cd()
  end)
  after_each(helper.after_each)

  it("default", function()
    command("Curstr file/path")

    assert.file_name("opened.txt")
  end)

  it("open", function()
    command("Curstr file/path -action=open")

    assert.file_name("opened.txt")
  end)

  it("tab_open", function()
    command("Curstr file/path -action=tab_open")

    assert.file_name("opened.txt")
    assert.tab_count(2)
  end)

  it("vertical_open", function()
    command("Curstr file/path -action=vertical_open")

    assert.file_name("opened.txt")
    assert.window_count(2)
    command("wincmd l")
    assert.file_name("entry.txt")
  end)

  it("horizontal_open", function()
    command("Curstr file/path -action=horizontal_open")

    assert.file_name("opened.txt")
    assert.window_count(2)
    command("wincmd j")
    assert.file_name("entry.txt")
  end)

  it("not_found", function()
    command("normal! G")
    local pos = vim.fn.getpos(".")

    command("Curstr file/path")

    assert.file_name("entry.txt")
    assert.same(pos, vim.fn.getpos("."))
  end)

  it("open_with_row", function()
    helper.search("opened.txt:3")

    command("Curstr file/path")

    assert.file_name("opened.txt")
    assert.current_row(3)
  end)

  it("open_with_position", function()
    helper.search("opened.txt:3,4")

    command("Curstr file/path")

    assert.file_name("opened.txt")
    assert.current_row(3)
    assert.current_column(4)
  end)

  it("open_with_env_expand", function()
    command("let $DIR_NAME = getcwd() . '/with_env'")
    helper.search("file")

    command("Curstr file/path")

    assert.file_name("file")
  end)

  it("raises no error with invalid regex", function()
    helper.search("+")

    command("Curstr file/path")
  end)

end)
