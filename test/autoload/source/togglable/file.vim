
let s:helper = CurstrTestHelper()
let s:suite = s:helper.suite('togglable/file')
let s:assert = s:helper.assert

function! s:suite.open()
    call curstr#custom#source_option('togglable/file', 'pattern_groups', [['test_%.vim', '%.vim']])

    call s:helper.new_file('test_togglable_file.vim')
    call s:helper.open_new_file('togglable_file.vim')
    call s:helper.cd_to_test_data()

    Curstr togglable/file
    call s:assert.file_name('test_togglable_file.vim')

    Curstr togglable/file
    call s:assert.file_name('togglable_file.vim')
endfunction

function! s:suite.open_include_not_matched_pattern()
    call curstr#custom#source_option('togglable/file', 'pattern_groups', [['not_matched_pattern%', 'test_%.vim', 'not_matched_pattern%', '%.vim']])

    call s:helper.new_file('test_togglable_file.vim')
    call s:helper.open_new_file('togglable_file.vim')
    call s:helper.cd_to_test_data()

    Curstr togglable/file
    call s:assert.file_name('test_togglable_file.vim')

    Curstr togglable/file
    call s:assert.file_name('togglable_file.vim')
endfunction

function! s:suite.create()
    call curstr#custom#source_option('togglable/file', 'pattern_groups', [['new_%.vim', '%.vim']])
    call curstr#custom#source_option('togglable/file', 'create', v:true)

    call s:helper.open_new_file('togglable_file.vim')
    call s:helper.cd_to_test_data()

    Curstr togglable/file
    call s:assert.file_name('new_togglable_file.vim')

    Curstr togglable/file
    call s:assert.file_name('togglable_file.vim')
endfunction
