
let s:helper = CurstrTestHelper()
let s:suite = s:helper.suite('directory/buffer_relative')
let s:assert = s:helper.assert

function! s:suite.default()
    edit ./test/autoload/_test_data/entry.txt
    call cursor(2, 1)

    Curstr directory/buffer_relative

    call s:assert.file_name('opened')
endfunction
