
function! curstr#custom#clean() abort
    let s:execute_options = {'_':{}}
    let s:source_options = {}
    let s:filetype_aliases = {}
    let s:source_aliases = {
        \ 'vim/runtime': ['vim/runtime/pattern/file', 'vim/runtime/pattern/directory', 'vim/runtime/file', 'vim/runtime/directory'],
        \ 'file': ['file/buffer_relative', 'file/path'],
        \ 'directory': ['directory/buffer_relative', 'directory/path'],
        \ 'vim/function': ['vim/autoload_function', 'vim/script_function'],
    \ }
endfunction
call curstr#custom#clean()

function! curstr#custom#get_execute_options(...) abort
    if a:0 == 1
        let source_name = a:1
    else
        let source_name = '_'
    endif
    if !has_key(s:execute_options, source_name)
        return {}
    endif
    return s:execute_options[source_name]
endfunction

function! curstr#custom#execute_option(name, value, ...) abort
    call s:validate_value(a:value)

    if a:0 == 1
        let source_name = a:1
    else
        let source_name = '_'
    endif
    if !has_key(s:execute_options, source_name)
        let s:execute_options[source_name] = {}
    endif
    let s:execute_options[source_name][a:name] = a:value
endfunction


function! curstr#custom#get_source_options(source_name) abort
    if !has_key(s:source_options, a:source_name)
        return {}
    endif
    return s:source_options[a:source_name]
endfunction

function! curstr#custom#source_option(source_name, option_name, value) abort
    call s:validate_value(a:value)

    if !has_key(s:source_options, a:source_name)
        let s:source_options[a:source_name] = {}
    endif
    let s:source_options[a:source_name][a:option_name] = a:value
endfunction


function! curstr#custom#get_filetype_aliase(filetype_alias_name) abort
    if !has_key(s:filetype_aliases, a:filetype_alias_name)
        return ''
    endif
    return s:filetype_aliases[a:filetype_alias_name]
endfunction

function! curstr#custom#filetype_alias(filetype_alias_name, filetype) abort
    if !s:is_type(a:filetype, v:t_string)
        echoerr 'filetype must be string'
    endif
    let s:filetype_aliases[a:filetype_alias_name] = a:filetype
endfunction


function! curstr#custom#get_source_aliases(alias_name) abort
    if !has_key(s:source_aliases, a:alias_name)
        return []
    endif
    return s:source_aliases[a:alias_name]
endfunction

function! curstr#custom#source_alias(alias_name, source_names) abort
    call s:validate_source_names(a:source_names)
    let s:source_aliases[a:alias_name] = a:source_names
endfunction


function! s:validate_source_names(source_names) abort
    if !s:is_type_list(a:source_names, v:t_string)
        echoerr 'source_names must be string list'
    endif
    return v:true
endfunction

function! s:validate_value(value) abort
    if s:is_type(a:value, v:t_list)
        let values = map(copy(a:value), { _, v -> s:validate_value(v) })
        return len(filter(values, {_, v -> v == v:false})) == 0
    endif
    if !s:is_type(a:value, v:t_string, v:t_bool, v:t_number)
        echoerr 'value must be string or bool or number'
    endif
    return v:true
endfunction


function! s:is_type(value, ...) abort
    let value_type = type(a:value)
    for type in a:000
        if type == value_type
            return v:true
        endif
    endfor
    return v:false
endfunction

function! s:is_type_list(values, type) abort
    if !s:is_type(a:values, v:t_list)
        return v:false
    endif
    let valid_values = filter(map(copy(a:values), {_, v -> a:type == type(v)}), {_, v -> v == 1})
    return len(valid_values) == len(a:values)
endfunction


