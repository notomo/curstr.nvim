
let s:helper = CurstrTestHelper()
let s:suite = s:helper.suite('vim/runtime/file')
let s:assert = s:helper.assert

function! s:suite.open()
    call s:helper.buffer('autoload/curstr.vim')

    Curstr vim/runtime/file

    call s:assert.path('autoload/curstr.vim')
endfunction
