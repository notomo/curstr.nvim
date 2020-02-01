
let s:helper = CurstrTestHelper()
let s:suite = s:helper.suite('togglable/file')
let s:assert = s:helper.assert

function! s:suite.before_each()
    edit ./test/autoload/_test_data/togglable_file.vim
endfunction

function! s:suite.open()
    call curstr#custom#source_option('togglable/file', 'pattern_groups', [['test_%.vim', '%.vim']])

    Curstr togglable/file
    call s:assert.file_name('test_togglable_file.vim')

    Curstr togglable/file
    call s:assert.file_name('togglable_file.vim')
endfunction

function! s:suite.open_include_not_matched_pattern()
    call curstr#custom#source_option('togglable/file', 'pattern_groups', [['not_matched_pattern%', 'test_%.vim', 'not_matched_pattern%', '%.vim']])

    Curstr togglable/file
    call s:assert.file_name('test_togglable_file.vim')

    Curstr togglable/file
    call s:assert.file_name('togglable_file.vim')
endfunction

function! s:suite.create()
    call curstr#custom#source_option('togglable/file', 'pattern_groups', [['new_%.vim', '%.vim']])
    call curstr#custom#source_option('togglable/file', 'create', v:true)

    Curstr togglable/file
    call s:assert.file_name('new_togglable_file.vim')

    Curstr togglable/file
    call s:assert.file_name('togglable_file.vim')

    call delete('./test/autoload/_test_data/new_togglable_file.vim')
endfunction
