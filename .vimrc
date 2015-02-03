function! MyFoldText()
    let linestart = substitute(getline(v:foldstart),"^  ","",1)
    let lineend = substitute(getline(v:foldend),"^ *","",1)
    return '+ ' . linestart . '...' . lineend
endfunction

function! MyStatusLine()
  return "[%n]\ %<%.99f\ %h%w%m%r%y\ %{exists('*CapsLockStatusline')?CapsLockStatusline():''}%=%-16(\ %l,%c-%v\ %)%P"
endfunction

                                  " Pathogen configuration
execute pathogen#infect()
set nocompatible                  " Must come first

filetype plugin indent on         " Turn on file type detection.
syntax enable                     " Turn on syntax highlighting.

colorscheme base16-ocean          " Set colour scheme

set background=dark
set showcmd                       " Display incomplete commands.
set showmode                      " Display the mode you're in.
set backspace=indent,eol,start    " Intuitive backspacing.
set hidden                        " Handle multiple buffers better.
set wildmenu                      " Enhanced command line completion.
set wildmode=list:longest         " Complete files like a shell.
set ignorecase                    " Case-insensitive searching.
set smartcase                     " But case-sensitive if capital letter.
set number                        " Show line numbers.
set ruler                         " Show cursor position.
set incsearch                     " Highlight matches as you type.
set hlsearch                      " Highlight matches.
" set nowrap                      " Turn off line wrapping.
set scrolloff=3                   " Show 3 lines of context around the cursor.
set title                         " Set the terminal's title
set visualbell                    " No beeping.
set shell=sh                      " Setting shell for vim
set nobackup                      " Don't backup before overwriting file.
set nowritebackup                 " And again.
set directory=.,$TEMP             " Keep swap files in one location
set backupdir=.,$TEMP             " Keep swap files in one location
set expandtab                     " Use spaces instead of tabs
set smartindent                   " Auto indent new lines
set tabstop=2                     " Use 2 spaces as default
set shiftwidth=2                  " Enforce above
set foldmethod=syntax             " Set default folding method to 'syntax'
" set foldclose=all               " Auto-closes folds afer cursor moves out
set laststatus=2                  " Show the status line all the time
set statusline=MyStatusLine()     " Format status line text"
set foldtext=MyFoldText()         " Customise folded blocks presentation
set fillchars=fold:\ 
" let &t_SI .= "\<Esc>[5 q"       " Map cursor for insert mode
" let &t_EI .= "\<Esc>[2 q"       " Solid block

filetype plugin on                " Syntax Completion
set ofu=syntaxcomplete#Complete

hi Search term=reverse cterm=reverse gui=reverse ctermfg=237

" Don't screw up folds when inserting text that might affect them, until
" leaving insert mode. Foldmethod is local to the window. Protect against
" screwing up folding when switching between windows.
autocmd InsertEnter * if !exists('w:last_fdm') | let w:last_fdm=&foldmethod | setlocal foldmethod=manual | endif
autocmd InsertLeave,WinLeave * if exists('w:last_fdm') | let &l:foldmethod=w:last_fdm | unlet w:last_fdm | endif

" #### MAPPINGS ####

" Splitting
" map <Leader>- :split<CR>
" map <Leader><bar> :vsplit<CR>
" map <leader>g :Git<Space>

" split navigation
" nnoremap <C-J> <C-W><C-J>
" nnoremap <C-K> <C-W><C-K>
" nnoremap <C-L> <C-W><C-L>
" nnoremap <C-H> <C-W><C-H>

" Removing search highlighting
nnoremap <ESC><ESC> :nohlsearch<CR>

" disable arrow keys
noremap   <Up>     <NOP>
noremap   <Down>   <NOP>
noremap   <Left>   <NOP>
noremap   <Right>  <NOP>



" #### FILE DEFAULTS ####

autocmd BufNewFile,BufReadPost *.md set filetype=markdown
autocmd BufNewFile,BufReadPost volofile set filetype=javascript

" #### PLUGIN CONFIGURATION ####

" Syntastic
let g:syntastic_go_checkers = []
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_html_checkers = ['w3']
let g:syntastic_less_checkers = ['lessc']

" Emmet-vim
let g:user_emmet_settings = {'html':{'quote_char': "",},}

" Goyo Config
function! s:goyo_enter()
  set noshowmode
  set noshowcmd
  " Always leave cursor in the middle
  set scrolloff=999

  let b:quitting = 0
  let b:quitting_bang = 0

  silent !tmux set status off
endfunction

function! s:goyo_leave()
  " Restore options
  silent !tmux set status on
  set showmode
  set showcmd
  set scrolloff=3
endfunction

let g:goyo_margin_top = 0
let g:goyo_margin_bottom = 0
autocmd! User GoyoEnter
autocmd! User GoyoLeave
autocmd User GoyoEnter call <SID>goyo_enter()
autocmd User GoyoLeave call <SID>goyo_leave()
autocmd VimEnter * Goyo
autocmd VimLeave * silent !tmux set status on
