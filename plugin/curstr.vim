if exists('g:loaded_curstr')
    finish
endif
let g:loaded_curstr = 1

if get(g:, 'curstr_debug', v:false)
    command! -nargs=+ -range Curstr lua require("curstr/lib/module").cleanup("curstr"); require("curstr/entrypoint/command").execute_by_excmd({<f-args>}, <line1>, <line2>)
else
    command! -nargs=+ -range Curstr lua require("curstr/entrypoint/command").execute_by_excmd({<f-args>}, <line1>, <line2>)
endif
