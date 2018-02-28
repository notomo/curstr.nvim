
if exists('g:loaded_curstr')
    finish
endif
let g:loaded_curstr = 1

command! -nargs=* Curstr call curstr#execute(<q-args>)
