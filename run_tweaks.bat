@echo off

title Cleanup running. Do not close.

cd /d "%~dp0"
REM utf-8 encoding, support russian text
chcp 65001 >nul


REM Run this script with administrative privilegies
if "%1"=="task" goto SKIP_ELEVATE
if "%1"=="ok" goto SKIP_ELEVATE
data\elevate -c %0 ok
exit
:SKIP_ELEVATE

REM In order to make checks invisible code below has been moved to the bootstrap.vbs

if NOT "%1"=="task" goto SKIP_CHECKS

REM Run script every monday and do check that script already runned at this day
SET DAY=%DATE:~0,3%
SET YYYYMMDD=%DATE:~10%%DATE:~4,2%%DATE:~7,2%
IF NOT [%DAY%]==[Mon] EXIT
IF [%DAY%]==[Mon] IF EXIST "%AppData%\Lock_%YYYYMMDD%.lck" EXIT
IF [%DAY%]==[Mon] IF NOT EXIST "%AppData%\Lock_%YYYYMMDD%.lck" (
	del "%AppData%\Lock_*.lck" 2>nul
	ECHO Script has run %YYYYMMDD% already>>"%AppData%\Lock_%YYYYMMDD%.lck"
)

:SKIP_CHECKS

REM 'start' to use short path
set DATA_DIR=%~dp0data
SET CCLEANER_DIR=%~dp0CCleaner
SET CCLEANER=ccleaner64.exe
SET NIRCMD=nircmd-x64.exe
SET NIRCMD_DIR=%~dp0data
if %PROCESSOR_ARCHITECTURE%==x86 (
  SET CCLEANER=ccleaner.exe
  SET NIRCMD=nircmd.exe
)
SET CCLEANER=%CCLEANER_DIR%\%CCLEANER%
SET NIRCMD=%NIRCMD_DIR%\%NIRCMD%

REM Regular task command line. 'windows-tweaks' should be a full path
REM wscript.exe "<windows-tweaks>\data\bootstrap.vbs" "<windows-tweaks>\run_tweaks.bat" task

REM Valid schedule types: MINUTE, HOURLY, DAILY, WEEKLY, MONTHLY, ONCE, ONSTART, ONLOGON, ONIDLE, ONEVENT.
REM Example: schtasks /Create /TN "Cleanup Task" /SC WEEKLY /TR "\"%0\" task" /RL HIGHEST /F

REM REM workaround with absent option 'run task as soon as possible'
REM REM NOTE: can't combine all params in one schtasks command
REM schtasks /Create /TN "Cleanup Task" /xml "data/Cleanup Task Idle.xml" /F >nul
REM SET OLD_TASK_COMMAND=\"%0\" task
REM SET TASK_COMMAND=wscript.exe \"%~dp0data\bootstrap.vbs\" \"%0\" task
REM schtasks /Change /TN "Cleanup Task" /TR "%TASK_COMMAND%" /RU Users /RL HIGHEST >nul

REM REM ru fix: all default users and groups are localized on non-english locales
REM schtasks /Change /TN "Cleanup Task" /TR "%TASK_COMMAND%" /RU Пользователи /RL HIGHEST 2>nul

echo ============================
echo Preparing for the cleanup...
echo ============================

echo Creating Restore point (you could easily revert changes)...
Wmic.exe /Namespace:\\root\default Path SystemRestore Call CreateRestorePoint "%DATE%", 100, 7 2>nul >nul

echo =========================
echo Beginning junk cleanup...
echo =========================

echo Closing processes that may interfere with cleanup tasks...
start /wait %NIRCMD% closeprocess chrome.exe

echo Running CCleaner...
start /wait %CCLEANER% /auto

REM restore processes
REM start /d "%ProgramFiles(x86)%\Google\Chrome\Application" chrome.exe --start-maximized --disk-cache-size=104857600
REM start "" "%ProgramData%\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk"

echo ==============================
echo Beginning main cleanup part...
echo ==============================

echo Detecting OS...
for /f "tokens=4-5 delims=. " %%i in ('ver') do set VERSION=%%i.%%j
if "%version%" == "6.1" goto WINDOWS_7
if "%version%" == "6.3" goto WINDOWS_8_1
if "%version%" == "6.2" goto WINDOWS_8
if "%version%" == "10.0" goto WINDOWS_10
goto WINDOWS_END
endlocal

:WINDOWS_10
echo Windows 10 detected
pushd win10-tweaks
call run-addons.bat ok
popd
goto WINDOWS_END

:WINDOWS_8_1
:WINDOWS_8
echo Windows 8 detected
pushd win8-tweaks
call win8-clean.bat
popd
goto WINDOWS_END

:WINDOWS_7
echo Windows 7 detected
pushd win7-tweaks
call run-addons.bat ok
popd
goto WINDOWS_END

:WINDOWS_END

if exist "defrag_disks_y.cfg" goto START_DEFRAG
if exist "defrag_disks_n.cfg" goto NO_DEFRAG

SET /P AREYOUSURE=Defragment your disks (Y/[N])?
IF /I "%AREYOUSURE%" NEQ "Y" GOTO NO_DEFRAG

:START_DEFRAG

echo Starting defragmentation...
%DATA_DIR%\defrag.exe -c

:NO_DEFRAG

echo ====================
echo Finishing cleanup...
echo ====================