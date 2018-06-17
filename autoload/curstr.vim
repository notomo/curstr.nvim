
function! curstr#execute(arg_string) abort
    call _curstr_execute(a:arg_string)
endfunction

function! curstr#is_testing() abort
    return exists('g:running_themis') ==? '1' ? v:true : v:false
endfunction
