set pcopy=-vcodec copy -acodec copy
set part1=%pcopy% -ss 00:00:00 -to 00:02:04 part1.ts 
set part2=%pcopy% -ss 00:04:38 -to 00:16:23 part2.ts
set part3=%pcopy% -ss 00:40:39 -to 00:44:05 part3.ts

"C:\Program Files (x86)\Streamlink\ffmpeg\ffmpeg.exe" -i split.ts %part1% %part2% %part3%