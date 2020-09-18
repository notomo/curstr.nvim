
let s:helper = CurstrTestHelper()
let s:suite = s:helper.suite('vim/runtime/pattern/directory')
let s:assert = s:helper.assert

function! s:suite.open()
    call s:helper.buffer(s:helper.test_data_path .. 'dir/*/child2')
    call s:helper.new_directory('dir')
    call s:helper.new_directory('dir/child')
    call s:helper.new_directory('dir/child/child2')

    Curstr vim/runtime/pattern/directory

    call s:assert.current_dir('dir/child/child2')
endfunction
