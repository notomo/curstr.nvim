
let s:suite = themis#suite('togglable/word/regex')
let s:assert = themis#helper('assert')

function! s:suite.before()
    let s:root = CurstrTestBefore()
endfunction

function! s:suite.before_each()
    call curstr#custom#source_option('togglable/word/regex', 'patterns', [])
endfunction

function! s:suite.after_each()
    call CurstrTestAfterEach()
endfunction

function! s:suite.toggle()
    tabe | setlocal buftype=nofile noswapfile
    call append(0, 'foo test')
    call setpos('.', [0, 1, 1, 0])
    call curstr#custom#source_option('togglable/word/regex', 'patterns', [['\vhoge|foo', 'bar'], ['bar', 'hoge']])
    Curstr togglable/word/regex
    call s:assert.equals(expand('<cword>'), 'bar')
    Curstr togglable/word/regex
    call s:assert.equals(expand('<cword>'), 'hoge')
    Curstr togglable/word/regex
    call s:assert.equals(expand('<cword>'), 'bar')
endfunction
