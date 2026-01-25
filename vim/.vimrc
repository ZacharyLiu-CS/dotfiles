set wildmenu "auto completion while tapping tab
set encoding=utf-8
set ignorecase "ignore case
set number "show line number
set relativenumber "relative number
set visualbell "disable dell
set ruler "show the ruler of the cursor
set autoread "auto read while file is modified outside
set autowrite "set auto save content
set autochdir "make the dir change according to the file
set mouse=a "open mouse support
set smartindent "c/c++ auto indent"
set autoindent "auto indent refet to the indentation of the previous line
set expandtab "repace <tab> with space
set tabstop=2
set shiftwidth=2
set softtabstop=2
set smarttab
set hlsearch "highlight search result
set incsearch "real time search
set cursorline
" TextEdit might fail if hidden is not set.
set hidden
" Some servers have issues with backup files, see #649.
set nowritebackup
set listchars=tab:»■,trail:■
set list
set autoread
set scrolloff=10
set noswapfile
set nobackup
set undofile
if empty(glob('~/.vim/undo'))
  silent !mkdir -p ~/.vim/undo
endif
set undodir=~/.vim/.undo/
set cc=100
"
" Give more space for displaying messages.
set cmdheight=1

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c
nnoremap <silent> <C-j> 5j
nnoremap <silent> <C-k> 5k
nnoremap <silent> <C-h> 5h
nnoremap <silent> <C-l> 5l
syntax enable
