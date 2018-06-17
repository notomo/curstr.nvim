
let s:suite = themis#suite('vim/autoload_function')
let s:assert = themis#helper('assert')

function! s:suite.before()
    let s:root = CurstrTestBefore()
endfunction

function! s:suite.before_each()
    edit ./test/autoload/_test_data/autoload_function.vim
    let s:init_position = [0, 6, 7, 0]
    call setpos('.', s:init_position)
endfunction

function! s:suite.after_each()
    call CurstrTestAfterEach()
endfunction

function! s:suite.string_option()
    call setpos('.', [0, 1, 1, 0])
    Curstr vim/autoload_function -string=curstr#execute

    call s:assert.equals(expand('%:p'), s:root . '/autoload/curstr.vim')
    let position = getpos('.')
    call s:assert.equals(position[1], 2)
    call s:assert.equals(position[2], 11)
endfunction

function! s:suite.no_cache_option()
    Curstr vim/autoload_function -no-cache

    call s:assert.equals(expand('%:p'), s:root . '/autoload/curstr.vim')
    let position = getpos('.')
    call s:assert.equals(position[1], 2)
    call s:assert.equals(position[2], 11)
endfunction

function! s:suite.open()
    Curstr vim/autoload_function

    call s:assert.equals(expand('%:p'), s:root . '/autoload/curstr.vim')
    let position = getpos('.')
    call s:assert.equals(position[1], 2)
    call s:assert.equals(position[2], 11)
endfunction

function! s:suite.tab_open()
    Curstr vim/autoload_function -action=tab_open

    call s:assert.equals(expand('%:p'), s:root . '/autoload/curstr.vim')
    let position = getpos('.')
    call s:assert.equals(position[1], 2)
    call s:assert.equals(position[2], 11)
    call s:assert.equals(tabpagenr('$'), 2)
endfunction

function! s:suite.vertical_open()
    Curstr vim/autoload_function -action=vertical_open

    call s:assert.equals(expand('%:p'), s:root . '/autoload/curstr.vim')
    call s:assert.equals(tabpagewinnr(1, '$'), 2)
    wincmd l
    call s:assert.equals(getpos('.'), s:init_position)
endfunction

function! s:suite.horizontal_open()
    Curstr vim/autoload_function -action=horizontal_open

    call s:assert.equals(expand('%:p'), s:root . '/autoload/curstr.vim')
    call s:assert.equals(tabpagewinnr(1, '$'), 2)
    wincmd j
    call s:assert.equals(getpos('.'), s:init_position)
endfunction

function! s:suite.not_found()
    let position = [0, 1, 1, 0]
    call setpos('.', position)
    Curstr vim/autoload_function
    call s:assert.equals(getpos('.'), position)
    call s:assert.equals(expand('%:t'), 'autoload_function.vim')
endfunction
