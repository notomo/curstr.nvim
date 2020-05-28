
let s:helper = CurstrTestHelper()
let s:suite = s:helper.suite('vim/lua')
let s:assert = s:helper.assert

function! s:suite.before_each()
    call s:helper.before_each()

    filetype on
    syntax enable

    call s:helper.open_new_file('entry.lua', ['require "vim.lsp.util"'])
    call s:helper.search('lsp')
endfunction

function! s:suite.after_each()
    call s:helper.after_each()

    filetype off
    syntax off
endfunction

function! s:suite.open()
    Curstr vim/lua

    call s:assert.file_name('util.lua')
endfunction

function! s:suite.not_found()
    normal! 0

    Curstr vim/lua

    call s:assert.file_name('entry.lua')
endfunction
