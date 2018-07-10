@echo off
set input=filegoc.mp4
set output=phim.mp4
call apps.bat
::=====================
"%ffmpeg%" -i "%input%" -ss 00:03:23 -to 00:53:52 -movflags faststart -fflags +genpts -v error -vcodec copy -acodec copy "%output%