set ext=mp4
set input=filegoc.%ext%
set output=phim2.%ext%
set ffmpeg=C:\Program Files (x86)\Streamlink\ffmpeg\ffmpeg.exe
::=====================
"%ffmpeg%" -i "%input%" -vcodec copy -acodec copy -ss 00:09:41  -to 00:51:47 -async 1 "%output%"