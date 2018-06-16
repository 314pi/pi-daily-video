@echo off
set input=filegoc.mp4
set output=phim.mp4
set ffmpeg=C:\Program Files (x86)\Streamlink\ffmpeg2\ffmpeg.exe
::=====================
"%ffmpeg%" -i "%input%" -ss 00:07:37 -to 00:53:58 -movflags faststart -fflags +genpts -v error -vcodec copy -acodec copy -reset_timestamps 1 -async 1 -copyts "%output%"