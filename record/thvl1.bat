set hour=%time:~0,2%
if "%hour:~0,1%" == " " set hour=0%hour:~1,1%
set min=%time:~3,2%
if "%min:~0,1%" == " " set min=0%min:~1,1%
set secs=%time:~6,2%
if "%secs:~0,1%" == " " set secs=0%secs:~1,1%

set filename=thvl1_%date:~0,2%%date:~3,2%_%hour%%min%%secs%.ts
set filename=%filename: =% 
set vlc=C:\Program Files (x86)\VideoLAN\VLC\vlc.exe -I dummy --sout=file/ts:%filename% --network-caching=60000 --run-time 4200 --play-and-exit

set thvl1=http://talk2.vcdn.vn/hls/c056383b080b512d0629dc43b39c018d/1636b77954c/thoixungan/index.m3u8

:start_record

tasklist /fi "WindowTitle eq pi-thvl1" | find /i "streamlink.exe" || start "pi-thvl1" streamlink --player "%vlc%" %thvl1% worst --hls-segment-threads 3

timeout /t 10 /nobreak

goto start_record