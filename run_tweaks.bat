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

REM if NOT "%1"=="task" goto SKIP_CHECKS

REM REM Run script every monday and do check that script already runned at this day
REM SET DAY=%DATE:~0,3%
REM SET YYYYMMDD=%DATE:~10%%DATE:~4,2%%DATE:~7,2%
REM IF NOT [%DAY%]==[Mon] EXIT
REM IF [%DAY%]==[Mon] IF EXIST "%userprofile%\Lock_%YYYYMMDD%.lck" EXIT
REM IF [%DAY%]==[Mon] IF NOT EXIST "%userprofile%\Lock_%YYYYMMDD%.lck" (
REM 	del "%userprofile%\Lock_*.lck" 2>nul
REM 	ECHO Script has run %YYYYMMDD% already>>"%userprofile%\Lock_%YYYYMMDD%.lck"
REM )

REM :SKIP_CHECKS

REM 'start' to use short path
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


REM Valid schedule types: MINUTE, HOURLY, DAILY, WEEKLY, MONTHLY, ONCE, ONSTART, ONLOGON, ONIDLE, ONEVENT.
REM Example: schtasks /Create /TN "Cleanup Task" /SC WEEKLY /TR "\"%0\" task" /RL HIGHEST /F

REM REM workaround with absent option 'run task as soon as possible'
REM REM NOTE: can't combine all params in one schtasks command
REM schtasks /Create /TN "Cleanup Task" /xml "data/Cleanup Task.xml" /F >nul
REM SET OLD_TASK_COMMAND=\"%0\" task
REM SET TASK_COMMAND=wscript.exe \"%~dp0data\bootstrap.vbs\" \"%0\" task
REM schtasks /Change /TN "Cleanup Task" /TR "%TASK_COMMAND%" /RU Users /RL HIGHEST >nul
REM REM ru fix: all default users and groups are localized on non-english locales
REM schtasks /Change /TN "Cleanup Task" /TR "%TASK_COMMAND%" /RU Пользователи /RL HIGHEST 2>nul

echo =========================
echo Beginning junk cleanup...
echo =========================

REM close processes that interfere with cleanup tasks
REM start /wait %NIRCMD% closeprocess chrome.exe

echo Running CCleaner...
start /wait %CCLEANER% /auto

REM restore processes
REM start /d "C:\Program Files (x86)\Google\Chrome\Application" chrome.exe --start-maximized --disk-cache-size=104857600

echo =============================
echo Entering main cleanup part...
echo =============================

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
call win10-clean.bat
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
call win7-clean.bat
popd
goto WINDOWS_END

:WINDOWS_END

echo ====================
echo Finishing cleanup...
echo ====================

REM cleanmgr settings
reg import data\cleanmgr.reg >nul

REM uncheck Defender, Temporal Files
REM if task already exist skip cleanup
cleanmgr /sagerun:1
REM Does verylowdisk hide GUI??? (No on Win10)
REM cleanmgr /sagerun:1 /verylowdisk

REM REM remove driver backups (view: pnputil -e)
REM for /l %%N in (1,1,30) do pnputil -d oem%%N.inf >nul

REM clear event logs, some logs cannot be cleared
echo Clearing event logs...
for /f %%E in ('wevtutil el') do wevtutil cl %%E 2>nul

REM defrag only work with elevate-x64

REM REM boot optimization and defragmentation
REM REM fixed: Some registry entries were missing from the boot optimization section of the registry. (0x89000017)
REM defrag.exe %SystemDrive% /B /U
REM if "%ERRORLEVEL%"=="0" goto DEFRAG_OK
REM start /wait rundll32.exe advapi32.dll,ProcessIdleTasks
REM :DEFRAG_OK

REM problem on win7 ro folder
REM call data\play_sound.bat