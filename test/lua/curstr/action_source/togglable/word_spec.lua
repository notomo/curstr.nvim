local helper = require("curstr/lib/testlib/helper")
local command = helper.command
local assert = helper.assert

describe("togglable/word", function()

  before_each(function()
    helper.before_each()

    vim.fn["curstr#custom#source_option"]("togglable/word", "words", {})
    vim.fn["curstr#custom#source_option"]("togglable/word", "char_pattern", "{:alnum:}_")
    command("tabe | setlocal buftype=nofile noswapfile")
  end)
  after_each(helper.after_each)

  it("toggle", function()
    vim.fn.append(0, "public toggle test")
    vim.fn.setpos(".", {0, 1, 1, 0})
    vim.fn["curstr#custom#source_option"]("togglable/word", "words", {
      "public",
      "protected",
      "private",
    })

    command("Curstr togglable/word")
    assert.cursor_word("protected")

    command("Curstr togglable/word")
    assert.cursor_word("private")

    command("Curstr togglable/word")
    assert.cursor_word("public")
  end)

  it("append", function()
    vim.fn.append(0, "public toggle test")
    vim.fn.setpos(".", {0, 1, 1, 0})
    vim.fn["curstr#custom#source_option"]("togglable/word", "words", {
      "public",
      "protected",
      "private",
    })

    command("Curstr togglable/word -action=append")

    assert.cursor_word("public")
    vim.fn.setpos(".", {0, 2, 1, 0})
    assert.cursor_word("protected")
  end)

  it("normalized_toggle", function()
    vim.fn.append(0, "True")
    helper.search("True")
    vim.fn["curstr#custom#source_option"]("togglable/word", "words", {"true", "false"})
    vim.fn["curstr#custom#source_option"]("togglable/word", "normalized", true)

    command("Curstr togglable/word")
    assert.cursor_word("False")

    command("Curstr togglable/word")
    assert.cursor_word("True")
  end)

  it("char_pattern_option", function()
    vim.fn.append(0, "foo:test")
    vim.fn.setpos(".", {0, 1, 1, 0})
    vim.fn["curstr#custom#source_option"]("togglable/word", "words", {"foo:test", "foo;test"})
    vim.fn["curstr#custom#source_option"]("togglable/word", "char_pattern", "{:alnum:}_;:")

    command("Curstr togglable/word")
    assert.current_line("foo;test")

    command("Curstr togglable/word")
    assert.current_line("foo:test")
  end)

  it("with_multibyte", function()
    vim.fn.append(0, "あああfalseあああ")
    vim.fn.setpos(".", {0, 1, 10, 0})
    vim.fn["curstr#custom#source_option"]("togglable/word", "words", {"true", "false"})

    command("Curstr togglable/word")
    assert.current_line("あああtrueあああ")

    command("Curstr togglable/word")
    assert.current_line("あああfalseあああ")
  end)

  it("nomodifiable", function()
    vim.fn.append(0, "public")
    vim.fn.setpos(".", {0, 1, 1, 0})
    vim.fn["curstr#custom#source_option"]("togglable/word", "words", {"public", "protected"})
    command("setlocal nomodifiable")

    command("Curstr togglable/word")

    assert.cursor_word("public")
  end)

end)
