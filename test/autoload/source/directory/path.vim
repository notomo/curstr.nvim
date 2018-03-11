
let s:suite = themis#suite('directory/path')
let s:assert = themis#helper('assert')

function! s:suite.before()
    let s:root = CurstrTestBefore()
endfunction

function! s:suite.before_each()
    edit ./test/autoload/_test_data/entry.txt
    cd ./test/autoload/_test_data
    call cursor(3, 1)
endfunction

function! s:suite.after_each()
    call CurstrTestAfterEach()
endfunction

function! s:suite.default()
    Curstr directory/path
    call s:assert.equals(expand('%'), s:root . '/test/autoload/_test_data/opened/')
endfunction
