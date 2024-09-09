local helper = require("curstr.test.helper")
local curstr = helper.require("curstr")
local assert = helper.typed_assert(assert)

describe("togglable/pattern", function()
  before_each(function()
    helper.before_each()

    curstr.setup({
      sources = { ["togglable/pattern"] = { opts = { char_pattern = "[:alnum:]_", patterns = {} } } },
    })
    vim.cmd.tabedit()
    vim.opt_local.buftype = "nofile"
    vim.opt_local.swapfile = false
  end)
  after_each(helper.after_each)

  it("toggle", function()
    helper.set_lines([[foo test]])
    vim.fn.setpos(".", { 0, 1, 1, 0 })
    curstr.setup({
      sources = {
        ["togglable/pattern"] = { opts = { patterns = { { "\\vhoge|foo", "bar" }, { "bar", "hoge" } } } },
      },
    })

    curstr.execute("togglable/pattern")
    assert.cursor_word("bar")

    curstr.execute("togglable/pattern")
    assert.cursor_word("hoge")

    curstr.execute("togglable/pattern")
    assert.cursor_word("bar")
  end)

  it("char_pattern_option", function()
    helper.set_lines([[foo:test]])
    vim.fn.setpos(".", { 0, 1, 1, 0 })
    curstr.setup({
      sources = {
        ["togglable/pattern"] = {
          opts = {
            patterns = { { "foo:test", "foo;test" }, { "foo;test", "foo:test" } },
            char_pattern = "[:alnum:]_;:",
          },
        },
      },
    })

    curstr.execute("togglable/pattern")
    assert.current_line("foo;test")

    curstr.execute("togglable/pattern")
    assert.current_line("foo:test")
  end)

  it("with_multibyte", function()
    helper.set_lines([[あああfooあああ]])
    vim.fn.setpos(".", { 0, 1, 10, 0 })
    curstr.setup({
      sources = {
        ["togglable/pattern"] = { opts = { patterns = { { "\\vhoge|foo", "bar" }, { "bar", "hoge" } } } },
      },
    })

    curstr.execute("togglable/pattern")
    assert.current_line("あああbarあああ")

    curstr.execute("togglable/pattern")
    assert.current_line("あああhogeあああ")
  end)

  it("toggle_line", function()
    helper.set_lines([[hoge]])
    vim.fn.search("hoge")
    curstr.setup({
      sources = { ["togglable/pattern"] = { opts = { is_line = true, patterns = { { "hoge", "bar" } } } } },
    })

    curstr.execute("togglable/pattern")

    assert.current_line("bar")
  end)

  it("append_line", function()
    helper.set_lines([[hoge]])
    vim.fn.search("hoge")
    curstr.setup({
      sources = { ["togglable/pattern"] = { opts = { is_line = true, patterns = { { "hoge", "bar" } } } } },
    })

    curstr.execute("togglable/pattern", { action = "append" })

    assert.current_line("hoge")
    vim.fn.search("bar")
    assert.current_line("bar")
  end)
end)
