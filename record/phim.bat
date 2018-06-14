set ext=mp4
set input=filegoc.%ext%
set output=phim.%ext%
set ffmpeg=C:\Program Files (x86)\Streamlink\ffmpeg\ffmpeg.exe
::=====================
"%ffmpeg%" -i "%input%" -vcodec copy -acodec copy -ss 00:29:15  -to 01:18:46 -async 1 "%output%"