set part1=-vcodec copy -acodec copy -ss 00:01:53 -to 00:16:17 part1.ts
set part2=-vcodec copy -acodec copy -ss 00:20:58 -to 00:34:00 part2.ts
set part3=-vcodec copy -acodec copy -ss 00:38:35 -to 00:48:57 part3.ts

"C:\Program Files (x86)\Streamlink\ffmpeg\ffmpeg.exe" -i split.ts %part1% %part2% %part3%