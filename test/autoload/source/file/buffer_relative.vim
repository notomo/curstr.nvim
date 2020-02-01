
let s:helper = CurstrTestHelper()
let s:suite = s:helper.suite('file/buffer_relative')
let s:assert = s:helper.assert

function! s:suite.before_each()
    call s:helper.before_each()
    edit ./test/autoload/_test_data/entry.txt
endfunction

function! s:suite.default()
    Curstr file/buffer_relative

    call s:assert.file_name('opened.txt')
endfunction

function! s:suite.open_with_row()
    call cursor(8, 1)

    Curstr file/buffer_relative

    call s:assert.file_name('opened.txt')
    call s:assert.line_number(3)
endfunction

function! s:suite.open_with_position()
    call cursor(9, 1)

    Curstr file/buffer_relative

    call s:assert.file_name('opened.txt')
    call s:assert.line_number(3)
    call s:assert.column_number(4)
endfunction
