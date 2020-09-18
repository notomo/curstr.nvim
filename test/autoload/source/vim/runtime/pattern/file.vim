
let s:helper = CurstrTestHelper()
let s:suite = s:helper.suite('vim/runtime/pattern/file')
let s:assert = s:helper.assert

function! s:suite.open()
    call s:helper.buffer(s:helper.test_data_path .. 'dir/*/file')
    call s:helper.new_directory('dir')
    call s:helper.new_directory('dir/child')
    call s:helper.new_file('dir/child/file')

    Curstr vim/runtime/pattern/file

    call s:assert.path(s:helper.test_data_path .. 'dir/child/file')
endfunction
