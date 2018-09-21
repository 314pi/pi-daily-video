@echo off
setlocal EnableExtensions EnableDelayedExpansion
call apps.bat
set lims[0]=700
set lims[1]=1000
set lims[2]=1300
set lims[3]=2000
set /a limc=0
set /a count=1
set /a bkcount=0
set "kenh=%1"
if [%kenh%]==[] set "kenh=test"
for /l %%i in (1,1,5) do ( %ini% tv.ini [%kenh%] link%%i==)
:ChangeLim
echo ==========================================================
if %limc% geq 4 goto Done
set /a lim=lims[%limc%]
set "stt=%2"
if [%stt%]==[] set /a stt=1
if %stt% geq 11 set /a stt=1
:GetLink1
if %stt% geq 11 (
	set /a limc+=1
	goto ChangeLim )
if exist .\tmp\%kenh%.* del "%scriptpath%\tmp\%kenh%.*"
for /f "delims=" %%a in ('%ini% tv.ini [%kenh%] source%stt%' ) do ( %%a )
call set source="%%source%stt%%%"
if not %source%=="" set source=%source: =%
if %source%=="" (
	set /a stt+=1
	goto GetLink1 )
echo ==========================================================
echo Source [%stt%]: %source%
type NUL>"%scriptpath%\tmp\%kenh%.4"
%wget% -qO- %source%>"%scriptpath%\tmp\%kenh%.1"
%grep% -Eo "http[^\,=]+m3u8" "%scriptpath%\tmp\%kenh%.1">"%scriptpath%\tmp\%kenh%.2" && (
	echo Type 1 [ http://-- m3u8 ]
	call :RemDup "%scriptpath%\tmp\%kenh%.2"
	copy "%scriptpath%\tmp\%kenh%.2" "%scriptpath%\tmp\%kenh%.4">NUL
)
%grep% -Eo "function init" "%scriptpath%\tmp\%kenh%.1">NUL && (
	echo Type 2 [ function init ]
	%grep% -Eo "'http[^\,]+'" "%scriptpath%\tmp\%kenh%.1">"%scriptpath%\tmp\%kenh%.2"
	%sed% "s/'//g" "%scriptpath%\tmp\%kenh%.2">"%scriptpath%\tmp\%kenh%.3"
	call :RemDup "%scriptpath%\tmp\%kenh%.3"
	%sed% "s/ //g" "%scriptpath%\tmp\%kenh%.3">"%scriptpath%\tmp\%kenh%.31"
	set /a lcount=0
	for /f %%i in (%scriptpath%\tmp\%kenh%.31) do (
		set /a ltype=0
		echo %%i>"%scriptpath%\tmp\%kenh%.32"
		!grep! -Eo "^.*m3u8" "%scriptpath%\tmp\%kenh%.32">NUL && (
			set /a lcount+=1
			echo [class 1] [!lcount!] : & echo %%i
			echo %%i>>"%scriptpath%\tmp\%kenh%.4"
			set /a ltype=1 )
		if !ltype! equ 0 (
			!wget! -qO- "%%i">"%scriptpath%\tmp\%kenh%.33"
			!sed! "s/ //g" "%scriptpath%\tmp\%kenh%.33">"%scriptpath%\tmp\%kenh%.34"
			!grep! -Eo "^.*m3u8" "%scriptpath%\tmp\%kenh%.34">NUL && (
				set /a lcount+=1
				echo [class 2] [!lcount!] : & echo %%i
				set /a ltype=2
				set /p type2=<"%scriptpath%\tmp\%kenh%.34"
				echo !type2!>>"%scriptpath%\tmp\%kenh%.4"
			)
		)
		REM if !ltype! equ 0 (
			REM !wget! -qO- "%%i">"%scriptpath%\tmp\%kenh%.35"
			REM set /p type3=<"%scriptpath%\tmp\%kenh%.35"
			REM !wget! -qO- !type3!>"%scriptpath%\tmp\%kenh%.36"
			REM %grep% -Eo "http[^\,]+" "%scriptpath%\tmp\%kenh%.36">>"%scriptpath%\tmp\%kenh%.4"
			REM set /a lcount+=1
			REM echo [ !lcount! ] [class 3] %%i
			REM set /a ltype=3 )
	)
)
%sed% "/^\s*$/d" "%scriptpath%\tmp\%kenh%.4">"%scriptpath%\tmp\%kenh%.41"
%sed% "s/ //g" "%scriptpath%\tmp\%kenh%.41">"%scriptpath%\tmp\%kenh%.0"
call :RemDup "%scriptpath%\tmp\%kenh%.0"
set /a lcount1=0
for /f %%i in (%scriptpath%\tmp\%kenh%.0) do (
	set /a lcount1+=1
	set /a found=!count!-1
	title getlink.bat [ !kenh! ] - [ resolution limits : !lim! ] - [ found : !found! ^& !bkcount! reserve ]
	echo __________________________________________________________
	echo [!count!] Source [!stt!] link No. !lcount1! : & echo %%i
	!streamlink! "%%i">"%scriptpath%\tmp\%kenh%.01"
	findstr /i /C:"Available streams" "%scriptpath%\tmp\%kenh%.01" && (
		set /a already=0
		call :GetRes res %%i
		if !res! leq !lim! (
			if !limc! geq 1 (
				set /a plimc=!limc!-1
				set /a plim=lims[!plimc!]
				if !res! lss !plim! (
					echo [ Already found before ]
					set /a already=1 )
			)
			if !already! equ 0 (
				echo [ FFprobe found resolution !res! ] ^< [ lim=!lim! ] ==^> [ OK ]
				echo Source [ !source! ]  - [ !stt! ] - [ !lcount1! ]>>"!scriptpath!\log\tk!kenh!.txt"
				if !count! leq 1 echo !streamlink! "--player=!vlc!" "%%i" worst>"!scriptpath!\log\!kenh!-vlc.bat"
				if !res! lss 640 (
					!ini! tv.ini [!kenh!] link5=%%i
					set /a bkcount=1
				) else (
					!ini! tv.ini [!kenh!] link!count!=%%i
					set /a "count+=1"
				)
				!ini! tv.ini [!kenh!] resolution=!res!
			)
		) else (
			echo [ FFprobe found resolution !res! ] ^> [ lim=!lim! ] ==^> [ Do not use this link ]
		)
	) || echo [ Is not a stream link for record or stream. ]
	if !count! geq 5 goto Done
)
if %count% leq 3 (
	set /a stt+=1
	goto GetLink1 )
:Done
echo =====================================
echo ^|^|                                 ^|^|
echo ^|^|[ %kenh% ] [ found atleast %found% and %bkcount% link(s) ] [ max resolution %res% ]
echo ^|^|                                 ^|^|
echo =====================================
::if exist .\tmp\%kenh%.* del "%scriptpath%\tmp\%kenh%.*"
if exist ftp.txt ftp -s:ftp.txt
endlocal
goto :eof

:GetRes
	@echo off
	setlocal
	set "link=%~2"
	call apps.bat
	%ffprobe% -v error -select_streams v:0 -show_entries stream=height,width -of csv=s=x:p=0 "%link%">"%scriptpath%\tmp\%kenh%.r0"
	for /f %%x in (' findstr /i "x" %scriptpath%\tmp\%kenh%.r0 ') do set "res=%%x"
	for /f "tokens=1 delims=x" %%x in ("%res%") do set /a "res1=%%x"
	endlocal & if not "%~1"=="" set /a "%~1=%res1%" & exit /b

:RemDup
	@echo off
	setlocal
	set "file=%~1"
	set "tmp=remdup.txt"
	type NUL>"%tmp%"
	for /f "tokens=*" %%a in (%file%) do (
		findstr "%%a" "%tmp%">NUL || echo %%a>>"%tmp%" )
	move /y "%tmp%" "%file%">NUL
	endlocal & exit /b