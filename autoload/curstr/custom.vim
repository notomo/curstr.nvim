
let s:init_customizes = {
    \ 'execute_option': [],
    \ 'filetype_source': [],
    \ 'filetype_alias': [],
    \ 'source_alias': [],
    \ 'source_option': [],
\ }

function! curstr#custom#execute_option(option_name, value) abort
    let dict = {'option_name': a:option_name, 'value': a:value}
    call s:custom('execute_option', dict)
endfunction

function! curstr#custom#filetype_alias(alias, filetype) abort
    let dict = {'alias': a:alias, 'filetype': a:filetype}
    call s:custom('filetype_alias', dict)
endfunction

function! curstr#custom#filetype_source(filetype, source_names) abort
    let dict = {'filetype': a:filetype, 'source_names': a:source_names}
    call s:custom('filetype_source', dict)
endfunction

function! curstr#custom#source_alias(alias, source_names) abort
    let dict = {'alias': a:alias, 'source_names': a:source_names}
    call s:custom('source_alias', dict)
endfunction

function! curstr#custom#source_option(source_name, option_name, value) abort
    let dict = {'source_name': a:source_name, 'option_name': a:option_name, 'value': a:value}
    call s:custom('source_option', dict)
endfunction

function! curstr#custom#init() abort
    if !exists('s:init_customizes')
        return
    endif
    for [type, dicts] in items(s:init_customizes)
        call _curstr_custom(type, dicts)
    endfor
    unlet s:init_customizes
endfunction

function! s:custom(type, dict) abort
    if has('vim_starting')
        call add(s:init_customizes[a:type], a:dict)
        return
    endif
    call _curstr_custom(a:type, [a:dict])
endfunction
