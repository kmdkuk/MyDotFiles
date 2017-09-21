"----------------------------------------------------------
" NeoBundle
"----------------------------------------------------------
if has('vim_starting')
  "初回起動時のみruntimepathにNeoBundleのパスを指定する
  set runtimepath+=~/.vim/bundle/neobundle.vim/

  " NeoBundleが未インストールであればgit cloneする
  if !isdirectory(expand("~/.vim/bundle/neobundle.vim/"))
    echo "install NeoBundle..."
    :call system("git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim")
    endif
endif

call neobundle#begin(expand('~/.vim/bundle/'))

" インストールするVimプラグインを以下に記述
" NeoBundle自身を管理
NeoBundleFetch 'Shougo/neobundle.vim'
" カラースキームmolokai
NeoBundle 'tomasr/molokai'
" ステータスラインの表示内容強化
NeoBundle 'itchyny/lightline.vim'
" インデントの可視化
NeoBundle 'Yggdroot/indentLine'
" 末尾の全角半角空白文字を赤くハイライト
NeoBundle 'bronson/vim-trailing-whitespace'
" 構文エラーチェック
NeoBundle 'scrooloose/syntastic'
" 多機能セレクタ
NeoBundle 'ctrlpvim/ctrlp.vim'
" CtrlPの拡張プラグイン. 関数検索
NeoBundle 'tacahiroy/ctrlp-funky'
" CtrlPの拡張プラグイン. コマンド履歴検索
NeoBundle 'suy/vim-ctrlp-commandline'
" CtrlPの検索にagを使う
NeoBundle 'rking/ag.vim'
" プロジェクトに入ってるESLintを読み込む
NeoBundle 'pmsorhaindo/syntastic-local-eslint.vim'
" vimのlua機能が使える時だけ以下のVimプラグインをインストールする
if has('lua')
  " コードの自動補完
  NeoBundle 'Shougo/neocomplete.vim'
  " スニペットの補完機能
  NeoBundle "Shougo/neosnippet"
  " スニペット集
  NeoBundle 'Shougo/neosnippet-snippets'
endif

call neobundle#end()

" ファイルタイプ別のVimプラグイン/インデントを有効にする
filetype plugin indent on

" 未インストールのVimプラグインがある場合、インストールするかどうかを尋ねてくれるようにする設定
NeoBundleCheck

"----------------------------------------------------------
" カラースキーム
"----------------------------------------------------------
if neobundle#is_installed('molokai')
  colorscheme molokai " カラースキームにmolokaiを設定する
endif
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

nmap <ESC><ESC> :nohlsearch<CR><ESC>

if has('vim_starting')
    " 挿入モード時に非点滅の縦棒タイプのカーソル
    let &t_SI .= "\e[6 q"
    " ノーマルモード時に非点滅のブロックタイプのカーソル
    let &t_EI .= "\e[2 q"
    " 置換モード時に非点滅の下線タイプのカーソル
    let &t_SR .= "\e[4 q"
endif
