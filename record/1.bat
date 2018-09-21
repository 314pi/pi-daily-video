@echo off
set input=1.mp4
set output=2.mp4
call apps.bat
::=====================
"%ffmpeg%" -i "%input%" -ss 00:00:00 -to 03:37:59 -movflags faststart -fflags +genpts -v error -vcodec copy -acodec copy "%output%"