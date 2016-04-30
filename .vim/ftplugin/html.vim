let s:level = 0
let s:tags = 'div|nav|header|section|aside|article|form|fieldset|footer|ul|ol|table|tbody|thead|tfoot|th|tr|td|blockquote|script|style'

function! HTMLFolds()
  let line = getline(v:lnum)

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

"setlocal foldmethod=expr
"setlocal foldexpr=HTMLFolds()

" Remove anchor tag underline
hi link htmlLink NONE
