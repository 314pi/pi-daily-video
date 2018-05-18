set part1=-vcodec copy -acodec copy -ss 00:04:03 -to 00:20:16 part1.ts
set part2=-vcodec copy -acodec copy -ss 00:25:10 -to 00:36:03 part2.ts
set part3=-vcodec copy -acodec copy -ss 00:40:48 -to 00:52:47 part3.ts

"C:\Program Files (x86)\Streamlink\ffmpeg\ffmpeg.exe" -i split.ts %part1% %part2% %part3%