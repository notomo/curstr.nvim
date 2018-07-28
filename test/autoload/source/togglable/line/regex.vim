
let s:suite = themis#suite('togglable/line/regex')
let s:assert = themis#helper('assert')

function! s:suite.before()
    let s:root = CurstrTestBefore()
endfunction

function! s:suite.before_each()
    call curstr#custom#source_option('togglable/line/regex', 'patterns', [])
endfunction

function! s:suite.after_each()
    call CurstrTestAfterEach()
endfunction

function! s:suite.toggle()
    tabe | setlocal buftype=nofile noswapfile
    call append(0, 'foo test')
    call setpos('.', [0, 1, 1, 0])
    call curstr#custom#source_option('togglable/line/regex', 'patterns', [['\v(hoge|foo)\ze test', 'bar'], ['bar test', 'hoge test']])
    Curstr togglable/line/regex
    call s:assert.equals(getline(line('.')), 'bar test')
    Curstr togglable/line/regex
    call s:assert.equals(getline(line('.')), 'hoge test')
    Curstr togglable/line/regex
    call s:assert.equals(getline(line('.')), 'bar test')
endfunction
