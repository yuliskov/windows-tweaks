@echo off

echo Running %~n0...

cd /d "%~dp0"

if "%1"=="ok" goto SKIP_ELEVATE
echo call :Elevate "%0" ok
call :Elevate "%0" ok
exit
:SKIP_ELEVATE

goto ElevateEnd

:Elevate
	set COMMAND=%*
	ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\OEgetPrivileges.vbs" 
	ECHO UAC.ShellExecute "cmd", "/c %COMMAND%", "", "runas", 1 >> "%temp%\OEgetPrivileges.vbs" 
	"%temp%\OEgetPrivileges.vbs"
goto :eof

:ElevateEnd

REM ================================================================

REM misc tmp dirs
rmdir /s /q "%SystemDrive%\Config.Msi" 2>nul
rmdir /s /q "%SystemDrive%\NVIDIA" 2>nul
rmdir /s /q "%SystemDrive%\Intel" 2>nul
rmdir /s /q "%SystemDrive%\_acestream_cache_" 2>nul
REM rmdir /s /q "%ProgramFiles%\NVIDIA Corporation\Installer2"

REM fix: chrome didn't shutdown correctly
del "%LocalAppData%\Google\*.tmp" /s >nul 2>nul

REM common location for Chome's downloaded files
del "%UserProfile%\Downloads\*.torrent" >nul 2>nul
del "%UserProfile%\Documents\*.torrent" >nul 2>nul

REM hidden files
del /a:- "%UserProfile%\Desktop\desktop.ini" 2>nul
del /a:- "%UserProfile%\Documents\desktop.ini" 2>nul
del /a:- "%UserProfile%\Downloads\desktop.ini" 2>nul
del /a:- "%ProgramFiles%\desktop.ini" 2>nul
del /a:- "%ProgramFiles(x86)%\desktop.ini" 2>nul

REM SublimeText2
set HOSTS=..\data\hosts.exe
%HOSTS% set license.sublimehq.com 0.0.0.0 >nul
%HOSTS% set 45.55.255.55 0.0.0.0 >nul
%HOSTS% set 45.55.41.223 0.0.0.0 >nul
