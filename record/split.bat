set pcopy=-vcodec copy -acodec copy
set part1=%pcopy% -ss 00:03:28 -to 00:16:44 part1.ts 
set part2=%pcopy% -ss 00:23:44 -to 00:35:16 part2.ts
set part3=%pcopy% -ss 00:41:01 -to 00:55:18 part3.ts

"C:\Program Files (x86)\Streamlink\ffmpeg\ffmpeg.exe" -i split.ts %part1% %part2% %part3%