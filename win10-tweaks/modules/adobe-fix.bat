@echo off

cd /d "%~dp0"

if "%1"=="ok" goto SKIP_ELEVATE
echo call :Elevate "%0" ok
call :Elevate "%0" ok
exit
:SKIP_ELEVATE

REM Import external utils here
set HOSTS=..\data\hosts.exe

echo Blocking unwanted services (Adobe)...

REM Adobe Autoupdate Service
sc config AdobeUpdateService start=disabled >nul
sc stop AdobeUpdateService >nul

REM Adobe Genuine Integrity Service
sc config "AGSService" start=disabled >nul
sc stop "AGSService" >nul

echo Blocking license hosts (Adobe)...

%HOSTS% set lmlicenses.wip4.adobe.com 0.0.0.0
%HOSTS% set lm.licenses.adobe.com 0.0.0.0
%HOSTS% set na1r.services.adobe.com 0.0.0.0
%HOSTS% set hlrcv.stage.adobe.com 0.0.0.0
%HOSTS% set practivate.adobe.com  0.0.0.0
%HOSTS% set activate.adobe.com 0.0.0.0

echo Blocking background apps (Adobe)...

ren "%ProgramFiles(x86)%\Common Files\Adobe\OOBE\PDApp\IPC\AdobeIPCBroker.exe" "AdobeIPCBroker.exe.bak" 2>nul

goto End

:Elevate
	set COMMAND=%*
	ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\OEgetPrivileges.vbs" 
	ECHO UAC.ShellExecute "cmd", "/c %COMMAND%", "", "runas", 1 >> "%temp%\OEgetPrivileges.vbs" 
	"%temp%\OEgetPrivileges.vbs"
goto :eof

:End