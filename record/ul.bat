@echo off
setlocal enabledelayedexpansion
call apps.bat
cls
set chs[0]=thvl1
set chs[1]=vtv1
set chs[2]=vtv3
set chs[3]=htv2
set chs[4]=htv7
set chs[5]=htv9
set chs[6]=qpvn

set "x=0"
:LenLoop 
	if defined chs[%x%] ( 
	   set /a "x+=1"
	   goto :LenLoop 
	)
set /a len=%x%-1
for /l %%n in (0,1,%len%) do ( call getlink.bat !chs[%%n]! )