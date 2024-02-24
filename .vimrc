set nocompatible
filetype on
filetype plugin on
filetype indent on
syntax on
set autoindent
set number
"set cursorline

set cursorcolumn
set shiftwidth=4
set tabstop=4
set expandtab
"set nowrap

set incsearch
set nohlsearch
set ignorecase
set showcmd
set wildmenu
set wildmode=list:longest

"autocmd TextChanged,TextChangedI <buffer> silent write
"Need vim-gtk3 for the next line to work
set clipboard+=unnamedplus
set number relativenumber
set whichwrap=lh
let mapleader = " "
set scrolloff=8
nnoremap("<C-d>", "<C-d>zz")
nnoremap("<C-u>", "<C-u>zz")

"Change split size using mouse
"set mouse=n
"set ttymouse=xterm2

"Tabs and buffers
"Cannot use t as it is a default keybinding for till char
"map <leader>n :bnext<cr>
"map <leader>p :bprevious<cr>
noremap <silent> <tab> :bnext<CR>
noremap <silent> <s-tab> :bprevious<CR>
nnoremap <leader><tab> :b#<cr>
nmap <leader>bq :bp <BAR> bd #<CR>
nmap <leader>bl :ls<CR>

" Resize windows with Meta key and arrow keys
nnoremap <M-Up> :resize -2<CR>
nnoremap <M-Down> :resize +2<CR>
nnoremap <M--> :vertical resize -2<CR>
nnoremap <M-+> :vertical resize +2<CR>

"Switching between splits
nmap <silent> <c-k> :wincmd k<CR>
nmap <silent> <c-j> :wincmd j<CR>
nmap <silent> <c-h> :wincmd h<CR>
nmap <silent> <c-l> :wincmd l<CR>

"Code folding
set foldmethod=syntax
set foldignore=
"set foldnestmax=10
"set nofoldenable
"set foldlevel=2

"Ctrl Backspace - Not working
"inoremap <C-w> <C-\><C-o>dB
"inoremap <C-BS> <C-\><C-o>db
noremap! <C-BS> <C-w>
noremap! <C-h> <C-w>

"Python indentation
let g:python_indent = {}
let g:python_indent.open_paren = 'shiftwidth() * 2'
let g:python_indent.nested_paren = 'shiftwidth()'
let g:python_indent.continue = 'shiftwidth() * 2'
let g:python_indent.closed_paren_align_last_line = v:false
let g:python_indent.searchpair_timeout = 500
let g:python_indent.disable_parentheses_indenting = 1

"Bracket pair colorizer
let g:rainbow_active = 1

"NERDCommenter
let g:NERDCreateDefaultMappings = 0
let g:NERDDefaultAlign = 'left'
noremap <C-_> :call NERDComment(0,"toggle")<C-m>
inoremap <C-_> :call NERDComment(0,"toggle")<C-m>

"Telescope
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" define line highlight color
highlight LineHighlight ctermbg=darkgray guibg=darkgray
" highlight the current line
nnoremap <silent> <Leader>l :call matchadd('LineHighlight', '\%'.line('.').'l')<CR>
" clear all the highlighted lines
nnoremap <silent> <Leader>c :call clearmatches()<CR>

" *multiedit.txt* Multi-editing for Vim
"
" Version: 2.0.2
" Author: Henrik Lissner <henrik at lissner.net>
" License: MIT license
"
" Inspired by https://github.com/felixr/vim-multiedit, this plugin hopes to
" fill that multi-cursor-shaped gap in your heart that Sublime Text 2 left you
" with.

if exists('g:loaded_multiedit') || &cp
    finish
endif
let g:loaded_multiedit = 1

" Settings
if !exists('g:multiedit_no_mappings')
    let g:multiedit_no_mappings = 0
endif

if !exists('g:multiedit_auto_reset')
    let g:multiedit_auto_reset = 1
endif

if !exists('g:multiedit_mark_character')
    let g:multiedit_mark_character = '|'
endif

if !exists('g:multiedit_auto_restore')
    let g:multiedit_auto_restore = 1
endif

" Color highlights
hi default link MultieditRegions Search
hi default link MultieditFirstRegion IncSearch

" Mappings
com! -bar -range MultieditAddRegion call multiedit#addRegion()
com! -bar -nargs=1 MultieditAddMark call multiedit#addMark(<q-args>)
com! -bar -bang Multiedit call multiedit#start(<q-bang>)
com! -bar MultieditClear call multiedit#clear()
com! -bar MultieditReset call multiedit#reset()
com! -bar MultieditRestore call multiedit#again()
com! -bar -nargs=1 MultieditHop call multiedit#jump(<q-args>)

if g:multiedit_no_mappings != 1
    " Insert a disposable marker after the cursor
    nmap <leader>ma :MultieditAddMark a<CR>
    " Insert a disposable marker before the cursor
    nmap <leader>mi :MultieditAddMark i<CR>
    " Make a new line and insert a marker
    nmap <leader>mo o<Esc>:MultieditAddMark i<CR>
    nmap <leader>mO O<Esc>:MultieditAddMark i<CR>
    " Insert a marker at the end/start of a line
    nmap <leader>mA $:MultieditAddMark a<CR>
    nmap <leader>mI ^:MultieditAddMark i<CR>
    " Make the current selection/word an edit region
    vmap <leader>m :MultieditAddRegion<CR>
    nmap <leader>mm viw:MultieditAddRegion<CR>
    " Restore the regions from a previous edit session
    nmap <leader>mu :MultieditRestore<CR>
    " Move cursor between regions n times
    map ]m :MultieditHop 1<CR>
    map [m :MultieditHop -1<CR>
    " Start editing!
    nmap <leader>M :Multiedit<CR>
    " Clear the word and start editing
    nmap <leader>C :Multiedit!<CR>
    " Unset the region under the cursor
    nmap <silent> <leader>md :MultieditClear<CR>
    " Uset all regions
    nmap <silent> <leader>mr :MultieditReset<CR>
endif

" vim: set foldmarker={{,}} foldlevel=0 foldmethod=marker


"Multi cursor
"nnoremap <C-p> :<c-u>call MultiCursorPlaceCursor()<cr>
"nnoremap <C-u> :<c-u>call MultiCursorManual()<cr>
"let g:multicursor_quit = "<C-q>"

" these lines are needed for ToggleComment()
"autocmd FileType c,cpp,java      let b:comment_leader = '//'
"autocmd FileType arduino         let b:comment_leader = '//'
"autocmd FileType sh,ruby,python  let b:comment_leader = '#'
"autocmd FileType zsh             let b:comment_leader = '#'
"autocmd FileType conf,fstab      let b:comment_leader = '#'
"autocmd FileType matlab,tex      let b:comment_leader = '%'
"autocmd FileType vim             let b:comment_leader = '"'
"
"" l:pos   --> cursor position
"" l:space --> how many spaces we will use b:comment_leader + ' '
"
"function! ToggleComment()
"    if exists('b:comment_leader')
"        let l:pos = col('.')
"        let l:space = ( &ft =~ '\v(c|cpp|java|arduino)' ? '3' : '2' )
"        if getline('.') =~ '\v(\s*|\t*)' .b:comment_leader
"            let l:space -= ( getline('.') =~ '\v.*\zs' . b:comment_leader . '(\s+|\t+)@!' ?  1 : 0 )
"            execute 'silent s,\v^(\s*|\t*)\zs' .b:comment_leader.'[ ]?,,g'
"            let l:pos -= l:space
"        else
"            exec 'normal! 0i' .b:comment_leader .' '
"            let l:pos += l:space
"        endif
"        call cursor(line("."), l:pos)
"    else
"        echo 'no comment leader found for filetype'
"    end
"endfunction
"
"nnoremap <C-_> :call ToggleComment()<CR>
"inoremap <C-_> <C-o>:call ToggleComment()<CR>
"xnoremap <C-_> :'<,'>call ToggleComment()<CR>

" For vim-devicons(square bracket issue)
"if exists("g:loaded_webdevicons")
"    call webdevicons#refresh()
"endif
