" GENERAL
set nocompatible        " Gotta be first
set number              " Show line numbers
set relativenumber      " Better, show relative numbers
set linebreak           " Break lines at word (requires Wrap lines)
set nowrap
set sidescroll=5
set listchars+=precedes:<,extends:>
set tildeop

set showbreak=+++       " Wrap-broken line prefix
set textwidth=120       " Where to line wrap
set showmatch           " Highlight matching brace
set virtualedit=all     " Enable free-range cursor
set errorbells          " Beep or flash screen on errors
set visualbell          " Use visual bell (no beeping)

" SEARCH
set hlsearch            " Highlight all search results
set smartcase           " Enable smart-case search
set ignorecase          " Always case-insensitive
set incsearch           " Searches for strings incrementally

" INDENT
set autoindent          " Auto-indent new lines
set cindent             " Use C style program indenting
set expandtab           " Use spaces instead of tabs
set shiftwidth=4        " Number of auto-indent spaces
set smartindent         " Enable smart-indent
set smarttab            " Enable smart-tabs
set softtabstop=4       " Number of spaces per Tab

" ADVANCED
syntax on               " Syntax highlight
set ruler               " Show row and column ruler information
set undolevels=99               " Number of undo levels
set backspace=indent,eol,start  " Backspace behaviour

" hard autowrap https://vi.stackexchange.com/a/375
highlight ColorColumn ctermbg=7 guibg=lightgrey
let &colorcolumn="80,".join(range(120,999),",")

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
