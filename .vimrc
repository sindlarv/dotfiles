" Some basic information
" For arguments of has() function see :help feature-list
" Similarly, arguments of exists() can be seen via :help option-list

"set nocompatible

" enable 256 color mode if terminal supports it
if $TERM == "xterm-256color"
    set t_Co=256
endif

" color scheme
if has('gui_running')
    set background=dark
    " set initial window size
    set columns=140
    set lines=40

    " http://vim.wikia.com/wiki/Accessing_the_system_clipboard
    " synchronize the * register with system clipboard
    " notes: for console version of vim, it has to be compiled with "+xterm_clipboard" option
    set clipboard=unnamed
    " since vim 7.3.74+ you can also sync the + register
    if has('unnamedplus')
        set clipboard=unnamedplus
    else
        "in case older version of vim is available, set the following
        vnoremap y "+y
        nnoremap yy V"+yy
        nnoremap p "+gp
    endif
else
    set background=dark
endif

"colorscheme solarized
colorscheme jellybeans
"colorscheme badwolf

" solarized options
let g:solarized_contrast='high'
let g:solarized_visibility='high'
"let g:solarized_termtrans=1

" vimdiff colors
if &diff
"    colorscheme some_other_scheme
    highlight! link DiffText MatchParen
"    highlight DiffAdd cterm=none ctermfg=bg ctermbg=Green gui=none guifg=bg guibg=Green
"    highlight DiffDelete cterm=none ctermfg=bg ctermbg=Red gui=none guifg=bg guibg=Red
"    highlight DiffChange cterm=none ctermfg=bg ctermbg=Yellow gui=none guifg=bg guibg=Yellow
"    highlight DiffText cterm=none ctermfg=bg ctermbg=Magenta gui=none guifg=bg guibg=Magenta
endif

" encoding
set encoding=utf-8

" change the way find works
set ignorecase
set smartcase

" Ignore case when doing completion; if needed in general for all operations,
" see fileignorecase (set by default on systems where case in file names is not
" considered at all)
" The following requires VIm 7.3.x
" wildignorecase is an option, not feature; use exists() instead
if exists('+wildignorecase')
    set wildignorecase
endif

" complete files like a shell
set wildmode=longest,list

" directory containing swap files
set dir=~/.cache,.

" always use Spaces instead of Tabs
set tabstop=4
set shiftwidth=4
set expandtab

" textwidth and format options
"set textwidth=80
" show line at 80 chars, requires VIm 7.3+
"if v:version >= 730
if exists('+colorcolumn')
    "set colorcolumn=80
    " or you can base the value of 'colorcolumn' on 'textwidth'
    "set colorcolumn=+1
    "highlight ColorColumn ctermbg=235 guibg=#2c2d27
    let &colorcolumn=join(range(81,999),",")
    "we can also have two color zones (warning|danger?)
    "let &colorcolumn="81,".join(range(121,999),",")
else
    autocmd BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif

" characters at 80+ column
map <F12> :/\%>80v./+<CR>
"command W /\%>80v./+<CR>
"command W match ErrorMsg '\%>80v.\+'

" enable line numbering and highlighting the current one
"set number
set cursorline

" turn on line wrapping and show 3 lines of context around the cursor
set nowrap
set scrolloff=2

" set the terminal's title
set title
" visual flash
"set visualbell
" no beeping please
set noerrorbells

" open horizontal splits below
set splitbelow
" open vertical splits on the right
set splitright

" status line
set laststatus=2
set statusline=[%n]\ %<%.99f\ %h%w%m%r%y\ %=%-16(\ %l,%c-%v\ %)%P
"set statusline+=\ %{fugitive#statusline()}

" folding
"set foldmethod=syntax
"set foldcolumn=4
"set nofoldenable
" make sure there's no additional column at the beginning of the screen
set foldcolumn=0

" turn on syntax highlighting
syntax on
" enable file type detection
filetype plugin indent on

" save view; needed for code-folding, for example
"autocmd BufWinLeave .* mkview
"autocmd BufWinEnter .* silent loadview

" plugin:AutoFenc configuration options
"g:autofenc_emit_messages

let g:Signs_file_path_corey=$HOME.'/.vim/marks/'

" clear highlighted search text
nnoremap <cr> :noh<cr>
"command C let @/=""

" invisible characters
" http://vimcasts.org/episodes/show-invisibles/
"  toggle `set list` quickly
command L set list!
"  use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:▸\ ,eol:¬

" reverse meaning of the Paste/New line keys
"nnoremap o O
"nnoremap O o
"nnoremap p P
"nnoremap P p

" highlight redundant spaces and tabs
let c_space_errors=1
highlight RedundantSpaces ctermbg=red guibg=red
match RedundantSpaces /\s\+$\| \+\ze\t/

" when splitting vertically put the new window right of the current one.
if has('vertsplit')
    set splitright
    set splitbelow
endif

" set mapleader (<leader>) so that it can easily be hit by either hand,
" the default ("\") is not very convenient
let mapleader = ","
" as there's no visual feedback <leader> has been pressed, lets tell vim to
" signal it
set showcmd

if &term =~ '256color'
    " disable Background Color Erase (BCE) so that color schemes
    " render properly when inside 256-color tmux and GNU screen.
    " http://sunaku.github.io/vim-256color-bce.html
    set t_ut=
endif

" set the sign and line columns to black
highlight LineNr ctermbg=black guibg=black
highlight SignColumn ctermbg=black guibg=black
