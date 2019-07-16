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

REM Powershell wrapper. Purpose: font fix
set PS=call ..\data\ps

REM ================================================================

REM Uninstall registry paths:
REM HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\
REM HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\

REM Microsoft Visual C++ 2005 Redistributable
MsiExec.exe /X{710f4c1c-cc18-4c49-8cbf-51240c89a1a2} /passive /quiet

REM Microsoft Visual C++ 2005 Redistributable
MsiExec.exe /X{7299052b-02a4-4627-81f2-1818da5d550d} /passive /quiet

REM Microsoft Visual C++ 2005 Redistributable (x64) 8.0.56336
MsiExec.exe /X{071c9b48-7c32-4621-a0ac-3f809523288f} /passive /quiet

REM Microsoft Visual C++ 2008 Redistributable - x86 9.0.30729.17
msiexec /X{9A25302D-30C0-39D9-BD6F-21E6EC160475} /passive /quiet

REM Microsoft Visual C++ 2008 Redistributable - x64 9.0.30729.17
MsiExec.exe /X{8220EEFE-38CD-377E-8595-13398D740ACE} /passive /quiet

REM Microsoft Visual C++ 2008 Redistributable - x64 9.0.21022
MsiExec.exe /X{350AA351-21FA-3270-8B7A-835434E766AD} /passive /quiet

REM Microsoft Visual C++ 2008 Redistributable - x64 9.0.30729.4148
MsiExec.exe /X{4B6C7001-C7D6-3710-913E-5BC23FCE91E6} /passive /quiet

REM Microsoft Visual C++ 2008 Redistributable - x86 9.0.30729.4148
MsiExec.exe /X{1F1C2DFC-2D24-3E06-BCB8-725134ADF989} /passive /quiet

REM Microsoft Visual C++ 2010  x64 Redistributable - 10.0.40219
MsiExec.exe /X{1D8E6291-B0D5-35EC-8441-6616F567A0F7} /passive /quiet

REM Microsoft Visual C++ 2010  x32 Redistributable - 10.0.40219
MsiExec.exe /X{F0C3E5D1-1ADE-321E-8167-68EF0DE699A5} /passive /quiet

REM EFLC update 2
MsiExec.exe /X{5454083B-1308-4485-BF17-111000038701} /passive /quiet

REM Microsoft Visual C++ 2012 Redistributable (x86) - 11.0.61030
"C:\ProgramData\Package Cache\{33d1fd90-4274-48a1-9bc1-97e33d9c2d6f}\vcredist_x86.exe" /uninstall /quiet 2>nul

REM Microsoft Visual C++ 2013 Redistributable (x86) - 12.0.30501
"C:\ProgramData\Package Cache\{f65db027-aff3-4070-886a-0d87064aabb1}\vcredist_x86.exe" /uninstall /quiet 2>nul

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
MsiExec.exe /X{90160000-001F-0401-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0402-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0403-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0404-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0405-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0406-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0407-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0408-1000-0000000FF1CE} /passive /quiet
REM Office 2016 unused MUI #2
MsiExec.exe /X{90160000-001F-040B-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-040C-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-040D-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-040E-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-040F-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0410-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0411-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0412-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0413-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0414-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0415-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0416-1000-0000000FF1CE} /passive /quiet
REM Office 2016 unused MUI #3
MsiExec.exe /X{90160000-001F-0418-1000-0000000FF1CE} /passive /quiet
REM Office 2016 unused MUI #4
MsiExec.exe /X{90160000-001F-041A-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-041B-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-041C-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-041D-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-041E-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-041F-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0420-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0421-1000-0000000FF1CE} /passive /quiet
REM Office 2016 unused MUI #5
MsiExec.exe /X{90160000-001F-0424-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0425-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0426-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0427-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0428-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0429-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-042A-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-042B-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-042C-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-042D-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-042E-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-042F-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0432-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0434-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0435-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0436-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0437-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0438-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0439-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-043A-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-043E-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-043F-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0440-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0441-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0443-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0444-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0445-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0446-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0447-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0448-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0449-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-044A-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-044B-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-044C-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-044D-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-044E-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0452-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0456-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0457-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-045B-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0461-1000-0000000FF1CE} /passive /quiet
REM Office 2016 unused MUI #6
MsiExec.exe /X{90160000-001F-0468-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-046A-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-046C-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-046E-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0470-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0481-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0487-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0488-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0491-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0804-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0814-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0816-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-081A-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-083C-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0845-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0C0A-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-0C1A-1000-0000000FF1CE} /passive /quiet
MsiExec.exe /X{90160000-001F-141A-1000-0000000FF1CE} /passive /quiet


REM Uninstall some of the Windows 10’s Built-in Apps
REM https://www.howtogeek.com/224798/how-to-uninstall-windows-10s-built-in-apps-and-how-to-reinstall-them/
REM You can easily reinstall them with this command: 
REM Get-AppxPackage -AllUsers| Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
REM More info: https://github.com/W4RH4WK/Debloat-Windows-10
REM list packages: Get-AppxPackage -AllUsers | out-string -stream | select-string "^Name"
%PS% -Command "Get-AppxPackage *zunemusic* | Remove-AppxPackage"
%PS% -Command "Get-AppxPackage *bingsports* | Remove-AppxPackage"
%PS% -Command "Get-AppxPackage *xboxapp* | Remove-AppxPackage"
%PS% -Command "Get-AppxPackage *3dbuilder* | Remove-AppxPackage"
%PS% -Command "Get-AppxPackage *officehub* | Remove-AppxPackage"
%PS% -Command "Get-AppxPackage *solitairecollection* | Remove-AppxPackage"
%PS% -Command "Get-AppxPackage *windowsphone* | Remove-AppxPackage"
REM not enough permission
REM %PS% -Command "Get-AppxPackage *people* | Remove-AppxPackage"
%PS% -Command "Get-AppxPackage *windowsmaps* | Remove-AppxPackage"
%PS% -Command "Get-AppxPackage *windowscommunicationsapps* | Remove-AppxPackage"
REM Mixed Reality Portal (error when trying to uninstall)
REM %PS% -Command "Get-AppxPackage *holographic* | Remove-AppxPackage"
REM Mixed Reality First Run (shown in Start Menu as ms-resource:AppName/Text)
REM More info: https://winaero.com/blog/uninstall-mixed-reality-portal-windows-10/
REM %PS% -Command "Get-AppxPackage *holographicfirstrun* | Remove-AppxPackage"
REM SMS app
%PS% -Command "Get-AppxPackage *messaging* | Remove-AppxPackage"
%PS% -Command "Get-AppxPackage *xboxidentity* | Remove-AppxPackage"
REM Microsoft Phone app (do call, answer, etc)
%PS% -Command "Get-AppxPackage *commsphone* | Remove-AppxPackage"
