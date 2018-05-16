set filename=thvl1-%date:~0,2%%date:~3,2%%date:~6,4%-%time:~0,2%%time:~3,2%%time:~6,2%
set vlc=C:\Program Files (x86)\VideoLAN\VLC\vlc.exe --sout=file/ts:%filename%.ts --run-time 5400

set thvl1=http://talk2.vcdn.vn/hls/7e72e4ec5b74976727ff432af3a1dbe6/1636716a569/thoixungan/index.m3u8

start "thvl1" streamlink --player "%vlc%" %thvl1% worst --hls-segment-threads 3
