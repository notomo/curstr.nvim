
let s:helper = CurstrTestHelper()
let s:suite = s:helper.suite('togglable/line/simple')
let s:assert = s:helper.assert

function! s:suite.toggle()
    call curstr#custom#source_option('togglable/line/simple', 'lines', [])
    tabe | setlocal buftype=nofile noswapfile
    call append(0, 'line toggle test')
    call setpos('.', [0, 1, 1, 0])
    call curstr#custom#source_option('togglable/line/simple', 'lines', ['line toggle test', 'line toggle tested'])

    Curstr togglable/line/simple
    call s:assert.current_line('line toggle tested')

    Curstr togglable/line/simple
    call s:assert.current_line('line toggle test')
endfunction
