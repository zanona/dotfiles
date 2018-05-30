" Author: zanona - https://github.com/zanona

function! ale_linters#less#lessHint#Handle(buffer, lines) abort
    " Matches patterns like the following:
    let l:pattern = '^\(\w\+\):.\{-}: line \(\d\+\), col \(\d\+\), \(.\{-}\)$'
    let l:output = []

    for l:match in ale#util#GetMatches(a:lines, l:pattern)
        call add(l:output, {
        \   'lnum': l:match[2] + 0,
        \   'col': l:match[3] + 0,
        \   'text': l:match[4],
        \   'type': l:match[1] is# 'Error' ? 'E' : 'W',
        \})
    endfor

    return l:output
endfunction

call ale#linter#Define('dless', {
\   'name': 'lesshint',
\   'executable': 'lesshint',
\   'command': 'lesshint %t',
\   'callback': 'ale_linters#less#lessHint#Handle',
\})
