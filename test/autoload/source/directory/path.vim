
let s:helper = CurstrTestHelper()
let s:suite = s:helper.suite('directory/path')
let s:assert = s:helper.assert

function! s:suite.default()
    edit ./test/autoload/_test_data/entry.txt
    cd ./test/autoload/_test_data
    call cursor(3, 1)
    let cwd = getcwd()

    Curstr directory/path

    call s:assert.current_buffer(cwd . '/opened/')
endfunction
