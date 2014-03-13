"set nocompatible

" enable 256 color mode if terminal supports it
if $TERM == "xterm-256color"
  set t_Co=256
endif

" color scheme
if has('gui_running')
    set background=light
else
    set background=dark
endif

" vimdiff colors
if &diff
"    colorscheme some_other_scheme
    highlight! link DiffText MatchParen
"    highlight DiffAdd cterm=none ctermfg=bg ctermbg=Green gui=none guifg=bg guibg=Green
"    highlight DiffDelete cterm=none ctermfg=bg ctermbg=Red gui=none guifg=bg guibg=Red
"    highlight DiffChange cterm=none ctermfg=bg ctermbg=Yellow gui=none guifg=bg guibg=Yellow
"    highlight DiffText cterm=none ctermfg=bg ctermbg=Magenta gui=none guifg=bg guibg=Magenta
endif

" color scheme related
let g:solarized_contrast='high'
let g:solarized_visibility='high'
"let g:solarized_termtrans=1
"colorscheme solarized
colorscheme jellybeans

" encoding
set encoding=utf-8

" change the way find works
set ignorecase
set smartcase

" open files in case insensitive manner, requires VIm 7.3.x
"set wildignorecase

" complete files like a shell
set wildmode=list:longest

" directory containing swap files
set dir=~/.cache,.

" always use Spaces instead of Tabs
set tabstop=4
set shiftwidth=4
set expandtab

" textwidth and format options
set textwidth=80
" show line at 80 chars
"set colorcolumn=+1

" enable line numbering and highlighting the current one
set number
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

" turn on syntax highlighting
syntax on
" enable file type detection
filetype plugin indent on

" save view; needed for code-folding, for example
autocmd BufWinLeave .* mkview
autocmd BufWinEnter .* silent loadview

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
nnoremap p P
nnoremap P p
nnoremap o O
nnoremap O o

" highlight redundant spaces and tabs
let c_space_errors=1
highlight RedundantSpaces ctermbg=red guibg=red
match RedundantSpaces /\s\+$\| \+\ze\t/

