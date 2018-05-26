@echo off
setlocal enabledelayedexpansion
set p_ffprobe=C:\Program Files (x86)\Streamlink\ffmpeg\ffprobe.exe
set p_ffmpeg=C:\Program Files (x86)\Streamlink\ffmpeg\ffmpeg.exe
set pcopy=-vcodec copy -acodec copy
set p_filename=adv_free.ts
set p_sub=15
cls

"%p_ffmpeg%" -i %p_filename% -strict experimental -vf "drawtext=fontfile='arial_0.ttf':textfile=marq1.txt:x=(w-text_w)/2:y=10:fontsize=10:fontcolor=white" -vcodec libx264 -crf 30 -c:a copy -ss 0 -t %p_sub% 1%p_filename%

"%p_ffprobe%" -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 %p_filename% >temp.txt
set /p p_end=<temp.txt
for /f "delims=" %%a in ('powershell %p_end%-%p_sub%') do set b_end=%%a

"%p_ffmpeg%" -i %p_filename% -vcodec copy -acodec copy -ss %p_sub% -to %p_end% 2%p_filename%

(for %%i in (?adv_free.ts) do @echo file '%%i') > af4j.txt

set filename=join_%date:~0,2%%date:~3,2%_%time:~0,2%%time:~3,2%%time:~6,2%.ts
set filename=%filename: =% 
"%p_ffmpeg%" -f concat -i af4j.txt -c copy %filename%