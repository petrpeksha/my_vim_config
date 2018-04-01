source $VIMRUNTIME/mswin.vim
behave mswin

autocmd FileType sql let b:vimpipe_command="sqlplus -s /"

set nocompatible
set encoding=utf-8
set history=9999     " big old history
set number           " turn on line numbers
set numberwidth=5    " We are good up to 99999 lines
set tabstop=4        " set tabulator length to 4 columns
set nowrap           " do not wrap line
set showcmd          " show command in bottom bar
set cursorline       " highlight current line
set showmatch        " highlight matching [{()}]
set guioptions+=b    " horizontal scrollbar
set backspace=2 " make backspace work like most other apps
set hlsearch

 " Backup settings
set backup
set backupdir=C:\\Temp
set dir=C:\\Temp

" Smart tabs
set noexpandtab
set autoindent
set cindent
set copyindent
set preserveindent
set softtabstop=0
set shiftwidth=4
set tabstop=4

" font
if has('gui_running')
  set guifont=Courier_New:h10
endif

let mapleader=","    " leader is comma

filetype plugin on

colorscheme sourcerer

syntax on
filetype on
au BufNewFile,BufRead *.sql set filetype=plsql
au BufNewFile,BufRead *.trg set filetype=plsql
au BufNewFile,BufRead *.pck set filetype=plsql
au BufNewFile,BufRead *.tps set filetype=plsql
au BufNewFile,BufRead *.tpb set filetype=plsql
au BufNewFile,BufRead *.vim set filetype=vim

map <F2> aSELECT * FROM 
map <F3> aDBMS_OUTPUT.PUT_LINE('


" tuning for gVim only
if has('gui_running')
    set columns=160 lines=46 " GUI window geometry
    set number " show line numbers
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

