@echo off
setlocal enableextensions disabledelayedexpansion
cls & set "kenh=%1"
if [%kenh%]==[] set "kenh=test"
set "vlcpath=C:\Program Files (x86)\VideoLAN\VLC\vlc.exe" & set "voice_opt=-I dummy --play-and-exit --volume 1024"
set ffmpeg=C:\Program Files (x86)\Streamlink\ffmpeg2\ffmpeg.exe
set canhbao="%vlcpath%" %voice_opt% canhbao.mp3
set batdau="%vlcpath%" %voice_opt% batdau.mp3
set ketthuc="%vlcpath%" %voice_opt% ketthuc.mp3
::======================================
for /f "delims=" %%a in ('ini.exe tv.ini [%kenh%] hetgio') do ( %%a )
if not "%hetgio%" == "" set "hetgio=%hetgio: =%"
if "%hetgio%" == "" ( call :getStop hetgio 1 30 )
call :chongio hetgio pbq cbq "%hetgio%"
set /a stt_link=1
echo stop = %hetgio% > %kenh%.log
::======================================
:start_record
if %stt_link% geq 5 (
	for /l %%x in (1,1,10) do (
		cls & echo ERROR URL___[%kenh% @ TV.INI]___[%%x]/[10]
		%canhbao% )
	set /a "stt_link = 1" )
for /f "delims=" %%a in ('ini.exe tv.ini [%kenh%] link%stt_link%') do ( %%a )	
call set streamurl=%%link%stt_link%%%
if not "%streamurl%" == "" (
	set "streamurl=%streamurl: =%"
	if "%streamurl%" == "" ( set /a "stt_link+=1" & goto start_record )
	if "x%streamurl:http=%" == "x%streamurl%" ( set /a "stt_link+=1" & goto start_record )
	if not "x%streamurl:youtube=%" == "x%streamurl%" ( set qual=360p ) else ( set qual=worst )
) else ( set /a "stt_link+=1" & goto start_record )
set filename=%kenh%_%date:~0,2%%date:~3,2%_%time:~0,2%%time:~3,2%%time:~6,2%.mp4
set filename=%filename: =%
::=========================================
call :getTime now
if "%now%" geq "%hetgio%" ( %ketthuc% & goto :eof )
streamlink "%streamurl%" | find /i "Available streams" || (
	echo URL KHONG DUNG !
	set /a "stt_link+=1" & goto start_record )
call :getTime now
call :TimeSub dur "%hetgio%" "%now%"
set ffopt=-vf scale=640:-2 -bsf:a aac_adtstoasc -f mp4 -movflags empty_moov+separate_moof+frag_keyframe
set streamopt=%qual% --hls-segment-threads 10 --hls-duration %dur%
echo [ %time% ]-URL[%stt_link%]=%streamurl% >> %kenh%.log
echo streamlink "%streamurl%"  worst --hls-duration 00:00:30 > chk%kenh%.bat
title %kenh% - %time% / %hetgio% - URL[%stt_link%] - [%dur%]
::%batdau%
streamlink "%streamurl%" %streamopt% --stdout | "%ffmpeg%" -i pipe:0 %ffopt% %filename% -hide_banner

call :getTime now
if "%now%" leq "%hetgio%" (
	goto :start_record
) else (
	echo [ %time% ] - [ KET THUC GHI ]  >> %kenh%.log
	%ketthuc% & goto :eof )
goto :eof
	
:chongio gio pbq cbq str
	@echo off
	setlocal enableextensions enabledelayedexpansion
	set "str=%~4"
	for /l %%i in (1,1,10) do (
		call :tach giotach %%i
		call :getTime now
		if "!now!" leq "!giotach!" (
			set thay=!giotach!
			goto :thay )
	)
	:thay
	for /f "tokens=1-3 delims=x" %%a in ("%giotach%") do (
		set "hetgio=%%a" & set /a "pbq=%%b" & set /a "cbq=%%c" )
	endlocal & set "%~1=%hetgio%" & set "%~2=%pbq%" & set "%~3=%cbq%" & exit /b

:tach giotach stt
	@echo off
	setlocal enableextensions enabledelayedexpansion
	for /f "tokens=%2 delims=va" %%a in ("%str%") do (
		set giotach=%%a )
	endlocal & if not "%~1"=="" set "%~1=%giotach%" & exit /b
	
:: Thoi gian thuc hien ghi Video
:getStop hetgio gi ph
	@echo off
	setlocal enableextensions disabledelayedexpansion
	if not "%~2"=="" (
		set /a tg=%~2
	) else (
		set /a tg=0 )
	if not "%~3"=="" (
		set /a tp=%~3
	) else (
		set /a tp=0 )
	set start=%time%
	set /a gio=%start:~0,2%
	if %gio% lss 10 set gio=0%gio%
	set /a thoigian=(1%gio%-100)*3600 + (1%start:~3,2%-100)*60 + (1%start:~6,2%-100) + %tg%*3600 + %tp%*60
	set /a gio=%thoigian% / 3600
	set /a phut=(%thoigian% - %gio%*3600) / 60
	set /a giay=(%thoigian% - %gio%*3600 - %phut%*60)
	if %gio% geq 24 set /a gio=%gio%-24
	if %gio% lss 10 set gio=0%gio%
	if %phut% lss 10 set phut=0%phut%
	if %giay% lss 10 set giay=0%giay%
	endlocal & if not "%~1"=="" set "%~1=%gio%:%phut%:%giay%,00x0x1" & exit /b

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

: TimeSub st xx yy
	setlocal enableextensions disabledelayedexpansion
	if "%~3"=="" ( set "yy=%time%" ) else ( set "yy=%~3" )
	set /a h=%yy:~0,2%
	if %h% lss 10 set h=0%h%
	set /a end=(1%h%-100)*3600 + (1%yy:~3,2%-100)*60 + (1%yy:~6,2%-100)
	set "xx=%~2"
	set /a h=%xx:~0,2%
	if %h% lss 10 set h=0%h%
	set /a start=(1%h%-100)*3600 + (1%xx:~3,2%-100)*60 + (1%xx:~6,2%-100)
	if %start% geq %end% (
		set /a num=%start% - %end%
	) else (
		set /a num=%end% - %start% )
	set /a gio=%num% / 3600
	set /a phut=(%num% - %gio%*3600) / 60
	set /a giay=(%num% - %gio%*3600 - %phut%*60)
	if %gio% geq 24 set /a gio=%gio%-24
	if %gio% lss 10 set gio=0%gio%
	if %phut% lss 10 set phut=0%phut%
	if %giay% lss 10 set giay=0%giay%
	endlocal & if not "%~1"=="" set "%~1=%gio%:%phut%:%giay%" & exit /b