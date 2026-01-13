#Requires AutoHotkey v2.0

; --------------------------------------------------------------
; 管理者権限で実行されていない場合、自動的に管理者として再実行する
; (VS Codeなどの強い権限のアプリで操作を有効にするため)
; --------------------------------------------------------------
if not A_IsAdmin {
    try
    {
        Run "*RunAs `"" A_ScriptFullPath "`""
    }
    ExitApp
}

; Win + R → shell:startup にリンクを配置する
; 以下サイトから参考
; http://www6.atwiki.jp/eamat/pages/17.html
; https://qiita.com/lx-sasabo/items/889172f28a1aaa3fded5
IME_SET(SetSts, WinTitle := "A") {
    if !(hWnd := WinExist(WinTitle))
        return

    if (WinActive(WinTitle)) {
        ptrSize := A_PtrSize
        cbSize := 48 + (ptrSize * 6)
        stGTI := Buffer(cbSize, 0)
        NumPut("UInt", cbSize, stGTI)
        if DllCall("GetGUIThreadInfo", "UInt", 0, "Ptr", stGTI) {
            hFocus := NumGet(stGTI, 8 + ptrSize, "Ptr")
            if (hFocus)
                hWnd := hFocus
        }
    }

    return DllCall("SendMessage"
        , "Ptr", DllCall("imm32\ImmGetDefaultIMEWnd", "Ptr", hWnd, "Ptr")
        , "UInt", 0x0283 ;Message : WM_IME_CONTROL
        , "Ptr", 0x006  ;wParam  : IMC_SETOPENSTATUS
        , "Ptr", SetSts) ;lParam  : 0 or 1
}

~Esc:: IME_SET(0)
~^[:: IME_SET(0)

; --------------------------------------------------------------
; HHKB US配列用: WindowsキーのDual Role化
; 単押し: 無変換(vk1D) / 変換(vk1C)
; 長押し/同時押し: Windowsキー (ショートカット用)
; --------------------------------------------------------------

; --- 左Windowsキー (LWin) ---
; ~ を付けて元のキー機能を活かしつつ、
; {Blind}{vkE8} を送ることで「スタートメニュー」の起動を阻止します
~LWin:: Send "{Blind}{vkE8}"

~LWin Up::
{
    ; 直前のキーが LWin または マスク用キー(vkE8) だった場合のみ実行
    if (A_PriorKey = "LWin" || A_PriorKey = "vkE8") {
        Send "{vk1D}" ; 無変換 (IME設定で「IMEオフ」に割り当て)
    }
    return
}

; --- 右Windowsキー (RWin) ---
~RWin:: Send "{Blind}{vkE8}"

~RWin Up::
{
    if (A_PriorKey = "RWin" || A_PriorKey = "vkE8") {
        Send "{vk1C}" ; 変換 (IME設定で「IMEオン」に割り当て)
    }
    return
}

; --------------------------------------------------------------
; SandS (Space and Shift)
; 単押し: Space
; 長押し/同時押し: Shift
; --------------------------------------------------------------
press := 0     ; スペースキーを押しているかどうか。
shifted := 0   ; スペースキー押下中に何かの印字可能文字を押したかどうか。
pressedAt := 0 ; スペースキーを押した時間（msec）。
timeout := 300 ; pressedAt からこの時間が経過したら、もはや離したときにもスペースを発射しない。

hook := InputHook() ; スペースキー押下中に何かの印字可能文字を押したかどうか捕捉するフック。

$*Space:: {
    global
    SendInput "{Shift Down}"
    if (press = 1) {
        return
    }
    shifted := 0
    press := 1
    pressedAt := A_TickCount

    ; 何かのキーが押されたことを検知する
    ; L1 はフックする文字数の上限を 1 にする
    ; V はフックした入力をブロックしない
    ; デフォルトで印字可能文字のみフックされる
    hook := InputHook("L1 V")

    ; 一文字待機し、待機中にスペースを離したとき以外、
    ; シフト済みにする
    hook.Start()
    if (hook.Wait() != "Stopped") {
        shifted := 1
    }
}

$*Space up:: {
    global
    SendInput "{Shift Up}"
    press := 0

    ; 待機キャンセル
    hook.Stop()

    ; 一定時間経過していたらスペースを発射しない
    if (A_TickCount - pressedAt > timeout) {
        return
    }

    ; シフト済みでなければスペースを発射する
    ; 先に押してあるモディファイアキーと組み合わせられるように {Blind} をつける
    if (shifted == 0) {
        SendInput "{Blind}{Space}"
    }
}
