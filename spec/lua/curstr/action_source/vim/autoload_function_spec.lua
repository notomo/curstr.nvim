local helper = require("curstr.test.helper")
local curstr = helper.require("curstr")

describe("vim/autoload_function", function()
  before_each(function()
    helper.before_each()

    helper.test_data:create_file(
      "test_plugin/autoload/curstr_test_plugin.vim",
      [[

function! curstr_test_plugin#execute()
endfunction

]]
    )
    vim.o.runtimepath = vim.o.runtimepath .. "," .. helper.test_data:path("test_plugin")

    helper.set_lines("call curstr_test_plugin#execute()")
    vim.opt_local.filetype = "vim"
    helper.search("curstr")
  end)
  after_each(helper.after_each)

  local assert_current_position = function()
    assert.cursor_row(2)
    assert.cursor_column(11)
  end

  local assert_position = function(pos)
    assert.is_same(pos, vim.fn.getpos("."))
  end

  it("open", function()
    curstr.execute("vim/autoload_function")

    assert.path(helper.test_data:relative_path("test_plugin/autoload/curstr_test_plugin.vim"))
    assert_current_position()
  end)

  it("tab_open", function()
    curstr.execute("vim/autoload_function", { action = "tab_open" })

    assert.path(helper.test_data:relative_path("test_plugin/autoload/curstr_test_plugin.vim"))
    assert_current_position()
    assert.tab_count(2)
  end)

  it("vertical_open", function()
    local pos = vim.fn.getpos(".")

    curstr.execute("vim/autoload_function", { action = "vertical_open" })

    assert.path(helper.test_data:relative_path("test_plugin/autoload/curstr_test_plugin.vim"))
    assert_current_position()
    assert.window_count(2)
    vim.cmd.wincmd("l")
    assert_position(pos)
  end)

  it("horizontal_open", function()
    local pos = vim.fn.getpos(".")

    curstr.execute("vim/autoload_function", { action = "horizontal_open" })

    assert.path(helper.test_data:relative_path("test_plugin/autoload/curstr_test_plugin.vim"))
    assert_current_position()
    assert.window_count(2)
    vim.cmd.wincmd("j")
    assert_position(pos)
  end)

  it("not_found", function()
    helper.search("call")
    local pos = vim.fn.getpos(".")

    curstr.execute("vim/autoload_function")

    assert_position(pos)
    assert.buffer_name_tail("")
  end)

  it("no_include_packpath", function()
    curstr.setup({ sources = { ["vim/autoload_function"] = { opts = { include_packpath = false } } } })

    helper.test_data:create_file(
      "package/pack/package/opt/example/autoload/example.vim",
      [[

function! example#execute() abort
endfunction]]
    )
    helper.open_new_file("call.vim", "vim.fn.example#execute()")
    helper.search("example#execute")
    local pos = vim.fn.getpos(".")

    curstr.execute("vim/autoload_function")

    assert_position(pos)
    assert.buffer_name_tail("call.vim")
  end)

  it("include_packpath", function()
    curstr.setup({ sources = { ["vim/autoload_function"] = { opts = { include_packpath = true } } } })

    helper.test_data:create_file(
      "package/pack/package/opt/example/autoload/example.vim",
      [[

function! example#execute() abort
endfunction
]]
    )
    helper.add_packpath("package")
    helper.open_new_file("call.vim", "vim.fn.example#execute()")
    vim.opt_local.filetype = "vim"
    helper.search("example#execute")

    curstr.execute("vim/autoload_function")

    assert.buffer_name_tail("example.vim")

    local pos = vim.fn.getpos(".")
    helper.search("example#execute")
    assert_position(pos)
  end)
end)
