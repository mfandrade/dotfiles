" GENERAL
set number		" Show line numbers
set linebreak		" Break lines at word (requires Wrap lines)
set showbreak=+++ 	" Wrap-broken line prefix
set textwidth=100	" Line wrap (number of cols)
set showmatch		" Highlight matching brace
set virtualedit=all	" Enable free-range cursor
set errorbells		" Beep or flash screen on errors
set visualbell		" Use visual bell (no beeping)
 
" SEARCH
set hlsearch		" Highlight all search results
set smartcase		" Enable smart-case search
set ignorecase		" Always case-insensitive
set incsearch		" Searches for strings incrementally
 
" INDENT
set autoindent		" Auto-indent new lines
set cindent		" Use C style program indenting
set expandtab		" Use spaces instead of tabs
set shiftwidth=4	" Number of auto-indent spaces
set smartindent		" Enable smart-indent
set smarttab		" Enable smart-tabs
set softtabstop=4	" Number of spaces per Tab
 
" ADVANCED
syntax on		" Syntax highlight
set ruler		" Show row and column ruler information
set undolevels=100		" Number of undo levels
set backspace=indent,eol,start	" Backspace behaviour


" EXTRAS
" doesn't indent pasted code - https://stackoverflow.com/a/38258720/62202
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"
inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()
function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

" space to fold - https://vim.fandom.com/wiki/Folding
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf

" yaml stuff - https://lornajane.net/posts/2018/vim-settings-for-working-with-yaml
au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml foldmethod=indent
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
