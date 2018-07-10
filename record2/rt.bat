title pi-thvl1 
streamlink "http://live2.thvli.vn/5496b7c5e8ccfddcae3f8fc779997ab81529149190/live/thvl1hd_720000/index.m3u8" worst  --stdout | "C:\Program Files (x86)\Streamlink\ffmpeg2\ffmpeg.exe" -i pipe:0 -vf scale=640:-2  -bsf:a aac_adtstoasc -f mp4 -movflags empty_moov+separate_moof+frag_keyframe -y thvl1_1606_105353.mp4 -hide_banner 
t