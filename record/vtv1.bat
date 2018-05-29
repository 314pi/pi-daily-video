@echo off
:: THIET LAP THONG SO CO DINH
set hetgio=21:30:00,00
set pruntime=--run-time 4200
:: Set Stream Segments
set hls_seg=%1
if [%hls_seg%]==[] set hls_seg=10
:: Set Play Before Quit
set /a pbq=1

::==================================================================================
set vlcpath=C:\Program Files\VideoLAN\VLC\vlc.exe
if not exist "%vlcpath%" set vlcpath=C:\Program Files (x86)\VideoLAN\VLC\vlc.exe
if not exist "%vlcpath%" set /p vlcpath=Enter VLC path: 
set voice_opt=-I dummy --play-and-exit --volume 1024
set canhbao="%vlcpath%" %voice_opt% canhbao.mp3
set batdau="%vlcpath%" %voice_opt% batdau.mp3
set ketthuc="%vlcpath%" %voice_opt% ketthuc.mp3
set plogo=--logo-file logo.png --logo-x=10 --logo-y=10 --logo-opacity=164
set ptext1=--sub-filter=marq --marq-file=marq1.txt --marq-position=6 --marq-size=15 --marq-y=15 --marq-color=16776960 
set ptext2=--sub-filter=marq --marq-file=marq2.txt --marq-position=10 --marq-size=15 --marq-y=15
set pothers=-I dummy --network-caching=60000 --play-and-exit %pruntime%
::==================================================================================

:start_record
set filename=vtv1_%date:~0,2%%date:~3,2%_%time:~0,2%%time:~3,2%%time:~6,2%.ts
set filename=%filename: =%
set psout=--sout=file/ts:%filename%
::set psout=--sout=#transcode{vcodec=h264,vb=1024,sfilter=logo,sfilter=marq}:std{access=file,mux=ts,dst=%filename%}
set vlc=%vlcpath% %pothers% %psout%
if not exist vtv1.txt (
:link_error
    for /l %%x in (1,1,10) do (
		cls
		echo ERROR___[vtv1.txt]___[%%x]/[10]
		%canhbao%
	)
	goto start_record
)
for %%a in (vtv1.txt) do set fsize=%%~za
if %fsize% equ 0 (
	goto link_error )
set /p vtv1=<vtv1.txt
tasklist /fi "WindowTitle eq pi-vtv1" | find /i "streamlink.exe" || (
	streamlink "%vtv1%" | find /i "Available streams" || (
		more +1 <vtv1.txt >vtv1.tem
		del vtv1.txt
		ren vtv1.tem vtv1.txt
		goto start_record
	)
	%batdau%
	start "pi-vtv1" streamlink --player "%vlc%" %vtv1% worst --hls-segment-threads %hls_seg%
)
cls
timeout /t 10 /nobreak
call :getTime now
if "%now%" geq "%hetgio%" (
:: Ask for if one want to see stream before quit
	if %pbq% equ 1 ( streamlink --player "%vlcpath%" %vtv1% worst )
	echo [ KET THUC GHI ]
	%ketthuc%
	goto :eof )
goto start_record
:: getTime
::    This routine returns the current (or passed as argument) time
::    in the form hh:mm:ss,cc in 24h format, with two digits in each
::    of the segments, 0 prefixed where needed.
:getTime returnVar [time]
    setlocal enableextensions disabledelayedexpansion

    :: Retrieve parameters if present. Else take current time
    if "%~2"=="" ( set "t=%time%" ) else ( set "t=%~2" )

    :: Test if time contains "correct" (usual) data. Else try something else
    echo(%t%|findstr /i /r /x /c:"[0-9:,.apm -]*" >nul || ( 
        set "t="
        for /f "tokens=2" %%a in ('2^>nul robocopy "|" . /njh') do (
            if not defined t set "t=%%a,00"
        )
        rem If we do not have a valid time string, leave
        if not defined t exit /b
    )

    :: Check if 24h time adjust is needed
    if not "%t:pm=%"=="%t%" (set "p=12" ) else (set "p=0")

    :: Separate the elements of the time string
    for /f "tokens=1-5 delims=:.,-PpAaMm " %%a in ("%t%") do (
        set "h=%%a" & set "m=00%%b" & set "s=00%%c" & set "c=00%%d" 
    )

    :: Adjust the hour part of the time string
    set /a "h=100%h%+%p%"

    :: Clean up and return the new time string
    endlocal & if not "%~1"=="" set "%~1=%h:~-2%:%m:~-2%:%s:~-2%,%c:~-2%" & exit /b