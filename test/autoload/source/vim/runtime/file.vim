
let s:helper = CurstrTestHelper()
let s:suite = s:helper.suite('vim/runtime/file')
let s:assert = s:helper.assert

function! s:suite.open()
    edit ./test/autoload/_test_data/entry.txt
    let s:init_position = [0, 4, 2, 0]
    call setpos('.', s:init_position)

    Curstr vim/runtime/file

    call s:assert.path('autoload/curstr.vim')
endfunction
