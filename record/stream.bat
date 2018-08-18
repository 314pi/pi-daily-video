@echo off
setlocal enableextensions disabledelayedexpansion
call apps.bat
set "kenh=%1"
set "mod=%2"
set liveurl="rtmp://live-api-s.facebook.com:80/rtmp/249230595853015?s_ps=1&s_vt=api-s&a=AThIWvRa8ZTc5RyR"
if [%kenh%]==[] set "kenh=test"
if [%mod%]==[] set /a "mod=1"
::======================================
for /f "delims=" %%a in ('%ini% tv.ini [%kenh%] plogo') do ( %%a )
for /f "delims=" %%a in ('%ini% tv.ini [%kenh%] pcfg') do ( %%a )
if not "%pcfg%"=="" set "pcfg=%pcfg: =%"
if "%pcfg%"=="" ( call :getStop pcfg 1 30 )
call :chongio endtime rcfg "%pcfg%"
call :strlen %rcfg% cfgl
if %cfgl% geq 1 set /a pad=%rcfg:~0,1%
if %getlinkfirst% equ 0 ( goto NoGetLink )
set /a src_count=1
:GetLink
if %src_count% geq 5 (
	for /l %%x in (1,1,5) do (
		cls & echo ERROR URL___[%kenh% @ TV.INI]___[%%x]/[5]
		if %spk% equ 1 ( %canhbao% ) else ( timeout /t 1 )
	)
	echo Downloading TV.INI ...
	powershell -Command "(New-Object Net.WebClient).DownloadFile('http://chuyendungath.com/images/videos/up/tv.ini', 'tv.ini')"
	set /a "src_count=1" )
call getlink.bat %kenh% %src_count%
:NoGetLink
if %mod% leq 0 ( goto :eof )
timeout /t 1
set /a link_count=1
if %rlog% equ 1 ( echo stop=%endtime%>"%scriptpath%\log\%kenh%.log" )
::======================================
:StartStream
if %link_count% geq 5 (
	set /a src_count+=1
	goto GetLink )
for /f "delims=" %%a in ('%ini% tv.ini [%kenh%] link%link_count%') do ( %%a )	
call set streamurl=%%link%link_count%%%
if not "%streamurl%"=="" (
	set "streamurl=%streamurl: =%"
	if "%streamurl%"=="" ( set /a "link_count+=1" & goto StartStream )
	if "x%streamurl:http=%"=="x%streamurl%" ( set /a "link_count+=1" & goto StartStream )
	if not "x%streamurl:youtube=%"=="x%streamurl%" ( set qual=360p ) else ( set qual=worst )
) else ( set /a "link_count+=1" & goto StartStream )
for /f "delims=" %%a in ('%ini% tv.ini [%kenh%] resolution') do ( %%a )
set filename=%kenh%_%resolution%_%date:~0,2%%date:~3,2%_%time:~0,2%%time:~3,2%%time:~6,2%.mp4
set filename=%filename: =%
::=========================================
call :getTime now
if "%now%" geq "%endtime%" ( %ketthuc% & goto :eof )
%streamlink% "%streamurl%">"%scriptpath%\log\ck.txt"
findstr /i /C:"Available streams"<"%scriptpath%\log\ck.txt" || (
	echo Streamlink can not use this link for stream [ stream.bat ]
	set /a "link_count+=1" & goto StartStream )
del "%scriptpath%\log\ck.txt"
call :getTime now
call :TimeSub dur "%endtime%" "%now%"
if "%dur%" geq "03:00:00" set dur=03:00:00
set streamopt=%qual% --hls-segment-threads 10 --hls-duration %dur%
if %pad% geq 1 (
	type s1.txt>pad.txt
	if %plogo% geq 1 ( echo.>>pad.txt & type t1.txt>>pad.txt )
	set ffopt=-filter:v "pad=840:480:(ow-iw)/2:(oh-ih)/2,drawtext=fontfile='arial_0.ttf':textfile=pad.txt:x=(w-text_w)/2:y=10:fontsize=20:fontcolor=white"
) else (
	if %plogo% equ 1 (
		set ffopt=-filter:v "drawtext=fontfile='arial_0.ttf':box=1:boxcolor=black@0.5:text='%%{localtime\:%tf%}@pilikeyou':y=h-th:fontsize=10:fontcolor=white" )
	if %plogo% equ 2 (
		set ffopt=-filter:v "drawtext=fontfile='arial_0.ttf':textfile=sub1.txt:x=(w-text_w)/2:fontsize=10:fontcolor=white" ) 	
)
echo %resolution%>"%scriptpath%\tmp\%kenh%.10"
findstr /i "720p 1280 2160k 1080p 1920" "%scriptpath%\tmp\%kenh%.10">NUL && ( set preset=-preset:v superfast )
findstr /i "480p 540p 960" "%scriptpath%\tmp\%kenh%.10">NUL && ( set preset=-preset:v veryfast )
set ffopt=%ffopt% -f flv -vcodec libx264 -crf 30 -movflags empty_moov+separate_moof+frag_keyframe %preset%
if %rlog% equ 1 (
	echo [ %time% ]-URL[%link_count%]=%streamurl%>>"%scriptpath%\log\%kenh%.log" )
if %spk% equ 1 ( %batdau% ) else ( timeout /t 1 )
if %mod% equ 1 (
	title Record [%kenh%] - URL[%link_count%] - %time%/%endtime% - [%dur%] - [%resolution%/%preset%]
	%streamlink% "%streamurl%" %streamopt% --stdout | "%ffmpeg%" -i pipe:0 %ffopt% "%filename%"
)
if %mod% equ 2 (
	title Live [%kenh%] - URL[%link_count%] - %time%/%endtime% - [%dur%] - [%resolution%/%preset%]
	%streamlink% "%streamurl%" %streamopt% --stdout | "%ffmpeg%" -i pipe:0 -acodec libmp3lame -ar 44100 -b:a 96k -pix_fmt yuv420p -profile:v baseline -bufsize 6000k -vb 400k -maxrate 1000k -deinterlace -vcodec libx264 -preset veryfast -g 30 -r 25 -crf 30 -f flv %liveurl%
)
if %mod% geq 3 (
	title Record+Live [%kenh%] - URL[%link_count%] - %time%/%endtime% - [%dur%] - [%resolution%/%preset%]
	%streamlink% "%streamurl%" %streamopt% --stdout | "%ffmpeg%" -i pipe:0 -acodec libmp3lame -ar 44100 -b:a 96k -pix_fmt yuv420p -profile:v baseline -bufsize 6000k -vb 400k -maxrate 1000k -deinterlace -vcodec libx264 -preset veryfast -g 30 -r 25 -crf 30 -f flv - | "%ffmpeg%" -f flv -i - -c copy -f flv %liveurl% -c copy -f flv "%filename%"
)
call :getTime now
if "%now%" leq "%endtime%" (
	goto StartStream
) else (
	if %rlog% equ 1 ( echo [ %time% ] - [ Stop ] [ stream.bat ]>>"%scriptpath%\log\%kenh%.log" )
	if %spk% equ 1 ( %ketthuc% ) else ( timeout /t 1 )
	goto :eof )
goto :eof

:chongio gio rcfg str
	@echo off
	setlocal enableextensions enabledelayedexpansion
	set "str=%~3"
	for /l %%i in (1,1,10) do (
		call :tach giotach %%i
		call :getTime now
		if "!now!" leq "!giotach!" (
			set thay=!giotach!
			goto Found )
	)
	:Found
	for /f "tokens=1-2 delims=x" %%a in ("%giotach%") do (
		set "endtime=%%a" & set "rcfg=%%b" )
	endlocal & set "%~1=%endtime%" & set "%~2=%rcfg%" & exit /b

:tach giotach stt
	@echo off
	setlocal enableextensions enabledelayedexpansion
	for /f "tokens=%2 delims=va" %%a in ("%str%") do (
		set giotach=%%a )
	endlocal & if not "%~1"=="" set "%~1=%giotach%" & exit /b
	
:: Thoi gian thuc hien ghi Video
:getStop pcfg gi ph
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
:: This routine returns the current (or passed as argument) time
:: in the form hh:mm:ss,cc in 24h format, with two digits in each
:: of the segments, 0 prefixed where needed.
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

:TimeSub st xx yy
	setlocal enableextensions disabledelayedexpansion
	if "%~3"=="" ( set "yy=%time%" ) else ( set "yy=%~3" )
	set /a h=100%yy:~0,2% %% 100
	if %h% lss 10 set h=0%h%
	set /a end=(1%h%-100)*3600 + (1%yy:~3,2%-100)*60 + (1%yy:~6,2%-100)
	set "xx=%~2"
	set /a h=100%xx:~0,2% %% 100
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

:strlen string len
	setlocal enabledelayedexpansion
	set "token=#%~1" & set "len=0"
	for /L %%A in (12,-1,0) do (
		set/A "len|=1<<%%A"
		for %%B in (!len!) do if "!token:~%%B,1!"=="" set/A "len&=~1<<%%A"
	)
	endlocal & set %~2=%len%
	exit /b