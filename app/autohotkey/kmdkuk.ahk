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
$Space::
{
    ; 既にShiftが押されている状態（＝キーリピート信号）なら何もしない
    if GetKeyState("LShift")
        return

    ; Space押下直後の入力を監視 (0.15秒)
    ; この間に他のキーが押されたら、ShiftではなくSpace+そのキーとして扱う
    ih := InputHook("L1 T0.15") 
    ih.KeyOpt("{All}", "E")
    ih.Start()

    ; Spaceが離されるのを監視
    while (ih.InProgress) {
        if !GetKeyState("Space", "P") {
            ih.Stop()
            break
        }
        Sleep 1
    }

    if (ih.EndKey != "") {
        ; 待機中にキー入力あり -> Space + そのキー
        Send "{Space}"
        Send "{Blind}{" ih.EndKey "}"
    } 
    else if (ih.Reason = "Timeout") {
        ; タイムアウト＝長押し判定 -> Shiftモード
        Send "{LShift Down}"
        KeyWait "Space"
        Send "{LShift Up}"
    } 
    else {
        ; Space単打ち
        Send "{Space}"
    }
}
