set part1=-vcodec copy -acodec copy -ss 00:14:26 -to 00:27:10 part1.ts
set part2=-vcodec copy -acodec copy -ss 00:29:35 -to 00:43:47 part2.ts
set part3=-vcodec copy -acodec copy -ss 00:43:57 -to 00:53:15 part3.ts

"C:\Program Files (x86)\Streamlink\ffmpeg\ffmpeg.exe" -i split.ts %part1% %part2% %part3%