set nocompatible
filetype on
filetype plugin on
filetype indent on
syntax on
set autoindent
set number
"set cursorline

"set cursorcolumn
set shiftwidth=4
set tabstop=4
set expandtab
"set nowrap

set incsearch
set hlsearch
set ignorecase
set showcmd
set wildmenu
set wildmode=longest:full,full

"autocmd TextChanged,TextChangedI <buffer> silent write
"Need vim-gtk3 for the next line to work
set clipboard+=unnamedplus
set number relativenumber
set whichwrap=lh
let mapleader = " "

" Forward jump wasn't working: https://github.com/neovim/neovim/issues/20126
nnoremap <C-I> <C-I>

" ---Jumplist Related Mappings---
nnoremap <expr> k (v:count > 1 ? "m'" . v:count : '') . 'k'
nnoremap <expr> j (v:count > 1 ? "m'" . v:count : '') . 'j'

" Ref: https://vi.stackexchange.com/questions/31197/add-current-position-to-the-jump-list-the-first-time-c-u-or-c-d-is-pressed
" The actual cursor movement is here, so the autocmd won't be cleared till this executes
function! SaveJump(motion)
  if exists('#SaveJump#CursorMoved')
    autocmd! SaveJump
  else
    normal! m'
  endif
  let m = a:motion
  if v:count
    let m = v:count.m
  endif
  execute 'normal!' m
endfunction

" Whenever the cursor moves, clear the autocmd
" If you use <C-d> then some other motion then again <C-d> it should and will have 2 entries in the jumplist. As the autocmd will be cleared on cursor move
function! SetJump()
  augroup SaveJump
    autocmd!
    autocmd CursorMoved * autocmd! SaveJump
  augroup END
endfunction

" :<C-u> is in command mode not normal and serves a different purpose
nnoremap <silent> <C-u> :<C-u>call SaveJump("\<lt>C-u>zz")<CR>:call SetJump()<CR>
nnoremap <silent> <C-d> :<C-u>call SaveJump("\<lt>C-d>zz")<CR>:call SetJump()<CR>
" ---END---

" ---Moving lines up/down---
" Ref: https://vi.stackexchange.com/questions/2674/how-can-i-easily-move-a-line
" Ref: https://vim.fandom.com/wiki/Moving_lines_up_or_down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
" Working: We need to use '> for the starting of text block to calculate the position to move to and the gv part is to indent and reselect
" But how does it know which part to move? When we use vnoremap, it automatically inserts the visual range '<,'>. This is how it might be behaving => :'<,'> m +10
" Ref: https://vi.stackexchange.com/questions/7149/mapping-a-command-in-visual-mode-results-in-error-e481-no-range-alllowed
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv
" ---END---

"Change split size using mouse
"set mouse=n
"set ttymouse=xterm2

"netrw
noremap <silent> <C-p> :Explore<CR>
let g:netrw_liststyle = 3
" gn is the mapping to make the directory you're on the current directory

"" Terminal Function
let g:term_buf = 0
let g:term_win = 0

function! TermToggle(height, width, direction)
    if win_gotoid(g:term_win)
        hide
    else
        if a:direction ==# 'v'
            execute 'vertical botright new'
            execute 'vertical resize ' . a:width
        else
            botright new
            execute 'resize ' . a:height
        endif
        try
            execute 'buffer ' . g:term_buf
        catch
            call termopen($SHELL, {"detach": 0})
            let g:term_buf = bufnr("")
        endtry
        setlocal nonumber
        setlocal norelativenumber
        setlocal signcolumn=no
        startinsert!
        let g:term_win = win_getid()
    endif
endfunction

" Horizontal split
nnoremap <C-\> :call TermToggle(12, 0, 'h')<CR>
inoremap <C-\> <Esc>:call TermToggle(12, 0, 'h')<CR>
tnoremap <C-\> <C-\><C-n>:call TermToggle(12, 0, 'h')<CR>

" Vertical split
nnoremap <A-\> :call TermToggle(0, 80, 'v')<CR>
inoremap <A-\> <Esc>:call TermToggle(0, 80, 'v')<CR>
tnoremap <A-\> <C-\><C-n>:call TermToggle(0, 80, 'v')<CR>
tnoremap <Esc> <C-\><C-n>

"Tabs and buffers
"Cannot use t as it is a default keybinding for till char
"map <leader>n :bnext<cr>
"map <leader>p :bprevious<cr>
noremap <silent> <tab> :bnext<CR>
noremap <silent> <s-tab> :bprevious<CR>
noremap <silent> <C-tab> :bnext<CR>
noremap <silent> <C-s-tab> :bprevious<CR>

"More ways to switch buffers
map gn :bnext<cr>
map gp :bprevious<cr>
"map gd :bdelete<cr>  
map <leader>n :bnext<cr>
map <leader>p :bprevious<cr>
map <leader>d :bdelete<cr>
nnoremap <leader><tab> :b#<cr>
nmap <leader>q :bp <BAR> bd #<CR>
nmap <leader><leader>d :bp <BAR> bd #<CR>
nmap <leader>bl :ls<CR>

"New tmp buffer
nnoremap <C-a> :enew<CR>

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

" reloading after file changed(https://www.reddit.com/r/neovim/comments/f0qx2y/automatically_reload_file_if_contents_changed/)
" trigger `autoread` when files changes on disk
set autoread
set updatetime=100
"autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | silent! checktime | endif
"au BufWinEnter *. set updatetime=300 | set autoread
" notification after file change
"autocmd FileChangedShellPost *
"            \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
autocmd FileChangedShell *.cpp let v:fcs_choice = 'reload'
"Code folding
"set foldmethod=syntax
"set foldignore=
"set foldnestmax=10
"set nofoldenable
"set foldlevel=2

" Function to toggle focus on the current split
let g:isWindowFocussed = 0
let g:originalWinWidths = {}

function! SaveWindowWidths()
    let winwidths = {}
    for i in range(1, winnr('$'))
        "execute i . 'wincmd w'
        let winwidths[i] = winwidth(i)
    endfor
    return winwidths
endfunction

function! RestoreWindowWidths(widths)
    for i in range(1, winnr('$'))
        if has_key(a:widths, i)
            execute i . 'wincmd w'
            execute 'vertical resize ' . a:widths[i]
        endif
    endfor
endfunction

function! ToggleWindowFocus()
    let currentWin = win_getid()
    if g:isWindowFocussed
        call RestoreWindowWidths(g:originalWinWidths)
        let g:isWindowFocussed = 0
    else
        let g:originalWinWidths = SaveWindowWidths()
        let targetWidth = float2nr((&columns * 0.75))
        call win_gotoid(currentWin)
        execute 'vertical resize ' . targetWidth
        let g:isWindowFocussed = 1
    endif

    call win_gotoid(currentWin)
endfunction
nnoremap <M-i> :call ToggleWindowFocus()<CR>

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
