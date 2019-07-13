
if exists('g:loaded_curstr')
    finish
endif
let g:loaded_curstr = 1

command! -nargs=+ -range Curstr call curstr#execute(<q-args>, <line1>, <line2>)
