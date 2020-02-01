
let s:helper = CurstrTestHelper()
let s:suite = s:helper.suite('vim/script_function')
let s:assert = s:helper.assert

function! s:suite.before_each()
    call s:helper.before_each()

    call s:helper.open_new_file('entry', ['', 'function! s:test() abort', "    echomsg 'test'", 'endfunction', '', 'call s:test()'])
    call s:helper.search('call s:\zstest')
endfunction

function! s:assert.cursor_position() abort
    call s:assert.line_number(2)
    call s:assert.column_number(13)
endfunction

function! s:suite.open()
    Curstr vim/script_function

    call s:assert.cursor_position()
endfunction

function! s:suite.tab_open()
    Curstr vim/script_function -action=tab_open

    call s:assert.cursor_position()
    call s:assert.tab_count(2)
endfunction

function! s:suite.vertical_open()
    let pos = getpos('.')

    Curstr vim/script_function -action=vertical_open

    call s:assert.cursor_position()
    call s:assert.window_count(2)
    wincmd l
    call s:assert.position(pos)
endfunction

function! s:suite.horizontal_open()
    let pos = getpos('.')

    Curstr vim/script_function -action=horizontal_open

    call s:assert.cursor_position()
    call s:assert.window_count(2)
    wincmd j
    call s:assert.position(pos)
endfunction

function! s:suite.not_found()
    normal! gg
    let pos = getpos('.')

    Curstr vim/script_function

    call s:assert.position(pos)
endfunction
