
let s:helper = CurstrTestHelper()
let s:suite = s:helper.suite('file/path')
let s:assert = s:helper.assert

function! s:suite.before_each()
    call s:helper.before_each()

    call s:helper.new_file('opened.txt', ['12345', '12345', '12345', '12345'])
    call s:helper.new_directory('with_env')
    call s:helper.new_file('with_env/file')
    call s:helper.open_new_file('entry.txt', ['opened.txt', 'opened.txt:3', 'opened.txt:3,4', '$DIR_NAME/file', ''])

    call s:helper.cd_to_test_data()
endfunction

function! s:suite.default()
    Curstr file/path

    call s:assert.file_name('opened.txt')
endfunction

function! s:suite.open()
    Curstr file/path -action=open

    call s:assert.file_name('opened.txt')
endfunction

function! s:suite.tab_open()
    Curstr file/path -action=tab_open

    call s:assert.file_name('opened.txt')
    call s:assert.tab_count(2)
endfunction

function! s:suite.vertical_open()
    Curstr file/path -action=vertical_open

    call s:assert.file_name('opened.txt')
    call s:assert.window_count(2)
    wincmd l
    call s:assert.file_name('entry.txt')
endfunction

function! s:suite.horizontal_open()
    Curstr file/path -action=horizontal_open

    call s:assert.file_name('opened.txt')
    call s:assert.window_count(2)
    wincmd j
    call s:assert.file_name('entry.txt')
endfunction

function! s:suite.not_found()
    normal! G
    let pos = getpos('.')

    Curstr file/path

    call s:assert.file_name('entry.txt')
    call s:assert.position(pos)
endfunction

function! s:suite.open_with_row()
    call s:helper.search('opened.txt:3')

    Curstr file/path

    call s:assert.file_name('opened.txt')
    call s:assert.line_number(3)
endfunction

function! s:suite.open_with_position()
    call s:helper.search('opened.txt:3,4')

    Curstr file/path

    call s:assert.file_name('opened.txt')
    call s:assert.line_number(3)
    call s:assert.column_number(4)
endfunction

function! s:suite.open_with_env_expand()
    let $DIR_NAME = getcwd() . '/with_env'
    call s:helper.search('file')

    Curstr file/path

    call s:assert.file_name('file')
endfunction
