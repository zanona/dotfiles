let s:level = 0
let s:tags = 'nav|header|section|aside|article|footer|script|style'

function! HTMLFolds()
  let line = getline(v:lnum)
  let prev = getline(v:lnum - 1)

  " Ignore tags that open and close in the same line
  if line =~ '\v\<(\w+).*\<\/\1'
    return '='
  endif

  if line =~ '\v\<(' . s:tags . ')'
    let s:level += 1
    return '>' . s:level
  endif

  if line =~ '\v\</(' . s:tags . ')'
    let s:level -= 1
    return '<' . (s:level + 1)
  endif

  return '='

endfunction

setlocal foldmethod=expr
setlocal foldexpr=HTMLFolds()
