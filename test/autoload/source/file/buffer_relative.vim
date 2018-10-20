
let s:suite = themis#suite('file/buffer_relative')
let s:assert = themis#helper('assert')

function! s:suite.before()
    let s:root = CurstrTestBefore()
endfunction

function! s:suite.before_each()
    edit ./test/autoload/_test_data/entry.txt
endfunction

function! s:suite.after_each()
    call CurstrTestAfterEach()
endfunction

function! s:suite.default()
    Curstr file/buffer_relative
    call s:assert.equals(expand('%:t'), 'opened.txt')
endfunction

function! s:suite.open_with_row()
    call cursor(8, 1)
    Curstr file/buffer_relative
    call s:assert.equals(expand('%:t'), 'opened.txt')
    call s:assert.equals(line('.'), '3')
endfunction

function! s:suite.open_with_position()
    call cursor(9, 1)
    Curstr file/buffer_relative
    call s:assert.equals(expand('%:t'), 'opened.txt')
    call s:assert.equals(line('.'), '3')
    call s:assert.equals(col('.'), '4')
endfunction
