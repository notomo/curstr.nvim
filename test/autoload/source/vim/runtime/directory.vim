
let s:suite = themis#suite('vim/runtime/directory')
let s:assert = themis#helper('assert')

function! s:suite.before()
    let s:root = CurstrTestBefore()
endfunction

function! s:suite.before_each()
    edit ./test/autoload/_test_data/entry.txt
    let s:init_position = [0, 5, 2, 0]
    call setpos('.', s:init_position)
endfunction

function! s:suite.after_each()
    call CurstrTestAfterEach()
endfunction

function! s:suite.open()
    Curstr vim/runtime/directory

    call s:assert.equals(expand('%:p'), s:root . '/rplugin/python3/curstr/')
endfunction
