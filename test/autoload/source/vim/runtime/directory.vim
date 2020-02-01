
let s:helper = CurstrTestHelper()
let s:suite = s:helper.suite('vim/runtime/directory')
let s:assert = s:helper.assert

function! s:suite.open()
    edit ./test/autoload/_test_data/entry.txt
    let s:init_position = [0, 5, 2, 0]
    call setpos('.', s:init_position)

    Curstr vim/runtime/directory

    call s:assert.path('rplugin/python3/curstr/')
endfunction
