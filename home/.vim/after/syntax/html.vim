" Remove anchor tag underline
hi link htmlLink NONE

" Remove error highlight on literal ampersand
syn match htmlIgnore "&"

" Fold HTML Tags — Thanks Ingo!! (http://vi.stackexchange.com/a/2333/3334)
syntax region htmlFold start="<\z(\<\(area\|base\|br\|col\|command\|embed\|hr\|img\|input\|keygen\|link\|meta\|para\|source\|track\|wbr\>\)\@![a-z-]\+\>\)\%(\_s*\_[^/]\?>\|\_s\_[^>]*\_[^>/]>\)" end="</\z1\_s*>" fold transparent keepend extend containedin=htmlHead,htmlH\d
