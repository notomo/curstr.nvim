
doautocmd User CurstrSourceLoad

function! curstr#execute(arg_string, first_line, last_line) range abort
    if get(g:, 'curstr_debug', v:false)
        lua require("curstr/lib/module").cleanup("curstr")
    endif
    return luaeval('require("curstr/entrypoint/command").execute_by_excmd(unpack(_A))', [a:arg_string, a:first_line, a:last_line])
endfunction
