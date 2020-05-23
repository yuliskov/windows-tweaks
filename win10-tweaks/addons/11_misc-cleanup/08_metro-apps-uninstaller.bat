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

REM ========= Full list packages command =================
REM ========= Get-AppxPackage | Select Name, PackageFullName >"$env:userprofile\Desktop\Apps_List.txt" =========

REM Uninstall some of the Windows 10’s Built-in Apps
REM https://www.howtogeek.com/224798/how-to-uninstall-windows-10s-built-in-apps-and-how-to-reinstall-them/
REM You can easily reinstall them with this command: 
REM Get-AppxPackage -AllUsers| Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
REM More info: https://github.com/W4RH4WK/Debloat-Windows-10
REM list packages: Get-AppxPackage -AllUsers | out-string -stream | select-string "^Name"

REM Mixed Reality Portal (error when trying to uninstall)
REM powershell -Command "Get-AppxPackage *holographic* | Remove-AppxPackage"
REM Mixed Reality First Run (shown in Start Menu as ms-resource:AppName/Text)
REM More info: https://winaero.com/blog/uninstall-mixed-reality-portal-windows-10/
REM powershell -Command "Get-AppxPackage *holographicfirstrun* | Remove-AppxPackage"

REM 'XBox Game Bar' and other stuff (throws error)
powershell -Command "Get-AppxPackage Microsoft.XboxIdentityProvider | Remove-AppxPackage" 2>nul
powershell -Command "Get-AppxPackage Microsoft.XboxGameCallableUI | Remove-AppxPackage" 2>nul
powershell -Command "Get-AppxPackage Microsoft.XboxSpeechToTextOverlay | Remove-AppxPackage" 2>nul
powershell -Command "Get-AppxPackage Microsoft.XboxGamingOverlay | Remove-AppxPackage" 2>nul
powershell -Command "Get-AppxPackage Microsoft.XboxGameOverlay | Remove-AppxPackage" 2>nul
powershell -Command "Get-AppxPackage Microsoft.XboxApp | Remove-AppxPackage" 2>nul
powershell -Command "Get-AppxPackage Microsoft.Xbox.TCUI | Remove-AppxPackage" 2>nul

powershell -Command "Get-AppxPackage Microsoft.ZuneMusic | Remove-AppxPackage"
powershell -Command "Get-AppxPackage Microsoft.MicrosoftSolitaireCollection | Remove-AppxPackage"
powershell -Command "Get-AppxPackage Microsoft.WindowsMaps | Remove-AppxPackage"
powershell -Command "Get-AppxPackage microsoft.windowscommunicationsapps | Remove-AppxPackage"
powershell -Command "Get-AppxPackage Microsoft.SkypeApp | Remove-AppxPackage"
powershell -Command "Get-AppxPackage Microsoft.WindowsFeedbackHub | Remove-AppxPackage"
powershell -Command "Get-AppxPackage Microsoft.WebpImageExtension | Remove-AppxPackage"
powershell -Command "Get-AppxPackage Microsoft.VP9VideoExtensions | Remove-AppxPackage"
powershell -Command "Get-AppxPackage Microsoft.WebMediaExtensions  | Remove-AppxPackage"
powershell -Command "Get-AppxPackage Microsoft.HEIFImageExtension | Remove-AppxPackage"
powershell -Command "Get-AppxPackage Microsoft.MicrosoftOfficeHub | Remove-AppxPackage"
powershell -Command "Get-AppxPackage Microsoft.Office.OneNote | Remove-AppxPackage"
powershell -Command "Get-AppxPackage Microsoft.YourPhone | Remove-AppxPackage"
powershell -Command "Get-AppxPackage Microsoft.Print3D | Remove-AppxPackage"
powershell -Command "Get-AppxPackage Microsoft.People | Remove-AppxPackage"
powershell -Command "Get-AppxPackage Microsoft.Wallet | Remove-AppxPackage"
powershell -Command "Get-AppxPackage Microsoft.MixedReality.Portal | Remove-AppxPackage"
powershell -Command "Get-AppxPackage Microsoft.Microsoft3DViewer | Remove-AppxPackage"
powershell -Command "Get-AppxPackage Microsoft.MicrosoftStickyNotes | Remove-AppxPackage"


REM Not present anymore?

REM powershell -Command "Get-AppxPackage *bingsports* | Remove-AppxPackage"
REM powershell -Command "Get-AppxPackage *3dbuilder* | Remove-AppxPackage"
REM powershell -Command "Get-AppxPackage *windowsphone* | Remove-AppxPackage"

REM REM SMS app
REM powershell -Command "Get-AppxPackage *messaging* | Remove-AppxPackage"
REM REM Microsoft Phone app (do call, answer, etc)
REM powershell -Command "Get-AppxPackage *commsphone* | Remove-AppxPackage"