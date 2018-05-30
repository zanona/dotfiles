setlocal tabstop=4
setlocal shiftwidth=4
set noexpandtab
set listchars=nbsp:☠,tab:\ \ 
set foldtext=MyJSFoldText()         " Customise folded blocks presentation
set fillchars="fold:@@@"           " Fill empty folding chars with spaces

function! MyJSFoldText()
    let linestart = substitute(getline(v:foldstart),"^@@\t","",1)
    let lineend = substitute(getline(v:foldend),"^@@\t*","",1)
    return '+ ' . linestart . '...' . lineend
endfunction
