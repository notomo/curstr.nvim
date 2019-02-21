scriptencoding utf-8

let s:suite = themis#suite('togglable/word/regex')
let s:assert = themis#helper('assert')

function! s:suite.before()
    let s:root = CurstrTestBefore()
endfunction

function! s:suite.before_each()
    call curstr#custom#source_option('togglable/word/regex', 'patterns', [])
    call curstr#custom#source_option('togglable/word/regex', 'char_pattern', '[:alnum:]_')
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

function! s:suite.char_pattern_option()
    tabe | setlocal buftype=nofile noswapfile
    call append(0, 'foo:test')
    call setpos('.', [0, 1, 1, 0])
    call curstr#custom#source_option('togglable/word/regex', 'patterns', [['foo:test', 'foo;test'], ['foo;test', 'foo:test']])
    call curstr#custom#source_option('togglable/word/regex', 'char_pattern', '[:alnum:]_;:')
    Curstr togglable/word/regex
    call s:assert.equals(getline(line('.')), 'foo;test')
    Curstr togglable/word/regex
    call s:assert.equals(getline(line('.')), 'foo:test')
endfunction

function! s:suite.with_multibyte()
    tabe | setlocal buftype=nofile noswapfile
    call append(0, 'あああfooあああ')
    call setpos('.', [0, 1, 10, 0])
    call curstr#custom#source_option('togglable/word/regex', 'patterns', [['\vhoge|foo', 'bar'], ['bar', 'hoge']])
    Curstr togglable/word/regex
    call s:assert.equals(getline(line('.')), 'あああbarあああ')
    Curstr togglable/word/regex
    call s:assert.equals(getline(line('.')), 'あああhogeあああ')
endfunction
