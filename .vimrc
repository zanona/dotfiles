"Example Vim configuration.
"Pathogen configuration
execute pathogen#infect()

set nocompatible                  " Must come first because it changes other options.

" Vundle config
" filetype off
" set rtp+=~/.vim/bundle/Vundle.vim
" call vundle#begin()
" Plugin 'gmarik/Vundle.vim'
" call vundle#end()

filetype plugin indent on         " Turn on file type detection.
syntax enable                     " Turn on syntax highlighting.

" runtime macros/matchit.vim        " Load the matchit plugin.

set showcmd                       " Display incomplete commands.
set showmode                      " Display the mode you're in.

set backspace=indent,eol,start    " Intuitive backspacing.

set hidden                        " Handle multiple buffers better.

set wildmenu                      " Enhanced command line completion.
set wildmode=list:longest         " Complete files like a shell.

set ignorecase                    " Case-insensitive searching.
set smartcase                     " But case-sensitive if expression contains a capital letter.

set number                        " Show line numbers.
set ruler                         " Show cursor position.

set incsearch                     " Highlight matches as you type.
set hlsearch                      " Highlight matches.

set nowrap                        " Turn off line wrapping.
set scrolloff=3                   " Show 3 lines of context around the cursor.

set title                         " Set the terminal's title

set visualbell                    " No beeping.

" Setting shell for vim
set shell=sh

" Syntax Completion
filetype plugin on
set ofu=syntaxcomplete#Complete

" syntastic
let g:syntastic_go_checkers = []
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_html_checkers = ['w3']
let g:syntastic_less_checkers = ['lessc']

" Supertab
let g:SuperTabDefaultCompletionType = "context"

set nobackup                      " Don't make a backup before overwriting a file.
set nowritebackup                 " And again.
set directory=.,$TEMP  " Keep swap files in one location
set backupdir=.,$TEMP  " Keep swap files in one location

" Emmet-vim
let g:user_emmet_settings = {'html':{'quote_char': "",},}

" UNCOMMENT TO USE
set expandtab                     " Use spaces instead of tabs
set smartindent                   " Auto indent new lines
set tabstop=2                     " Use 4 spaces as default
set shiftwidth=2

set foldmethod=syntax             "Set default folding method to 'syntax'
" set foldclose=all                 "Auto-closes folds afer cursor moves out

" Don't screw up folds when inserting text that might affect them, until
" leaving insert mode. Foldmethod is local to the window. Protect against
" screwing up folding when switching between windows.
autocmd InsertEnter * if !exists('w:last_fdm') | let w:last_fdm=&foldmethod | setlocal foldmethod=manual | endif
autocmd InsertLeave,WinLeave * if exists('w:last_fdm') | let &l:foldmethod=w:last_fdm | unlet w:last_fdm | endif

set laststatus=2                  " Show the status line all the time

" Useful status information at bottom of screen
set statusline=[%n]\ %<%.99f\ %h%w%m%r%y\ %{exists('*CapsLockStatusline')?CapsLockStatusline():''}%=%-16(\ %l,%c-%v\ %)%P

" CtrlP
if executable('ag')
        " Use ag over grep
        set grepprg=ag\ --nogroup\ --nocolor

        " Use ag in CtrlP for listing files. Lightning fast and
        " respects .gitignore
        let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

        " ag is fast enough that CtrlP doesn't need to cache
        let g:ctrlp_use_caching = 0
endif

" Color Scheme
"let base16colorspace=256
"set t_Co=256
set background=dark
colorscheme base16-ocean

hi Search term=reverse cterm=reverse gui=reverse ctermfg=237

" Map cursor for insert mode
let &t_SI .= "\<Esc>[5 q"
" solid block
let &t_EI .= "\<Esc>[2 q"
" 1 or 0 -> blinking block
" 3 -> blinking underscore
" Recent versions of xterm (282 or above) also support
" 5 -> blinking vertical bar
" 6 -> solid vertical bar

" Splitting
map <Leader>- :split<CR>
map <Leader><bar> :vsplit<CR>

map <leader>n :NERDTreeToggle<cr>
map <leader>g :Git<Space>
map <leader>c :CtrlPClearAllCaches<cr>
map <leader>/ :Ack<Space>
map <leader>p :YRShow<cr>

" Removing search highlighting
nnoremap <ESC><ESC> :nohlsearch<CR>

" split naviagation
" nnoremap <C-J> <C-W><C-J>
" nnoremap <C-K> <C-W><C-K>
" nnoremap <C-L> <C-W><C-L>
" nnoremap <C-H> <C-W><C-H>

" Zencoding
" let g:user_zen_expandabbr_key='<C-e>'
" let g:user_zen_settings = { 'erb': { 'extends': 'html' } }

" disable arrow keys
noremap   <Up>     <NOP>
noremap   <Down>   <NOP>
noremap   <Left>   <NOP>
noremap   <Right>  <NOP>

" Relative line numbers
" function! NumberToggle()
"         if(&relativenumber == 1)
"                 set number
"         else
"                 set relativenumber
"         endif
" endfunc

" nnoremap <C-n> :call NumberToggle()<cr>
" Forces *.md files to be rendered as Markdown
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
autocmd BufNewFile,BufReadPost volofile set filetype=javascript

" Customise folded blocks presentation
function! MyFoldText()
    let nl = v:foldend - v:foldstart + 1
    let comment = substitute(getline(v:foldstart),"^ *","",1)
    let linestart = substitute(getline(v:foldstart),"^  ","",1)
    let lineend = substitute(getline(v:foldend),"^ *","",1)
    let linetext = substitute(getline(v:foldstart+1),"^ *","",1)
    let indent = repeat('@', len(v:folddashes) - 1)
    let txt = '+ ' . linestart . '...' . lineend
    return txt
endfunction
set foldtext=MyFoldText()
set fillchars=fold:\ 
