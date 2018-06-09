@echo off
setlocal enableextensions disabledelayedexpansion
cls

call :ini hetgio tv.ini test stop
if not "%hetgio%" == "" set "hetgio=%hetgio: =%"
if "%hetgio%" == "" ( call :getStop hetgio 1 30 )
call :chongio hetgio "%hetgio%"
echo %hetgio%


goto :eof

:chongio gio str
	@echo off
	setlocal enableextensions enabledelayedexpansion
	set "str=%~2"
	for /l %%i in (1,1,10) do ( 
		call :tach giotach %%i
		call :getTime now
		if !now! leq !giotach! (
			set thay=!giotach!
			goto :thay )
	)
	:thay
	endlocal & if not "%~1"=="" set "%~1=%thay%" & exit /b

:tach giotach stt
	@echo off
	setlocal enableextensions enabledelayedexpansion
	for /f "tokens=%2 delims=va" %%a in ("%str%") do (
		set giotach=%%a )
	endlocal & if not "%~1"=="" set "%~1=%giotach%" & exit /b

::Doc file cau hinh TV.INI
:ini bien [tepini] [muc] [khoa]
	@echo off
	setlocal enableextensions enabledelayedexpansion
	set "file=%~2" & set "area=[%~3]" & set "key=%~4" & set "currarea="
	for /f "usebackq delims=" %%a in ("!file!") do (
		set ln=%%a
		if "x!ln:~0,1!"=="x[" (
			set currarea=!ln!
		) else (
			for /f "tokens=1,2 delims==" %%b in ("!ln!") do (
				set "currkey=%%b" & set "currval=%%c"
				if "x!area!"=="x!currarea!" if "x!key!"=="x!currkey!" (
					goto done
				)
			)
		)
	)
	:done
	endlocal & if not "%~1"=="" set "%~1=%currval%" & exit /b

:: Thoi gian thuc hien ghi Video
:getStop stop gi ph
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

	endlocal & if not "%~1"=="" set "%~1=%gio%:%phut%:%giay%,00" & exit /b

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