REM Adobe Cache (up to 20 GB)
rmdir /s /q "%AppData%\Adobe\Common\Media Cache Files" 2>nul

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

REM !!!!!!!!!TWEAKS!!!!!!!!!!

echo applying registry tweaks...
REM core tweaks
reg import win8-tweaks.reg >nul


REM sync task in tray that was appeared surpraisingly (process: msosync.exe)
REM schtasks /Delete /TN "\Microsoft Office 15 Sync Maintenance for %ComputerName%-%UserName% %ComputerName%" /F >nul 2>&1
schtasks /Change /DISABLE /TN "\Microsoft Office 15 Sync Maintenance for %ComputerName%-%UserName% %ComputerName%" >nul
schtasks /Change /DISABLE /TN "\Microsoft\Office\Office 15 Subscription Heartbeat" >nul
taskkill /im msosync.exe /f 2>nul
REM Adone CS6 task
schtasks /Delete /TN "\AdobeAAMUpdater-1.0-%ComputerName%-%UserName%" /F 2>nul

REM cause number of DistributedCOM errors in event log?
schtasks /Delete /TN "\Microsoft\Windows\SkyDrive\Routine Maintenance Task" /F 2>nul
schtasks /Delete /TN "\Microsoft\Windows\SkyDrive\Idle Sync Maintenance Task" /F 2>nul

REM Google Chrome - manual check for updates
schtasks /Change /DISABLE /TN "\GoogleUpdateTaskMachineCore" >nul
schtasks /Change /DISABLE /TN "\GoogleUpdateTaskMachineUA" >nul


REM fix: "Windows Store failed to sync machine licenses. Result code 0x80070490"
schtasks /Change /DISABLE /TN "\Microsoft\Windows\WS\WSRefreshBannedAppsListTask" >nul

schtasks /Change /DISABLE /TN "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" >nul
schtasks /Change /DISABLE /TN "\Microsoft\Windows\Wininet\CacheTask" >nul
REM schtasks /Change /DISABLE /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" >nul
REM schtasks /Change /DISABLE /TN "\Microsoft\Windows\Windows Error Reporting\QueueReporting" >nul

REM Distributed Link Tracking Client (update link to file when one moved)
sc config TrkWks start=demand >nul
sc stop TrkWks >nul

REM Superfetch Service (background caching)
sc config SysMain start=demand >nul
sc stop SysMain >nul

REM Offline Files
sc config CscService start=demand >nul
sc stop CscService >nul

REM Google
sc config gupdate start=demand >nul
sc stop gupdate >nul

REM Adobe
sc config AdobeUpdateService start=demand >nul
sc stop AdobeUpdateService >nul

REM Nvidia
sc config nvUpdatusService start=demand >nul
sc stop nvUpdatusService >nul

REM Nvidia
sc config nvsvc start=demand >nul
sc stop nvsvc >nul

REM Touch Keyboard and Handwriting Panel Service (acitve when device attached)
sc config TabletInputService start=demand >nul
sc stop TabletInputService >nul

REM Skype Update Service
sc config SkypeUpdate start=demand >nul
sc stop SkypeUpdate >nul

REM Font Cache Service
sc config FontCache start=demand >nul
sc stop FontCache >nul


REM Program Compatability Assistent
sc config PcaSvc start=demand >nul
sc stop PcaSvc >nul

REM Program Compatability Assistent
sc config "Net Driver HPZ12" start=demand >nul
sc stop "Net Driver HPZ12" >nul

REM Uninstall registry paths:
REM HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\
REM HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\

REM Microsoft Visual C++ 2008 Redistributable - x86 9.0.30729.17
msiexec /X{9A25302D-30C0-39D9-BD6F-21E6EC160475} /passive

REM Microsoft Visual C++ 2008 Redistributable - x64 9.0.21022
MsiExec.exe /X{350AA351-21FA-3270-8B7A-835434E766AD} /passive

REM Microsoft Visual C++ 2008 Redistributable - x64 9.0.30729.4148
MsiExec.exe /X{4B6C7001-C7D6-3710-913E-5BC23FCE91E6} /passive

REM Microsoft Visual C++ 2008 Redistributable - x86 9.0.30729.4148
MsiExec.exe /X{1F1C2DFC-2D24-3E06-BCB8-725134ADF989} /passive

REM Microsoft Visual C++ 2010  x64 Redistributable - 10.0.40219
MsiExec.exe /X{1D8E6291-B0D5-35EC-8441-6616F567A0F7} /passive

REM Microsoft Visual C++ 2010  x32 Redistributable - 10.0.40219
MsiExec.exe /X{F0C3E5D1-1ADE-321E-8167-68EF0DE699A5} /passive

REM Microsoft Visual C++ 2005 Redistributable
MsiExec.exe /X{710f4c1c-cc18-4c49-8cbf-51240c89a1a2} /passive


REM Are we running from scheduled task? Limit to basic job only.
REM NOTE: exit /b to return "operation completed successfully"
if "%1"=="task" exit /b


echo Cleaning System

REM FIXME: set values on active power scheme
REM disable 'require a password on wakeup' (0=no, 1=yes)
powercfg -SETACVALUEINDEX SCHEME_BALANCED SUB_NONE CONSOLELOCK 0

REM enable auto login (select in GUI)
set REG=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon
reg query "%REG%" /v AutoAdminLogon | findstr 0 >nul && netplwiz