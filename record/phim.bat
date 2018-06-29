@echo off
set input=filegoc.ts
set output=phim.ts
set ffmpeg=C:\Program Files (x86)\Streamlink\ffmpeg2\ffmpeg.exe
::=====================
"%ffmpeg%" -i "%input%" -ss 00:00:00 -to 01:57:07 -movflags faststart -fflags +genpts -v error -vcodec copy -acodec copy "%output%"