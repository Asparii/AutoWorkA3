$clickBot = False
Global $hasLooped = False
Global $paused = True
Global $tickRate = 15000 ;time that it takes to burn all your force, if you're meditating, just set it to however long you want to meditate for.
Global $counter = 0
Global $xpCounter = 0
Global $lvCounter = 0
Global $meditateOnly = False ;false = True
Global $seconds = 0
Global $minutes = 0 + $seconds/60
Global $hours = 0 + $minutes/60
;Edit this stuff below to your needs
$debugEnabled = True
$jumpEnabled = False
$meditateEnabled = True ;use this for force leveling
$duckEnabled = True
$rightEnabled = False
$forceKey = 2


Func trooperToolTip()
    $xpCounter += 1.04 ;Accurate to Troopers, assuming overhead swing 3
    $lvCounter = $xpCounter/100 ;No longer sure
    $seconds += .2
   If $seconds > 60 Then
      $seconds = 0
      $minutes += 1
   EndIf
   If $minutes > 60 Then
      $minutes = 0
      $hours += 1
   EndIf

    if $paused Then
        ToolTip("Unactive" & @CRLF & "---------------------" & @CRLF & @CRLF & "Time: " & Round($hours,0) & ":" & Round($minutes,0) & ":" & Round($Seconds,0) & @CRLF &"AVG LVs Earned: " & Round($lvCounter,2) & @CRLF & "Ticks: " & $counter  & @CRLF & "AVG XP Earned: " & Round($xpCounter,2), 0, 0, "JvS Script", 0)
    Else
        ToolTip("Active" & @CRLF & "---------------------" & @CRLF & @CRLF & "Time: " & Round($hours,0) & ":" & Round($minutes,0) & ":" & Round($Seconds,0) & @CRLF & "AVG LVs Earned: " & Round($lvCounter,2) & @CRLF & "Ticks: " & $counter & @CRLF & "AVG XP Earned: " & Round($xpCounter,2), 0, 0, "JvS Script", 0)
    EndIf
EndFunc

Func meditateToolTip()
    $xpCounter += 1.04 ;
    $lvCounter = $xpCounter/100 ;No longer sure
    $seconds += .2
   If $seconds > 60 Then
      $seconds = 0
      $minutes += 1
   EndIf
   If $minutes > 60 Then
      $minutes = 0
      $hours += 1
   EndIf

    if $paused Then
        ToolTip("Unactive" & @CRLF & "---------------------" & @CRLF & @CRLF & "Time: " & Round($hours,0) & ":" & Round($minutes,0) & ":" & Round($Seconds,0) & @CRLF &"AVG LVs Earned: " & Round($lvCounter,2) & @CRLF & "Ticks: " & $counter  & @CRLF & "AVG XP Earned: " & Round($xpCounter,2), 0, 0, "JvS Script", 0)
    Else
        ToolTip("Active" & @CRLF & "---------------------" & @CRLF & @CRLF & "Time: " & Round($hours,0) & ":" & Round($minutes,0) & ":" & Round($Seconds,0) & @CRLF & "AVG LVs Earned: " & Round($lvCounter,2) & @CRLF & "Ticks: " & $counter & @CRLF & "AVG XP Earned: " & Round($xpCounter,2), 0, 0, "JvS Script", 0)
    EndIf
EndFunc

Func clickBot()

    If Not $paused Then
        $paused = True
        ;stop everything from running
        $clickBot = False
        $hasLooped = False
        trooperToolTip()
    Else
        $paused = False
        $clickBot = True
    EndIf

    If $meditateEnabled Then
        Call("meditate")
    Else
        Local $i = 0
        Do
            If $clickBot Then ;break the loop if the function gets called again
                ControlClick("Garry's Mod", "", "", "left", 1, 0, 0) ;Set this to whichever click you want it to do. left or right
                If $jumpEnabled Then
                    ControlSend("Garry's Mod", "", "", "{SPACE}") ;jump - this is nice for leveling endurance
                EndIf
                Sleep(100)
                $counter += 1 ;per second
                meditateToolTip()
                $i += 1
            Else
                Return
            EndIf
        Until $i = 5000000 ;Set this if you want it to stop after a certain amount of clicks
    EndIf

EndFunc   ;==>clickBot

Func meditate()
    While $clickBot
        AutoItSetOption("SendKeyDelay", 75)
        ControlSend("Garry's Mod", "", "", "`{NUMPADADD}attack2{ENTER}", 0) ;open console, types +attack2

        if $duckEnabled then
            Sleep(25)
            ControlSend("Garry's Mod", "", "", "{NUMPADADD}duck{ENTER}") ;enable duck
        EndIf
        if $rightEnabled Then
            Sleep(25)
            ControlSend("Garry's Mod", "", "", "{NUMPADADD}right{ENTER}") ;enable right
        EndIf

        Sleep(25)
        ControlSend("Garry's Mod", "", "", "`", 0) ;close console

        Local $i = 0
        Do
            If $clickBot Then ;break the loop if the function gets called again
                ControlClick("Garry's Mod", "", "", "left", 1, 0, 0) ;If  you want to left click during auto clicking, uncomment this.
                if not $meditateOnly then
                    ControlSend("Garry's Mod", "", "", "f",1)
                EndIf
                If $jumpEnabled Then
                    ControlSend("Garry's Mod", "", "", "{SPACE}") ;jump - this is nice for leveling endurance
                EndIf
                Sleep(200)
                $counter += 1 ;per second
                meditateToolTip()
                $i += 1
            Else
                ControlSend("Garry's Mod", "", "", "`{NUMPADSUB}attack2{ENTER}") ;open console, types -attack2
                if $duckEnabled then
                    Sleep(100)
                    ControlSend("Garry's Mod", "", "", "{NUMPADSUB}duck{ENTER}") ;disable duck
                EndIf
                if $rightEnabled Then
                    Sleep(100)
                    ControlSend("Garry's Mod", "", "", "{NUMPADSUB}right{ENTER}") ;disable right
                EndIf
                Sleep(50)
                ControlSend("Garry's Mod", "", "", "`") ;close console and presses stop sound keybind
                meditateToolTip()
                $counter = 0
                Return
            EndIf
        Until $i = $tickRate
        If Not $meditateOnly Then
            ;after do statement, go to console and disable attack2
            AutoItSetOption("SendKeyDelay", 75)
            ControlSend("Garry's Mod", "", "", "`{NUMPADSUB}attack2{ENTER}`") ;open console, types -attack2
            AutoItSetOption("SendKeyDelay", 250);set key delay to press f
			;check until we are on meditate again

            AutoItSetOption("SendKeyDelay", 75);sets key delay for typing
            ControlSend("Garry's Mod", "", "", "`{NUMPADADD}attack2{ENTER}`") ;open console, types +attack2
            Sleep(10000) ;10 seconds -- Change if it doesnt fill up your Force bar completely.

            ControlSend("Garry's Mod", "", "", "`{NUMPADSUB}attack2{ENTER}`") ;open console, types -attack2
            Sleep(5000);wait for meditation to stop
            AutoItSetOption("SendKeyDelay", 250);set key delay to press f
            ;switch to force power
            Local $i = 0
            Do
                ControlSend("Garry's Mod", "", "", "f")
                $i += 1
            Until $i = $forceKey + 1 ;amount of times to press f to get back to force power -- for some reason we need to do a +1... Idk why
        EndIf
        Call("meditate")
    WEnd
EndFunc   ;==>meditate

Func exitScript()
    Exit
EndFunc   ;==>exitScript


While 1

    HotKeySet("{F11}", "clickBot") ;Hotkey to start/stop auto clicking
    HotKeySet("{F10}", "exitScript") ;exit script

WEnd