@echo off
set input=filegoc.mp4
set output=phim.mp4
call apps.bat
::=====================
"%ffmpeg%" -i "%input%" -ss 00:00:00 -to 03:39:00 -movflags faststart -fflags +genpts -v error -vcodec copy -acodec copy "%output%