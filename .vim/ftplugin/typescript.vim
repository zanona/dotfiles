setlocal tabstop=4
setlocal shiftwidth=4
setlocal noexpandtab
set listchars=nbsp:☠,tab:\ \ 
setlocal foldtext=MyJSFoldText()         " Customise folded blocks presentation
setlocal fillchars="fold:@@@"           " Fill empty folding chars with spaces

function! MyJSFoldText()
    let linestart = substitute(getline(v:foldstart),"^@@\t","",1)
    let lineend = substitute(getline(v:foldend),"^@@\t*","",1)
    return '+ ' . linestart . '...' . lineend
endfunction
