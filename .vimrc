" GENERAL
set nocompatible        " gotta be first
set encoding=utf-8      " utf-8 is now widely used, right?
set number              " number lines
set relativenumber      " better, show relative numbers
set linebreak           " break lines at word (requires wrap lines)
set nowrap
set sidescroll=5
set listchars+=precedes:<,extends:>
set tildeop

set showbreak=+++       " wrap-broken line prefix
set textwidth=80        " line wrap (number of cols)
set colorcolumn=+1      " make it obvious where the 80 col is
set showmatch           " highlight matching brace
set virtualedit=all     " enable free-range cursor
set errorbells          " beep or flash screen on errors
set visualbell          " use visual bell (no beeping)
set laststatus=1        " file name and status info when using multiple tabs
set ruler               " show row and column ruler information
set showcmd             " show (partial) command in the last line


" VIM BEHAVIOUR

" SEARCH
set hlsearch            " highlight all search results
set smartcase           " enable smart-case search
set ignorecase          " always case-insensitive
set incsearch           " search as you type

" INDENT
set autoindent          " auto-indent new lines
set cindent             " use C style program indenting
set expandtab           " use spaces instead of tabs
set shiftwidth=4        " number of auto-indent spaces
set smartindent         " enable smart-indent
set smarttab            " enable smart-tabs
set softtabstop=4       " number of spaces per Tab

" ADVANCED VIM BEHAVIOUR
" syntax highlight when terminal has colors
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif
set undolevels=99        " how many (ctrl-u) undo levels
set history=50           " how many (: and /) commands and searchs can be saved
set autowrite            " autosave?
set nobackup
set nowritebackup
set noswapfile 
set backspace=indent,eol,start  " Backspace behaviour
set modelines=0          " disable modelines as a security precaution
set nomodeline
set splitbelow
set splitright

" this is vim!
nnoremap <Right> :echoe "Use l "<CR>
nnoremap <Left> :echoe "Use h "<CR>
nnoremap <Down> :echoe "Use j "<CR>
nnoremap <Up> :echoe "Use k "<CR>

" hard autowrap https://vi.stackexchange.com/a/375
"highlight ColorColumn ctermbg=7 guibg=lightgrey
"let &colorcolumn="80"



augroup vimrcEx
  autocmd!
  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
augroup END

" autocomplete words when spell check is on
set complete+=kspell            

" switch between the last two files
nnoremap <Leader><Leader> <C-^>


" SPLITS - https://thoughtbot.com/blog/vim-splits-move-faster-and-more-naturally
" save a keystroke avoiding ctrl-w to navigate between splits
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

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

" space to fold stuff - https://vim.fandom.com/wiki/Folding
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf
highlight Folded ctermbg=Black ctermfg=Darkgray

" xml folding - https://stackoverflow.com/a/44053643
let g:xml_syntax_folding=1
au FileType xml setlocal foldmethod=syntax

" yaml stuff - https://lornajane.net/posts/2018/vim-settings-for-working-with-yaml
au! BufNewFile,BufReadPost *.{yaml,yml} set filetype=yaml
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" python pep8
au BufNewFile,BufRead *.py set tabstop=4 softtabstop=4 shiftwidth=4 textwidth=79 expandtab autoindent fileformat=unix

" no tabexpand for Makefiles
autocmd FileType make set noexpandtab shiftwidth=8 softtabstop=0

" automatically removes all trailing space
autocmd Filetype c,cpp,java,php,yaml autocmd BufWritePre * %s/\s\+$//e

" XML formatter
function! DoFormatXML() range
  " Save the file type
  let l:origft = &ft

  " Clean the file type
  set ft=

  " Add fake initial tag (so we can process multiple top-level elements)
  exe ":let l:beforeFirstLine=" . a:firstline . "-1"
  if l:beforeFirstLine < 0
    let l:beforeFirstLine=0
  endif
  exe a:lastline . "put ='</PrettyXML>'"
  exe l:beforeFirstLine . "put ='<PrettyXML>'"
  exe ":let l:newLastLine=" . a:lastline . "+2"
  if l:newLastLine > line('$')
    let l:newLastLine=line('$')
  endif

  " Remove XML header
  exe ":" . a:firstline . "," . a:lastline . "s/<\?xml\\_.*\?>\\_s*//e"

  " Recalculate last line of the edited code
  let l:newLastLine=search('</PrettyXML>')

  " Execute external formatter
  exe ":silent " . a:firstline . "," . l:newLastLine . "!xmllint --noblanks --format --recover -"

  " Recalculate first and last lines of the edited code
  let l:newFirstLine=search('<PrettyXML>')
  let l:newLastLine=search('</PrettyXML>')
	
  " Get inner range
  let l:innerFirstLine=l:newFirstLine+1
  let l:innerLastLine=l:newLastLine-1

  " Remove extra unnecessary indentation
  exe ":silent " . l:innerFirstLine . "," . l:innerLastLine "s/^  //e"

  " Remove fake tag
  exe l:newLastLine . "d"
  exe l:newFirstLine . "d"

  " Put the cursor at the first line of the edited code
  exe ":" . l:newFirstLine

  " Restore the file type
  exe "set ft=" . l:origft
endfunction
command! -range=% FormatXML <line1>,<line2>call DoFormatXML()

nmap <silent> <leader>x :%FormatXML<CR>
vmap <silent> <leader>x :FormatXML<CR>
