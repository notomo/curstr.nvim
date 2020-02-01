
let s:helper = CurstrTestHelper()
let s:suite = s:helper.suite('vim/autoload_function')
let s:assert = s:helper.assert

function! s:suite.before_each()
    call s:helper.before_each()

    edit ./test/autoload/_test_data/autoload_function.vim
    let s:init_position = [0, 6, 7, 0]
    call setpos('.', s:init_position)
endfunction

function! s:suite.string_option()
    call setpos('.', [0, 1, 1, 0])
    Curstr vim/autoload_function -string=curstr#execute

    call s:assert.path('autoload/curstr.vim')
    let position = getpos('.')
    call s:assert.equals(position[1], 4)
    call s:assert.equals(position[2], 11)
endfunction

function! s:suite.no_cache_option()
    Curstr vim/autoload_function -no-cache

    call s:assert.path('autoload/curstr.vim')
    let position = getpos('.')
    call s:assert.equals(position[1], 4)
    call s:assert.equals(position[2], 11)
endfunction

function! s:suite.open()
    Curstr vim/autoload_function

    call s:assert.path('autoload/curstr.vim')
    let position = getpos('.')
    call s:assert.equals(position[1], 4)
    call s:assert.equals(position[2], 11)
endfunction

function! s:suite.tab_open()
    Curstr vim/autoload_function -action=tab_open

    call s:assert.path('autoload/curstr.vim')
    let position = getpos('.')
    call s:assert.equals(position[1], 4)
    call s:assert.equals(position[2], 11)
    call s:assert.tab_count(2)
endfunction

function! s:suite.vertical_open()
    Curstr vim/autoload_function -action=vertical_open

    call s:assert.path('autoload/curstr.vim')
    call s:assert.window_count(2)
    wincmd l
    call s:assert.equals(getpos('.'), s:init_position)
endfunction

function! s:suite.horizontal_open()
    Curstr vim/autoload_function -action=horizontal_open

    call s:assert.path('autoload/curstr.vim')
    call s:assert.window_count(2)
    wincmd j
    call s:assert.equals(getpos('.'), s:init_position)
endfunction

function! s:suite.not_found()
    let position = [0, 1, 1, 0]
    call setpos('.', position)

    Curstr vim/autoload_function

    call s:assert.equals(getpos('.'), position)
    call s:assert.file_name('autoload_function.vim')
endfunction

function! s:suite.no_include_packpath()
    call curstr#custom#source_option('vim/autoload_function', 'include_packpath', v:false)

    Curstr vim/autoload_function -string=example#execute

    call s:assert.not_path('test/autoload/_test_data/package/pack/package/opt/example/autoload/example.vim')
endfunction

function! s:suite.include_packpath()
    call curstr#custom#source_option('vim/autoload_function', 'include_packpath', v:true)

    let p = fnamemodify('test/autoload/_test_data/package', ':p')
    execute 'set packpath^=' . p

    call setpos('.', [0, 1, 1, 0])
    Curstr vim/autoload_function -string=example#execute

    call s:assert.path('test/autoload/_test_data/package/pack/package/opt/example/autoload/example.vim')
    let position = getpos('.')
    call s:assert.equals(position[1], 2)
    call s:assert.equals(position[2], 11)
endfunction
