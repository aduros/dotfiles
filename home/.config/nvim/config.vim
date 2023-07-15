" Legacy stuff I haven't moved over to Lua yet, or is easier to configure in vimscript

" File types
autocmd BufNewFile,BufRead *.hx set filetype=haxe
autocmd BufNewFile,BufRead ~/.config/dunst/dunstrc set filetype=dosini
autocmd BufNewFile,BufRead ~/.config/polybar/config set filetype=dosini
autocmd BufNewFile,BufRead ~/.config/tridactyl/tridactylrc set filetype=vim
autocmd BufNewFile,BufRead ~/.config/zathura/zathurarc set filetype=config
autocmd BufNewFile,BufRead ~/.lesskey set filetype=config

" Prefer line comments
autocmd FileType c,haxe setlocal commentstring=//%s
autocmd FileType lf setlocal commentstring=#%s
autocmd FileType wast setlocal commentstring=;;%s

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
        filetype detect
    endif
endfunction
autocmd BufWritePost * call MakeExecutable()

" Use the zip browsing interface to load these file extensions
au BufReadCmd *.apk,*.ipa,*.appx,*.wgt,*.ane,*.swc,*.fdz,*.zxp,*.crx call zip#Browse(expand("<amatch>"))

" File type specific settings
autocmd FileType ant,xml,html,css,json setlocal sw=2
autocmd Filetype mail,gitcommit,svn setlocal textwidth=72
" Because overridden by filetype, dunno why
" autocmd FileType typescript setlocal sw=4

" Make prose writing easier
autocmd FileType markdown,text,mail,gitcommit PencilSoft

" Persistent backup and undo
" Use :recover to restore a corrupted file, or manually copy the .backup file in ~/trash
if isdirectory(glob("~/trash"))
    set backup
    set backupdir=~/trash
    " Include the full path in the backup filename
    autocmd BufWritePre * let &backupext = "_" . substitute(expand("%:p:h"), "/", "%", "g") . ".backup"

    set undofile
    set undolevels=10000
    set undodir=~/trash

    " Put the swapfiles in trash, but ignore warnings about swapfile already existing
    set directory=~/trash
    set shortmess+=A
endif

" Remember lots of history
set viminfo=!,'10000,<50,s1000,h

" Restore the last cursor position when reopening files
autocmd BufReadPost * silent! normal! g`"zz

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
set scrolloff=4
set sidescrolloff=4

" Indentation
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab
set smartindent

" Terminal
" set background=dark
" set fillchars=vert:\ 

" " Ignore files in wildcard completion
" set wildignore+=build
" set wildignore+=.svn,.hg,.git
" set wildignore+=*.png,*.swf,*.fla,*.pyc,*.o,*.cmo,*.cmi,*.cmx,*.annot,*.class,*.jar,*.swc

" Highlight characters past 100 columns
" highlight LongLine ctermbg=DarkRed guibg=DarkRed
" autocmd BufNewFile,BufRead * if &modifiable | syntax match LongLine '\%>100v.\+' | endif
set textwidth=100
set winwidth=100
set previewheight=20
" set laststatus=1
set laststatus=3

" " Soft wrapping when editting textareas from tridactyl
" set linebreak
" autocmd FileType text setlocal textwidth=0 wrap

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
" highlight RulerFormat ctermfg=black cterm=bold
highlight RulerFormat ctermfg=darkgray

highlight MsgArea ctermfg=gray
highlight ErrorMsg ctermfg=lightgray

" Color the command line (needs Vim 8.2?)
" set wincolor=NormalAlt
" autocmd WinEnter set wincolor=NormalAlt
" highlight NormalAlt ctermfg=gray

" Explicitly define the statusline so that the above ruler format doesn't mess with the colors
set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P

" Tuck away the command line when inactive
set cmdheight=0
au CmdlineEnter * :set cmdheight=1
au CmdlineLeave * :set cmdheight=0

" Shows the syntax group under the cursor
function! ShowColorHere()
    let l:s = synID(line('.'), col('.'), 1)
    echo 'highlight link ' . synIDattr(l:s, 'name') . ' ' . synIDattr(synIDtrans(l:s), 'name')
endfunction
command ShowColorHere call ShowColorHere()

" Autosave often. Use version control!
autocmd TextChanged,InsertLeave,FocusLost * if !&readonly | silent! wall | endif
set autowriteall

" Always handle C-style comments nicely
set formatoptions+=croq

" Ctags options
set tags=$HOME/.cache/vim-ctags/*/tags

" Make <tab> be contextual completion
" let g:SuperTabDefaultCompletionType = "context"

" Make vertical splits open on the right instead of left
set splitright

" Cursor movement
noremap T 10j
noremap N 10k
noremap s l
noremap n k
noremap t j
if version > 500
    ounmap t
endif
noremap l n
noremap L N
noremap H <C-O>
noremap S <C-I>

" Dvorak HTNS switches windows
noremap <C-H> <C-W>h
noremap <C-T> <C-W>j
noremap <C-N> <C-W>k
noremap <C-S> <C-W>l
noremap <Space> <C-W>w
" Shift-space is remapped to F13 by the terminal in ~/.Xresources to make this work
" noremap <F13> <C-W>W

" Parity with zsh
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-h> <C-Left>
cnoremap <C-s> <C-Right>

" Can't cunmap original <C-r>?
" For some reason this messes up <leader>r mapping
" cnoremap <C-r> <C-e><C-u>History:<CR>

" Trying this out
nnoremap <C-r> <nop>
nnoremap U <C-r>

" Stop search highlighting when hitting ESC in normal mode
nnoremap <silent> <esc> :nohlsearch<CR>

" Content searching
let g:rg_highlight = 1
nnoremap <leader>f :Rg<space>

" Remap ; to start command mode
nnoremap ; :
" Temporary for rewiring
" nnoremap : :echo "Semicolon ;)"<CR>

" Go to last modification
xnoremap gm `.

" inoremap <C-s> <C-o>:w<CR>
" nnoremap <C-s> :w<CR>

" Make w and b move based on identifiers instead of iskeyword characters
nnoremap <silent> w <cmd>call search('\i\i*', 'W')<CR>
nnoremap <silent> b <cmd>call search('\i\i*', 'Wb')<CR>
nnoremap <silent> f <cmd>HopWordMW<CR>
" nnoremap W w
" nnoremap B b
vnoremap <silent> w <cmd>call search('\i\i*', 'W')<CR>
vnoremap <silent> b <cmd>call search('\i\i*', 'Wb')<CR>
vnoremap <silent> f <cmd>HopWordMW<CR>
" vnoremap W w
" vnoremap B b

function! ToggleQuickfix ()
    let wincount = winnr("$")
    for win in range(1, wincount)
        let buf = winbufnr(win)
        let buftype = getbufvar(buf, "&buftype")
        if buftype == "quickfix"
            cclose
            return
        endif
    endfor
    botright copen
endfunction
nnoremap <silent> <leader>- :call ToggleQuickfix()<CR>
nnoremap <silent> - :cc<CR>:cnext<CR>
nnoremap <silent> _ :cc<CR>:cprevious<CR>

nnoremap <silent> <leader>ga :lua require("gitsigns").stage_hunk()<CR>
nnoremap <silent> <leader>gA :lua require("gitsigns").undo_stage_hunk()<CR>
nnoremap <silent> <leader>gu :lua require("gitsigns").reset_hunk()<CR>
nnoremap <silent> <leader>g- :lua require("gitsigns").next_hunk()<CR>
nnoremap <silent> <leader>g_ :lua require("gitsigns").prev_hunk()<CR>
nnoremap <silent> <leader>gb :lua require("gitsigns").blame_line()<CR>
" nnoremap <silent> <leader>gc :Git commit<CR>
nnoremap <silent> <c-g> :Neogit<CR>

" Start git commits in insert mode
autocmd FileType gitcommit execute "normal! gg0" | startinsert

nnoremap <silent> <c-f> :Files<CR>
nnoremap <silent> <c-j> :History<CR>
" nnoremap j :Buffers<CR>
" nnoremap <leader>t :Tags<CR>
nnoremap <silent> <leader>we :call fzf#vim#files("~/data", {"source": "fd -e md"})<CR>
" Also disables the ctrl-t binding which is not dvorak-friendly
let g:fzf_action = {
    \ 'ctrl-s': 'vsplit' }

" Quickly search and replace the word under the cursor
nnoremap <leader>r :keeppatterns %s/\<<c-r>=expand("<cword>")<cr>\>/
vnoremap <leader>r :<c-u>keeppatterns '<,'>s/

" Commenting (using commentary.vim)
nnoremap <silent> <leader>/ :Commentary<CR>
" nmap <leader>? gcgc
vnoremap <silent> <leader>/ :Commentary<CR>
" vmap <leader>? :Commentary!<cr>

" Put a commented out duplicate of the current line above it
" TODO(2020-12-10): Don't use marks or clobber the unnamed register
" TODO(2020-12-10): Extend support to visual mode?
nmap <leader>c mcyyPgcc`c

" Sort lines and remove duplicates using <leader>s
noremap <silent> <leader>s :!LC_ALL=C sort -u<CR>

" Extract an expression into a JS variable
nnoremap <leader>x Oconst <C-R>. = <C-R>";<Esc>

" Handle navigation with z
nnoremap <silent> <c-z> :call fzf#run(fzf#wrap({"source": "z-history", "sink": "cd", "options": ["--tac", "--prompt", "z> "]}))<CR>

" Handle standard clipboard keys
vnoremap <c-c> "+y
vnoremap <c-x> "+d
vnoremap <c-v> c<esc>"+p
inoremap <c-v> <c-r><c-o>+

" Other mappings
noremap <leader>, <cmd>exit<CR>

" Support running @ macros on visual selections
function! ExecuteMacroOverVisualRange()
    echo "@".getcmdline()
    execute ":'<,'>normal @".nr2char(getchar())
endfunction
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

" Support running . on visual selections
xnoremap . :normal .<CR>

" Show a live preview of markdown files
command PandocView :w | silent !pandoc-view % &
" command PandocView :w | AsyncRun pandoc-view %
nmap <leader>m :PandocView<CR>

" let g:vim_markdown_conceal_code_blocks = 0
" let g:vim_markdown_frontmatter = 1
let g:vim_markdown_autowrite = 1
let g:vim_markdown_no_extensions_in_markdown = 1
set nofoldenable
" set conceallevel=2
" highlight markdownUrl cterm=underline
" highlight markdownLinkText cterm=underline

autocmd User plugin-template-loaded call s:template_keywords()
function! s:template_keywords()
    " The absolute path of the new file
    let abspath = expand("%:p")

    " Short name of the file
    let file = substitute(abspath, "^.*\/", "", "")

    " Filename extension
    let suffix = substitute(file, "^.*\\.", "", "")

    " Part before the extension
    let class = substitute(file, "\\..*", "", "")
    silent! %s/%CLASS%/\=class/g

    " Try to guess the relative path from the project root
    let relpath = substitute(abspath, "^.*\/\\(" . suffix . "\\|src\\)\/", "", "")
    silent! %s/%PATH%/\=relpath/g

    let relpath_noextension = substitute(relpath, "\\..*", "", "")
    silent! %s/%PATH_NOEXTENSION%/\=relpath_noextension/g

    let package = substitute(relpath, "\/[^\/]*$", "", "")
    let package = substitute(package, "\/", ".", "g")
    silent! %s/%PACKAGE%/\=package/g

    let parts = split(expand("%:p:h"), "/")
    while !empty(parts)
        let header_path = "/" . join(parts, "/") . "/.header"
        if filereadable(header_path)
            let header = join(readfile(header_path), "\n")
            silent! %s/%SOURCE_HEADER%/\=header/g
            break
        endif
        call remove(parts, -1)
    endwhile
    if empty(parts) && search("%SOURCE_HEADER%")
        " Remove the entire line with SOURCE_HEADER if we don't have one
        execute 'normal! "_dd'
    endif

    let date = strftime("%FT%TZ")
    silent! %s/%DATE%/\=date/g

    silent! %s/%TITLE%/\=g:bruno_template_title/g

    " Jump to %CURSOR%
    if search("%CURSOR%")
        execute 'normal! "_cf%'
    endif
endfunction

" This may break everything
autocmd WinEnter * wincmd =

" Window management
" set splitright
" set splitbelow

" " Layout windows by their type. Help windows will always be openned at the
" " very top, file edit windows will always be vertically split below that, and
" " everything else along the very bottom.
" function! GetWindowPosition(buf)
"     let buftype = getbufvar(a:buf, "&buftype")
"     let previewwindow = getwinvar(bufwinnr(a:buf), "&previewwindow")
"     if buftype == "help" || previewwindow
"         return "top"
"     elseif buftype == "quickfix"
"         return "bottom"
"     else
"         return "middle"
"     end
" endfunction

" function! ArrangeWindows()
"     let bookmark = bufnr("%")
"     let top = []
"     let middle = []
"     let bottom = []

"     let wincount = winnr("$")
"     for win in range(1, wincount)
"         let buf = winbufnr(win)
"         let position = GetWindowPosition(buf)
"         if position == "top"
"             let top = add(top, buf)
"         elseif position == "middle"
"             let middle = add(middle, buf)
"         elseif position == "bottom"
"             let bottom = add(bottom, buf)
"         endif
"     endfor

"     " echomsg "Top=".string(top)." Middle=".string(middle)." Bottom=".string(bottom)

"     for buf in middle
"         silent! exec bufwinnr(buf) . "wincmd w"
"         wincmd L
"     endfor
"     for buf in top
"         silent! exec bufwinnr(buf) . "wincmd w"
"         wincmd K
"         " resize 20
"     endfor
"     for buf in bottom
"         silent! exec bufwinnr(buf) . "wincmd w"
"         wincmd J
"         resize 10
"     endfor

"     " Jump back to the original window
"     silent! exec bufwinnr(bookmark) . "wincmd w"
" endfunction

" autocmd BufNewFile,BufRead * call ArrangeWindows()

" function! ToggleWindow()
"     if len(g:RecentWindows) < 2
"         return
"     endif
"     let buf = bufnr("%")
"     let dest = g:RecentWindows[0]
"     if buf == dest
"         let dest = g:RecentWindows[1]
"     endif
"     exec bufwinnr(dest) . "wincmd w"
" endfunction
"noremap <silent> <Space> :call ToggleWindow()<CR>

" Opens the edit command on the current directory
" cnoremap ced e <c-r>=expand("%:h")<cr>/

" Integration with "TODO" comments
function ShowTodos(...)
    let cmd = ["todo"]
    for arg in a:000
        let cmd = add(cmd, shellescape(arg))
    endfor
    silent cexpr system(join(cmd, " "))
    cwindow
    if empty(getqflist())
        echo "No TODOs found."
    else
        let w:quickfix_title = "TODOs"
    endif
endfunction
function ExpandTodo(tag)
    return a:tag."(".strftime("%F").")"
endfunction
command -nargs=? -complete=file Todo :call ShowTodos(<f-args>)
noremap <leader>d :Todo<CR>
inoreabbrev <expr> TODO ExpandTodo("TODO")
inoreabbrev <expr> FIXME ExpandTodo("FIXME")

" function! s:add_endwise_rule(at, end, filetype)
"     let rule = {
"     \ 'char': '<CR>',
"     \ 'input': '<CR>',
"     \ 'input_after': '<CR>' . a:end,
"     \ 'at': a:at,
"     \ 'except': '\C\v^(\s*)\S.*%#\n%(%(\s*|\1\s.+)\n)*\1' . a:end,
"     \ 'filetype': a:filetype,
"     \ }
"     call lexima#add_rule(rule)
" endfunction

" " Messes up indentation?
" let g:lexima_map_escape = ""

" " " Expand jsdoc/javadoc comments when typing /**<CR>
" " call s:add_endwise_rule('^\s*/\*\*\%#$', ' */', [])

" " Expand jsdoc/javadoc comments when typing /**<space>
" call lexima#add_rule({
" \ 'char': ' ',
" \ 'input': ' ',
" \ 'input_after': ' */',
" \ 'at': '/\*\*\%#$',
" \ })

function OpenBlog (...)
    let title = join(a:000)
    let slug = substitute(tolower(title), "[ /]", "-", "g")
    let slug = substitute(slug, "[^a-z0-9\-]", "", "g")
    let slug = substitute(slug, "--*", "-", "g")

    let dir = $HOME."/data/website/blog/".slug
    let g:bruno_template_title = title
    call mkdir(dir)
    execute "edit ".dir."/index.md"
endfunction
command -nargs=? Blog :call OpenBlog(<f-args>)
autocmd BufNewFile ~/data/website/blog/*.md call template#load("~/.config/nvim/template/other/blog.md")

sign define DapBreakpoint text=▶ texthl=DapBreakpoint
highlight DapBreakpoint ctermfg=cyan
sign define DapStopped text= linehl=DapStopped
highlight DapStopped ctermbg=52
nnoremap <silent> kk <Cmd>lua require'dap'.continue()<CR>
nnoremap <silent> kt <Cmd>lua require'dap'.step_over()<CR>
nnoremap <silent> kT <Cmd>lua require'dap'.run_to_cursor()<CR>
nnoremap <silent> ks <Cmd>lua require'dap'.step_into()<CR>
nnoremap <silent> kh <Cmd>lua require'dap'.step_out()<CR>
nnoremap <silent> kb <Cmd>lua require'dap'.toggle_breakpoint()<CR>
nnoremap <silent> kB <Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
" nnoremap <silent> <Leader>lp <Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
nnoremap <silent> kr <Cmd>lua require'dap'.repl.toggle()<CR>
nnoremap <silent> ki <Cmd>lua require'dap.ui.widgets'.hover()<CR>

nnoremap <silent> <leader>tr <Cmd>wall \| lua require'neotest'.run.run()<CR>
nnoremap <silent> <leader>tR <Cmd>wall \| lua require'neotest'.run.run_last()<CR>
nnoremap <silent> <leader>td <Cmd>wall \| lua require'neotest'.run.run({ strategy = "dap" })<CR>
nnoremap <silent> <leader>tD <Cmd>wall \| lua require'neotest'.run.run_last({ strategy = "dap" })<CR>
nnoremap <silent> <leader>ts <Cmd>lua require'neotest'.summary.toggle()<CR>
nnoremap <silent> <leader>to <Cmd>lua require'neotest'.output.open({ enter = true, short = true })<CR>
nnoremap <silent> <leader>tO <Cmd>lua require'neotest'.output.open({ enter = true, short = false })<CR>

" Kitty can display curly underlines without changing text color
highlight DiagnosticUnderlineError cterm=undercurl ctermfg=none
highlight DiagnosticUnderlineWarn cterm=undercurl ctermfg=none
highlight DiagnosticUnderlineInfo cterm=undercurl ctermfg=none
highlight DiagnosticUnderlineHint cterm=undercurl ctermfg=none
