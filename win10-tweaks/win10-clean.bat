REM IDEA evaluation key
rmdir /s /q "%UserProfile%\.IntelliJIdea2016.2\config\eval" 2>nul

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

SET REGFILE_NAME=win10-tweaks.reg

echo applying registry tweaks...
REM core tweaks
reg import %REGFILE_NAME% >nul


REM sync task in tray that was appeared surpraisingly (process: msosync.exe)
REM schtasks /Delete /TN "\Microsoft Office 15 Sync Maintenance for %ComputerName%-%UserName% %ComputerName%" /F >nul 2>&1
schtasks /Change /DISABLE /TN "\Microsoft Office 15 Sync Maintenance for %ComputerName%-%UserName% %ComputerName%" >nul
schtasks /Change /DISABLE /TN "\Microsoft\Office\Office 15 Subscription Heartbeat" >nul
taskkill /im msosync.exe /f 2>nul
REM Adone CS6 task
schtasks /Delete /TN "\AdobeAAMUpdater-1.0-%ComputerName%-%UserName%" /F 2>nul

REM REM cause number of DistributedCOM errors in event log?
REM schtasks /Delete /TN "\Microsoft\Windows\SkyDrive\Routine Maintenance Task" /F 2>nul
REM schtasks /Delete /TN "\Microsoft\Windows\SkyDrive\Idle Sync Maintenance Task" /F 2>nul

REM Google Chrome - manual check for updates
schtasks /Change /DISABLE /TN "\GoogleUpdateTaskMachineCore" >nul
schtasks /Change /DISABLE /TN "\GoogleUpdateTaskMachineUA" >nul


REM REM fix: "Windows Store failed to sync machine licenses. Result code 0x80070490"
REM schtasks /Change /DISABLE /TN "\Microsoft\Windows\WS\WSRefreshBannedAppsListTask" >nul

REM schtasks /Change /DISABLE /TN "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" >nul
REM schtasks /Change /DISABLE /TN "\Microsoft\Windows\Wininet\CacheTask" >nul



REM Start Services




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

REM Adobe Genuine Integrity Service
sc config "AGSService" start=demand >nul
sc stop "AGSService" >nul

REM Distributed Link Tracking Client (update link to file when one moved)
sc config TrkWks start=demand >nul
sc stop TrkWks >nul

REM Program Compatability Assistent
sc config PcaSvc start=demand >nul
sc stop PcaSvc >nul

REM Punk Buster game service
sc config PnkBstrA start=demand >nul
sc stop PnkBstrA >nul

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




REM Block unwanted hosts (Adobe)
set HOSTS=data\hosts.exe
%HOSTS% set lmlicenses.wip4.adobe.com 0.0.0.0
%HOSTS% set lm.licenses.adobe.com 0.0.0.0
%HOSTS% set na1r.services.adobe.com 0.0.0.0
%HOSTS% set hlrcv.stage.adobe.com 0.0.0.0
%HOSTS% set practivate.adobe.com  0.0.0.0
%HOSTS% set activate.adobe.com 0.0.0.0


REM Uninstall registry paths:
REM HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\
REM HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\

REM Adobe Creative Suite

REM Microsoft Visual C++ 2008 Redistributable - x86 9.0.30729.17
msiexec /X{9A25302D-30C0-39D9-BD6F-21E6EC160475} /passive

REM Microsoft Visual C++ 2008 Redistributable - x64 9.0.30729.17
MsiExec.exe /X{8220EEFE-38CD-377E-8595-13398D740ACE} /passive

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

REM Microsoft Visual C++ 2005 Redistributable
MsiExec.exe /X{7299052b-02a4-4627-81f2-1818da5d550d} /passive

REM REM Microsoft Visual C++ 2008 Redistributable - x86 9.0.30729.6161 (MSI AfterBurner)
REM MsiExec.exe /X{9BE518E6-ECC6-35A9-88E4-87755C07200F} /passive

REM Microsoft Visual C++ 2012 Redistributable (x86) - 11.0.61030
"C:\ProgramData\Package Cache\{33d1fd90-4274-48a1-9bc1-97e33d9c2d6f}\vcredist_x86.exe" /uninstall /quiet

REM Microsoft Visual C++ 2013 Redistributable (x86) - 12.0.30501
"C:\ProgramData\Package Cache\{f65db027-aff3-4070-886a-0d87064aabb1}\vcredist_x86.exe" /uninstall /quiet

REM REM Microsoft Visual C++ 2008 Redistributable - x86 9.0.30729.6161 (MSIAfterburner)
REM MsiExec.exe /X{9BE518E6-ECC6-35A9-88E4-87755C07200F} /passive

REM REM Microsoft Visual C++ 2008 Redistributable - x64 9.0.30729.6161 (MSIAfterburner)
REM MsiExec.exe /X{5FCE6D76-F5DC-37AB-B2B8-22AB8CEDB1D4} /passive

REM REM Microsoft Visual C++ 2012 Redistributable (x64) - 11.0.61030 (Photoshop 2015)
REM "C:\ProgramData\Package Cache\{ca67548a-5ebe-413a-b50c-4b9ceb6d66c6}\vcredist_x64.exe" /uninstall /quiet

REM REM Microsoft Visual C++ 2013 Redistributable (x64) - 12.0.30501 (Photoshop 2015)
REM "C:\ProgramData\Package Cache\{050d4fc8-5d48-4b8f-8972-47c82c46020f}\vcredist_x64.exe" /uninstall /quiet

REM REM Microsoft Visual C++ 2013 Redistributable (x86) - 12.0.21005 (Photoshop 2015)
REM MsiExec.exe /X{13A4EE12-23EA-3371-91EE-EFB36DDFFF3E} /passive


REM Office 2016 unused MUI #1
MsiExec.exe /X{90160000-001F-0401-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0402-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0403-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0404-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0405-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0406-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0407-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0408-1000-0000000FF1CE} /passive
REM Office 2016 unused MUI #2
MsiExec.exe /X{90160000-001F-040B-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-040C-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-040D-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-040E-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-040F-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0410-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0411-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0412-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0413-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0414-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0415-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0416-1000-0000000FF1CE} /passive
REM Office 2016 unused MUI #3
MsiExec.exe /X{90160000-001F-0418-1000-0000000FF1CE} /passive
REM Office 2016 unused MUI #4
MsiExec.exe /X{90160000-001F-041A-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-041B-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-041C-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-041D-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-041E-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-041F-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0420-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0421-1000-0000000FF1CE} /passive
REM Office 2016 unused MUI #5
MsiExec.exe /X{90160000-001F-0424-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0425-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0426-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0427-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0428-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0429-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-042A-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-042B-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-042C-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-042D-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-042E-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-042F-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0432-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0434-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0435-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0436-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0437-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0438-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0439-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-043A-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-043E-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-043F-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0440-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0441-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0443-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0444-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0445-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0446-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0447-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0448-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0449-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-044A-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-044B-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-044C-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-044D-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-044E-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0452-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0456-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0457-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-045B-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0461-1000-0000000FF1CE} /passive
REM Office 2016 unused MUI #6
MsiExec.exe /X{90160000-001F-0468-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-046A-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-046C-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-046E-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0470-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0481-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0487-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0488-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0491-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0804-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0814-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0816-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-081A-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-083C-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0845-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0C0A-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-0C1A-1000-0000000FF1CE} /passive
MsiExec.exe /X{90160000-001F-141A-1000-0000000FF1CE} /passive


REM Uninstall some of the Windows 10’s Built-in Apps
REM https://www.howtogeek.com/224798/how-to-uninstall-windows-10s-built-in-apps-and-how-to-reinstall-them/
REM You can easily reinstall them with this command: 
REM Get-AppxPackage -AllUsers| Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
REM More info: https://github.com/W4RH4WK/Debloat-Windows-10
powershell -Command "Get-AppxPackage *zunemusic* | Remove-AppxPackage"
powershell -Command "Get-AppxPackage *bingsports* | Remove-AppxPackage"
powershell -Command "Get-AppxPackage *xboxapp* | Remove-AppxPackage"
powershell -Command "Get-AppxPackage *3dbuilder* | Remove-AppxPackage"
powershell -Command "Get-AppxPackage *officehub* | Remove-AppxPackage"
powershell -Command "Get-AppxPackage *solitairecollection* | Remove-AppxPackage"
powershell -Command "Get-AppxPackage *windowsphone* | Remove-AppxPackage"
REM not enough permission
REM powershell -Command "Get-AppxPackage *people* | Remove-AppxPackage"
powershell -Command "Get-AppxPackage *windowsmaps* | Remove-AppxPackage"
powershell -Command "Get-AppxPackage *windowscommunicationsapps* | Remove-AppxPackage"
REM Mixed Reality Portal
REM powershell -Command "Get-AppxPackage *holographic* | Remove-AppxPackage"
REM SMS app
powershell -Command "Get-AppxPackage *messaging* | Remove-AppxPackage"
powershell -Command "Get-AppxPackage *xboxidentity* | Remove-AppxPackage"
REM Microsoft Phone app (do call, answer, etc)
powershell -Command "Get-AppxPackage *commsphone* | Remove-AppxPackage"


REM Are we running from scheduled task? Limit to basic job only.
REM NOTE: exit /b to return "operation completed successfully"
if "%1"=="task" exit /b

echo Cleaning System

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

REM HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon
REM enable auto login (select in GUI)
set REG=HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon
reg query "%REG%" /v AutoAdminLogon | findstr 0 >nul && netplwiz
