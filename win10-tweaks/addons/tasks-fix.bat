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

REM sync task in tray that was appeared surpraisingly (process: msosync.exe)
REM schtasks /Delete /TN "\Microsoft Office 15 Sync Maintenance for %ComputerName%-%UserName% %ComputerName%" /F >nul 2>&1
REM path: C:\Program Files\Microsoft Office\Office15\MsoSync.exe
schtasks /Change /DISABLE /TN "\Microsoft Office 15 Sync Maintenance for %ComputerName%-%UserName% %ComputerName%" >nul 2>nul
schtasks /Change /DISABLE /TN "\Microsoft\Office\Office 15 Subscription Heartbeat" >nul 2>nul
taskkill /im msosync.exe /f 2>nul

REM Adobe (example: \AdobeAAMUpdater-1.0-DESKTOP-G03L3IK-UserName)
schtasks /Delete /TN "\AdobeAAMUpdater-1.0-%ComputerName%-%UserName%" /F 2>nul

REM REM cause number of DistributedCOM errors in event log?
REM schtasks /Delete /TN "\Microsoft\Windows\SkyDrive\Routine Maintenance Task" /F 2>nul
REM schtasks /Delete /TN "\Microsoft\Windows\SkyDrive\Idle Sync Maintenance Task" /F 2>nul

REM Google Chrome - manual check for updates
schtasks /Change /DISABLE /TN "\GoogleUpdateTaskMachineCore" >nul 2>nul
schtasks /Change /DISABLE /TN "\GoogleUpdateTaskMachineUA" >nul 2>nul


REM REM fix: "Windows Store failed to sync machine licenses. Result code 0x80070490"
REM schtasks /Change /DISABLE /TN "\Microsoft\Windows\WS\WSRefreshBannedAppsListTask" >nul

REM schtasks /Change /DISABLE /TN "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" >nul
REM schtasks /Change /DISABLE /TN "\Microsoft\Windows\Wininet\CacheTask" >nul

REM OneDrive update task
schtasks /Change /DISABLE /TN "\OneDrive Standalone Update Task v2" >nul 2>nul

REM Misc
schtasks /Change /DISABLE /TN "\Microsoft\Windows\Windows Media Sharing\UpdateLibrary" >nul 2>nul
schtasks /Change /DISABLE /TN "\Microsoft\Windows\HelloFace\FODCleanupTask" >nul 2>nul
schtasks /Change /DISABLE /TN "\Microsoft\Windows\Feedback\Siuf\DmClient" >nul 2>nul
schtasks /Change /DISABLE /TN "\CCleaner Update" >nul 2>nul
