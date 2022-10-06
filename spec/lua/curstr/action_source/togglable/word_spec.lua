local helper = require("curstr.test.helper")
local curstr = helper.require("curstr")

describe("togglable/word", function()
  before_each(function()
    helper.before_each()

    curstr.setup({
      sources = { ["togglable/word"] = { opts = { char_pattern = "[:alnum:]_", words = {} } } },
    })
    vim.cmd.tabedit()
    vim.opt_local.buftype = "nofile"
    vim.opt_local.swapfile = false
  end)
  after_each(helper.after_each)

  it("toggle", function()
    helper.set_lines([[public toggle test]])
    vim.fn.setpos(".", { 0, 1, 1, 0 })
    curstr.setup({
      sources = { ["togglable/word"] = { opts = { words = { "public", "protected", "private" } } } },
    })

    curstr.execute("togglable/word")
    assert.cursor_word("protected")

    curstr.execute("togglable/word")
    assert.cursor_word("private")

    curstr.execute("togglable/word")
    assert.cursor_word("public")
  end)

  it("append", function()
    helper.set_lines([[public toggle test]])
    vim.fn.setpos(".", { 0, 1, 1, 0 })
    curstr.setup({
      sources = { ["togglable/word"] = { opts = { words = { "public", "protected", "private" } } } },
    })

    curstr.execute("togglable/word", { action = "append" })

    assert.cursor_word("public")
    vim.fn.setpos(".", { 0, 2, 1, 0 })
    assert.cursor_word("protected")
  end)

  it("normalized_toggle", function()
    helper.set_lines([[True]])
    helper.search("True")
    curstr.setup({
      sources = { ["togglable/word"] = { opts = { normalized = true, words = { "true", "false" } } } },
    })

    curstr.execute("togglable/word")
    assert.cursor_word("False")

    curstr.execute("togglable/word")
    assert.cursor_word("True")
  end)

  it("char_pattern_option", function()
    helper.set_lines([[foo:test]])
    vim.fn.setpos(".", { 0, 1, 1, 0 })
    curstr.setup({
      sources = {
        ["togglable/word"] = {
          opts = { char_pattern = "[:alnum:]_;:", words = { "foo:test", "foo;test" } },
        },
      },
    })

    curstr.execute("togglable/word")
    assert.current_line("foo;test")

    curstr.execute("togglable/word")
    assert.current_line("foo:test")
  end)

  it("with_multibyte", function()
    helper.set_lines([[あああfalseあああ]])
    vim.fn.setpos(".", { 0, 1, 10, 0 })
    curstr.setup({ sources = { ["togglable/word"] = { opts = { words = { "true", "false" } } } } })

    curstr.execute("togglable/word")
    assert.current_line("あああtrueあああ")

    curstr.execute("togglable/word")
    assert.current_line("あああfalseあああ")
  end)

  it("nomodifiable", function()
    helper.set_lines([[public]])
    vim.fn.setpos(".", { 0, 1, 1, 0 })
    curstr.setup({ sources = { ["togglable/word"] = { opts = { words = { "public", "protected" } } } } })
    vim.opt_local.modifiable = false

    curstr.execute("togglable/word")

    assert.cursor_word("public")
  end)
end)
