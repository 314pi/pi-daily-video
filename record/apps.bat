@echo off
set scriptpath=%~dp0
set scriptpath=%scriptpath:~0,-1%
set streamlink="%scriptpath%\streamlink\Streamlink.exe"
if not "x%PROCESSOR_ARCHITECTURE:64=%" == "x%PROCESSOR_ARCHITECTURE%" ( 
	set ffmpeg=%scriptpath%\streamlink\ffmpeg64\ffmpeg.exe
	set ffprobe=%scriptpath%\streamlink\ffmpeg64\ffprobe.exe
	set ffplay=%scriptpath%\streamlink\ffmpeg64\ffplay.exe
	set vlc=%scriptpath%\streamlink\vlc64\vlc.exe
	set wget="%scriptpath%\streamlink\wget\wget64.exe"
	set ini=ini64.exe
) else (
	set ffmpeg=%scriptpath%\streamlink\ffmpeg32\ffmpeg.exe
	set ffprobe=%scriptpath%\streamlink\ffmpeg32\ffprobe.exe
	set ffplay=%scriptpath%\streamlink\ffmpeg32\ffplay.exe
	set vlc=%scriptpath%\streamlink\vlc32\vlc.exe
	set wget="%scriptpath%\streamlink\wget\wget32.exe"
	set ini=ini32.exe
)
set sed="%scriptpath%\streamlink\GnuWin32\bin\sed.exe"
set grep="%scriptpath%\streamlink\GnuWin32\bin\grep.exe"
set "voice_opt=-I dummy --play-and-exit --volume 1024"
set canhbao="%vlc%" %voice_opt% %kenh%.mp3 ccl.mp3
set batdau="%vlc%" %voice_opt% batdau.mp3 %kenh%.mp3
set ketthuc="%vlc%" %voice_opt% ketthuc.mp3 %kenh%.mp3
::=========================
for /f "delims=" %%a in ('%ini% my.ini [configure] spk') do ( %%a )
for /f "delims=" %%a in ('%ini% my.ini [configure] copyini') do ( %%a )
for /f "delims=" %%a in ('%ini% my.ini [configure] downloadini') do ( %%a )
for /f "delims=" %%a in ('%ini% my.ini [configure] rlog') do ( %%a )
for /f "delims=" %%a in ('%ini% my.ini [configure] getlinkfirst') do ( %%a )
if not defined spk set /a spk=0
if not defined copyini set /a copyini=0
if not defined downloadini set /a downloadini=0
if not defined rlog set /a rlog=0
if not defined getlinkfirst set /a getlinkfirst=1
if %downloadini% equ 1 (
	powershell -Command "(New-Object Net.WebClient).DownloadFile('http://chuyendungath.com/images/videos/up/tv.ini', 'tv.ini')"
) else (
	if %copyini% equ 1 (
		if exist z:\tv.ini copy /y z:\tv.ini .\tv.ini )
	)
)
if not exist tv.ini (
	title Khong Ghi Duoc VIDEO [Khong Co File TV.INI]
	echo Khong Ghi Duoc VIDEO [Khong Co File TV.INI] 
	pause )
::============================
set tf=%%Hh%%Mp%%S
set ffopt=
set /a plogo=0
:: Default Channel Configure
set /a cfgl=0
set /a pad=0
set spd=1.0
