#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
#Persistent
SetTitleMatchMode, 2 ; match start of the title

SetTimer, checkTime, 30000
SetTimer, checkIfStillRunning, 10000
StartTime := 1528
StopTime := 1530
streaming := 0
obsPath := "C:\Program Files (x86)\obs-studio\bin\32bit\obs32.exe"

RunOBS(obsPath) {
    Run %obsPath%
    Sleep, 10000
    WinMinimize OBS
    Sleep, 500
    ControlSend,,{F9},ahk_class Qt5QWindowIcon ; Go to right scene
    Sleep, 500
    ControlSend,,{F10},ahk_class Qt5QWindowIcon  ;starts the stream
    WinMinimize OBS
}
CheckIfOBSIsRunning(obsPath) {
    Process, Exist, obs32.exe
    if !ErrorLevel {
        RunOBS(obsPath)
    } else {
        Process, Close, obs32.exe
        Sleep, 1000
        RunOBS(obsPath)
    }
}
checkTime:
time := A_Hour . A_Min
If (time = StartTime && !streaming) {
    streaming := 1
    CheckIfOBSIsRunning(obsPath)
    TrayTip STREAMING, Streaming lance jusque minuit
}
If (time = StopTime && streaming) {
    streaming := 0
    ControlSend,,{F12},ahk_class Qt5QWindowIcon  ;stop the stream
    TrayTip STREAMING, Arret du stream
    Sleep, 2000
    Process, Close, obs32.exe
}
return
checkIfStillRunning:
If (streaming) {
    Sleep, 100
    Process, Exist, obs32.exe
    if !ErrorLevel {
        RunOBS(obsPath)
    }
}
return