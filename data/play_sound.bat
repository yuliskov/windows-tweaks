@echo off
set SOUND_FILE=%1
if "%1"=="" set SOUND_FILE=C:\Windows\Media\Alarm05.wav
set "file=%SOUND_FILE%"
( echo Set Sound = CreateObject("WMPlayer.OCX.7"^)
  echo Sound.URL = "%file%"
  echo Sound.Controls.play
  echo do while Sound.currentmedia.duration = 0
  echo wscript.sleep 100
  echo loop
  echo wscript.sleep (int(Sound.currentmedia.duration^)+1^)*1000) > "%~dp0\sound.vbs"
"%~dp0\sound.vbs"
