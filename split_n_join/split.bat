set part1=-vcodec copy -acodec copy -ss 00:03:32 -to 00:15:34 part1.ts
set part2=-vcodec copy -acodec copy -ss 00:20:11 -to 00:33:40 part2.ts
set part3=-vcodec copy -acodec copy -ss 00:39:17 -to 00:52:05 part3.ts

"C:\Program Files (x86)\Streamlink\ffmpeg\ffmpeg.exe" -i split.ts %part1% %part2% %part3%