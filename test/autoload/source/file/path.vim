
let s:suite = themis#suite('file/path')
let s:assert = themis#helper('assert')

function! s:suite.before()
    let s:root = CurstrTestBefore()
endfunction

function! s:suite.before_each()
    edit ./test/autoload/_test_data/entry.txt
    cd ./test/autoload/_test_data
endfunction

function! s:suite.after_each()
    call CurstrTestAfterEach()
endfunction

function! s:suite.default()
    Curstr file/path
    call s:assert.equals(expand('%:t'), 'opened.txt')
endfunction

function! s:suite.open()
    Curstr file/path -action=open
    call s:assert.equals(expand('%:t'), 'opened.txt')
endfunction

function! s:suite.tab_open()
    Curstr file/path -action=tab_open
    call s:assert.equals(expand('%:t'), 'opened.txt')
    call s:assert.equals(tabpagenr('$'), 2)
endfunction

function! s:suite.vertical_open()
    Curstr file/path -action=vertical_open
    call s:assert.equals(expand('%:t'), 'opened.txt')
    call s:assert.equals(tabpagewinnr(1, '$'), 2)
    wincmd l
    call s:assert.equals(expand('%:t'), 'entry.txt')
endfunction

function! s:suite.horizontal_open()
    Curstr file/path -action=horizontal_open
    call s:assert.equals(expand('%:t'), 'opened.txt')
    call s:assert.equals(tabpagewinnr(1, '$'), 2)
    wincmd j
    call s:assert.equals(expand('%:t'), 'entry.txt')
endfunction

function! s:suite.not_found()
    let position = [0, 2, 1, 0]
    call setpos('.', position)
    Curstr file/path
    call s:assert.equals(expand('%:t'), 'entry.txt')
    call s:assert.equals(getpos('.'), position)
endfunction
