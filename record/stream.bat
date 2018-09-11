	@echo off
	setlocal enableextensions disabledelayedexpansion
	call apps.bat
	set "channel=%1"
	set "mod=%2"
	if [%1]==[] set "channel=test"
	if [%2]==[] set /a "mod=1"
	if not "x%1"=="xall" ( goto FixedChannel )
	:: else channel = all ( dynamic channel)
:DynamicChannel
	call :TimeToChannel channel
	if [%2]==[] set /a "mod=2"
	powershell -Command "(New-Object Net.WebClient).DownloadFile('http://chuyendungath.com/images/videos/up/tv.ini', 'tv.ini')"
:FixedChannel
::======================================
	for /f "delims=" %%a in ('%ini% tv.ini [%channel%] plogo') do ( %%a )
	for /f "delims=" %%a in ('%ini% tv.ini [%channel%] pcfg') do ( %%a )
	for /f "delims=" %%a in ('%ini% tv.ini [%channel%] liveurl') do ( %%a )
	if not "%pcfg%"=="" set "pcfg=%pcfg: =%"
	if "%pcfg%"=="" ( call :getStop pcfg 1 30 )
	call :chongio endtime rcfg "%pcfg%"
	call :strlen %rcfg% cfgl
	if %cfgl% geq 1 set /a pad=%rcfg:~0,1%
	if %getlinkfirst% equ 0 ( goto NoGetLink )
	set /a dowloadcount=0
:UpdateLink
	set /a dowloadcount+=1
	echo Downloading TV.INI ...
	powershell -Command "(New-Object Net.WebClient).DownloadFile('http://chuyendungath.com/images/videos/up/tv.ini', 'tv.ini')"
	if %dowloadcount% geq 3 call getlink.bat %channel%
:NoGetLink
	if %mod% leq 0 ( goto :eof )
	if %rlog% equ 1 ( echo stop=%endtime%>"%scriptpath%\log\%channel%.log" )
	timeout /t 1
	set /a link_count=1
::======================================
:StartStream
	if %link_count% geq 6 (	goto UpdateLink )
	for /f "delims=" %%a in ('%ini% tv.ini [%channel%] link%link_count%') do ( %%a )
	call set "streamurl=%%link%link_count%%%"
	if not "%streamurl%"=="" (
		set "streamurl=%streamurl: =%"
		if "%streamurl%"=="" ( set /a "link_count+=1" & goto StartStream )
		if "x%streamurl:http=%"=="x%streamurl%" ( set /a "link_count+=1" & goto StartStream )
		if not "x%streamurl:youtube=%"=="x%streamurl%" ( set qual=360p ) else ( set qual=worst )
	) else ( set /a "link_count+=1" & goto StartStream )
	for /f "delims=" %%a in ('%ini% tv.ini [%channel%] resolution') do ( %%a )
	set filename="%channel%_%date:~0,2%%date:~3,2%_%time:~0,2%%time:~3,2%%time:~6,2%.mp4"
	set filename=%filename: =%
	::=========================================
	call :getTime nows
	if "%nows%" geq "%endtime%" ( 
		if %spk% equ 1 ( %ketthuc% ) else ( timeout /t 1 )
		if "x%1"=="xall" (
			goto DynamicChannel
		) else (
			goto :eof )
	)
	%streamlink% "%streamurl%">"%scriptpath%\log\ck.txt"
	findstr /i /C:"Available streams"<"%scriptpath%\log\ck.txt" || (
		echo [ Can not use this link for stream. Trying another one ] - [ stream.bat ]
		set /a "link_count+=1" & goto StartStream )
	del "%scriptpath%\log\ck.txt"
	call :getTime nowd
	call :TimeSub dur "%endtime%" "%nowd%"
	if "%dur%" geq "03:00:00" set dur=03:00:00
	set streamopt=%qual% --hls-segment-threads 10 --hls-duration %dur%
	set ffopt=-acodec libmp3lame -ar 44100 -b:a 96k -pix_fmt yuv420p -profile:v baseline -bufsize 6000k -vb 400k -maxrate 1000k -deinterlace -vcodec libx264 -preset veryfast -g 30 -r 25 -crf 30 -f flv
	if %rlog% equ 1 (
		echo [ %time% ]-URL[%link_count%]="%streamurl%">>"%scriptpath%\log\%channel%.log" )
	if %spk% equ 1 ( %batdau% ) else ( timeout /t 1 )
	if %mod% equ 2 (
		title Live [%channel%] - URL[%link_count%] - [start %time:~0,-6% ] + [ %dur:~0,-3% ] = [stop %endtime%] - [ param: %1 %2 %3 ]
		%streamlink% "%streamurl%" %streamopt% --stdout | "%ffmpeg%" -i pipe:0 %ffopt% "%liveurl%"
	)
	if %mod% geq 3 (
		title Record+Live [%channel%] - URL[%link_count%] - [start %time:~0,-6% ] + [ %dur:~0,-3% ] = [stop %endtime%] - [ param: %1 %2 %3 ]
		%streamlink% "%streamurl%" %streamopt% --stdout | "%ffmpeg%" -i pipe:0 %ffopt% - | "%ffmpeg%" -f flv -i - -c copy -f flv "%liveurl%" -s 640x360 -f flv %filename%
	)
	if %mod% equ 1 (
		title Record [%channel%] - URL[%link_count%] - [start %time:~0,-6% ] + [ %dur:~0,-3% ] = [stop %endtime%] - [ param: %1 %2 %3 ]
		%streamlink% "%streamurl%" %streamopt% --stdout | "%ffmpeg%" -i pipe:0 -s 640x360 %ffopt% %filename%
	)
	call :getTime nowe
	if "%nowe%" lss "%endtime%" (
		goto StartStream
	) else (
		if %rlog% equ 1 ( echo [ %time% ] - [ Stop ] [ stream.bat ]>>"%scriptpath%\log\%channel%.log" )
		if %spk% equ 1 ( %ketthuc% ) else ( timeout /t 1 )
		if "x%1"=="xall" (
			goto DynamicChannel
		) else (
			goto :eof )
	)
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
			goto CfgFound )
	)
	:CfgFound
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
	
:TimeToChannel channel
	@echo off
	call apps.bat
	setlocal enableextensions enabledelayedexpansion
	set timetable[0].start=08:50 & set timetable[0].end=09:30 & set timetable[0].chan=qpvn & 	set timetable[0].days=6
	set timetable[1].start=11:50 & set timetable[1].end=13:00 & set timetable[1].chan=thvl1 & 	set timetable[1].days=0123456
	set timetable[2].start=13:50 & set timetable[2].end=15:20 & set timetable[2].chan=vtv3 & 	set timetable[2].days=60
	set timetable[3].start=19:50 & set timetable[3].end=21:00 & set timetable[3].chan=htv2 & 	set timetable[3].days=123
	set timetable[4].start=19:50 & set timetable[4].end=21:00 & set timetable[4].chan=thvl1 & 	set timetable[4].days=456
	set timetable[5].start=21:30 & set timetable[5].end=23:00 & set timetable[5].chan=vtv3 & 	set timetable[5].days=1234

	set /a leng=6
	set nextchan=
	set start=00:00
	set nextstart=23:59
	call :getTime now
	for /f "delims=" %%a in ('wmic path win32_localtime get dayofweek /format:list ') do for /f "delims=" %%d in ("%%a") do set %%d
	::echo day of the week : %dayofweek%
	set i=0
	:LoopTime
		if %i% geq %leng% (
			title [ cmd: stream all ] [ Next channel: %nextchan% @ %nextstart%] Waitting ...  & cls & timeout /t 60
			set /a i=0 )
		set cur.chan=
		set cur.start=
		set cur.days=
		set cday=

		for /f "usebackq delims==. tokens=1-3" %%j in (`set timetable[%i%]`) do ( set cur.%%k=%%l )
		set start=%cur.start%
		set end=%cur.end%
		set days=%cur.days%
		call :NowInTime true %start% %end%
		if %true% equ 1 (
			call set "cday=%%days:!dayofweek!=%%"
			::echo %days% !cday!
			if not "!cday!" equ "%days%" (
				set "chan=%cur.chan%"
				goto FoundChannel )
		) else (
			call :getTime now
			if "%start%" gtr "%now%" (
				if "%nextstart%" gtr "%start%" (
					call set "cday=%%days:!dayofweek!=%%"
					if not "!cday!" equ "%days%" (
						set nextstart=%start%
						set "nextchan=%cur.chan%" )
				)
			)
		)
		set /a i=%i%+1
	goto LoopTime
	:FoundChannel
		echo Channel is set to [ %chan% ] & timeout /t 5
	endlocal & set %~1=%chan% & exit /b
	
:NowInTime true start end
	@echo off
	setlocal enableextensions enabledelayedexpansion
	set /a true=0
	set "start=%~2"
	set "end=%~3"
	call :getTime curtime
	if "%curtime%" geq "%start%" (
		if "%curtime%" lss "%end%" ( set /a true=1 )
	) else (
		set /a true=0
	)
	endlocal & set %~1=%true% & exit /b