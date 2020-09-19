local helper = require("curstr/lib/testlib/helper")
local command = helper.command
local assert = helper.assert

describe("vim/autoload_function", function()

  before_each(function()
    helper.before_each()

    helper.set_lines("call curstr#execute('', 1, 2)")
    command("setlocal filetype=vim")
    helper.search("curstr")
  end)
  after_each(helper.after_each)

  local assert_current_position = function()
    assert.current_row(4)
    assert.current_column(11)
  end

  local assert_position = function(pos)
    assert.is_same(pos, vim.fn.getpos("."))
  end

  it("open", function()
    command("Curstr vim/autoload_function")

    assert.path("autoload/curstr.vim")
    assert_current_position()
  end)

  it("tab_open", function()
    command("Curstr vim/autoload_function -action=tab_open")

    assert.path("autoload/curstr.vim")
    assert_current_position()
    assert.tab_count(2)
  end)

  it("vertical_open", function()
    local pos = vim.fn.getpos(".")

    command("Curstr vim/autoload_function -action=vertical_open")

    assert.path("autoload/curstr.vim")
    assert_current_position()
    assert.window_count(2)
    command("wincmd l")
    assert_position(pos)
  end)

  it("horizontal_open", function()
    local pos = vim.fn.getpos(".")

    command("Curstr vim/autoload_function -action=horizontal_open")

    assert.path("autoload/curstr.vim")
    assert_current_position()
    assert.window_count(2)
    command("wincmd j")
    assert_position(pos)
  end)

  it("not_found", function()
    helper.search("call")
    local pos = vim.fn.getpos(".")

    command("Curstr vim/autoload_function")

    assert_position(pos)
    assert.file_name("")
  end)

  it("no_include_packpath", function()
    vim.fn["curstr#custom#source_option"]("vim/autoload_function", "include_packpath", false)

    helper.new_directory("package/pack/package/opt/example/autoload")
    helper.new_file("package/pack/package/opt/example/autoload/example.vim", [[

function! example#execute() abort
endfunction]])
    helper.open_new_file("call.vim", "vim.fn.example#execute()")
    helper.search("example#execute")
    local pos = vim.fn.getpos(".")

    command("Curstr vim/autoload_function")

    assert_position(pos)
    assert.file_name("call.vim")
  end)

  it("include_packpath", function()
    vim.fn["curstr#custom#source_option"]("vim/autoload_function", "include_packpath", true)

    helper.new_directory("package/pack/package/opt/example/autoload")
    helper.new_file("package/pack/package/opt/example/autoload/example.vim", [[

function! example#execute() abort
endfunction
]])
    helper.add_packpath("package")
    helper.open_new_file("call.vim", "vim.fn.example#execute()")
    command("setlocal filetype=vim")
    helper.search("example#execute")

    command("Curstr vim/autoload_function")

    assert.file_name("example.vim")

    local pos = vim.fn.getpos(".")
    helper.search("example#execute")
    assert_position(pos)
  end)

end)
