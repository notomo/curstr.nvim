scriptencoding utf-8

let s:helper = CurstrTestHelper()
let s:suite = s:helper.suite('togglable/pattern')
let s:assert = s:helper.assert

function! s:suite.before_each()
    call s:helper.before_each()

    call curstr#custom#source_option('togglable/pattern', 'patterns', [])
    call curstr#custom#source_option('togglable/pattern', 'char_pattern', '[:alnum:]_')
    tabe | setlocal buftype=nofile noswapfile
endfunction

function! s:suite.toggle()
    call append(0, 'foo test')
    call setpos('.', [0, 1, 1, 0])
    call curstr#custom#source_option('togglable/pattern', 'patterns', [['\vhoge|foo', 'bar'], ['bar', 'hoge']])

    Curstr togglable/pattern
    call s:assert.cursor_word('bar')

    Curstr togglable/pattern
    call s:assert.cursor_word('hoge')

    Curstr togglable/pattern
    call s:assert.cursor_word('bar')
endfunction

function! s:suite.char_pattern_option()
    call append(0, 'foo:test')
    call setpos('.', [0, 1, 1, 0])
    call curstr#custom#source_option('togglable/pattern', 'patterns', [['foo:test', 'foo;test'], ['foo;test', 'foo:test']])
    call curstr#custom#source_option('togglable/pattern', 'char_pattern', '[:alnum:]_;:')

    Curstr togglable/pattern
    call s:assert.current_line('foo;test')

    Curstr togglable/pattern
    call s:assert.current_line('foo:test')
endfunction

function! s:suite.with_multibyte()
    call append(0, 'あああfooあああ')
    call setpos('.', [0, 1, 10, 0])
    call curstr#custom#source_option('togglable/pattern', 'patterns', [['\vhoge|foo', 'bar'], ['bar', 'hoge']])

    Curstr togglable/pattern
    call s:assert.current_line('あああbarあああ')

    Curstr togglable/pattern
    call s:assert.current_line('あああhogeあああ')
endfunction

function! s:suite.toggle_line()
    call append(0, 'hoge')
    call search('hoge')
    call curstr#custom#source_option('togglable/pattern', 'patterns', [['hoge', 'bar']])

    Curstr togglable/pattern

    call s:assert.current_line('bar')
endfunction

function! s:suite.append_line()
    call append(0, 'hoge')
    call search('hoge')
    call curstr#custom#source_option('togglable/pattern', 'patterns', [['hoge', 'bar']])

    Curstr togglable/pattern -action=append

    call s:assert.current_line('hoge')
    call search('bar')
    call s:assert.current_line('bar')
endfunction
