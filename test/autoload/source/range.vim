
let s:suite = themis#suite('range')
let s:assert = themis#helper('assert')

function! s:suite.before()
    let s:root = CurstrTestBefore()
endfunction

function! s:suite.before_each()
    call curstr#custom#source_option('range', 'separator', '+')
endfunction

function! s:suite.after_each()
    call CurstrTestAfterEach()
endfunction

function! s:suite.join()
    tabe | setlocal buftype=nofile noswapfile
    call append(0, '    1')
    call append(1, '    2')
    call append(2, '    3 ')
    call setpos('.', [0, 1, 1, 0])
    1,3Curstr range -action=join
    call s:assert.equals(getline(line('.')), '1+2+3 ')
endfunction

function! s:suite.join_default()
    tabe | setlocal buftype=nofile noswapfile
    call append(0, '    1')
    call append(1, '    2')
    call append(2, '    3 ')
    call setpos('.', [0, 2, 1, 0])
    Curstr range -action=join
    call s:assert.equals(getline(line('.')), '2+3 ')
endfunction
