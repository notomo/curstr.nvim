
let s:helper = CurstrTestHelper()
let s:suite = s:helper.suite('vim/runtime/directory')
let s:assert = s:helper.assert

function! s:suite.open()
    call s:helper.buffer('rplugin/python3/curstr')

    Curstr vim/runtime/directory

    call s:assert.path('rplugin/python3/curstr/')
endfunction
