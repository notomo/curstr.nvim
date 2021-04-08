local helper = require("curstr.lib.testlib.helper")
local curstr = helper.require("curstr")

describe("range", function()

  before_each(helper.before_each)
  after_each(helper.after_each)

  it("join", function()
    require("curstr.custom").groups.range = {opts = {separator = "+"}}
    vim.cmd("tabedit | setlocal buftype=nofile noswapfile")

    helper.set_lines([[
    1
     
    3 ]])
    vim.fn.setpos(".", {0, 1, 1, 0})

    vim.cmd("normal! 1gg")
    vim.cmd("normal! V")
    vim.cmd("normal! 3gg")
    curstr.execute("range", {action = "join"})

    assert.current_line("    1+3 ")
  end)

  it("join_default", function()
    require("curstr.custom").groups.range = {opts = {separator = "+"}}
    vim.cmd("tabedit | setlocal buftype=nofile noswapfile")

    helper.set_lines([[
    1
    2
    3 ]])
    vim.fn.setpos(".", {0, 2, 1, 0})

    curstr.execute("range", {action = "join"})

    assert.current_line("    2+3 ")
  end)

  it("join_with_empty_separator", function()
    require("curstr.custom").groups.range = {opts = {separator = ""}}
    vim.cmd("tabedit | setlocal buftype=nofile noswapfile")

    helper.set_lines([[
    1
    2]])
    vim.fn.setpos(".", {0, 1, 1, 0})

    curstr.execute("range", {action = "join"})

    assert.current_line("    12")
  end)

  it("join_on_nomodifiable_buffer", function()
    require("curstr.custom").groups.range = {opts = {separator = ""}}
    vim.cmd("tabedit")

    helper.set_lines([[
    1
    2]])
    vim.cmd("setlocal buftype=nofile nomodifiable")
    vim.fn.setpos(".", {0, 1, 1, 0})

    curstr.execute("range", {action = "join"})

    assert.current_line("    1")
  end)

end)
