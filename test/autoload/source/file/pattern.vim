
let s:suite = themis#suite('file/pattern')
let s:assert = themis#helper('assert')

function! s:suite.before()
    let s:root = CurstrTestBefore()
endfunction

function! s:suite.before_each()
    edit ./test/autoload/_test_data/entry.txt
    cd ./test/autoload/_test_data
endfunction

function! s:suite.after_each()
    call CurstrTestAfterEach()
endfunction

function! s:suite.file()
    call curstr#custom#source_option('file/pattern', 'source_pattern', '\v^([^#]*)#(\w+)$')
    call curstr#custom#source_option('file/pattern', 'result_pattern', '\1')
    call cursor(11, 1)

    Curstr file/pattern

    call s:assert.equals(expand('%:t'), 'pattern.txt')
    call s:assert.equals(line('.'), 1)
endfunction

function! s:suite.file_with_position()
    call curstr#custom#source_option('file/pattern', 'source_pattern', '\v^([^#]*)#(\w+)$')
    call curstr#custom#source_option('file/pattern', 'result_pattern', '\1')
    call curstr#custom#source_option('file/pattern', 'search_pattern', '\2:')
    call cursor(11, 1)

    Curstr file/pattern

    call s:assert.equals(expand('%:t'), 'pattern.txt')
    call s:assert.equals(expand('<cword>'), 'target_pattern')
endfunction

function! s:suite.not_found()
    call cursor(11, 1)

    Curstr file/pattern

    call s:assert.equals(expand('%:t'), 'entry.txt')
endfunction

function! s:suite.file_not_found()
    call cursor(12, 1)

    Curstr file/pattern

    call s:assert.equals(expand('%:t'), 'entry.txt')
endfunction
