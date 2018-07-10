@echo off
setlocal enabledelayedexpansion
cls
::=================================
set filename=%1
if [%filename%]==[] set filename=filegoc.ts
set pispd=%2
if [%pispd%]==[] set pispd=1.1
set ffmpeg=C:\Program Files (x86)\Streamlink\ffmpeg\ffmpeg.exe
set start=%time%
set speed=-filter_complex "[0:v]setpts=(1/%pispd%)*PTS[v];[0:a]atempo=%pispd%[a]" -map "[v]" -map "[a]"
"%ffmpeg%" -i %filename% -strict experimental -vcodec libx264 -crf 30 %speed% -ss 0 -t 10800 x%pispd%_%filename%
echo START @: %start% / END @: %time%