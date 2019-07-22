
let s:suite = themis#suite('custom')
let s:assert = themis#helper('assert')

function! s:suite.before()
    let s:root = CurstrTestBefore()
endfunction

function! s:suite.before_each()
    call curstr#custom#clean()
endfunction

function! s:suite.after_each()
    call CurstrTestAfterEach()
endfunction

function! s:suite.execute_option()
    let option_name = 'string'
    let option_value = 'test'
    call curstr#custom#execute_option(option_name, option_value)

    let execute_options = curstr#custom#get_execute_options()
    call s:assert.equals(execute_options[option_name], option_value)
endfunction

function! s:suite.source_execute_option()
    let option_name = 'string'
    let option_value = 'test'
    let source_name = 'source_name'
    call curstr#custom#execute_option(option_name, option_value, source_name)

    let execute_options = curstr#custom#get_execute_options(source_name)
    call s:assert.equals(execute_options[option_name], option_value)
endfunction

function! s:suite.empty_execute_option()
    let execute_options = curstr#custom#get_execute_options('source_name')
    call s:assert.empty(execute_options)
endfunction

function! s:suite.source_option()
    let source_name = 'source_name'
    let option_name = 'string'
    let option_value = 'test'
    call curstr#custom#source_option(source_name, option_name, option_value)

    let source_options = curstr#custom#get_source_options(source_name)
    call s:assert.equals(source_options[option_name], option_value)
endfunction

function! s:suite.empty_source_option()
    let source_options = curstr#custom#get_source_options('source_name')
    call s:assert.empty(source_options)
endfunction

function! s:suite.list_source_option()
    call curstr#custom#source_option('source_name', 'option_name', ['option1', 'option2', ['option3']])
    call curstr#custom#get_source_options('option_name')
endfunction

function! s:suite.action_option()
    let group_name = 'group_name'
    let option_name = 'string'
    let option_value = 'test'
    call curstr#custom#action_option(group_name, option_name, option_value)

    let action_options = curstr#custom#get_action_options()
    call s:assert.equals(action_options[group_name][option_name], option_value)
endfunction

function! s:suite.filetype_alias()
    let alias_name = 'alias_name'
    let expected_filetype = 'filetype'
    call curstr#custom#filetype_alias(alias_name, expected_filetype)

    let filetype = curstr#custom#get_filetype_aliase(alias_name)
    call s:assert.equals(filetype, expected_filetype)
endfunction

function! s:suite.empty_filetype_alias()
    let filetype = curstr#custom#get_filetype_aliase('alias_name')
    call s:assert.empty(filetype)
endfunction

function! s:suite.source_alias()
    let alias_name = 'alias_name'
    let expected_source_names = ['source_name1', 'source_name2']
    call curstr#custom#source_alias(alias_name, expected_source_names)

    let source_names = curstr#custom#get_source_aliases(alias_name)
    call s:assert.equals(source_names, expected_source_names)
endfunction

function! s:suite.empty_source_alias()
    let source_names = curstr#custom#get_source_aliases('alias_name')
    call s:assert.empty(source_names)
endfunction

