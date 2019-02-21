scriptencoding utf-8

let s:suite = themis#suite('togglable/word/simple')
let s:assert = themis#helper('assert')

function! s:suite.before()
    let s:root = CurstrTestBefore()
endfunction

function! s:suite.before_each()
    call curstr#custom#source_option('togglable/word/simple', 'words', [])
    call curstr#custom#source_option('togglable/word/simple', 'char_pattern', '[:alnum:]_')
endfunction

function! s:suite.after_each()
    call CurstrTestAfterEach()
endfunction

function! s:suite.toggle()
    tabe | setlocal buftype=nofile noswapfile
    call append(0, 'public toggle test')
    call setpos('.', [0, 1, 1, 0])
    call curstr#custom#source_option('togglable/word/simple', 'words', ['public', 'protected', 'private'])

    Curstr togglable/word/simple
    call s:assert.equals(expand('<cword>'), 'protected')
    Curstr togglable/word/simple
    call s:assert.equals(expand('<cword>'), 'private')
    Curstr togglable/word/simple
    call s:assert.equals(expand('<cword>'), 'public')
endfunction

function! s:suite.append()
    tabe | setlocal buftype=nofile noswapfile
    call append(0, 'public toggle test')
    call setpos('.', [0, 1, 1, 0])

    call curstr#custom#source_option('togglable/word/simple', 'words', ['public', 'protected', 'private'])
    Curstr togglable/word/simple -action=append
    call s:assert.equals(expand('<cword>'), 'public')

    call setpos('.', [0, 2, 1, 0])
    call s:assert.equals(expand('<cword>'), 'protected')
endfunction

function! s:suite.normalized_toggle()
    tabe | setlocal buftype=nofile noswapfile
    call append(0, 'True')
    call setpos('.', [0, 1, 1, 0])
    call curstr#custom#source_option('togglable/word/simple', 'words', ['true', 'false'])
    call curstr#custom#source_option('togglable/word/simple', 'normalized', v:true)

    Curstr togglable/word/simple
    call s:assert.equals(expand('<cword>'), 'False')
    Curstr togglable/word/simple
    call s:assert.equals(expand('<cword>'), 'True')
endfunction

function! s:suite.char_pattern_option()
    tabe | setlocal buftype=nofile noswapfile
    call append(0, 'foo:test')
    call setpos('.', [0, 1, 1, 0])
    call curstr#custom#source_option('togglable/word/simple', 'words', ['foo:test', 'foo;test'])
    call curstr#custom#source_option('togglable/word/simple', 'char_pattern', '[:alnum:]_;:')
    Curstr togglable/word/simple
    call s:assert.equals(getline(line('.')), 'foo;test')
    Curstr togglable/word/simple
    call s:assert.equals(getline(line('.')), 'foo:test')
endfunction

function! s:suite.with_multibyte()
    tabe | setlocal buftype=nofile noswapfile
    call append(0, 'あああfalseあああ')
    call setpos('.', [0, 1, 10, 0])
    call curstr#custom#source_option('togglable/word/simple', 'words', ['true', 'false'])
    Curstr togglable/word/simple
    call s:assert.equals(getline(line('.')), 'あああtrueあああ')
    Curstr togglable/word/simple
    call s:assert.equals(getline(line('.')), 'あああfalseあああ')
endfunction
