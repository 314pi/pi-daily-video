set pcopy=-vcodec copy -acodec copy
set part1=%pcopy% -ss 00:00:00 -to 00:39:27 part1.ts
set part2=%pcopy% -ss 00:44:32 -to 00:57:45 part2.ts
set part3=%pcopy% -ss 00:59:26 -to 00:59:59 part3.ts

"C:\Program Files (x86)\Streamlink\ffmpeg\ffmpeg.exe" -i split.ts %part1% %part2% %part3%