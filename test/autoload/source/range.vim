
let s:helper = CurstrTestHelper()
let s:suite = s:helper.suite('range')
let s:assert = s:helper.assert

function! s:suite.join()
    call curstr#custom#action_option('range', 'separator', '+')
    tabedit | setlocal buftype=nofile noswapfile

    call append(0, '    1')
    call append(1, '     ')
    call append(2, '    3 ')
    call setpos('.', [0, 1, 1, 0])

    1,3Curstr range -action=join

    call s:assert.current_line('    1+3 ')
endfunction

function! s:suite.join_default()
    call curstr#custom#action_option('range', 'separator', '+')
    tabedit | setlocal buftype=nofile noswapfile

    call append(0, '    1')
    call append(1, '    2')
    call append(2, '    3 ')
    call setpos('.', [0, 2, 1, 0])

    Curstr range -action=join

    call s:assert.current_line('    2+3 ')
endfunction

function! s:suite.join_with_empty_separator()
    call curstr#custom#action_option('range', 'separator', '')
    tabedit | setlocal buftype=nofile noswapfile

    call append(0, '    1')
    call append(1, '    2')
    call setpos('.', [0, 1, 1, 0])

    Curstr range -action=join

    call s:assert.current_line('    12')
endfunction

function! s:suite.join_on_nomodifiable_buffer()
    tabe
    call curstr#custom#action_option('range', 'separator', '')

    call append(0, '    1')
    call append(1, '    2')
    setlocal buftype=nofile nomodifiable
    call setpos('.', [0, 1, 1, 0])

    Curstr range -action=join

    call s:assert.current_line('    1')
endfunction
