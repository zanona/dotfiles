setlocal tabstop=2
setlocal shiftwidth=2
setlocal noexpandtab
set listchars=nbsp:☠,tab:\ \ 
let b:phpfold_text = 0

setlocal foldtext=FoldText()            " Customise folded blocks presentation
setlocal fillchars="fold:@@@"           " Fill empty folding chars with spaces

function! FoldText()
    let linestart = substitute(getline(v:foldstart),"^@@\t","",1)
    let lineend = substitute(getline(v:foldend),"^@@\t*","",1)
    return '+ ' . linestart . '...' . lineend
endfunction

" vim:ft=vim:foldmethod=marker:nowrap:tabstop=4:shiftwidth=4
