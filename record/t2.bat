@echo off
setlocal enabledelayedexpansion
    set c5=test
    set num=5

    :: set cnum to string "c5"
        set cnum=c%num%
    :: set h1 to to the existing variable c5 
        call set "h1=%%%cnum%%%"
        echo %h1%