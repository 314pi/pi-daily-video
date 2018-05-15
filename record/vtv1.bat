set filename=%date:~0,2%%date:~3,2%%date:~6,4%-%time:~0,2%%time:~3,2%%time:~6,2%
echo %filename%
start "vtv1" streamlink --player "C:\Program Files (x86)\VideoLAN\VLC\vlc.exe --sout=file/ts:%filename%.ts --run-time 5400" http://vtvgo-live-appobj.b5695cde.cdnviet.com/fe96a8880d5a70ad3e08d93dbd1cc3ca1526399426/live/_definst_/vtv1-mid.m3u8 worst --hls-segment-threads 3
