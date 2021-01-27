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
noremap <F13> <C-W>W

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

" Content searching
let g:rg_highlight = 1
nmap <leader>f :Rg<space>

" Remap ; to start command mode
nnoremap ; :
" Temporary for rewiring
" nnoremap : :echo "Semicolon ;)"<CR>

" Go to last modification
xnoremap gm `.

inoremap <C-s> <C-o>:w<CR>
nnoremap <C-s> :w<CR>

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
    copen
endfunction
map <silent> <leader>- :call ToggleQuickfix()<CR>
map <silent> - :cc<CR>:cnext<CR>
map <silent> _ :cc<CR>:cprevious<CR>

let g:gitgutter_map_keys = 0
nmap <leader>ga :GitGutterStageHunk<CR>
nmap <leader>gu :GitGutterUndoHunk<CR>
nmap <leader>g- :GitGutterNextHunk<CR>
nmap <leader>g_ :GitGutterPrevHunk<CR>
nmap <leader>gc :Git commit<CR>
nmap <c-g> :Git<CR>

" LF configuration
let g:lf_map_keys = 0
let g:lf_replace_netrw = 1
nmap <c-o> :Lf<CR>
" Ctrl-shift-o is remapped to F14 by the terminal in ~/.Xresources to make this work
nmap <F14> :call OpenLfIn("%", "vsplit ")<CR>

nmap <c-f> :Files<CR>
nmap <c-j> :History<CR>
nmap j :Buffers<CR>
nmap <leader>t :Tags<CR>
nmap <leader>we :call fzf#vim#files("~/data", {"source": "fdfind -e md"})<CR>
" Also disables the ctrl-t binding which is not dvorak-friendly
let g:fzf_action = {
    \ 'ctrl-s': 'vsplit' }

" Quickly search and replace the word under the cursor
nmap <leader>r :keeppatterns %s/\<<c-r>=expand("<cword>")<cr>\>/
vmap <leader>r :<c-u>keeppatterns '<,'>s/

" Commenting (using tcomment)
map <leader>/ gcc
map <leader>? g<c
vmap <leader>/ gc
vmap <leader>? g<

" Put a commented out duplicate of the current line above it
" TODO(2020-12-10): Don't use marks or clobber the unnamed register
" TODO(2020-12-10): Extend support to visual mode?
nmap <leader>c mcyyPg>c`c

" Sort lines and remove duplicates using <leader>s
map <leader>s :!LC_ALL=C sort -u<CR>

" Extract an expression into a variable, for haxe and js
nmap <leader>x Ovar <C-R>. = <C-R>";<Esc>

" Handle navigation with z
nmap <silent> <c-z> :call fzf#run(fzf#wrap({"source": "z-history", "sink": "cd", "options": ["--tac", "--prompt", "z> "]}))<CR>

" Handle standard clipboard keys
vmap <c-c> "+y
vmap <c-x> "+d
vmap <c-v> c<esc>"+p
imap <c-v> <c-r><c-o>+

" Other mappings
map <leader>, :exit<CR>

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
