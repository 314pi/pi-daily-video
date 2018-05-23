set pcopy=-vcodec copy -acodec copy
set part1=%pcopy% -ss 00:00:04 -to 01:00:38 part4.ts 

"C:\Program Files (x86)\Streamlink\ffmpeg\ffmpeg.exe" -i part16.ts %part1%