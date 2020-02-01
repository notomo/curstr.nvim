
let s:helper = CurstrTestHelper()
let s:suite = s:helper.suite('file/buffer_relative')
let s:assert = s:helper.assert

function! s:suite.default()
    call s:helper.new_file('opened.txt')
    call s:helper.open_new_file('entry', ['opened.txt'])

    Curstr file/buffer_relative

    call s:assert.file_name('opened.txt')
endfunction

function! s:suite.open_with_row()
    call s:helper.new_file('opened.txt', ['', '', '', ''])
    call s:helper.open_new_file('entry', ['opened.txt:3'])

    Curstr file/buffer_relative

    call s:assert.file_name('opened.txt')
    call s:assert.line_number(3)
endfunction

function! s:suite.open_with_position()
    call s:helper.new_file('opened.txt', ['12345', '12345', '12345', '12345'])
    call s:helper.open_new_file('entry', ['opened.txt:3,4'])

    Curstr file/buffer_relative

    call s:assert.file_name('opened.txt')
    call s:assert.line_number(3)
    call s:assert.column_number(4)
endfunction
