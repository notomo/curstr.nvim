
let s:helper = CurstrTestHelper()
let s:suite = s:helper.suite('file/pattern')
let s:assert = s:helper.assert

function! s:suite.file_one()
    call curstr#custom#source_option('file/pattern', 'source_pattern', '\v^([^#]*)#(\w+)$')
    call curstr#custom#source_option('file/pattern', 'result_pattern', '\1')

    call s:helper.new_file('pattern.txt')
    call s:helper.open_new_file('entry', ['./pattern.txt#target_pattern'])
    call s:helper.cd_to_test_data()

    Curstr file/pattern

    call s:assert.file_name('pattern.txt')
    call s:assert.line_number(1)
endfunction

function! s:suite.file_with_position()
    call curstr#custom#source_option('file/pattern', 'source_pattern', '\v^([^#]*)#(\w+)$')
    call curstr#custom#source_option('file/pattern', 'result_pattern', '\1')
    call curstr#custom#source_option('file/pattern', 'search_pattern', '\2:')

    call s:helper.new_file('pattern.txt', ['', 'test:', '', '    target_pattern:', ''])
    call s:helper.open_new_file('entry', ['./pattern.txt#target_pattern'])
    call s:helper.cd_to_test_data()

    Curstr file/pattern

    call s:assert.file_name('pattern.txt')
    call s:assert.cursor_word('target_pattern')
endfunction

function! s:suite.not_found()
    call s:helper.open_new_file('entry', ['./pattern.txt#target_pattern'])

    Curstr file/pattern

    call s:assert.file_name('entry')
endfunction

function! s:suite.file_not_found()
    call s:helper.open_new_file('entry', ['./not_found.txt'])

    Curstr file/pattern

    call s:assert.file_name('entry')
endfunction
