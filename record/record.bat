@echo off
setlocal enableextensions disabledelayedexpansion
:: THIET LAP THONG SO CO DINH
cls
set hls_seg=10
set /a pbq=1
set /a usevlc=0
set vlcpath=C:\Program Files\VideoLAN\VLC\vlc.exe
if not exist "%vlcpath%" set vlcpath=C:\Program Files (x86)\VideoLAN\VLC\vlc.exe
if not exist "%vlcpath%" set /p vlcpath=Enter VLC path: 
set voice_opt=-I dummy --play-and-exit --volume 1024
set canhbao="%vlcpath%" %voice_opt% canhbao.mp3
set batdau="%vlcpath%" %voice_opt% batdau.mp3
set ketthuc="%vlcpath%" %voice_opt% ketthuc.mp3
::======================================
:: Duoi day chi su dung cho ghi bang VLC: set /a usevlc=1
set plogo=--logo-file logo.png --logo-x=10 --logo-y=10 --logo-opacity=164
set ptext1=--sub-filter=marq --marq-file=marq1.txt --marq-position=6 --marq-size=15 --marq-y=15 --marq-color=16776960 
set ptext2=--sub-filter=marq --marq-file=marq2.txt --marq-position=10 --marq-size=15 --marq-y=15
set pothers=-I dummy --network-caching=60000 --play-and-exit
:: Tren day chi su dung cho ghi bang VLC
::======================================
set kenh=%1
if [%kenh%]==[] set kenh=test
for /f "delims=" %%a in ('call ini.cmd tv.ini %kenh% stop') do ( set "hetgio=%%a" )
set hetgio=%hetgio: =%
set /a stt_link=1

:start_record
if %stt_link% geq 5 ( set /a "stt_link = 1" )
for /f "delims=" %%a in ('call ini.cmd tv.ini %kenh% link%stt_link%') do ( set "streamurl=%%a" )
if "%streamurl:http=%" == "%streamurl%" ( 
	set /a stt_link+=1
	goto start_record 
)
set streamurl=%streamurl: =%
set filename=%kenh%_%date:~0,2%%date:~3,2%_%time:~0,2%%time:~3,2%%time:~6,2%.ts
set filename=%filename: =%
:: Duoi day chi su dung cho ghi bang VLC: set /a usevlc=1
set psout=--sout=file/ts:%filename%
::set psout=--sout=#transcode{width=640,height=360}:std{access=file,mux=ts,dst=%filename%}
set vlc=%vlcpath% %pothers% %psout%
:: Tren day chi su dung cho ghi bang VLC

tasklist /fi "WindowTitle eq pi-%kenh%" | find /i "streamlink.exe" || (
	echo Stream URL : %streamurl%
	streamlink "%streamurl%" | find /i "Available streams" || (
		set /a stt_link+=1
		if %stt_link% geq 5 ( 
			for /l %%x in (1,1,10) do (
				cls
				echo ERROR URL___[%kenh% @ TV.INI]___[%%x]/[10]
				%canhbao%
			)
		)
		goto start_record
	)
	%batdau%
	if %usevlc% equ 1 (
		start "pi-%kenh%" streamlink --player "%vlc%" %streamurl% worst --hls-segment-threads %hls_seg%
	) else (
		start "pi-%kenh%" streamlink %streamurl% worst --hls-segment-threads %hls_seg% -o %filename%
	)
)
cls
timeout /t 10 /nobreak
call :getTime now
if "%now%" geq "%hetgio%" (
:: Ask for if one want to see stream before quit
	if %pbq% equ 1 ( streamlink --player "%vlcpath%" %streamurl% worst )
	echo [ KET THUC GHI ]
	%ketthuc%
	goto :eof )
goto start_record

::Doc file cau hinh TV.INI
:ini bien [tepini] [muc] [khoa]
	setlocal enableextensions enabledelayedexpansion
	@echo off
	set file=%~2
	set area=[%~3]
	set key=%~4
	set currarea=
	for /f "usebackq delims=" %%a in ("!file!") do (
		set ln=%%a
		if "x!ln:~0,1!"=="x[" (
			set currarea=!ln!
		) else (
			for /f "tokens=1,2 delims==" %%b in ("!ln!") do (
				set currkey=%%b
				set currval=%%c
				if "x!area!"=="x!currarea!" if "x!key!"=="x!currkey!" (
					echo !currval!
				)
			)
		)
	)
	endlocal & if not "%~1"=="" set "%~1=%currval%" & exit /b
	goto :eof

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