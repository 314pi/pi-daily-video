@echo off
set input=filegoc.mp4
set output=phim.mp4
set ffmpeg=C:\Program Files (x86)\Streamlink\ffmpeg2\ffmpeg.exe
::=====================
"%ffmpeg%" -i "%input%" -ss 00:09:30 -to 00:54:18 -movflags faststart -fflags +genpts -v error -vcodec copy -acodec copy "%output%"