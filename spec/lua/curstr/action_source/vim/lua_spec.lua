local helper = require("curstr.test.helper")
local curstr = helper.require("curstr")

describe("vim/lua", function()
  before_each(function()
    helper.before_each()

    vim.cmd.filetype("on")
    vim.cmd.syntax("enable")

    helper.open_new_file("entry.lua", 'require "vim.lsp.util"')
    helper.search("lsp")
  end)

  after_each(function()
    helper.after_each()

    vim.cmd.filetype("off")
    vim.cmd.syntax("off")
  end)

  it("open", function()
    curstr.execute("vim/lua")

    assert.buffer_name_tail("util.lua")
  end)

  it("not_found", function()
    vim.cmd.normal({ args = { "0" }, bang = true })

    curstr.execute("vim/lua")

    assert.buffer_name_tail("entry.lua")
  end)
end)
