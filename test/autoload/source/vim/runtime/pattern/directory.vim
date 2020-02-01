
let s:helper = CurstrTestHelper()
let s:suite = s:helper.suite('vim/runtime/pattern/directory')
let s:assert = s:helper.assert

function! s:suite.open()
    edit ./test/autoload/_test_data/entry.txt
    let s:init_position = [0, 7, 2, 0]
    call setpos('.', s:init_position)

    Curstr vim/runtime/pattern/directory

    call s:assert.path('rplugin/python3/curstr/action/group/')
endfunction
