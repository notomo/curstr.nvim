
let s:suite = themis#suite('togglable/line/simple')
let s:assert = themis#helper('assert')

function! s:suite.before()
    let s:root = CurstrTestBefore()
endfunction

function! s:suite.before_each()
    call curstr#custom#source_option('togglable/line/simple', 'lines', [])
endfunction

function! s:suite.after_each()
    call CurstrTestAfterEach()
endfunction

function! s:suite.toggle()
    tabe | setlocal buftype=nofile noswapfile
    call append(0, 'line toggle test')
    call setpos('.', [0, 1, 1, 0])
    call curstr#custom#source_option('togglable/line/simple', 'lines', ['line toggle test', 'line toggle tested'])
    Curstr togglable/line/simple
    call s:assert.equals(getline(line('.')), 'line toggle tested')
    Curstr togglable/line/simple
    call s:assert.equals(getline(line('.')), 'line toggle test')
endfunction
