local helper = require("curstr/lib/testlib/helper")
local command = helper.command
local assert = helper.assert

describe("togglable/word", function()

  before_each(function()
    helper.before_each()

    require("curstr/custom").sources["togglable/word"] = {
      opts = {char_pattern = "[:alnum:]_", words = {}},
    }
    command("tabe | setlocal buftype=nofile noswapfile")
  end)
  after_each(helper.after_each)

  it("toggle", function()
    vim.fn.append(0, "public toggle test")
    vim.fn.setpos(".", {0, 1, 1, 0})
    require("curstr/custom").sources["togglable/word"] = {
      opts = {words = {"public", "protected", "private"}},
    }

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
    require("curstr/custom").sources["togglable/word"] = {
      opts = {words = {"public", "protected", "private"}},
    }

    command("Curstr togglable/word -action=append")

    assert.cursor_word("public")
    vim.fn.setpos(".", {0, 2, 1, 0})
    assert.cursor_word("protected")
  end)

  it("normalized_toggle", function()
    vim.fn.append(0, "True")
    helper.search("True")
    require("curstr/custom").sources["togglable/word"] = {
      opts = {normalized = true, words = {"true", "false"}},
    }

    command("Curstr togglable/word")
    assert.cursor_word("False")

    command("Curstr togglable/word")
    assert.cursor_word("True")
  end)

  it("char_pattern_option", function()
    vim.fn.append(0, "foo:test")
    vim.fn.setpos(".", {0, 1, 1, 0})
    require("curstr/custom").sources["togglable/word"] = {
      opts = {char_pattern = "[:alnum:]_;:", words = {"foo:test", "foo;test"}},
    }

    command("Curstr togglable/word")
    assert.current_line("foo;test")

    command("Curstr togglable/word")
    assert.current_line("foo:test")
  end)

  it("with_multibyte", function()
    vim.fn.append(0, "あああfalseあああ")
    vim.fn.setpos(".", {0, 1, 10, 0})
    require("curstr/custom").sources["togglable/word"] = {opts = {words = {"true", "false"}}}

    command("Curstr togglable/word")
    assert.current_line("あああtrueあああ")

    command("Curstr togglable/word")
    assert.current_line("あああfalseあああ")
  end)

  it("nomodifiable", function()
    vim.fn.append(0, "public")
    vim.fn.setpos(".", {0, 1, 1, 0})
    require("curstr/custom").sources["togglable/word"] = {opts = {words = {"public", "protected"}}}
    command("setlocal nomodifiable")

    command("Curstr togglable/word")

    assert.cursor_word("public")
  end)

end)
