#!/usr/bin/env perl

$latex                         = 'uplatex %O -synctex=1 -interaction=nonstopmode %S';
$pdflatex                      = 'pdflatex %O -synctex=1 -interaction=nonstopmode %S';
$lualatex                      = 'lualatex %O -synctex=1 -interaction=nonstopmode %S';
$xelatex                       = 'xelatex %O -no-pdf -synctex=1 -shell-escape -interaction=nonstopmode %S';
$biber                         = 'biber %O --bblencoding=utf8 -u -U --output_safechars %B';
$bibtex                        = 'upbibtex %O %B';
$makeindex                     = 'upmendex %O -o %D %S';
$dvipdf                        = 'dvipdfmx %O -f ptex-ipaex.map -o %D %S';
$dvips                         = 'dvips %O -z -f %S | convbkmk -u > %D';
$ps2pdf                        = 'ps2pdf %O %S %D';
$pdf_mode                      = 3;
# macOS の場合のみの設定
if ($^O eq 'darwin') {
  # 一時ファイルの作成を抑止するオプション(0: 抑止)
  # Skim 等の変更検知機構のあるビュアーで変更箇所を検知できるようにするため
  $pvc_view_file_via_temporary = 0;
  # PDF ビュアーの設定 for macOS
  # macOS では SyncTeX が利用できる Skim が推奨されている。
  $pdf_previewer               = 'open -ga /Applications/Skim.app';
} else {
  # PDF ビュアーの設定 for Linux
  # Linux ではディストリビューションによってインストールされているアプリケーションが
  # 異なるため、ディストリビューションに依存しない xdg-open で開くようにする
  $pdf_previewer               = 'xdg-open';
}
