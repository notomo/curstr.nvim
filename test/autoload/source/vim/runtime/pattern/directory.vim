
let s:helper = CurstrTestHelper()
let s:suite = s:helper.suite('vim/runtime/pattern/directory')
let s:assert = s:helper.assert

function! s:suite.open()
    call s:helper.buffer('rplugin/python3/curstr/*/group')

    Curstr vim/runtime/pattern/directory

    call s:assert.path('rplugin/python3/curstr/action/group/')
endfunction
