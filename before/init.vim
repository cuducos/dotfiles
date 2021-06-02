"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set leader key & Python bin                                               "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:python3_host_prog = '~/.virtualenvs/neovim/bin/python'
let g:python_host_prog = '~/.virtualenvs/neovim.old/bin/python'
let mapleader="\<Space>"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-plug                                                                  "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/plugged')

" syntax, completion & file types
Plug 'nvim-treesitter/nvim-treesitter', {'do': 'TSUpdate'}
Plug 'elmcast/elm-vim', {'for': 'elm'}
Plug 'python-mode/python-mode', {'branch': 'develop', 'for': 'python'}
Plug 'fatih/vim-go', {'for': 'go', 'do': ':GoUpdateBinaries'}
Plug 'rust-lang/rust.vim', {'for': 'rust'}
Plug 'vim-ruby/vim-ruby', {'for': 'ruby'}
Plug 'tpope/vim-rails', {'for': 'ruby'}

" cursor navigation
Plug 'justinmk/vim-sneak' " eg.: s<char><char> (ie `sab` jumps to first `ab`, use ; to next)
Plug 'terryma/vim-expand-region' " eg.: vv to select word

" visual enhancements
Plug 'Yggdroot/indentLine'
Plug 'unblevable/quick-scope'
Plug 'airblade/vim-gitgutter'
Plug 'psliwka/vim-smoothie'
Plug 'nightsense/snow'
Plug 'hoob3rt/lualine.nvim'
Plug 'jose-elias-alvarez/buftabline.nvim'
Plug 'winston0410/cmd-parser.nvim' " required by range-highlight
Plug 'winston0410/range-highlight.nvim'

" lint tools
Plug 'bronson/vim-trailing-whitespace', {'on': 'FixWhitespace'} " eg.: :FixWhitespace
Plug 'ambv/black', {'for': 'python', 'tag': '19.10b0'}  " see https://github.com/psf/black/issues/1293
Plug 'ngmy/vim-rubocop', {'for': 'ruby'}
Plug 'prettier/vim-prettier', {'do': 'npm install', 'for': ['javascript', 'json', 'markdown']}

" general tools
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'hrsh7th/nvim-compe'
Plug 'markonm/traces.vim'
Plug 'tpope/vim-commentary' " eg.: gc
Plug 'tpope/vim-fugitive'
Plug 'vim-scripts/greplace.vim', {'on': 'Gsearch'}  " eg.: :Gsearch and :Greplace
Plug 'scrooloose/nerdtree', {'on': 'NERDTreeFocus'}
Plug 'PhilRunninger/nerdtree-visual-selection', {'on': 'NERDTreeFocus'}
Plug 'arthurxavierx/vim-caser' " eg.: gsc for camelCase or gs_ for snake case
Plug 'voldikss/vim-floaterm'

call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins configuration                                                       "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Black
let g:black_virtualenv = '~/.virtualenvs/neovim'

" NERDTRee
let NERDTreeIgnore=['\.pyc$', '__pycache__', '^.git$', '.DS_Store', '.ropeproject', '.coverage', 'cover/']
noremap <silent> <leader>nt :NERDTreeFocus<CR>

" Rust
let g:rustfmt_autosave = 1

" IndentLine
let g:indentLine_enabled = 1
let g:indentLine_concealcursor = 0
let g:indentLine_char = '┆'
let g:indentLine_faster = 1

" vim-go
let g:go_auto_type_info = 1
let g:go_fmt_autosave = 1
let g:go_fmt_command = "goimports"
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_functions = 1
let g:go_highlight_operators = 1
let g:go_jump_to_error = 0

" elm-vim
let g:elm_setup_keybindings = 0
let g:elm_format_autosave = 1

" quick-scope (only enable highlighting when using the f/F/t/T movements)
function! Quick_scope_selective(movement)
  let needs_disabling = 0
  if !g:qs_enable
    QuickScopeToggle
    redraw
    let needs_disabling = 1
  endif
  let letter = nr2char(getchar())
  if needs_disabling
    QuickScopeToggle
  endif
  return a:movement . letter
endfunction
let g:qs_enable = 0
nnoremap <expr> <silent> f Quick_scope_selective('f')
nnoremap <expr> <silent> F Quick_scope_selective('F')
nnoremap <expr> <silent> t Quick_scope_selective('t')
nnoremap <expr> <silent> T Quick_scope_selective('T')
vnoremap <expr> <silent> f Quick_scope_selective('f')
vnoremap <expr> <silent> F Quick_scope_selective('F')
vnoremap <expr> <silent> t Quick_scope_selective('t')
vnoremap <expr> <silent> T Quick_scope_selective('T')

" telescope
nmap <Leader>g <cmd>Telescope git_files<CR>
nmap <Leader>G <cmd>Telescope git_status<CR>
nmap <Leader>f <cmd>Telescope find_files<CR>
nmap <Leader>b <cmd>Telescope buffers<CR>
nmap <Leader>/ <cmd>Telescope live_grep<CR>

" vim-expand-region
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" sneak
let g:sneak#label = 1
map m <Plug>Sneak_s
map M <Plug>Sneak_S

" python-mode
let g:pymode_rope = 1
let g:pymode_doc_bind = 'S'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Visual settings                                                             "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"enable color syntax highlight
syntax on

" color scheme
highlight pythonBoolean ctermfg=2 cterm=bold
set background=dark
colorscheme snow

" show line numbers and highlight current
set number relativenumber
set cursorline
highlight CursorLineNr ctermfg=DarkMagenta cterm=bold

autocmd InsertEnter  * set relativenumber
autocmd FocusGained * set relativenumber
autocmd BufEnter * set relativenumber

autocmd InsertLeave * set norelativenumber
autocmd BufLeave * set norelativenumber
autocmd FocusLost * set norelativenumber

" detect file type and load plugins for them
filetype on
filetype plugin on
filetype plugin indent on

" enable mouse
set mouse=a

" set font and color column
set colorcolumn=80

" search and highlight as you type
set incsearch
set hlsearch

" when scrolling, keep cursor visible within 5 lines
set scrolloff=5

" show pending operator
set showcmd

" highlight extra spaces
highlight BadWhitespace ctermbg=red guibg=red

" split windows below and right instead of above and left
set splitbelow splitright

" prevent vim from wrap inserted text
set textwidth=0
set wrapmargin=0

" enable switch buffers without saving
set hidden

" allow non-case-sensitive case when using only lowercase
set ignorecase
set smartcase

" disable swaps and backups
set nobackup
set directory=$HOME/.config/nvim/swp//

" fast rendering terminal
set ttyfast

" disable annoying beeping
set noerrorbells
set vb t_vb=

" disable netwr
let loaded_netrwPlugin = 1
"
" ignore certain type of files
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite

" auto-reload external changes
set autoread

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Shortcuts & aliases                                                         "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" linters & runners
noremap <leader>pb :Black<CR>
noremap <leader>gt :GoTest<CR>
noremap <leader>gr :GoRun<CR>
noremap <leader>cr :!cargo run<CR>
noremap <leader>pp :PrettierAsync<CR>
noremap <silent> <leader>rr :RuboCop --disable-pending-cops -a<CR>:FixWhitespace<CR>
noremap <leader>rl :luafile %<CR>

" disable search highlights
noremap <silent> <leader>, :nohl<CR>

" navigate splits
noremap <silent> <leader>h <C-w>h<CR>
noremap <silent> <leader>j <C-w>j<CR>
noremap <silent> <leader>k <C-w>k<CR>
noremap <silent> <leader>l <C-w>l<CR>
noremap <silent> <leader>cs <C-w>c<CR>  " close split, keep buffer

" save
noremap <silent> <leader>w :w<CR>

" clean-up leading white spaces
noremap <silent> <leader>fw :FixWhitespace<CR>

" indent and keep in visual mode
map < <gv
map > >gv

" move lines up and down with J and K
vnoremap J :m '>+1<cr>gv=gv
vnoremap K :m '<-2<cr>gv=gv

" disable arrows navigation
noremap <up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>
" inoremap <up> <nop> allow arrows in autocompletion
" inoremap <down> <nop> allow aoorws in autocompletion
inoremap <left> <nop>
inoremap <right> <nop>

" use c-j c-k in command mode
cmap <c-j> <down>
cmap <c-k> <up>

" use clipboard for Y/P/X
if has('unnamedplus')
  set clipboard=unnamed,unnamedplus
endif
noremap YY "+y<CR>
noremap P "+gP<CR>
noremap XX "+x<CR>

" stop c, s and d from yanking
nnoremap c "_c
xnoremap c "_c
nnoremap s "_s
xnoremap s "_s
nnoremap d "_d
xnoremap d "_d

" stop p from overwtitting the register (by re-yanking it)
xnoremap p pgvy

" buffer nav
noremap <leader>z :bp<CR>
noremap <leader>x :bn<CR>
noremap <leader>q :bw<CR>
noremap <leader>qa :bufdo bw<CR>

" no one is really happy until you have this shortcuts
cnoreabbrev W w
cnoreabbrev W! w!
cnoreabbrev Q q
cnoreabbrev Q! q!
cnoreabbrev Qa qa
cnoreabbrev Qa! qa!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev WQ wq
cnoreabbrev Wqa wqa

" open last session (works on startup)
noremap <silent> <leader>ls '0<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tabs, spaces, encoding, etc.                                                "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" line endings & other file chars settings
set encoding=utf-8
set fileencoding=utf-8
set fileformat=unix
set fileformats=unix,dos,mac
set binary

" indentation with 2 or 4 spaces
set expandtab       " use spaces instead of tabs
set autoindent      " autoindent based on line above
set smartindent     " smarter indent for C-like languages
set shiftwidth=4    " when using Shift + > or <
set softtabstop=4   " in insert mode
set tabstop=4       " set the space occupied by a regular tab

" special files tabs, spaces etc.

function! FourSpacesStyle()
  set tabstop=4
  set softtabstop=4
  set shiftwidth=4
  set textwidth=79
  set expandtab
  set autoindent
  set fileformat=unix
endfunction

function! TwoSpacesStyle()
  set tabstop=2
  set softtabstop=2
  set shiftwidth=2
endfunction

function! TabStyle()
  set noexpandtab
  set tabstop=4
  set softtabstop=4
  set shiftwidth=4
endfunction

au BufNewFile,BufRead *.elm call FourSpacesStyle()
au BufNewFile,BufRead *.py call FourSpacesStyle()

au BufNewFile,BufRead *.coffee call TwoSpacesStyle()
au BufNewFile,BufRead *.css call TwoSpacesStyle()
au BufNewFile,BufRead *.erb call TwoSpacesStyle()
au BufNewFile,BufRead *.html call TwoSpacesStyle()
au BufNewFile,BufRead *.jade call TwoSpacesStyle()
au BufNewFile,BufRead *.js call TwoSpacesStyle()
au BufNewFile,BufRead *.jsx call TwoSpacesStyle()
au BufNewFile,BufRead *.pug call TwoSpacesStyle()
au BufNewFile,BufRead *.rb call TwoSpacesStyle()
au BufNewFile,BufRead *.sass call TwoSpacesStyle()
au BufNewFile,BufRead *.scss call TwoSpacesStyle()
au BufNewFile,BufRead *.yaml call TwoSpacesStyle()
au BufNewFile,BufRead *.yml call TwoSpacesStyle()

au BufNewFile,BufRead *.go call TabStyle()
au BufNewFile,BufRead Makefile call TabStyle()

" view documents in vim (requires pandoc)
autocmd BufReadPost *.doc,*.docx,*.rtf,*.odp,*.odt silent %!pandoc "%" -tplain -o /dev/stdout

" .md to .markdown and .adoc to .asciidoctor
autocmd BufNewFile,BufRead *.md setlocal ft=markdown " .md ->markdown
autocmd BufNewFile,BufRead *.adoc setlocal ft=asciidoc " .adoc ->asciidoc

" set spell checker for certain files
autocmd FileType rst,md,markdown,adoc setlocal spell spelllang=en_ca

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Lua init                                                                    "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

lua require('init')
