set ext=mp4
set input=filegoc.%ext%
set output=phim.%ext%
set ffmpeg=C:\Program Files (x86)\Streamlink\ffmpeg\ffmpeg.exe
::=====================
"%ffmpeg%" -i "%input%" -vcodec copy -acodec copy -ss 00:45:33  -to 01:28:51 -async 1 "%output%"