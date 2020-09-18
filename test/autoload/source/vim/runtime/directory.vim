
let s:helper = CurstrTestHelper()
let s:suite = s:helper.suite('vim/runtime/directory')
let s:assert = s:helper.assert

function! s:suite.open()
    call s:helper.buffer(s:helper.test_data_path .. 'dir/child')
    call s:helper.new_directory('dir')
    call s:helper.new_directory('dir/child')

    Curstr vim/runtime/directory

    call s:assert.current_dir('dir/child')
endfunction
