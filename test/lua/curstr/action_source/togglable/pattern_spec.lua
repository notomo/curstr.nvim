local helper = require("curstr/lib/testlib/helper")
local command = helper.command
local assert = helper.assert

describe("togglable/pattern", function()

  before_each(function()
    helper.before_each()

    vim.fn["curstr#custom#source_option"]("togglable/pattern", "patterns", {})
    vim.fn["curstr#custom#source_option"]("togglable/pattern", "char_pattern", "{:alnum:}_")
    command("tabe | setlocal buftype=nofile noswapfile")

    helper.cd()
  end)
  after_each(helper.after_each)

  it("toggle", function()
    vim.fn.append(0, "foo test")
    vim.fn.setpos(".", {0, 1, 1, 0})
    vim.fn["curstr#custom#source_option"]("togglable/pattern", "patterns", {
      {"\\vhoge|foo", "bar"},
      {"bar", "hoge"},
    })

    command("Curstr togglable/pattern")
    assert.cursor_word("bar")

    command("Curstr togglable/pattern")
    assert.cursor_word("hoge")

    command("Curstr togglable/pattern")
    assert.cursor_word("bar")
  end)

  it("char_pattern_option", function()
    vim.fn.append(0, "foo:test")
    vim.fn.setpos(".", {0, 1, 1, 0})
    vim.fn["curstr#custom#source_option"]("togglable/pattern", "patterns", {
      {"foo:test", "foo;test"},
      {"foo;test", "foo:test"},
    })
    vim.fn["curstr#custom#source_option"]("togglable/pattern", "char_pattern", "{:alnum:}_;:")

    command("Curstr togglable/pattern")
    assert.current_line("foo;test")

    command("Curstr togglable/pattern")
    assert.current_line("foo:test")
  end)

  it("with_multibyte", function()
    vim.fn.append(0, "あああfooあああ")
    vim.fn.setpos(".", {0, 1, 10, 0})
    vim.fn["curstr#custom#source_option"]("togglable/pattern", "patterns", {
      {"\\vhoge|foo", "bar"},
      {"bar", "hoge"},
    })

    command("Curstr togglable/pattern")
    assert.current_line("あああbarあああ")

    command("Curstr togglable/pattern")
    assert.current_line("あああhogeあああ")
  end)

  it("toggle_line", function()
    vim.fn.append(0, "hoge")
    vim.fn.search("hoge")
    vim.fn["curstr#custom#source_option"]("togglable/pattern", "patterns", {{"hoge", "bar"}})

    command("Curstr togglable/pattern")

    assert.current_line("bar")
  end)

  it("append_line", function()
    vim.fn.append(0, "hoge")
    vim.fn.search("hoge")
    vim.fn["curstr#custom#source_option"]("togglable/pattern", "patterns", {{"hoge", "bar"}})

    command("Curstr togglable/pattern -action=append")

    assert.current_line("hoge")
    vim.fn.search("bar")
    assert.current_line("bar")
  end)

end)
