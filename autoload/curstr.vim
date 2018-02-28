
function! curstr#execute(arg_string) abort
    call curstr#initialize()
    call _curstr_execute(a:arg_string)
endfunction

function! curstr#initialize() abort
    if !exists('g:loaded_remote_plugins')
        runtime! plugin/rplugin.vim
    endif
    call curstr#custom#init()
endfunction
