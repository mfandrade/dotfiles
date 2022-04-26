" An example for a vimrc file.
" https://github.com/vim/vim/blob/master/runtime/vimrc_example.vim
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2019 Dec 17

" Get the defaults that most users want.
source $VIMRUNTIME/defaults.vim

" Default color scheme (default,desert,elflord,pablo)
colorscheme desert

" don't keep a backup file
set nobackup
if has('persistent_undo')
  " keep an undo file (undo changes after closing)
  set undofile
endif

" Switch on highlighting the last used search pattern.
" (<C-L> to temporarily turn it off, see mapping)
if &t_Co > 2 || has('gui_running')
  set hlsearch
endif

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78
augroup END

" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
" The ! means the package won't be loaded right away but when plugins are
" loaded during initialization.
if has('syntax') && has('eval')
  packadd! matchit
endif

" A minimal, but feature rich, example .vimrc
" https://vim.fandom.com/wiki/Example_vimrc

" Many Vim users likely the flexibility that set hidden offers, allowing them
" to move around files quickly without worrying about whether they’ve written
" to disk.
set hidden

" Use case insensitive search, except when using capital letters.
set ignorecase
set smartcase
" Search as you type.
set incsearch

" Line numbering is always useful.
set number
set relativenumber

" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on.  Useful for READMEs, etc.
set autoindent

" Stop certain movements from always going to the first character of a line.
" While this behaviour deviates from that of Vi, it does what most people
" expect in a text edior.
"set nostartofline

" Always display the status line, even if only one window is displayed.
set laststatus=2

" Raise a dialog asking to save changed files instead of failing on quit.
set confirm

" Use visual bell instead of annoying beeping when something wrong happens.
set visualbell

" Reset terminal code for visual bell, silently doing nothing on flash.
"set t_vb=

" Enable use of the mouse for all modes.
"if has('mouse')
"  set mouse=a
"endif

" Set command windows height to 2 lines, to avoid many cases of having to
" 'press <Enter> to continue'.
set cmdheight=2

" Quickly time out on keycodes, but never time out on mappings.
set notimeout ttimeout ttimeoutlen=200

" Use <F11> to toggle between 'paste' and 'nopaste'.
set pastetoggle=<F11>


" Indentation settings for using 4 spaces instead of tabs.
" Don't change 'tabstop' from its default value of 8 with this setup.
set shiftwidth=4
set softtabstop=4
set expandtab

" Display tabs as 4 characters wide.
set tabstop=4

" Useful mappings
" Y to act like D and C, i.e. to yank until EOL rather like act as yy.
map Y y$

" <C-L> (redraw screen) to also turn off search highlighting.
nnoremap <C-L> :nohlsearch<CR><C-L>

" Let's use vim navigation keys.
for key in ['<Up>', '<Down>', '<Left>', '<Right>']
  exec 'nnoremap' key '<Nop>'
  exec 'vnoremap' key '<Nop>'
  exec 'inoremap' key '<Nop>'
  "exec 'cnoremap' key '<Nop>'
endfor

" How to show invisible characters.
nnoremap <C-H> :set list!<CR>
set showbreak=+++\ " when wrapping long lines
set listchars=tab:»\ ,eol:⁋,nbsp:¤,space:·,trail:•,extends:⟩,precedes:⟨

" We don't like trailling spaces.
match ErrorMsg '\s\+$'
