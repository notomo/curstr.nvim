local helper = require("curstr.test.helper")
local curstr = helper.require("curstr")
local assert = helper.typed_assert(assert)

describe("range", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("join", function()
    curstr.setup({ groups = { range = { opts = { separator = "+" } } } })
    vim.cmd.tabedit()
    vim.opt_local.buftype = "nofile"
    vim.opt_local.swapfile = false

    helper.set_lines([[
    1
     
    3 ]])
    vim.fn.setpos(".", { 0, 1, 1, 0 })

    vim.cmd.normal({ args = { "1gg" }, bang = true })
    vim.cmd.normal({ args = { "V" }, bang = true })
    vim.cmd.normal({ args = { "3gg" }, bang = true })
    curstr.execute("range", { action = "join" })

    assert.current_line("    1+3 ")
  end)

  it("join_default", function()
    curstr.setup({ groups = { range = { opts = { separator = "+" } } } })
    vim.cmd.tabedit()
    vim.opt_local.buftype = "nofile"
    vim.opt_local.swapfile = false

    helper.set_lines([[
    1
    2
    3 ]])
    vim.fn.setpos(".", { 0, 2, 1, 0 })

    curstr.execute("range", { action = "join" })

    assert.current_line("    2+3 ")
  end)

  it("join_with_empty_separator", function()
    curstr.setup({ groups = { range = { opts = { separator = "" } } } })
    vim.cmd.tabedit()
    vim.opt_local.buftype = "nofile"
    vim.opt_local.swapfile = false

    helper.set_lines([[
    1
    2]])
    vim.fn.setpos(".", { 0, 1, 1, 0 })

    curstr.execute("range", { action = "join" })

    assert.current_line("    12")
  end)

  it("join_on_nomodifiable_buffer", function()
    curstr.setup({ groups = { range = { opts = { separator = "" } } } })
    vim.cmd.tabedit()

    helper.set_lines([[
    1
    2]])
    vim.opt_local.buftype = "nofile"
    vim.opt_local.modifiable = false
    vim.fn.setpos(".", { 0, 1, 1, 0 })

    curstr.execute("range", { action = "join" })

    assert.current_line("    1")
  end)
end)
