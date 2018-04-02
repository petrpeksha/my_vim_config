source $VIMRUNTIME/mswin.vim
behave mswin

autocmd FileType sql let b:vimpipe_command="sqlplus -s /"

" Use Vim settings, rather then Vi settings
set nocompatible

" Encoding
set encoding=utf-8

" Big old history
set history=9999

" Turn on line numbers
set number

" Show file stats
set ruler

" Blink cursor on error instead of beeping
set visualbell

" Turn on syntax highlighting
syntax on

" We are good up to 99999 lines
set numberwidth=5

" Set tabulator length to 4 columns
set tabstop=4

" Number of spaces in tab when editing
set softtabstop=4

" Tabs are spaces
set expandtab

" Do not wrap line
set nowrap

" Show command in bottom bar
set showcmd

" Highlight current line
set cursorline

" Visual autocomplete for command menu
set wildmenu

" Highlight matching [{()}]
set showmatch

" Horizontal scrollbar
set guioptions+=b

" Make backspace work like most other apps
set backspace=2

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase
set hlsearch

 " Backup settings
if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
  set backupdir=C:\\Temp
  set dir=C:\\Temp
  set writebackup
endif

" Font
if has('gui_running')
  set guifont=Courier_New:h10
endif

" Leader is comma
let mapleader=","

" jk is escape
inoremap jk <esc>

filetype plugin on

" Colors
colorscheme sourcerer

filetype on

au BufNewFile,BufRead *.sql set filetype=plsql
au BufNewFile,BufRead *.trg set filetype=plsql
au BufNewFile,BufRead *.pck set filetype=plsql
au BufNewFile,BufRead *.tps set filetype=plsql
au BufNewFile,BufRead *.tpb set filetype=plsql
au BufNewFile,BufRead *.vim set filetype=vim

map <F2> aSELECT * FROM 
map <F3> aDBMS_OUTPUT.PUT_LINE('
map <C-n> :NERDTreeToggle<CR>

" Pathogen plugin execute
execute pathogen#infect()
filetype plugin indent on

" python-mode plugin
" let g:pymode_python = 'python3'

" syntastic plugin
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0

" gim-gutter
let g:gitgutter_max_signs = 500
nmap ]h <Plug>GitGutterNextHunk
nmap [h <Plug>GitGutterPrevHunk
nmap <Leader>hs <Plug>GitGutterStageHunk
nmap <Leader>hu <Plug>GitGutterUndoHunk

" tuning for gVim only
if has('gui_running')
    set columns=160 lines=46 " GUI window geometry
endif

" Let me choose the statusbar
let g:vorax_output_force_overwrite_status_line = 0

function! VoraxOutputFlags()
  let funnel = ["", "VERTICAL", "PAGEZIP", "TABLEZIP"][vorax#output#GetFunnel()]
  let append = g:vorax_output_window_append ? "APPEND" : ""
  let sticky = g:vorax_output_window_sticky_cursor ? "STICKY" : ""
  let heading = g:vorax_output_full_heading ? "HEADING" : ""
  let top = g:vorax_output_cursor_on_top ? "TOP" : ""
  return join(filter([funnel, append, sticky, heading, top], 'v:val != ""'), ' ')
endfunction

function! VoraxAirPlugin(...)
  let session = '%{vorax#sqlplus#SessionOwner()}'
  let txn = '%{vorax#utils#IsOpenTxn() ? "!" . g:vorax_output_txn_marker : ""}'
  if vorax#utils#IsVoraxBuffer()
    let w:airline_section_b = get(w:, 'airline_section_b', g:airline_section_b) . session
    let w:airline_section_warning = get(w:, 'airline_section_warning', g:airline_section_warning) . txn
  endif
  if &ft == 'outputvorax'
    let lrows = '%{exists("g:vorax_limit_rows") ? " [LIMIT ROWS <=" . g:vorax_limit_rows . "] " : ""}'
    let w:airline_section_a = '%{vorax#utils#Throbber()}'
    let w:airline_section_b = airline#section#create_left([session])
    let w:airline_section_c = 'Output window'
    let w:airline_section_x = ''
    let w:airline_section_y = g:airline_section_z
    let w:airline_section_z = airline#section#create(["%{VoraxOutputFlags()}"])
    let w:airline_section_warning = get(w:, 'airline_section_warning', g:airline_section_warning)
    let w:airline_section_warning .= airline#section#create([lrows, txn])
  elseif (&ft == 'connvorax') || (&ft == 'explorervorax') || (&ft == 'oradocvorax')
    let w:airline_section_a = ''
    let w:airline_section_b = ''
    let w:airline_section_c = (&ft == 'connvorax' ? 'Connection Profiles' : &ft == 'explorervorax' ? 'DB Explorer' : 'Oracle Documentation')
    let w:airline_section_x = ''
    let w:airline_section_y = ''
    let w:airline_section_z = ''
  endif
endfunction
call airline#add_statusline_func('VoraxAirPlugin')

" Let the statusbar as it is for inactive windows
let g:airline_inactive_collapse=0

