set part1=-vcodec copy -acodec copy -ss 00:08:42 -to 00:22:09 part1.ts
set part2=-vcodec copy -acodec copy -ss 00:24:44 -to 00:36:05 part2.ts
set part3=-vcodec copy -acodec copy -ss 00:38:24 -to 00:55:00 part3.ts

"C:\Program Files (x86)\Streamlink\ffmpeg\ffmpeg.exe" -i split.ts %part1% %part2% %part3%