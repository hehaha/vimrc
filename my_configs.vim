set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
Plugin 'L9'
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}
"
" Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}

" code complete plugin
Plugin 'Valloric/YouCompleteMe'

" 4 space show a white line
Plugin 'Yggdroot/indentLine'

" vue highlighter
Plugin 'posva/vim-vue'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"
set clipboard=unnamed

set relativenumber
set number
noremap <leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

set colorcolumn=100

" ycm GoTo shortcut
map <C-g> :YcmCompleter GoTo<cr>

" source vimr config filv
nnoremap <leader>sv :source $MYVIMRC<cr>

" map to shell shortcut
imap <c-a> <esc>0i
imap <c-e> <esc>$a

" auto add header
augroup insertheader
    autocmd!
    autocmd BufNewFile *.py 0put =\"# -*- coding: utf-8 -*-\<nl>\"|$
augroup END

" shortcut to invoke ack search
nnoremap <leader>g :set operatorfunc=<SID>GrepOperator<cr>g@
vnoremap <leader>g :<c-u>call <SID>GrepOperator(visualmode())<cr>

function! s:GrepOperator(type)
    if a:type ==# 'v'
        normal! `<v`>y
    elseif a:type ==# 'char'
        normal! `[v`]y
    else
        return
    endif

    let word = substitute(@@, '^\s*\(.\{-}\)\s*$', '\1', '')
    if len(word) <= 1
        echo "Short word search omitted!"
        return
    endif

    execute "Ack " . shellescape(word)
endfunction

" shortcut to enclose the cursor word with input char
nnoremap <c-e> :silent call EncloseWord()<cr>

function! EncloseWord()
    let l:c = nr2char(getchar())
    if l:c ==# '(' || l:c ==# ')'
        let l:l = '('
        let l:r = ')'
    elseif l:c ==# '{' || l:c ==# '}'
        let l:l = '{'
        let l:r = '}'
    elseif l:c ==# '[' || l:c ==# ']'
        let l:l = '['
        let l:r = ']'
    elseif l:c ==# '<' || l:c ==# '>'
        let l:l = '<'
        let l:r = '>'
    elseif l:c ==# '“' || l:c ==# '”'
        let l:l = '“'
        let l:r = '”'
    else
        let l:l = l:c
        let l:r = l:c
    endif

    let cursor = expand("<cWORD>")
    let cursor = substitute(cursor, '^\s*\(.\{-}\)\s*$', '\1', '')
    if len(cursor) <= 1
        execute "normal! i" . l:l . l:r
        startinsert
    else
        execute "normal! viW\<esc>a" . l:r . "\<esc>Bi" . l:l . "\<esc>lEl"
    endif
endfunction

" fast open file mapping
map <leader>v :vsplit <c-r>=expand("%:p:h")<cr>/
map <leader>s :split <c-r>=expand("%:p:h")<cr>/
map <leader>e :edit <c-r>=expand("%:p:h")<cr>/

" vue highlight
autocmd FileType vue syntax sync fromstart
 " 1 tab == 2 space in js, vue, html, css
autocmd FileType javascript,html,css,vue setlocal ts=2 sts=2 sw=2

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Syntastic (syntax checker)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ale_linters = {
\   'javascript': ['eslint'],
\   'python': ['flake8'],
\   'go': ['go', 'golint', 'errcheck'],
\   'vue': ['tsserver', 'eslint']
\}
let g:ale_linter_aliases = {'vue': 'typescript'}
let g:ale_fixers = {'vue': ['eslint']}
let g:ale_python_flake8_options = '--max-line-length=100'
