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

REM Start/Stop unwanted services

REM Unwanted Windows services (BEGIN)
REM Details: https://github.com/W4RH4WK/Debloat-Windows-10/blob/master/scripts/disable-services.ps1

REM Disable Telemetry and Data Collection
sc config dmwappushservice start=disabled >nul
sc stop dmwappushservice >nul

REM Diagnostics Tracking Service
sc config DiagTrack start=disabled >nul
sc stop DiagTrack >nul

REM Microsoft (R) Diagnostics Hub Standard Collector Service
REM HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\diagnosticshub.standardcollector.service
sc config diagnosticshub.standardcollector.service start=disabled >nul
sc stop diagnosticshub.standardcollector.service >nul

REM Distributed Link Tracking Client (update link to file when one moved)
sc config TrkWks start=demand >nul
sc stop TrkWks >nul

REM Unwanted Windows services (END)

REM Google Chrome update
sc config gupdate start=disabled >nul
sc stop gupdate >nul

REM Google Chrome update
sc config gupdatem start=disabled >nul
sc stop gupdatem >nul

REM Nvidia
sc config nvUpdatusService start=demand >nul
sc stop nvUpdatusService >nul

REM Nvidia
sc config nvsvc start=demand >nul
sc stop nvsvc >nul

REM Skype Update Service
sc config SkypeUpdate start=demand >nul
sc stop SkypeUpdate >nul

REM HP LaserJet Print
sc config "Net Driver HPZ12" start=demand >nul
sc stop "Net Driver HPZ12" >nul

REM HP LaserJet Print
sc config "Pml Driver HPZ12" start=demand >nul
sc stop "Pml Driver HPZ12" >nul

REM Windows 10: Fix Event 7031 System Control Manager
sc config "OneSyncSvc" start=disabled >nul
sc stop "OneSyncSvc" >nul

REM Windows 10: Fix Event 7031 System Control Manager
sc config "OneSyncSvc_470c3" start=disabled >nul
sc stop "OneSyncSvc_470c3" >nul

REM Adobe Autoupdate
sc config AdobeUpdateService start=disabled >nul
sc stop AdobeUpdateService >nul

REM Adobe Genuine Integrity Service
sc config "AGSService" start=disabled >nul
sc stop "AGSService" >nul

REM Program Compatability Assistent
sc config PcaSvc start=demand >nul
sc stop PcaSvc >nul

REM Punk Buster game service
sc config PnkBstrA start=demand >nul
sc stop PnkBstrA >nul

REM Intel content protection service
sc config cphs start=demand >nul
sc stop cphs >nul

REM Windows Remediation Service (Update help service)
sc config sedsvc start=demand >nul
sc stop sedsvc >nul

REM Freemake Video Converter service
sc config FreemakeVideoCapture start=demand >nul
sc stop FreemakeVideoCapture >nul

REM Windows Remediation Service
sc config sedsvc start=demand >nul
sc stop sedsvc >nul

REM REM Connected Devices Platform Service (Auto-Delayed)
REM sc config CDPSvc start=demand >nul
REM sc stop CDPSvc >nul

REM REM Connected Devices Platform User Service_30c79 (Auto) DISABLE NOT WORK
REM sc config CDPUserSvc_30c79 start=demand >nul
REM sc stop CDPUserSvc_30c79 >nul

REM REM Windows Push Notifications System Service (Auto)
REM sc config WpnService start=demand >nul
REM sc stop WpnService >nul

REM REM Windows Push Notifications User Service_30c79 (Auto) DISABLE NOT WORK
REM sc config WpnUserService_30c79 start=demand >nul
REM sc stop WpnUserService_30c79 >nul

REM REM Superfetch Service (background caching, increase RAM usage)
REM REM Optimize Windows 10: https://www.tenforums.com/tutorials/26120-optimize-performance-windows-10-a.html
REM sc config SysMain start=demand >nul
REM sc stop SysMain >nul

REM Search Indexing Service
REM sc config WSearch start=demand >nul
REM sc stop WSearch >nul

REM REM Offline Files
REM sc config CscService start=demand >nul
REM sc stop CscService >nul

REM REM Touch Keyboard and Handwriting Panel Service (acitve when device attached)
REM sc config TabletInputService start=demand >nul
REM sc stop TabletInputService >nul

REM REM Font Cache Service
REM sc config FontCache start=demand >nul
REM sc stop FontCache >nul

REM End Services
