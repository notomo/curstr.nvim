
let s:suite = themis#suite('plugin')
let s:assert = themis#helper('assert')

function! s:suite.definition()
    call s:assert.equals(exists(':Curstr'), 2)
    call s:assert.equals(g:loaded_curstr, 1)
endfunction
