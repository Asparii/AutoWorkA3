Global $UnPaused
HotKeySet("1", "TogglePause")
HotKeySet("{ESC}", "Terminate")

While 1
    Sleep(100)
    ToolTip("Rave offline",0,0)
WEnd

Func TogglePause()
    $UnPaused = NOT $UnPaused
    While $UnPaused
        ToolTip("R A V E",0,0)
        Send("m")
    WEnd
EndFunc

Func Terminate()
    Exit 0
EndFunc