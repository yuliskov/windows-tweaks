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

set DATA_DIR=..\data

echo Applying System tweaks...

echo Restore original background...
if not exist "%WinDir%\Web\Wallpaper\Windows\img1.jpg" copy /y "%DATA_DIR%\img1.jpg" "%WinDir%\Web\Wallpaper\Windows\img1.jpg" >nul

REM REM FIXME: set values on active power scheme
REM REM disable 'require a password on wakeup' (0=no, 1=yes)
REM powercfg -SETACVALUEINDEX SCHEME_BALANCED SUB_NONE CONSOLELOCK 0

REM disable hybrid sleep (save ssd life)
REM powercfg -h off
REM powercfg -h on
REM turn off hdd after 60 minutes of inactivity (default - 20 min)
powercfg -change -disk-timeout-ac 60
REM disable wake timers (plugged in) 
powercfg /SETACVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 bd3b718a-0680-4d9d-8ab2-e1d2b4ac806d 0
REM disable wake timers (on battery) 
powercfg /SETDCVALUEINDEX SCHEME_CURRENT 238c9fa8-0aad-41ed-83f4-97be242c8f20 bd3b718a-0680-4d9d-8ab2-e1d2b4ac806d 0

REM Enable auto login (in GUI)
REM Example (REG_SZ): AutoAdminLogon=1, DefaultPassword=1, DefaultUserName=Yuriy
set REG=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon
reg query "%REG%" /v AutoAdminLogon | findstr 0 >nul && netplwiz

