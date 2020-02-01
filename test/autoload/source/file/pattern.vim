
let s:helper = CurstrTestHelper()
let s:suite = s:helper.suite('file/pattern')
let s:assert = s:helper.assert

function! s:suite.before_each()
    call s:helper.before_each()
    edit ./test/autoload/_test_data/entry.txt
    cd ./test/autoload/_test_data
endfunction

function! s:suite.file()
    call curstr#custom#source_option('file/pattern', 'source_pattern', '\v^([^#]*)#(\w+)$')
    call curstr#custom#source_option('file/pattern', 'result_pattern', '\1')
    call cursor(11, 1)

    Curstr file/pattern

    call s:assert.file_name('pattern.txt')
    call s:assert.line_number(1)
endfunction

function! s:suite.file_with_position()
    call curstr#custom#source_option('file/pattern', 'source_pattern', '\v^([^#]*)#(\w+)$')
    call curstr#custom#source_option('file/pattern', 'result_pattern', '\1')
    call curstr#custom#source_option('file/pattern', 'search_pattern', '\2:')
    call cursor(11, 1)

    Curstr file/pattern

    call s:assert.file_name('pattern.txt')
    call s:assert.cursor_word('target_pattern')
endfunction

function! s:suite.not_found()
    call cursor(11, 1)

    Curstr file/pattern

    call s:assert.file_name('entry.txt')
endfunction

function! s:suite.file_not_found()
    call cursor(12, 1)

    Curstr file/pattern

    call s:assert.file_name('entry.txt')
endfunction
