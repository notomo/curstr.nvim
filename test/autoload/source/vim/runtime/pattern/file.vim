
let s:helper = CurstrTestHelper()
let s:suite = s:helper.suite('vim/runtime/pattern/file')
let s:assert = s:helper.assert

function! s:suite.open()
    call s:helper.buffer('rplugin/python3/curstr/echoable.*')

    Curstr vim/runtime/pattern/file

    call s:assert.path('rplugin/python3/curstr/echoable.py')
endfunction
