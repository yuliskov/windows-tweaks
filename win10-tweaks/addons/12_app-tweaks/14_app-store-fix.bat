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

REM Fix high cpu consumption by wsappx service
REM More info: https://www.howtogeek.com/249690/how-to-fix-a-stuck-download-in-the-windows-store/

REM Reset store cache
wsreset.exe

REM Close App Store (it should auto pop-up after wsreset command)
taskkill /im WinStore.App.exe /f >nul 2>nul