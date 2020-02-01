
let s:helper = CurstrTestHelper()
let s:suite = s:helper.suite('directory/path')
let s:assert = s:helper.assert

function! s:suite.default()
    call s:helper.new_directory('path')
    call s:helper.new_directory('opened')
    call s:helper.cd_to_test_data()

    call s:helper.buffer('./path/../opened')

    Curstr directory/path

    call s:assert.current_buffer('opened/')
endfunction
