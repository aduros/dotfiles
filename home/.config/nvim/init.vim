" Setup vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif
call plug#begin('~/.config/nvim/plugged')

" After modifying this list, run :PlugInstall
Plug 'tomtom/tcomment_vim'
Plug 'wellle/targets.vim'
Plug 'sheerun/vim-polyglot'
Plug 'skywind3000/asyncrun.vim'

" Minimal tab completion
Plug 'ajh17/VimCompletesMe'

" Color scheme
Plug 'arcticicestudio/nord-vim'
Plug 'machakann/vim-highlightedyank'

" Basic new file templating
Plug 'thinca/vim-template'

" Indent-aware pasting
Plug 'sickill/vim-pasta'

" " Snippets: vim-snipmate
" Plug 'MarcWeber/vim-addon-mw-utils'
" Plug 'tomtom/tlib_vim'
" Plug 'garbas/vim-snipmate'

" Pair auto-closing
" Plug 'jiangmiao/auto-pairs'
" Plug 'tpope/vim-endwise'
" Plug 'rstacruz/vim-closer'
" Plug 'cohama/lexima.vim'
" Plug 'Raimondi/delimitMate'
" Plug 'alvan/vim-closetag'

" Rg integration
Plug 'jremmen/vim-ripgrep'

" Git integration
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/gv.vim'

" LF integration
Plug 'ptzz/lf.vim'
Plug 'rbgrouleff/bclose.vim' " dependency
Plug 'VebbNix/lf-vim' " lfrc syntax highlighting

" FZF integration
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" Makes the quickfix window modifiable for easy search and replace
Plug 'stefandtw/quickfix-reflector.vim'

" Really more for the markdown features
Plug 'vimwiki/vimwiki'

" Language-server client for IDE features
Plug 'natebosch/vim-lsc'

call plug#end()

source ~/.config/nvim/options.vim
source ~/.config/nvim/mappings.vim

" Minimalist brace matching
inoremap (<CR> (<CR>)<C-c>O
inoremap {<CR> {<CR>}<C-c>O
inoremap [<CR> [<CR>]<C-c>O
inoremap (; (<CR>);<C-c>O
inoremap {; {<CR>};<C-c>O
inoremap [; [<CR>];<C-c>O
inoremap (, (<CR>),<C-c>O
inoremap {, {<CR>},<C-c>O
inoremap [, [<CR>],<C-c>O

" SnipMate configuration
" let g:snipMate = { 'snippet_version': 1 }
" let g:snips_no_mappings = 1
" function! CanTriggerSnipMate()
"     " TODO: Check if the line is otherwise empty?
"     if pumvisible()
"         return 0
"     endif
"     let line = getline(".")
"     if line =~ '^\s*\#\?\a\+\s*$' && len(snipMate#GetSnippetsForWordBelowCursor(snipMate#WordBelowCursor(), 1)) > 0
"         return 1
"     endif
"     return 0
" endfunction
" inoremap <expr><Space> CanTriggerSnipMate() ? "\<C-r>=snipMate#TriggerSnippet()\<CR>" : "\<Space>"

let g:asyncrun_exit = "silent call OnBuildComplete()"
" let g:asyncrun_bell = 1
function! OnBuildComplete()
    let dir = getcwd()
    let project = substitute(dir, ".*/", "", "")

    echo

    if g:asyncrun_code == 0
        exec "silent !notify-send -i ~/.config/nvim/icon-ok.svg 'Build passed' '" . project . "'"

        cclose
    else
        exec "silent !notify-send -i ~/.config/nvim/icon-error.svg 'Build FAILED' '" . project . "'"

        let curwin = winnr()
        cwindow
        " Jump back and prevent the quickfix window from stealing focus
        exec curwin . "wincmd w"
    endif
endfunction

function! RunBuild()
    silent wall

    " TODO: Some way to intelligently set the errorformat/compiler
    let dir = getcwd()
    let project = substitute(dir, ".*/", "", "")
    echo "Building " . project . " ..."
    let command = "make"

    " Run 2dk if this is a 2DKit project
    if filereadable(dir . "/2DKit.yaml")
        let command = "2dk run -d"
    endif

    execute "AsyncRun " . command
endfunction
map <silent> <C-B> :call RunBuild()<CR>
imap <silent> <C-B> <ESC>:call RunBuild()<CR>

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

    " let project_root = substitute(abspath, "\/src/.*", "", "")
    " let header_path = project_root . "/etc/SOURCE_HEADER"
    " if filereadable(header_path)
    "     let header = join(readfile(header_path), "\n")
    "     silent! %s/%SOURCE_HEADER%/\=header/g
    " elseif search("%SOURCE_HEADER%")
    "     " Remove the entire line with SOURCE_HEADER if we don't have one
    "     execute 'normal! "_dd'
    " endif
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

    " Jump to %CURSOR%
    if search("%CURSOR%")
        execute 'normal! "_cf%'
    endif
endfunction

" Window management
set splitright
set splitbelow

" Layout windows by their type. Help windows will always be openned at the
" very top, file edit windows will always be vertically split below that, and
" everything else along the very bottom.
function! GetWindowPosition(buf)
    let buftype = getbufvar(a:buf, "&buftype")
    let previewwindow = getwinvar(bufwinnr(a:buf), "&previewwindow")
    if buftype == "help" || previewwindow
        return "top"
    elseif buftype == "quickfix"
        return "bottom"
    else
        return "middle"
    end
endfunction

function! ArrangeWindows()
    let bookmark = bufnr("%")
    let top = []
    let middle = []
    let bottom = []

    let wincount = winnr("$")
    for win in range(1, wincount)
        let buf = winbufnr(win)
        let position = GetWindowPosition(buf)
        if position == "top"
            let top = add(top, buf)
        elseif position == "middle"
            let middle = add(middle, buf)
        elseif position == "bottom"
            let bottom = add(bottom, buf)
        endif
    endfor

    " echomsg "Top=".string(top)." Middle=".string(middle)." Bottom=".string(bottom)

    for buf in middle
        silent! exec bufwinnr(buf) . "wincmd w"
        wincmd L
    endfor
    for buf in top
        silent! exec bufwinnr(buf) . "wincmd w"
        wincmd K
        " resize 20
    endfor
    for buf in bottom
        silent! exec bufwinnr(buf) . "wincmd w"
        wincmd J
        resize 10
    endfor

    " Jump back to the original window
    silent! exec bufwinnr(bookmark) . "wincmd w"
endfunction

autocmd BufNewFile,BufRead * call ArrangeWindows()

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

" vim -b : edit binary using xxd-format!
" TODO: Generalize so that it can operate on any file extension
augroup Binary
  au!
  au BufReadPre  *.dat let &bin=1
  au BufReadPost *.dat if &bin | %!xxd
  au BufReadPost *.dat set ft=xxd | endif
  au BufWritePre *.dat if &bin | %!xxd -r
  au BufWritePre *.dat endif
  au BufWritePost *.dat if &bin | %!xxd
  au BufWritePost *.dat set nomod | endif
augroup END

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
    return a:tag."(".strftime("%Y-%m-%d").")"
endfunction
command -nargs=? -complete=file Todo :call ShowTodos(<f-args>)
noremap <leader>d :Todo<CR>
inoreabbrev <expr> TODO ExpandTodo("TODO")
inoreabbrev <expr> FIXME ExpandTodo("FIXME")
