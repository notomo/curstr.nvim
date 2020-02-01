scriptencoding utf-8

let s:helper = CurstrTestHelper()
let s:suite = s:helper.suite('togglable/word/simple')
let s:assert = s:helper.assert

function! s:suite.before_each()
    call s:helper.before_each()
    call curstr#custom#source_option('togglable/word/simple', 'words', [])
    call curstr#custom#source_option('togglable/word/simple', 'char_pattern', '[:alnum:]_')
    tabe | setlocal buftype=nofile noswapfile
endfunction

function! s:suite.toggle()
    call append(0, 'public toggle test')
    call setpos('.', [0, 1, 1, 0])
    call curstr#custom#source_option('togglable/word/simple', 'words', ['public', 'protected', 'private'])

    Curstr togglable/word/simple
    call s:assert.cursor_word('protected')

    Curstr togglable/word/simple
    call s:assert.cursor_word('private')

    Curstr togglable/word/simple
    call s:assert.cursor_word('public')
endfunction

function! s:suite.append()
    call append(0, 'public toggle test')
    call setpos('.', [0, 1, 1, 0])
    call curstr#custom#source_option('togglable/word/simple', 'words', ['public', 'protected', 'private'])

    Curstr togglable/word/simple -action=append

    call s:assert.cursor_word('public')
    call setpos('.', [0, 2, 1, 0])
    call s:assert.cursor_word('protected')
endfunction

function! s:suite.normalized_toggle()
    call append(0, 'True')
    call setpos('.', [0, 1, 1, 0])
    call curstr#custom#source_option('togglable/word/simple', 'words', ['true', 'false'])
    call curstr#custom#source_option('togglable/word/simple', 'normalized', v:true)

    Curstr togglable/word/simple
    call s:assert.cursor_word('False')

    Curstr togglable/word/simple
    call s:assert.cursor_word('True')
endfunction

function! s:suite.char_pattern_option()
    call append(0, 'foo:test')
    call setpos('.', [0, 1, 1, 0])
    call curstr#custom#source_option('togglable/word/simple', 'words', ['foo:test', 'foo;test'])
    call curstr#custom#source_option('togglable/word/simple', 'char_pattern', '[:alnum:]_;:')

    Curstr togglable/word/simple
    call s:assert.current_line('foo;test')

    Curstr togglable/word/simple
    call s:assert.current_line('foo:test')
endfunction

function! s:suite.with_multibyte()
    call append(0, 'あああfalseあああ')
    call setpos('.', [0, 1, 10, 0])
    call curstr#custom#source_option('togglable/word/simple', 'words', ['true', 'false'])

    Curstr togglable/word/simple
    call s:assert.current_line('あああtrueあああ')

    Curstr togglable/word/simple
    call s:assert.current_line('あああfalseあああ')
endfunction

function! s:suite.nomodifiable()
    call append(0, 'public')
    call setpos('.', [0, 1, 1, 0])
    call curstr#custom#source_option('togglable/word/simple', 'words', ['public', 'protected'])
    setlocal nomodifiable

    Curstr togglable/word/simple

    call s:assert.cursor_word('public')
endfunction
