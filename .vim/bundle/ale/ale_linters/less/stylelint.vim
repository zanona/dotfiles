" Author: diartyz <diartyz@gmail.com>

function! ale_linters#less#stylelint#GetExecutable(buffer) abort
    return ale#node#FindExecutable(a:buffer, 'css_stylelint', [
          \ 'node_modules/.bin/stylelint',
          \ ])
endfunction

function! ale_linters#less#stylelint#GetCommand(buffer) abort
    return ale_linters#less#stylelint#GetExecutable(a:buffer)
          \ . ' --stdin-filename %s'
endfunction

call ale#linter#Define('dless', {
      \   'name': 'stylelint',
      \   'executable_callback': 'ale_linters#less#stylelint#GetExecutable',
      \   'command_callback': 'ale_linters#less#stylelint#GetCommand',
      \   'callback': 'ale#handlers#css#HandleStyleLintFormat',
\})
