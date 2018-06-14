" dein settings {{{
if &compatible
  set nocompatible
endif
" dein.vimのディレクトリ
let s:dein_dir = expand('~/.vim/bundle')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" なければgit clone
if !isdirectory(s:dein_repo_dir)
  execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
endif
execute 'set runtimepath^=' . s:dein_repo_dir

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  call dein#add('Shougo/dein.vim')
  call dein#add('Shougo/neocomplcache.vim')
  call dein#add('Shougo/neocomplcache-rsense.vim')

  " Add or remove your plugins here:
  call dein#add('Shougo/neosnippet.vim')
  call dein#add('Shougo/neosnippet-snippets')
  " カラースキームmolokai
  call dein#add( 'tomasr/molokai')
  " ステータスラインの表示内容強化
  call dein#add( 'itchyny/lightline.vim')
  " インデントの可視化
  call dein#add( 'Yggdroot/indentLine')
  " 末尾の全角半角空白文字を赤くハイライト
  call dein#add( 'bronson/vim-trailing-whitespace')
  " 構文エラーチェック
  call dein#add( 'scrooloose/syntastic')
  " 多機能セレクタ
  call dein#add( 'ctrlpvim/ctrlp.vim')
  " CtrlPの拡張プラグイン. 関数検索
  call dein#add( 'tacahiroy/ctrlp-funky')
  " CtrlPの拡張プラグイン. コマンド履歴検索
  call dein#add( 'suy/vim-ctrlp-commandline')
  " CtrlPの検索にagを使う
  call dein#add( 'rking/ag.vim')
  " プロジェクトに入ってるESLintを読み込む
  call dein#add( 'pmsorhaindo/syntastic-local-eslint.vim')
  " 静的解析
  call dein#add( 'scrooloose/syntastic')

  " ドキュメント参照
  call dein#add( 'thinca/vim-ref')
  call dein#add( 'yuku-t/vim-ref-ri')

  " メソッド定義元へのジャンプ
  call dein#add( 'szw/vim-tags')

  " ファイルをtree表示
  call dein#add( 'scrooloose/nerdtree')

  " Rails向けのコマンドを提供する
  call dein#add( 'tpope/vim-rails')
  " Ruby向けにendを自動挿入してくれる
  call dein#add( 'tpope/vim-endwise')

  " インデントに色を付けて見やすくする
  call dein#add( 'nathanaelkane/vim-indent-guides')

  "ruby
  call dein#add('vim-ruby/vim-ruby')

  " You can specify revision/branch/tag.
  call dein#add('Shougo/vimshell', { 'rev': '3787e5' })

" vimのlua機能が使える時だけ以下のVimプラグインをインストールする
if has('lua')
  " コードの自動補完
  call dein#add( 'Shougo/neocomplcache.vim')
  " スニペットの補完機能
  call dein#add( "Shougo/neosnippet")
  " スニペット集
  call dein#add( 'Shougo/neosnippet-snippets')
endif

  call dein#end()
  call dein#save_state()
endif

" その他インストールしていないものはこちらに入れる
if dein#check_install()
  call dein#install()
endif
" }}}

" -------------------------------
" Rsense
" -------------------------------
let g:rsenseHome = '/User/kouki/.rbenv/shims/rsense'
let g:rsenseUseOmniFunc = 1

" neocomplcacheの設定
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0

" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1

" Use smartcase.
let g:neocomplcache_enable_smart_case = 1

" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_underbar_completion = 1

" Rsense用の設定
if !exists('g:neocomplcache_omni_patterns')
    let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete

" --------------------------------
" rubocop
" --------------------------------
" syntastic_mode_mapをactiveにするとバッファ保存時にsyntasticが走る
" active_filetypesに、保存時にsyntasticを走らせるファイルタイプを指定する
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': ['ruby'] }
let g:syntastic_ruby_checkers = ['rubocop']


"----------------------------------------------------------
" カラースキーム
"----------------------------------------------------------
colorscheme molokai " カラースキームにmolokaiを設定する
set t_Co=256 " iTerm2など既に256色環境なら無くても良い
syntax enable " 構文に色を付ける


set encoding=utf-8
set nobackup
set noswapfile
set hidden
set showcmd
syntax on

set number
set cursorline
set virtualedit=onemore
set smartindent
set visualbell
set showmatch
set laststatus=2
set wildmode=list:longest
nnoremap j gj
nnoremap k gk

set list listchars=tab:\▸\-
set expandtab
set tabstop=2
set shiftwidth=2

set ignorecase
set smartcase
set incsearch
set wrapscan
set hlsearch

" 新しい行を開始したとき、新しい行のインデントを現在行と同じにする
set autoindent

" ファイル形式の検出の有効化する
" ファイル形式別プラグインのロードを有効化する
" ファイル形式別インデントのロードを有効化する
filetype plugin indent on

nmap <ESC><ESC> :nohlsearch<CR><ESC>

if has('vim_starting')
  " 挿入モード時に非点滅の縦棒タイプのカーソル
  let &t_SI .= "\e[6 q"
  " ノーマルモード時に非点滅のブロックタイプのカーソル
  let &t_EI .= "\e[2 q"
  " 置換モード時に非点滅の下線タイプのカーソル
  let &t_SR .= "\e[4 q"
endif

" カッコ、クォート補完
inoremap { {}<LEFT>
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>
vnoremap { "zdi^V{<C-R>z}<ESC>
vnoremap [ "zdi^V[<C-R>z]<ESC>
vnoremap ( "zdi^V(<C-R>z)<ESC>
vnoremap " "zdi^V"<C-R>z^V"<ESC>
vnoremap ' "zdi'<C-R>z'<ESC>

set backspace=indent,eol,start
