
let s:helper = CurstrTestHelper()
let s:suite = s:helper.suite('togglable/line/regex')
let s:assert = s:helper.assert

function! s:suite.toggle()
    call curstr#custom#source_option('togglable/line/regex', 'patterns', [])
    tabe | setlocal buftype=nofile noswapfile
    call append(0, 'foo test')
    call setpos('.', [0, 1, 1, 0])
    call curstr#custom#source_option('togglable/line/regex', 'patterns', [['\v(hoge|foo)\ze test', 'bar'], ['bar test', 'hoge test']])

    Curstr togglable/line/regex
    call s:assert.current_line('bar test')

    Curstr togglable/line/regex
    call s:assert.current_line('hoge test')

    Curstr togglable/line/regex
    call s:assert.current_line('bar test')
endfunction
