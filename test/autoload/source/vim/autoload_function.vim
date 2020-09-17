
let s:helper = CurstrTestHelper()
let s:suite = s:helper.suite('vim/autoload_function')
let s:assert = s:helper.assert

function! s:suite.before_each()
    call s:helper.before_each()

    call s:helper.buffer("call curstr#execute('', 1, 2)")
    setlocal filetype=vim
    call s:helper.search('curstr')
endfunction

function! s:assert.cursor_position() abort
    call s:assert.line_number(4)
    call s:assert.column_number(11)
endfunction

function! s:suite.open()
    Curstr vim/autoload_function

    call s:assert.path('autoload/curstr.vim')
    call s:assert.cursor_position()
endfunction

function! s:suite.tab_open()
    Curstr vim/autoload_function -action=tab_open

    call s:assert.path('autoload/curstr.vim')
    call s:assert.cursor_position()
    call s:assert.tab_count(2)
endfunction

function! s:suite.vertical_open()
    let pos = getpos('.')

    Curstr vim/autoload_function -action=vertical_open

    call s:assert.path('autoload/curstr.vim')
    call s:assert.cursor_position()
    call s:assert.window_count(2)
    wincmd l
    call s:assert.position(pos)
endfunction

function! s:suite.horizontal_open()
    let pos = getpos('.')

    Curstr vim/autoload_function -action=horizontal_open

    call s:assert.path('autoload/curstr.vim')
    call s:assert.cursor_position()
    call s:assert.window_count(2)
    wincmd j
    call s:assert.position(pos)
endfunction

function! s:suite.not_found()
    call s:helper.search('call')
    let pos = getpos('.')

    Curstr vim/autoload_function

    call s:assert.position(pos)
    call s:assert.file_name('')
endfunction

function! s:suite.no_include_packpath()
    call curstr#custom#source_option('vim/autoload_function', 'include_packpath', v:false)

    call s:helper.new_directory('package/pack/package/opt/example/autoload')
    call s:helper.new_file('package/pack/package/opt/example/autoload/example.vim', ['', 'function! example#execute() abort', 'endfunction'])
    call s:helper.open_new_file('call.vim', ['call example#execute()'])
    call s:helper.search('example#execute')
    let pos = getpos('.')

    Curstr vim/autoload_function

    call s:assert.position(pos)
    call s:assert.file_name('call.vim')
endfunction

function! s:suite.include_packpath()
    call curstr#custom#source_option('vim/autoload_function', 'include_packpath', v:true)

    call s:helper.new_directory('package/pack/package/opt/example/autoload')
    call s:helper.new_file('package/pack/package/opt/example/autoload/example.vim', ['', 'function! example#execute() abort', 'endfunction'])
    call s:helper.add_packpath('package')
    call s:helper.open_new_file('call.vim', ['call example#execute()'])
    call s:helper.search('example#execute')

    Curstr vim/autoload_function

    call s:assert.file_name('example.vim')

    let pos = getpos('.')
    call s:helper.search('example#execute')
    call s:assert.position(pos)
endfunction
