local helper = require("curstr.lib.testlib.helper")
local command = helper.command

describe("vim/lua", function()

  before_each(function()
    helper.before_each()

    command("filetype on")
    command("syntax enable")

    helper.open_new_file("entry.lua", "require \"vim.lsp.util\"")
    helper.search("lsp")
  end)

  after_each(function()
    helper.after_each()

    command("filetype off")
    command("syntax off")
  end)

  it("open", function()
    command("Curstr vim/lua")

    assert.file_name("util.lua")
  end)

  it("not_found", function()
    command("normal! 0")

    command("Curstr vim/lua")

    assert.file_name("entry.lua")
  end)

end)
