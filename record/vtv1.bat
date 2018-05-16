set filename=%date:~0,2%%date:~3,2%%date:~6,4%-%time:~0,2%%time:~3,2%%time:~6,2%

start "vtv1" streamlink --player "C:\Program Files (x86)\VideoLAN\VLC\vlc.exe --sout=file/ts:%filename%.ts --run-time 5400" http://vtvgo-live-appobj.b5695cde.cdnviet.com/9a126474a4bf19dd7017363518d9d21f1526410764/live/_definst_/vtv1-mid.m3u8 worst --hls-segment-threads 3
