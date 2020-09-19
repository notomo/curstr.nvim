local helper = require("curstr/lib/testlib/helper")
local command = helper.command
local assert = helper.assert

describe("range", function()

  before_each(helper.before_each)
  after_each(helper.after_each)

  it("join", function()
    require("curstr/custom").groups.range = {opts = {separator = "+"}}
    command("tabedit | setlocal buftype=nofile noswapfile")

    vim.fn.append(0, "    1")
    vim.fn.append(1, "     ")
    vim.fn.append(2, "    3 ")
    vim.fn.setpos(".", {0, 1, 1, 0})

    command("1,3Curstr range -action=join")

    assert.current_line("    1+3 ")
  end)

  it("join_default", function()
    require("curstr/custom").groups.range = {opts = {separator = "+"}}
    command("tabedit | setlocal buftype=nofile noswapfile")

    vim.fn.append(0, "    1")
    vim.fn.append(1, "    2")
    vim.fn.append(2, "    3 ")
    vim.fn.setpos(".", {0, 2, 1, 0})

    command("Curstr range -action=join")

    assert.current_line("    2+3 ")
  end)

  it("join_with_empty_separator", function()
    require("curstr/custom").groups.range = {opts = {separator = ""}}
    command("tabedit | setlocal buftype=nofile noswapfile")

    vim.fn.append(0, "    1")
    vim.fn.append(1, "    2")
    vim.fn.setpos(".", {0, 1, 1, 0})

    command("Curstr range -action=join")

    assert.current_line("    12")
  end)

  it("join_on_nomodifiable_buffer", function()
    require("curstr/custom").groups.range = {opts = {separator = ""}}
    command("tabedit")

    vim.fn.append(0, "    1")
    vim.fn.append(1, "    2")
    command("setlocal buftype=nofile nomodifiable")
    vim.fn.setpos(".", {0, 1, 1, 0})

    command("Curstr range -action=join")

    assert.current_line("    1")
  end)

end)
