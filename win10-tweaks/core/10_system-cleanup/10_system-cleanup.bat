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

echo Cleaning System...

echo Running Disk Cleanup...

if not exist "%SystemDrive%\Windows.old" goto NO_WINDOWS_OLD

SET /P AREYOUSURE=Remove Windows.old directory (Y/[N])?
IF /I "%AREYOUSURE%" NEQ "Y" GOTO NO_CLEANUP

:NO_WINDOWS_OLD

rmdir /s /q "%SystemDrive%\Windows.old" 2>nul >nul

REM REM Import Disk Cleanup settings
REM reg import cleanmgr.reg >nul

REM REM NOTE: Runs tooo long!
REM REM Uncheck Defender, Temporal Files
REM cleanmgr /sagerun:1

:NO_CLEANUP

REM REM remove driver backups (view: pnputil -e)
REM REM NOTE: not active drivers (like printer ones) will be removed too
REM for /l %%N in (1,1,30) do pnputil -d oem%%N.inf >nul

echo Cleaning Startup folder...
del /q "%AppData%\Microsoft\Windows\Start Menu\Programs\Startup\*.*" 2>nul

REM clear event logs, some logs cannot be cleared
echo Clearing event logs...
for /f %%E in ('wevtutil el') do wevtutil cl %%E 2>nul

echo Cleaning WinSxS folder...
DISM /Online /Cleanup-Image /StartComponentCleanup >nul

REM Fix broken files that may appear after previous commands

SET /P AREYOUSURE=Fix broken files (Y/[N])?
IF /I "%AREYOUSURE%" NEQ "Y" GOTO NO_FIX

echo Fixing broken Distribution files...
DISM /Online /Cleanup-image /Restorehealth >nul

echo Fixing broken System files...
sfc /scannow >nul

:NO_FIX

