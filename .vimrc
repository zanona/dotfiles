" RESET previous sourced commands
autocmd!

" GENERAL SETTINGS
" ==============================================================================
                                  " Initialize Pathogen
execute     pathogen#infect()
filetype    plugin indent on      " Turn on file type detection.
syntax      on                    " Turn on syntax highlighting.
colorscheme base16-ocean          " Set colour scheme

set background=dark               " Ajudst background color to dark
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
set scrolloff=3                   " Show 3 lines of context around the cursor.
set title                         " Set the terminal's title
set visualbell                    " No beeping.
set shell=sh                      " Setting shell for vim
set nobackup                      " Don't backup before overwriting file.
set nowritebackup                 " And again.
set expandtab                     " Use spaces instead of tabs
set smartindent                   " Auto indent new lines
set tabstop=2                     " Use 2 spaces as default
set shiftwidth=2                  " Enforce above
set foldmethod=syntax             " Set default folding method to 'syntax'
set foldtext=MyFoldText()         " Customise folded blocks presentation
set fillchars="fold:\ "           " Fill empty folding chars with spaces
set laststatus=2                  " Show the status line all the time
set statusline=%!MyStatusLine()   " Format status line text

" Plugin-specific settings
let g:syntastic_javascript_checkers = ['jslint']
let g:syntastic_javascript_jslint_args = ''
let g:syntastic_html_checkers       = ['tidy']
" Install tidy `brew install tidy-html5`
let g:syntastic_less_checkers       = ['lessc']
let g:user_emmet_settings           = {'html':{'quote_char': '',},}

" MAPPINGS
" ==============================================================================

" Removing search highlighting
nnoremap <ESC><ESC> :nohlsearch<CR>

" Disable arrow keys
noremap   <Up>     <NOP>
noremap   <Down>   <NOP>
noremap   <Left>   <NOP>
noremap   <Right>  <NOP>


" AUTO COMMANDS
" ==============================================================================

autocmd       InsertEnter             *        call <SID>OnInsertModeEnter()
autocmd       InsertLeave,WinLeave    *        call <SID>OnInsertModeLeave()
autocmd  User GoyoEnter                        call <SID>OnGoyoEnter()
autocmd  User GoyoLeave                        call <SID>OnGoyoLeave()
autocmd       BufNewFile,BufReadPost  *.md     set  filetype=markdown
" autocmd       VimEnter                * Goyo
autocmd       VimEnter                * call <SID>GoMinimal()
autocmd       VimLeave                * silent !tmux set status on


" UTILITY METHODS
" ==============================================================================

function! MyStatusLine()
  return "[%n]\ %<%.99f\ %h%w%m%r%y\ %{exists('*CapsLockStatusline')?CapsLockStatusline():''}%=%-16(\ %l,%c-%v\ %)%P"
endfunction

function! MyFoldText()
    let linestart = substitute(getline(v:foldstart),"^  ","",1)
    let lineend = substitute(getline(v:foldend),"^ *","",1)
    return '+ ' . linestart . '...' . lineend
endfunction

function! s:OnInsertModeEnter()
  if !exists('w:last_fdm')
    let w:last_fdm = &foldmethod
    setlocal foldmethod=manual
  endif
endfunction

function! s:OnInsertModeLeave()
  if exists('w:last_fdm')
    let &l:foldmethod = w:last_fdm
    unlet w:last_fdm
  endif
endfunction

function! s:OnGoyoEnter()
  set noshowmode
  set noshowcmd
  set scrolloff=999               " Always leave cursor in the middle
  if exists('$TMUX')
    silent !tmux set status off
  endif
endfunction

function! s:OnGoyoLeave()
  " set showmode
  " set showcmd
  " set scrolloff=3
endfunction

function! s:GoMinimal()
  set noshowmode
  set noshowcmd
  set noruler
  set nonu
  set scrolloff=999
  set laststatus=0
  if exists('$TMUX')
    silent !tmux set status off
  endif
endfunction
