@echo off
call apps.bat
type NUL > "%scriptpath%\tmp\blank.txt"
set chanelurl="http://data.xemtiviso.com/live/vtv/vtv1.php"
%wget% -qO- %chanelurl% > "%scriptpath%\tmp\src.txt"
%grep% -Eo "function init" "%scriptpath%\tmp\src.txt" > NUL
if %errorlevel% equ 0 (
	%grep% -Eo "'http[^\,]+'" "%scriptpath%\tmp\src.txt" > "%scriptpath%\tmp\quotes.txt"
	%sed% "s/'//g" "%scriptpath%\tmp\quotes.txt" > "%scriptpath%\tmp\lnk.txt"
	for /f %%i in (%scriptpath%\tmp\lnk.txt) do (
		%wget% -qO- "%%i" >> "%scriptpath%\tmp\blank.txt"
		echo. >> "%scriptpath%\tmp\blank.txt"
	)
) else (
	echo May be YOUTUBE
)
%sed% "/^\s*$/d" "%scriptpath%\tmp\blank.txt" > "m3u8.txt"