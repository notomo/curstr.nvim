
let s:helper = CurstrTestHelper()
let s:suite = s:helper.suite('directory/buffer_relative')
let s:assert = s:helper.assert

function! s:suite.default()
    call s:helper.new_directory('opened')
    call s:helper.open_new_file('entry', ['opened'])

    Curstr directory/buffer_relative

    call s:assert.current_dir('opened')
endfunction
