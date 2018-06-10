let s:execute_options = {}
function! curstr#custom#get_execute_options() abort
    return s:execute_options
endfunction

function! curstr#custom#execute_option(name, value) abort
    let s:execute_options[a:name] = a:value
endfunction


let s:source_options = {}
function! curstr#custom#get_source_options() abort
    return s:source_options
endfunction

function! curstr#custom#source_option(source_name, option_name, value) abort
    if !has_key(s:source_options, a:source_name)
        let s:source_options[a:source_name] = {}
    endif
    let s:source_options[a:source_name][a:option_name] = a:value
endfunction


let s:filetype_sources = {}
function! curstr#custom#get_filetype_sources() abort
    return s:filetype_sources
endfunction

function! curstr#custom#filetype_source(filetype, source_names) abort
    let s:filetype_sources[a:filetype] = a:source_names
endfunction


let s:filetype_aliases = {}
function! curstr#custom#get_filetype_aliases() abort
    return s:filetype_aliases
endfunction

function! curstr#custom#filetype_alias(alias, filetype) abort
    let s:filetype_aliases[a:alias] = a:filetype
endfunction


let s:source_aliases = {}
function! curstr#custom#get_source_aliases() abort
    return s:source_aliases
endfunction

function! curstr#custom#source_alias(alias, source_names) abort
    let s:source_aliases[a:alias] = a:source_names
endfunction
