local helper = require("curstr.test.helper")
local curstr = helper.require("curstr")

describe("vim/script_function", function()
  before_each(function()
    helper.before_each()

    helper.open_new_file(
      "entry.vim",
      [[

function! s:test() abort
    echomsg 'test'
endfunction

call s:test()]]
    )
    vim.bo.filetype = "vim"
    helper.search("call s:\\zstest")
  end)

  after_each(helper.after_each)

  local assert_cursor_position = function()
    assert.cursor_row(2)
    assert.cursor_column(13)
  end

  local assert_position = function(pos)
    assert.is_same(pos, vim.fn.getpos("."))
  end

  it("open", function()
    curstr.execute("vim/script_function")

    assert_cursor_position()
  end)

  it("tab_open", function()
    curstr.execute("vim/script_function", { action = "tab_open" })

    assert_cursor_position()
    assert.tab_count(2)
  end)

  it("vertical_open", function()
    local pos = vim.fn.getpos(".")

    curstr.execute("vim/script_function", { action = "vertical_open" })

    assert_cursor_position()
    assert.window_count(2)
    vim.cmd.wincmd("l")
    assert_position(pos)
  end)

  it("horizontal_open", function()
    local pos = vim.fn.getpos(".")

    curstr.execute("vim/script_function", { action = "horizontal_open" })

    assert_cursor_position()
    assert.window_count(2)
    vim.cmd.wincmd("j")
    assert_position(pos)
  end)

  it("not_found", function()
    vim.cmd.normal({ args = { "gg" }, bang = true })
    local pos = vim.fn.getpos(".")

    curstr.execute("vim/script_function")

    assert_position(pos)
  end)
end)
