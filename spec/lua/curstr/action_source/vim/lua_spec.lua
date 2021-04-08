local helper = require("curstr.lib.testlib.helper")
local curstr = helper.require("curstr")

describe("vim/lua", function()

  before_each(function()
    helper.before_each()

    vim.cmd("filetype on")
    vim.cmd("syntax enable")

    helper.open_new_file("entry.lua", "require \"vim.lsp.util\"")
    helper.search("lsp")
  end)

  after_each(function()
    helper.after_each()

    vim.cmd("filetype off")
    vim.cmd("syntax off")
  end)

  it("open", function()
    curstr.execute("vim/lua")

    assert.file_name("util.lua")
  end)

  it("not_found", function()
    vim.cmd("normal! 0")

    curstr.execute("vim/lua")

    assert.file_name("entry.lua")
  end)

end)
