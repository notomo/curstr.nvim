
let s:helper = CurstrTestHelper()
let s:suite = s:helper.suite('vim/script_function')
let s:assert = s:helper.assert

function! s:suite.before_each()
    call s:helper.before_each()

    edit ./test/autoload/_test_data/script_function.vim
    let s:init_position = [0, 6, 8, 0]
    call setpos('.', s:init_position)
endfunction

function! s:suite.open()
    Curstr vim/script_function

    let position = getpos('.')
    call s:assert.equals(position[1], 2)
    call s:assert.equals(position[2], 13)
endfunction

function! s:suite.tab_open()
    Curstr vim/script_function -action=tab_open

    let position = getpos('.')
    call s:assert.equals(position[1], 2)
    call s:assert.equals(position[2], 13)
    call s:assert.tab_count(2)
endfunction

function! s:suite.vertical_open()
    Curstr vim/script_function -action=vertical_open

    call s:assert.window_count(2)
    wincmd l
    call s:assert.equals(getpos('.'), s:init_position)
endfunction

function! s:suite.horizontal_open()
    Curstr vim/script_function -action=horizontal_open

    call s:assert.window_count(2)
    wincmd j
    call s:assert.equals(getpos('.'), s:init_position)
endfunction

function! s:suite.not_found()
    let position = [0, 1, 1, 0]
    call setpos('.', position)

    Curstr vim/script_function

    call s:assert.equals(getpos('.'), position)
endfunction
