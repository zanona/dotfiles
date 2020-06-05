" RESET previous sourced commands
autocmd!

" PLUGIN MANAGEMENT SETTINGS
" ==============================================================================

" AUTOINSTALL PLUG IN CASE NOT AVAILABLE
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'junegunn/goyo.vim'
Plug 'dense-analysis/ale'
Plug 'editorconfig/editorconfig-vim'
Plug 'mattn/emmet-vim'
Plug 'Konfekt/FastFold'
Plug 'othree/html5.vim'
Plug 'godlygeek/tabular'
Plug 'leafgarland/typescript-vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'pangloss/vim-javascript'
Plug 'elzr/vim-json'
Plug 'groenewege/vim-less'
Plug 'cespare/vim-toml'
Plug 'ianks/vim-tsx'
Plug 'swekaj/php-foldexpr.vim'
Plug 'sainnhe/edge'

call plug#end()

" GENERAL SETTINGS
" ==============================================================================
                                  " Initialize Pathogen
filetype    plugin indent on      " Turn on file type detection.
syntax      on                    " Turn on syntax highlighting.

"set noshowcmd                     " Display incomplete commands.
set noshowmode                    " Hide current mode text
set backspace=indent,eol,start    " Intuitive backspacing.
set hidden                        " Handle multiple buffers better.
set wildmenu                      " Enhanced command line completion.
set wildmode=list:longest         " Complete files like a shell.
set ignorecase                    " Case-insensitive searching.
set smartcase                     " But case-sensitive if capital letter.
set nonumber                      " Hide line numbers.
set noruler                       " Hide cursor position.
set incsearch                     " Highlight matches as you type.
set hlsearch                      " Highlight matches.
set scrolloff=999                 " Show 999 lines of context around the cursor.
set title                         " Set the terminal's title
set visualbell                    " No beeping.
set nobackup                      " Don't backup before overwriting file.
set nowritebackup                 " And again.
set expandtab                     " Use spaces instead of tabs
set smartindent                   " Auto indent new lines
set tabstop=2                     " Use 2 spaces as default
set shiftwidth=2                  " Enforce above
set foldmethod=syntax             " Set default folding method to 'syntax'
set foldtext=MyFoldText()         " Customise folded blocks presentation
set fillchars="fold:\ "           " Fill empty folding chars with spaces
set laststatus=0                  " Hide the status line
set iskeyword-=_                  " Treat _ as word boundary
set listchars=nbsp:☠,tab:▸␣       " Mark nbsp chars
set list                          " Show invisible marked chars
set nowrap                        " Prevet line-wrapping by default
set colorcolumn=80                " Show column for 80 chars
set clipboard=unnamed             " Reset clipboard to work with tmux on OSX Sierra (goo.gl/KjXTkP)
"set shell=sh                      " Setting shell for vim
set shell=bash\ -l                " Keep same Shell profile when running sh or ! (goo.gl/itWE3c)
set modeline                      " Use vim modeline comment at end of files, if existent

let loaded_netrwPlugin = 1        " Disable Netrw (vim file-manager)

" Plugin-specific settings

" Goyo
let g:goyo_width = 104

" JSON
let g:vim_json_syntax_conceal = 0 " Disable Vim's quote hiding on JSON files

" Ale <https://github.com/w0rp/ale>
let g:ale_linters = {'javascript': ['xo'], 'typescript': ['eslint','tsserver']}
let g:ale_less_lessc_options = '--html'

"Extend Emmet functionality
let g:user_emmet_settings = {
\  'html': {
\    'quote_char': '',
\    'indent_blockelement': 0,
\    'default_attributes': {
\      'label': {},
\      'select': {},
\    },
\    'expandos': {
\      'ph': 'img[src=//placehold.it/${1}]',
\      'desc': 'meta[name=description content=${1}]',
\      'x-if':  'template[is=x-if][has=${1}]',
\      'x-for': 'template[is=x-for][items=${1}]',
\      'import': 'module-import[href=${1}][as=${2}]',
\      'mod': "(template>style[type=text/less])+script{${newline}  module.exports = class extends WebComponent {${newline}  };${newline}}",
\      'label': 'label>span|input',
\      'select': 'select>option*2',
\    }
\  },
\  'javascript': {
\    'snippets': {
\      'log': 'console.log(|)',
\    },
\  },
\}

" MAPPINGS
" ==============================================================================

" Removing search highlighting
nnoremap <ESC><ESC> :nohlsearch<CR>

" Disable arrow keys
noremap   <Up>     <NOP>
noremap   <Down>   <NOP>
noremap   <Left>   <NOP>
noremap   <Right>  <NOP>


" Map quick show prev and next errors to ctrl+K and ctrl+J
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
nmap <silent> <C-l> <Plug>(ale_detail)

" Follow symlink (resolve) when opening in buffer
" https://vim.fandom.com/wiki/Replace_a_builtin_command_using_cabbrev
" https://stackoverflow.com/questions/30791692/make-vim-follow-symlinks-when-opening-files-from-command-line
" cabbrev    <expr>    e    ((getcmdtype() == ':' && getcmdpos() <= 2)? 'expand("<args>")' : 'e')

" AUTO COMMANDS
" ==============================================================================
"
autocmd! VimEnter * call <SID>ApplyTheme()
autocmd! User GoyoEnter nested call <SID>GoyoEnter()
autocmd! User GoyoLeave nested call <SID>GoyoLeave()
autocmd! InsertLeave,WinLeave * call <SID>OnInsertModeLeave()
autocmd! BufEnter * let &titlestring = @%
autocmd! BufWinEnter nested call disable_syntax_large_files()
" autocmd BufNewFile,BufReadPost *.map set filetype=json
" autocmd BufNewFile,BufReadPost *.md set filetype=markdown

" UTILITY METHODS
" ==============================================================================

function! s:disable_syntax_large_files()
  if line2byte(line("$") + 1) > 100000
    syntax clear
    let b:syntastic_mode="passive"
  endif
endfunction

function MyFoldText()
    let linestart = substitute(getline(v:foldstart),"^  ","",1)
    let lineend = substitute(getline(v:foldend),"^ *","",1)
    return '+ ' . linestart . '...' . lineend
endfunction

function! s:OnInsertModeLeave()
  set nopaste "disable paste when leaving insert mode
endfunction

function! s:SetColorScheme()
  ":h xterm-true-color, resetting to xterm defaults
  "in order to accept termguicolors
  if &term =~# '^st'
      let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
      let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  endif
  set termguicolors
  set background=dark
  let g:edge_style = 'neon'
  let g:edge_disable_italic_comment = 1
  let g:edge_transparent_background = 1
  colorscheme edge
endfunction

function! s:SetDefaultColorScheme()
  set background=dark
  highlight ColorColumn ctermbg=Black
  highlight Visual ctermbg=DarkBlue ctermfg=Black
  highlight Folded ctermbg=None ctermfg=DarkGray
  highlight SignColumn ctermbg=None
  "Ale Warnings
  highlight SpellCap ctermbg=Black
  "Tilde left line
  highlight EndOfBuffer ctermfg=Black
endfunction

function! s:ApplyTheme()
  if ($TERM == 'linux')
    call s:SetDefaultColorScheme()
  else
    call s:SetColorScheme()
  endif
endfunction

function! s:GoyoEnter()
  set colorcolumn=80
  highlight ColorColumn ctermbg=1 guifg=NONE guibg=#2b2d3a
  "persist on buffer enter
  "https://github.com/junegunn/goyo.vim/issues/31#issuecomment-45432284
  augroup show_cc
    autocmd!
    autocmd BufWinEnter * setlocal colorcolumn=80
  augroup END
  "remove bottom caret line https://github.com/junegunn/goyo.vim/issues/134
  highlight StatusLineNC ctermfg=White
endfunction

function! s:GoyoLeave()
  call s:ApplyTheme()
endfunction
