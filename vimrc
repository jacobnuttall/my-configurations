$VIMRUNTIME/defaults.vim

" Basic Settings ----------------------{{{
set nocompatible

color industry

" Highlight everything when using search
set hlsearch

" Turn on syntax highlighting.
syntax on

" Turn on line numbers
set number

" Turn on line wrapping
set wrap

" Show partial command you type in the last line of the screen
set showcmd

" Show the mode you are in on the last line
set showmode

" Show matching words during a search
set showmatch

" Set the commands to save in history (Default 20)
set history=100

" Enable autocompletion menu after pressing TAB
set wildmenu

" Make wildmenu behave similar to Bash autocompletion
set wildmode=list:longest

" May need this for working with git.physics.byu.edu
" export GIT_SSL_NO_VERIFY = 1
"
" Auto-tabs
" tabstop:          Width of tab character
" softtabstop:      Fine tunes the amount of white space to be added
" shiftwidth        Determines the amount of whitespace to add in normal mode
" expandtab:        When this option is enabled, vi will use spaces instead of tabs
set tabstop     =4
set softtabstop =4
set shiftwidth  =4
set expandtab
" }}}

" Cursor Settings ----------------------{{{
" 1 -> blinking block
" 2 -> solid block
" 3 -> blinking underscore
" 4 -> solid underscore
" 5 -> blinking vertical bar
" 6 -> solid vertical bar

" Set cursor for mode:
let &t_SI= "\e[6 q" " INSERT mode
let &t_SR= "\e[4 q" " REPLACE mode
let &t_EI= "\e[2 q" " NORMAL mode

" Adjust the refresh rate for quicker cursor changes.
set ttimeout
set ttimeoutlen =1
set ttyfast

" Reset the cursor on start (for older versions of vim, not usually required)
augroup myCmds
au!
autocmd VimEnter * silent !echo -ne "\[2 q"
augroup END
" }}}

" Mappings  ----------------------{{{
"
" }}}

" Status Line ----------------------{{{
" Clear status line when vimrc is reloaded.
set statusline=

" Status line is left side.
" %F Full path of current file
" %M Modified flag shows if file is unsaved.
" %Y Type of file in buffer.
" %R Displays the read-only flag.
" %b Shows the ASCII/Unicode character under cursor.
" 0x%B Shows the hexadecimal character under cursor.
" %l show the line number.
" %c Display the row number.
" %c Display the column number.
" %p%% Show the cursor percentage from the top of the file.
set statusline+=\ %F\ %M\ %Y\ %R

" Use a divider to separte the left side from the right side.
set statusline+=%=

" Status line right side.
set statusline+=\ ascii:\ %b\ hex:\ 0x%B\ row:\ %l\ col:\ %c\ percent:\%p%%

" Show the status on the second-to-last line.
set laststatus=2

" }}}

" VIMScript ----------------------{{{

" Enable cold folding.
" Use marker method of folding.
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup end

" }}}

" Plugins ----------------------{{{

" Get Plugins for using with vim
" Install repo with cmd:
"   $ curl -flo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" Run :PlugInstall to update
" See https://github.com/junegunn/vim-plug
call plug#begin('~/.vim/plugged')

" Add Julia plugin
Plug 'dense-analysis/ale'
Plug 'preservim/nerdtree'
Plug 'JuliaEditorSupport/julia-vim'
call plug#end()

" }}}


