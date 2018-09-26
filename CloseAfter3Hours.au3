AdlibRegister('close', 1004440)

Func close()
    AdlibUnRegister('close')
    If ProcessExists("hl2.exe") Then
        ProcessClose("hl2.exe")
    EndIf
EndFunc