if exists('g:loaded_curstr')
    finish
endif
let g:loaded_curstr = 1

command! -nargs=+ -range Curstr lua require("curstr/entrypoint/command").execute_by_excmd({<f-args>}, <line1>, <line2>)
