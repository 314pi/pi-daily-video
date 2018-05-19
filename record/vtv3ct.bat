@echo off
set vlcpath=C:\Program Files (x86)\VideoLAN\VLC\vlc.exe
set hetgio=14:50:00,00
set canhbao="%vlcpath%" -I dummy canhbao.mp3  --play-and-exit --volume 1024
set batdau="%vlcpath%" -I dummy batdau.mp3  --play-and-exit --volume 1024
set ketthuc="%vlcpath%" -I dummy ketthuc.mp3  --play-and-exit --volume 1024

:start_record
set filename=vtv3ct_%date:~0,2%%date:~3,2%_%time:~0,2%%time:~3,2%%time:~6,2%.ts
set filename=%filename: =% 
set vlc=%vlcpath% -I dummy --sout=file/ts:%filename% --network-caching=60000 --run-time 4200 --play-and-exit
if not exist vtv3ct.txt (
:link_error
    for /l %%x in (1,1,3) do (
		echo ERROR___[vtv3ct.txt]___[%%x]/[3]
		%canhbao%
	)
	goto start_record
)
for %%a in (vtv3ct.txt) do set fsize=%%~za
if %fsize% equ 0 (
	goto link_error )
set /p vtv3ct=<vtv3ct.txt
tasklist /fi "WindowTitle eq pi-vtv3ct" | find /i "streamlink.exe" || (
	streamlink "%vtv3ct%" | find /i "Available streams" || (
		more +1 <vtv3ct.txt >vtv3ct.tem
		del vtv3ct.txt
		ren vtv3ct.tem vtv3ct.txt
		goto start_record
	)
	start "pi-vtv3ct" streamlink --player "%vlc%" "%vtv3ct%" worst --hls-segment-threads 3
	%batdau%
)
timeout /t 10 /nobreak
call :getTime now
if "%now%" geq "%hetgio%" (
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