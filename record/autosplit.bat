@echo off
setlocal enabledelayedexpansion
set p_ffprobe=C:\Program Files (x86)\Streamlink\ffmpeg\ffprobe.exe
set p_ffmpeg=C:\Program Files (x86)\Streamlink\ffmpeg\ffmpeg.exe
set pcopy=-vcodec copy -acodec copy
set p_file=autosplit.ts

echo %time%
"%p_ffprobe%" -f lavfi -i "movie=%p_file%,blackdetect[out0]" -show_entries tags=lavfi.black_start,lavfi.black_end -of default=nw=1 -v quiet | find /i "tag" >autosplit.txt
echo %time%
:: remove duplicate lines
if exist "temp.txt" del temp.txt
copy NUL temp.txt
for /f "delims=" %%L in (autosplit.txt) do find "%%L" temp.txt>NUL 2>NUL || echo %%L>>temp.txt
del autosplit.txt
ren temp.txt autosplit.txt

set p_start=0
set p_end=0
set /a p_part=1
for /f "tokens=1,2 delims==" %%L in (autosplit.txt) do (
	echo %%L | findstr /i "start" && ( 
		set p_end=%%M
		if !p_part! leq 9 ( 
			set p_split=!pcopy! -ss !p_start! -to !p_end! part0!p_part!.ts 
		) else (
			set p_split=!pcopy! -ss !p_start! -to !p_end! part!p_part!.ts 
		)
		"%p_ffmpeg%" -i !p_file! !p_split!
		set /a p_part+=1
	)
	echo %%L | findstr /i "end" && ( set p_start=%%M )
)
:: split last part.
"%p_ffprobe%" -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 autosplit.ts >temp.txt
set /p p_len=<temp.txt
set p_split=%pcopy% -ss %p_start% -to %p_len% part%p_part%.ts 
"%p_ffmpeg%" -i %p_file% %p_split%