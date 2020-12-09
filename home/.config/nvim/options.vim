" File types
" autocmd BufNewFile,BufRead *.hx set filetype=haxe
autocmd BufNewFile,BufRead *.jsfl set filetype=javascript
autocmd BufNewFile,BufRead ~/.config/dunst/dunstrc set filetype=dosini
autocmd BufNewFile,BufRead ~/.config/polybar/config set filetype=dosini
autocmd BufNewFile,BufRead ~/.config/tridactyl/tridactylrc set filetype=vim
autocmd BufNewFile,BufRead ~/.config/zathura/zathurarc set filetype=config
autocmd BufNewFile,BufRead ~/.lesskey set filetype=config

autocmd FileType haxe setlocal commentstring=//%s
autocmd FileType lf setlocal commentstring=#%s

" Project specific code-styles
autocmd BufNewFile,BufRead ~/remote/haxe/* setlocal noexpandtab
autocmd BufNewFile,BufRead ~/remote/html-externs/* setlocal noexpandtab
autocmd BufNewFile,BufRead ~/remote/2DKit/intellij-haxe/* setlocal sw=2
autocmd BufNewFile,BufRead ~/remote/2DKit/core/src/box2d/* setlocal noexpandtab

" Validate XML syntax on write (skips schema validation)
" autocmd BufWritePost *.xml call AsyncCommand("xmllint --postvalid " . expand("%:p"), "ShowErrors")
" autocmd BufWritePost *.json call AsyncCommand("jsonlint --compact " . expand("%:p"), "ShowErrors")

" Reload certain files on write
autocmd BufWritePost ~/.config/dconf-settings.ini silent !dconf load / < <afile>
autocmd BufWritePost ~/.config/dunst/dunstrc silent !killall dunst && notify-send "Test" > /dev/null
autocmd BufWritePost ~/.config/i3/config silent !i3-msg reload > /dev/null
autocmd BufWritePost ~/.Xresources silent !xrdb <afile> > /dev/null
autocmd BufWritePost ~/.lesskey silent !lesskey <afile> > /dev/null

" Make shebang scripts executable on write
function! MakeExecutable ()
    if getline(1) =~ "^#!"
        exec "silent !chmod +x '" . expand("%:p") . "'"
        " filetype detect
    endif
endfunction
autocmd BufWritePost * call MakeExecutable()

" Use the zip browsing interface to load these file extensions
au BufReadCmd *.apk,*.ipa,*.appx,*.wgt,*.ane,*.swc,*.fdz,*.zxp,*.crx call zip#Browse(expand("<amatch>"))

" File type specific settings
autocmd FileType ant,xml,html,css,json setlocal sw=2
autocmd Filetype text,mail,gitcommit,svn,mkd setlocal textwidth=72
" Because overridden by filetype, dunno why
autocmd FileType typescript setlocal sw=4

" Persistent backup and undo
if isdirectory(glob("~/trash"))
    set backup
    set backupdir=~/trash
    set undofile
    set undolevels=10000
    set undodir=~/trash
endif
set noswapfile " More trouble than they're worth

" Remember lots of history
set viminfo=!,'10000,<50,s1000,h

" General options
let mapleader=","
set confirm

" Searching
set ignorecase
set smartcase
set gdefault
set inccommand=nosplit

" Horizontal scrolling
set nowrap
set scrolloff=2
set sidescrolloff=2

" Indentation
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab
set smartindent

" Terminal
" set background=dark
" set fillchars=vert:\ 

" Ignore files in wildcard completion
set wildignore+=build
set wildignore+=.svn,.hg,.git
set wildignore+=*.png,*.swf,*.fla,*.pyc,*.o,*.cmo,*.cmi,*.cmx,*.annot,*.class,*.jar,*.swc

" Highlight trailing whitespace
" FIXME: Doesn't seem to work anymore
" highlight TrailingWhitespace ctermbg=red guibg=red
" autocmd InsertLeave,Syntax * match TrailingWhitespace /\s\+$/
" autocmd InsertEnter * match TrailingWhitespace /\s\+\%#\@<!$/
" autocmd FileType mail match TrailingWhitespace //

" Highlight characters past 100 columns
" highlight LongLine ctermbg=DarkRed guibg=DarkRed
" autocmd BufNewFile,BufRead * if &modifiable | syntax match LongLine '\%>100v.\+' | endif
set textwidth=100
set winwidth=100
set previewheight=20
set laststatus=1
set mouse=a

" Add a 1 character margin so vertical splits can breathe a bit
" set foldcolumn=1

" Colors
" let g:nord_bold_vertical_split_line=1
let g:nord_bold=1
let g:nord_italic=1
" let g:nord_italic_comments=1
let g:nord_underline=1
colorscheme nord
highlight Comment ctermfg=darkgray cterm=italic
" Also used for highlighted-yank
highlight IncSearch ctermfg=NONE ctermbg=black cterm=NONE

" highlight VertSplit ctermfg=blue ctermbg=black
" highlight VertSplit ctermbg=blue
" highlight StatusLine ctermfg=black ctermbg=blue
" highlight StatusLineNC ctermfg=black ctermbg=blue
" highlight Search cterm=NONE ctermbg=yellow ctermfg=black

" Color the ruler (info on bottom right)
set rulerformat=%#RulerFormat#%l,%c%V%=%P
highlight RulerFormat ctermfg=black cterm=bold

highlight MsgArea ctermfg=gray
highlight ErrorMsg ctermfg=lightgray

" Color the command line (needs Vim 8.2?)
" set wincolor=NormalAlt
" autocmd WinEnter set wincolor=NormalAlt
" highlight NormalAlt ctermfg=gray

" Explicitly define the statusline so that the above ruler format doesn't mess with the colors
set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P

" Shows the syntax group under the cursor
function! ShowColorHere()
    let l:s = synID(line('.'), col('.'), 1)
    echo 'highlight link ' . synIDattr(l:s, 'name') . ' ' . synIDattr(synIDtrans(l:s), 'name')
endfunction
command ShowColorHere call ShowColorHere()

" function! ReduceColors()
    " Try to reduce the color spam to be able to detect code-shape at a glance
    highlight Function ctermfg=NONE
    " highlight Type ctermfg=NONE
    highlight link haxeType Constant
    highlight link haxeFunction Keyword
    highlight link haxeConstant Keyword
    highlight link typescriptFuncKeyword Keyword
" endfunction
" autocmd FileType javascript,typescript,haxe call ReduceColors()

" Autosave on unfocus. Use version control!
autocmd FocusLost * if !&readonly | silent! wall | endif
set autowrite

" Always handle C-style comments nicely
set formatoptions+=croq

" " Treat • the same as - for list formatting
" set comments+=fb:•

" Ctags options
set tags=$HOME/.cache/bruno-ctags/*/tags

" Make <tab> be contextual completion
" let g:SuperTabDefaultCompletionType = "context"

" Plugin auto-pairs
let g:AutoPairsMultilineClose=0

" Plugin vimwiki
let g:vimwiki_list = [{"path": "~/data", "syntax": "markdown", "ext": ".md", "links_space_char": "-"}]
let g:vimwiki_markdown_link_ext = 1

" Plugin vim-lsc
" https://bluz71.github.io/2019/10/16/lsp-in-vim-with-the-lsc-plugin.html
let g:lsc_server_commands = {
\    "javascript": "typescript-language-server --stdio",
\    "typescript": "typescript-language-server --stdio",
\    "sh": "bash-language-server start",
\    "zsh": "bash-language-server start",
\    "vim": "vim-language-server --stdio",
\}
let g:lsc_auto_map = {'defaults': v:true, 'NextReference': ''}
let g:lsc_enable_autocomplete = v:true
let g:lsc_enable_diagnostics = v:false
let g:lsc_reference_highlights = v:false
