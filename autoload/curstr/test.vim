
let s:is_testing = v:false
function! curstr#test#start_testing() abort
    let s:is_testing = v:true
endfunction

function! curstr#test#is_testing() abort
    return s:is_testing
endfunction
