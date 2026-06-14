local ntf = require("ntf")
local describe, it, before_each, after_each = ntf.describe, ntf.it, ntf.before_each, ntf.after_each
local helper = require("curstr.test.helper")
local curstr = require("curstr")
local assert = helper.typed_assert(ntf.assert)

describe("vim/lua", function()
  before_each(function()
    helper.before_each()

    helper.open_new_file("entry.lua", 'require "vim.lsp.util"')
    vim.bo.filetype = "lua"
    helper.search("lsp")
  end)

  after_each(helper.after_each)

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
