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

if not exist "%SystemDrive%\Windows.old" goto NO_DELETE

SET /P AREYOUSURE=Remove Windows.old directory (Y/[N])?
IF /I "%AREYOUSURE%" NEQ "Y" GOTO NO_DELETE

echo Removing old Windows directory...
rmdir /s /q "%SystemDrive%\Windows.old" 2>nul >nul

:NO_DELETE

REM ================================================================

REM REM remove driver backups (view: pnputil -e)
REM REM NOTE: not active drivers (like printer ones) will be removed too
REM for /l %%N in (1,1,30) do pnputil -d oem%%N.inf >nul

echo Cleaning Startup folder...
del /q "%AppData%\Microsoft\Windows\Start Menu\Programs\Startup\*.*" 2>nul

echo Cleaning old boot files...
del /q "%SystemDrive%\BOOTSECT.BAK" 2>nul

echo Removing desktop.ini files...
del  /a:H /s /q "%SystemDrive%\Users\desktop.ini" 2>nul >nul

REM clear event logs, some logs cannot be cleared
echo Clearing event logs...
for /f %%E in ('wevtutil el') do wevtutil cl %%E 2>nul

echo Cleaning WinSxS folder...
DISM /Online /Cleanup-Image /StartComponentCleanup >nul

REM ================================================================

REM Run Windows Disk Cleanup utility 
REM NOTE: Runs tooo long!

if exist "%CONFIG_DIR%\run_disk_cleanup_y.cfg" goto START_CLEANUP
if exist "%CONFIG_DIR%\run_disk_cleanup_n.cfg" goto NO_CLEANUP

SET /P AREYOUSURE=Run Windows Disk Cleanup utility (Y/[N])?
IF /I "%AREYOUSURE%" NEQ "Y" GOTO NO_CLEANUP

:START_CLEANUP

echo Running Disk Cleanup...

REM Import Disk Cleanup settings
reg import cleanmgr-settings.reg >nul 2>nul

cleanmgr /sagerun:1

:NO_CLEANUP

REM ================================================================

REM Fix broken files that may appear after previous commands

if exist "%CONFIG_DIR%\fix_broken_files_y.cfg" goto START_FIX
if exist "%CONFIG_DIR%\fix_broken_files_n.cfg" goto NO_FIX

SET /P AREYOUSURE=Fix broken files (Y/[N])?
IF /I "%AREYOUSURE%" NEQ "Y" GOTO NO_FIX

:START_FIX

echo Fixing broken Distribution files...
DISM /Online /Cleanup-image /Restorehealth >nul

echo Fixing broken System files...
sfc /scannow >nul

:NO_FIX

