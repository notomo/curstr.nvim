
let s:helper = CurstrTestHelper()
let s:suite = s:helper.suite('position/pattern')
let s:assert = s:helper.assert

function! s:suite.file_one()
    call curstr#custom#source_option('position/pattern', 'source_pattern', '\v\k+')
    call curstr#custom#source_option('position/pattern', 'search_pattern', '\1:\1')

    call s:helper.open_new_file('entry', ['hoge', '', 'hoge:hoge'])
    call s:helper.cd_to_test_data()

    Curstr position/pattern

    call s:assert.line_number(3)
    call s:assert.current_line('hoge:hoge')
endfunction

function! s:suite.not_found()
    call s:helper.open_new_file('entry', [])

    Curstr position/pattern

    call s:assert.line_number(1)
endfunction
