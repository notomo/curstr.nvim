
doautocmd User CurstrSourceLoad

function! curstr#execute(arg_string, first_line, last_line) range abort
    call _curstr_execute(a:arg_string, a:first_line, a:last_line)
endfunction
