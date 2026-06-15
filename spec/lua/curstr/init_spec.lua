local ntf = require("ntf")
local describe, it, before_each, after_each = ntf.describe, ntf.it, ntf.before_each, ntf.after_each
local helper = require("curstr.test.helper")
local curstr = require("curstr")
local assert = helper.typed_assert(ntf.assert)

describe("curstr.operator()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("can dot repeat", function()
    helper.set_lines([[public toggle test]])
    vim.fn.setpos(".", { 0, 1, 1, 0 })
    curstr.setup({
      sources = { ["togglable/word"] = { opts = { words = { "public", "protected", "private" } } } },
    })

    local cmd = curstr.operator("togglable/word") .. "$"
    vim.cmd.normal({ args = { cmd }, bang = true })

    assert.cursor_word("protected")

    vim.cmd.normal({ args = { "." }, bang = true })

    assert.cursor_word("private")
  end)
end)
