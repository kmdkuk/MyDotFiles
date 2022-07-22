" dein settings
if &compatible
  set nocompatible
endif
" dein.vimのディレクトリ
let s:dein_dir = expand('~/.vim/bundle')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
let g:dein#types#git#clone_dept = 1

if !isdirectory(s:dein_repo_dir)
  execute '!git clone --depth=1 https://github.com/Shougo/dein.vim' s:dein_repo_dir
endif
execute 'set  runtimepath^=' . s:dein_repo_dir

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  call dein#add('Shougo/dein.vim')

  call dein#add('tomasr/molokai')
  call dein#add('cocopon/iceberg.vim')
  call dein#add('gkeep/iceberg-dark')

  call dein#add('mechatroner/rainbow_csv')

  " ファイル構造見れるやつ
  call dein#add('scrooloose/nerdtree')

  " 補完
  call dein#add('prabirshrestha/vim-lsp')
  call dein#add('prabirshrestha/async.vim')
  call dein#add('prabirshrestha/asyncomplete.vim')
  call dein#add('prabirshrestha/asyncomplete-lsp.vim')

  " status line
  call dein#add('vim-airline/vim-airline')
  call dein#add('vim-airline/vim-airline-themes')
  call dein#add('ryanoasis/vim-devicons')

  " インデントの可視化
  call dein#add( 'Yggdroot/indentLine')
  " 末尾の全角半角空白文字を赤くハイライト
  call dein#add( 'bronson/vim-trailing-whitespace')
  " インデントに色を付けて見やすくする
  call dein#add( 'nathanaelkane/vim-indent-guides')


  " Rails向けのコマンドを提供する
  call dein#add( 'tpope/vim-rails')
  " Ruby向けにendを自動挿入してくれる
  call dein#add( 'tpope/vim-endwise')

  " for clang-format
  call dein#add('rhysd/vim-clang-format')

  " for dart and flutter
  call dein#add('dart-lang/dart-vim-plugin')
  call dein#add('thosakwe/vim-flutter')

  " for git
  call dein#add('airblade/vim-gitgutter')
  call dein#add('tpope/vim-fugitive')

  " 閉じカッコなど補完
  call dein#add('mattn/vim-lexiv')

  " テキストを囲む
  call dein#add('tpope/vim-surround')

  call dein#end()
  call dein#save_state()
endif

" もし、未インストールものものがあったらインストール
if dein#check_install()
  silent! call dein#install()
endif

" ノーマルモード時だけ ; と : を入れ替える
nnoremap ; :
nnoremap : ;

" Split window
nnoremap ss :split<Return><C-w>w
nnoremap sv :vsplit<Return><C-w>w
" Move window
noremap sh <C-w>h
noremap sk <C-w>k
noremap sj <C-w>j
noremap sl <C-w>l
" Switch tab
nnoremap <S-Tab> :tabprev<Return>
nnoremap <Tab> :tabnext<Return>


" language server protocol shortcut
" leaderはデフォルトでバックスラッシュ,
" 自由に設定ができる
let mapleader=","
nnoremap <Leader>a :echo "Hello"<CR>
nnoremap <Leader>d :LspDefinition<CR>
nnoremap <Leader>h :LspHover<CR>
nnoremap <Leader>r :LspReferences<CR>
nnoremap <Leader>i :LspImplementation<CR>
nnoremap <Leader>n :LspNextError<CR>
nnoremap <Leader>s :split \| :LspDefinition <CR>
nnoremap <Leader>v :vsplit \| :LspDefinition <CR>
"
" ファイルバッファの前後に行く
nnoremap bp :bprevious<CR>
nnoremap bn :bnext<CR>

" asyncomplete
" set completeopt+=preview

" setting for airline
let g:airline_theme = 'icebergDark'
set laststatus=2
let g:airline_mode_map = {
  \ 'n'  : 'Normal',
  \ 'i'  : 'Insert',
  \ 'R'  : 'Replace',
  \ 'c'  : 'Command',
  \ 'v'  : 'Visual',
  \ 'V'  : 'V-Line',
  \ '⌃V' : 'V-Block',
  \ }

" airline symbols
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.crypt = '🔒'

let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#buffer_idx_format = {
  \ '0': '0 ',
  \ '1': '1 ',
  \ '2': '2 ',
  \ '3': '3 ',
  \ '4': '4 ',
  \ '5': '5 ',
  \ '6': '6 ',
  \ '7': '7 ',
  \ '8': '8 ',
  \ '9': '9 '
  \}
let g:airline#extensions#wordcount#enabled = 0
let g:airline#extensions#default#layout = [['a', 'b', 'c'], ['x', 'y', 'z', 'error', 'warning']]
" let g:airline_section_c = '%t'
" let g:airline_section_x = '%{&filetype}'
" let g:airline_section_z = '%3l:%2v %{airline#extensions#ale#get_warning()} %{airline#extensions#ale#get_error()}'
let g:airline#extensions#ale#error_symbol = ' '
let g:airline#extensions#ale#warning_symbol = ' '
let g:airline#extensions#default#section_truncate_width = {}
let g:airline#extensions#whitespace#enabled = 1
let g:airline_powerline_fonts = 1

" lsp clangd settings
" let g:lsp_log_verbose = 1
" let g:lsp_log_file = expand('~/vim-lsp.log')
let g:lsp_signs_enabled = 1         " enable signs
let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode
let g:lsp_signs_error = {'text': ' '}
let g:lsp_signs_warning = {'text': ' '}
let g:lsp_signs_hint = {'text': ''}

if executable('clangd')
    augroup lsp_clangd
        autocmd!
        autocmd User lsp_setup call lsp#register_server({
                    \ 'name': 'clangd',
                    \ 'cmd': {server_info->['clangd']},
                    \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
                    \ })
        autocmd FileType c setlocal omnifunc=lsp#complete
        autocmd FileType cpp setlocal omnifunc=lsp#complete
        autocmd FileType objc setlocal omnifunc=lsp#complete
        autocmd FileType objcpp setlocal omnifunc=lsp#complete
    augroup end
endif

autocmd FileType c ClangFormatAutoEnable
autocmd FileType cpp ClangFormatAutoEnable
autocmd FileType objc ClangFormatAutoEnable
autocmd FileType objcpp ClangFormatAutoEnable

if executable('bash-language-server')
  au User lsp_setup call lsp#register_server({
        \ 'name': 'bash-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'bash-language-server start']},
        \ 'whitelist': ['sh'],
        \ 'ignoredRootPaths': ['~'],
        \ })
endif

if executable('solargraph')
    " gem install solargraph
    au User lsp_setup call lsp#register_server({
        \ 'name': 'solargraph',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'solargraph stdio']},
        \ 'whitelist': ['ruby'],
        \ })
endif

if executable('typescript-language-server')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'typescript-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tsconfig.json'))},
        \ 'whitelist': ['typescript', 'typescript.tsx'],
        \ })
endif

if executable('gopls')
  augroup LspGo
    au!
    autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'go-lang',
        \ 'cmd': {server_info->['gopls', '-mode', 'stdio']},
        \ 'whitelist': ['go'],
        \ })
    autocmd FileType go setlocal omnifunc=lsp#complete
  augroup END
endif

" NERDTree settings
noremap <C-n> :NERDTreeToggle<CR>
let g:NERDTreeDirArrows = 1
let g:NERDTreeDirArrowExpandable  = '▶'
let g:NERDTreeDirArrowCollapsible = '▼'

" setting
"文字コードをUFT-8に設定
set fenc=utf-8
set encoding=utf-8
" バックアップファイルを作らない
set nobackup
" スワップファイルを作らない
set noswapfile
" 編集中のファイルが変更されたら自動で読み直す
set autoread
" バッファが編集中でもその他のファイルを開けるように
set hidden
" 入力中のコマンドをステータスに表示する
set showcmd


" 見た目系
" 行番号を表示
set number
" カーソル位置の行数と列を表示
set ruler
" 現在の行を強調表示
set cursorline
" 行末の1文字先までカーソルを移動できるように
set virtualedit=onemore
" インデントはスマートインデント
set smartindent
" ビープ音を可視化
set visualbell
" 括弧入力時の対応する括弧を表示
set showmatch
" ステータスラインを常に表示
set laststatus=2
" コマンドラインの補完
set wildmode=list:longest
" 折り返し時に表示行単位での移動できるようにする
nnoremap j gj
nnoremap k gk
" シンタックスハイライトの有効化
syntax enable
" colorscheme molokai
colorscheme iceberg
set t_Co=256

" Tab系
" 不可視文字を可視化(タブが「▸-」と表示される)
set list listchars=tab:\▸\-
" Tab文字を半角スペースにする
set expandtab
" 行頭以外のTab文字の表示幅（スペースいくつ分）
set tabstop=2
" 行頭でのTab文字の表示幅
set shiftwidth=2


" 検索系
" 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase
" 検索文字列に大文字が含まれている場合は区別して検索する
set smartcase
" 検索文字列入力時に順次対象文字列にヒットさせる
set incsearch
" 検索時に最後まで行ったら最初に戻る
set wrapscan
" 検索語をハイライト表示
set hlsearch
" ESC連打でハイライト解除
nmap <Esc><Esc> ;nohlsearch<CR><Esc>

set backspace=indent,eol,start

" ファイル形式の検出の有効化する
" ファイル形式別プラグインのロードを有効化する
" ファイル形式別インデントのロードを有効化する
filetype plugin indent on

if has('vim_starting')
  " 挿入モード時に非点滅の縦棒タイプのカーソル
  let &t_SI .= "\e[6 q"
  " ノーマルモード時に非点滅のブロックタイプのカーソル
  let &t_EI .= "\e[2 q"
  " 置換モード時に非点滅の下線タイプのカーソル
  let &t_SR .= "\e[4 q"
endif

au BufNewFile,BufRead Dockerfile* setf Dockerfile
set clipboard+=unnamed

" undo 永続化
silent !mkdir -p ~/.vim/undo >/dev/null 2>&1
if has('persistent_undo')
  set undodir=~/.vim/undo
  set undofile
endif
