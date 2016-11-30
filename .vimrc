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
set iskeyword-=_                  " Treat _ as word boundary
set listchars=nbsp:☠,tab:▸␣       " Mark nbsp chars
set list                          " Show invisible marked chars
set nowrap                        " Prevet line-wrapping by default
set colorcolumn=80                " Show column for 80 chars
set clipboard=unnamed             " Reset clipboard to work with tmux on OSX Sierra (goo.gl/KjXTkP)

" Plugin-specific settings
let g:vim_json_syntax_conceal = 0 " Disable Vim's quote hiding on JSON files

" Install tidy `brew install tidy-html5`
" let g:syntastic_always_populate_loc_list = 1

"Allow syntanstic to run eslint-plugin-html on html files
"npm i eslint-plugin-html -g
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0
let g:syntastic_aggregate_errors = 1 "Show all linter errors

let g:syntastic_vim_checkers        = ['vimlint']
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_html_checkers       = ['tidy']
let g:syntastic_less_checkers       = ['lessc']
let g:syntastic_yaml_checkers       = ['jsyaml', 'ajsl']

let g:syntastic_less_options        = ['--html']
let g:syntastic_sh_shellcheck_args  = '-x'
let g:syntastic_html_tidy_args      = '--drop-empty-elements no'


"Igrore Web-Components related errors
let g:syntastic_html_tidy_ignore_errors = [
\ "<template> proprietary attribute",
\ "missing </template> before",
\ "before <option>",
\ "option> isn't allowed",
\ "proprietary attribute \"async\"",
\ "proprietary attribute \"is\"",
\ "is not recognized!",
\ "discarding unexpected"
\ ]
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
\      'desc': 'meta[name=description content=${1}]',
\      'import': 'link[rel=import]',
\      'x-if':  'template[is=x-if][has=${1}]',
\      'x-for': 'template[is=x-for][items=${1}]',
\      'mod': "(template>style)+script{${newline}  module.exports = class extends WebComponent {${newline}  };${newline}}",
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


" AUTO COMMANDS
" ==============================================================================

autocmd       InsertEnter             *        call <SID>OnInsertModeEnter()
autocmd       InsertLeave,WinLeave    *        call <SID>OnInsertModeLeave()
autocmd  User GoyoEnter                        call <SID>OnGoyoEnter()
autocmd  User GoyoLeave                        call <SID>OnGoyoLeave()
autocmd       BufNewFile,BufReadPost  *.html     set filetype=html.javascript.less
autocmd       BufNewFile,BufReadPost  *.md       set filetype=markdown
autocmd       BufNEwFile,BufReadPost  Makefile   set nolist
" autocmd       VimEnter                * Goyo
autocmd       VimEnter                * call <SID>GoMinimal()
" autocmd       VimLeave                * silent !tmux set status on
autocmd       BufEnter                * let &titlestring = @%
"Set terminal title to relative file path

" enable swagger syntax checker only for swagger.yaml files
" autocmd BufRead swagger.yaml let g:syntastic_yaml_checkers = ['jsyaml', 'swagger']

" disable syntax highlighting for large files
autocmd BufWinEnter * call CheckBigFile()
function CheckBigFile()
  if line2byte(line("$") + 1) > 100000
    syntax clear
    let b:syntastic_mode="passive"
  endif
endfunction

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
"   if !exists('w:last_fdm')
"     let w:last_fdm = &foldmethod
"     setlocal foldmethod=manual
"   endif
endfunction

function! s:OnInsertModeLeave()
  set nopaste "disable paste when leaving insert mode
  "if exists('w:last_fdm')
  "  let &l:foldmethod = w:last_fdm
  "  unlet w:last_fdm
  "endif
endfunction

function! s:OnGoyoEnter()
  set noshowmode
  set noshowcmd
  set scrolloff=999               " Always leave cursor in the middle
  "if exists('$TMUX')
  "  silent !tmux set status off
  "endif
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
  "if exists('$TMUX')
  "  silent !tmux set status off
  "endif
endfunction
