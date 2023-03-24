call plug#begin()

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'vimoutliner/vimoutliner'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'

call plug#end()


set encoding=utf-8

syntax on                         " show syntax highlighting
filetype plugin indent on
set autoindent                    " set auto indent
set ts=2                          " set indent to 2 spaces
set shiftwidth=2
set expandtab                     " use spaces, not tab characters
set nocompatible                  " don't need to be compatible with old vim
set relativenumber                " show relative line numbers
set showmatch                     " show bracket matches
set ignorecase                    " ignore case in search
set hlsearch                      " highlight all search matches
set smartcase                     " pay attention to case when caps are used
set incsearch                     " show search results as I type
set mouse=a                       " enable mouse support
set ttimeoutlen=100               " decrease timeout for faster insert with 'O'
set vb                            " enable visual bell (disable audio bell)
set ruler                         " show row and column in footer
set scrolloff=2                   " minimum lines above/below cursor
set laststatus=2                  " always show status bar
" set list listchars=tab:Â»Â·,trail:Â· " show extra space characters
set re=1
set nofoldenable                  " disable code folding
set clipboard=unnamed             " use the system clipboard
set wildmenu                      " enable bash style tab completion
set wildmode=list:longest,full
set backspace=indent,eol,start    " adding this to solve when backspace stops working
set list listchars=tab:▷▷⋮             " show tabs as arrows

runtime macros/matchit.vim        " use % to jump between start/end of methods

" set up some custom colors
highlight clear SignColumn
highlight VertSplit    ctermbg=236
highlight LineNr       ctermbg=236 ctermfg=240
highlight CursorLineNr ctermbg=236 ctermfg=240
highlight CursorLine   ctermbg=236
highlight IncSearch    ctermbg=3   ctermfg=1
highlight Search       ctermbg=1   ctermfg=3
highlight Visual       ctermbg=3   ctermfg=0
highlight Pmenu        ctermbg=240 ctermfg=12
highlight PmenuSel     ctermbg=3   ctermfg=1
highlight SpellBad     ctermbg=0   ctermfg=1

" highlight the status bar when in insert mode
au InsertEnter * hi StatusLine ctermfg=235 ctermbg=2
au InsertLeave * hi StatusLine ctermbg=240 ctermfg=12

" highlight trailing spaces in annoying red
highlight ExtraWhitespace ctermbg=1 guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" set leader key to comma
let mapleader = ","

"fzf search
nnoremap <leader>ff :GFiles<Cr>

" silver searcher config
let g:ackprg = 'ag --nogroup --nocolor --column'

" ctrlp config
let g:ctrlp_map = '<leader>f'
let g:ctrlp_max_height = 30
let g:ctrlp_working_path_mode = 0
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_show_hidden = 1

" use silver searcher for ctrlp
let g:ctrlp_user_command = 'ag %s -l --nocolor -g "" --ignore-dir "node_modules"'

"easily add new line in normal mode
nmap <S-Enter> O<Esc>
nmap <CR> o<Esc>

"move to last file
nnoremap <leader><leader> <c-^>

" write files
nnoremap <leader>w :w<CR>

" unmap F1 help
nmap <F1> :echo<CR>
imap <F1> <C-o>:echo<CR>

" map . in visual mode
vnoremap . :norm.<cr>

" die hash rockets, die!
vnoremap <leader>h :s/:\(\w*\) *=>/\1:/g<cr>

" map markdown preview
map <leader>m :!open -a Marked %<cr><cr>

" map git commands -- requires vim-fugitive
map <leader>b :Gblame<cr>
map <leader>l :!clear && git log -p %<cr>
map <leader>d :!clear && git diff %<cr>

" add a require 'pry' and binding.pry at current cursor location
map <leader>bp :s/\(^.*\n\)/require 'pry'\rbinding.pry\r\1/g<cr>:noh<cr>3k==2.2j:w<cr>

" clean up require 'pry' and binding.pry in file mapped to undo-binding-pry ie
" ubp
map <leader>ubp :g/require 'pry'\_s\+binding.pry\_s\+/,+1d<cr>

" open gist after it's been created
let g:gist_open_browser_after_post = 1

" map Silver Searcher
map <leader>s :Ag!<space>

" search for word under cursor with Silver Searcher
map <leader>A :Ag! "<C-r>=expand('<cword>')<CR>"

" clear the command line and search highlighting
noremap <C-l> :nohlsearch<CR>

" toggle spell check with <F5>
map <F5> :setlocal spell! spelllang=en_us<cr>
imap <F5> <ESC>:setlocal spell! spelllang=en_us<cr>

" execute current file
map <leader>e :call ExecuteFile(expand("%"))<cr>

" execute file if we know how
function! ExecuteFile(filename)
  :w
  :silent !clear
  if match(a:filename, '\.rb$') != -1
    if filereadable("Gemfile")
      exec ":!bundle exec ruby " . a:filename
    else
      exec ":!ruby " . a:filename
    end
  elseif match(a:filename, '\.js$') != -1
    exec ":!node " . a:filename
  elseif match(a:filename, '\.sh$') != -1
    exec ":!bash " . a:filename
  elseif match(a:filename, '\.c$') != -1
    exec ":!gcc " . a:filename . " ; ./a.out"
  elseif match(a:filename, '\.go$') != -1
    exec ":!go run " . a:filename
  else
    exec ":!echo \"Don't know how to execute: \"" . a:filename
  end
endfunction

" jump to last position in file
autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif

" rename current file, via Gary Bernhardt
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'))
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
map <leader>rn :call RenameFile()<cr>

function! RunTests(filename)
  " Write the file and run tests for the given filename
  :w
  :silent !clear
  if match(a:filename, '\.feature$') != -1
    exec ":!bundle exec cucumber " . a:filename
  elseif match(a:filename, '_test\.rb') != -1
    if filereadable("Rakefile")
      exec "!bundle exec rake test TEST=" . a:filename
    else
      exec ":!ruby " . a:filename
    end
  elseif match(a:filename, '_test\.rb$') != -1
    if filereadable("bin/testrb")
      exec ":!bin/testrb " . a:filename
    else
      exec ":!ruby -Itest " . a:filename
    end
  elseif match(a:filename, '_test\.go$') != -1
    exec ":!go test "
  elseif match(a:filename, '\.go$') != -1
    exec ":!go test"
  elseif match(a:filename, '\.spec\.js') != -1
    exec ":!gulp test"
  elseif match(a:filename, '\.scala$') != -1
    exec ":!sbt test"
  else
    if filereadable("Gemfile")
      " this use to include bundle exec but
      " I'm only getting the benefits of spring by using
      " rspec on it's own, ie rspec some_file
      " temp leaving this for now
      exec ":!bundle exec rspec --color " . a:filename
    else
      exec ":!rspec --color " . a:filename
    end
  end
endfunction

function! SetTestFile()
  " set the spec file that tests will be run for.
  let t:grb_test_file=@%
endfunction

function! RunTestFile(...)
  if a:0
    let command_suffix = a:1
  else
    let command_suffix = ""
  endif

  " run the tests for the previously-marked file.
  let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\|_test.rb\|_test.go\|.spec.js\|.scala\|.go\)$') != -1
  if in_test_file
    call SetTestFile()
  elseif !exists("t:grb_test_file")
    return
  end
  call RunTests(t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
  let rspec_test = match(expand("%"), '_spec.rb')
  let mini_test = match(expand("%"), '_test.rb')

  if rspec_test != -1
    let spec_line_number = line('.')
    call RunTestFile(":" . spec_line_number . " -b")
  elseif mini_test != -1
    let line_text = getline(search('def ', 'bcW'))
    let test_name = substitute(line_text, 'def ', "", "g")
    call RunTestFile(" -n " . test_name)
  endif

endfunction

" run test runner
map <leader>t :call RunTestFile()<cr>
map <leader>T :call RunNearestTest()<cr>

"toggle insert and normal mode
imap ii <C-[>

"ctag everything in current directory and gems

function! Ctag()
  let ruby = match(expand("%"), ".rb")
  let go = match(expand("%"), ".go")
  if ruby != -1
    exec ":!ctags -R --languages=ruby --exclude=.git --exclude=log . $(bundle list --paths)"
  endif
endfunction

map <leader>rt :call Ctag()<cr>
" map <leader>rt :!ctags -R --languages=ruby --exclude=.git --exclude=log . $(bundle list --paths)<cr>

" remove trailing white space before save
autocmd BufWritePre * :%s/\s\+$//e

"utilsnips:
let g:UltiSnipsExpandTrigger="<c-k>"
let g:UltiSnipsJumpForwardTrigger="<c-k>"
let g:UltiSnipsJumpBackwardTrigger="<c-l>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" vim expand region settings
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" remove paste buffer issue
function! RestoreRegister()
  let @" = s:restore_reg
  return ''
endfunction
function! s:Repl()
  let s:restore_reg = @"
  return "p@=RestoreRegister()\<cr>"
endfunction
vmap <silent> <expr> p <sid>Repl()

" vim region expand settings, use v for highlight, vv for word, vvv for
" paragraph
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" Rubocop with syntastic
" let g:syntastic_ruby_checkers = ['rubocop', 'mri']
"
" Ruby
let g:ruby_indent_block_style = 'do'
"
" JavaScript
let g:syntastic_javascript_checkers = ['eslint']

" Allow jsx syntax highlighting for .js files
let g:jsx_ext_required = 0

function! IndentJSON()
  :%!jq
endfunction

map <leader>js :call IndentJSON() <cr>
