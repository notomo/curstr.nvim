
let s:suite = themis#suite('directory/buffer_relative')
let s:assert = themis#helper('assert')

function! s:suite.before()
    let s:root = CurstrTestBefore()
endfunction

function! s:suite.before_each()
    edit ./test/autoload/_test_data/entry.txt
    call cursor(2, 1)
endfunction

function! s:suite.after_each()
    call CurstrTestAfterEach()
endfunction

function! s:suite.default()
    Curstr directory/buffer_relative
    call s:assert.equals(expand('%:t'), 'opened')
endfunction
