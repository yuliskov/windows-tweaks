@echo off

echo Running %~n0...

set THIS_NAME=%~dpf0
set BLANK_TASK=%temp%/blank_task.xml
set MY_TASK_NAME="Reset Idea Trial"
set IDEA_PROFILE_DIR_TEMPLATE=%UserProfile%\.IntelliJIdea*

if "%1"=="ok" goto ENABLE_CHECK
goto SKIP_CHECK
:ENABLE_CHECK
REM comment lines below if you want to force reset
schtasks /query /TN %MY_TASK_NAME% >NUL 2>&1
if %errorlevel% EQU 0 (
	echo Idea reset task already created... exiting...
	goto End
)
:SKIP_CHECK

for /d %%f in ("%IDEA_PROFILE_DIR_TEMPLATE%") do call :IdeaLicenseFix %%f
REM comment line below in case you want only reset trial
call :SetupTask

goto End

:IdeaLicenseFix
	set IDEA_PROFILE_DIR=%1
	echo Processing %IDEA_PROFILE_DIR%...
    del "%IDEA_PROFILE_DIR%\config\eval" /q
	type "%IDEA_PROFILE_DIR%\config\options\options.xml" | findstr /v evlsprt > "%IDEA_PROFILE_DIR%\config\options\options_new.xml"
	copy "%IDEA_PROFILE_DIR%\config\options\options_new.xml" "%IDEA_PROFILE_DIR%\config\options\options.xml" /y >nul
	reg delete "HKEY_CURRENT_USER\Software\JavaSoft\Prefs\jetbrains\idea" /f >nul 2>nul
goto :eof

:Elevate
	set COMMAND=%*
	ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\OEgetPrivileges.vbs" 
	ECHO UAC.ShellExecute "cmd", "/c %COMMAND%", "", "runas", 1 >> "%temp%\OEgetPrivileges.vbs" 
	"%temp%\OEgetPrivileges.vbs"
goto :eof

:SetupTask
	echo Setting up scheduled task...
	REM run task every 25 days (MO) on this user account (IT)
	set MY_TASK_COMMAND=schtasks /Create /TN "%MY_TASK_NAME%" /xml ""%BLANK_TASK%"" /F

	call :WriteBlankTask
	call :Elevate %MY_TASK_COMMAND%
goto :eof

REM we can't set from command line 'Run task as soon as possible'
REM do reset every 24th day
:WriteBlankTask
	echo ^<?xml version="1.0" encoding="UTF-16"?^>^ > "%BLANK_TASK%"
	echo ^<Task version="1.2" xmlns="http://schemas.microsoft.com/windows/2004/02/mit/task"^>^ >> "%BLANK_TASK%"
	echo ^<Triggers^>^ >> "%BLANK_TASK%"
	echo ^<CalendarTrigger^>^ >> "%BLANK_TASK%"
	echo ^<StartBoundary^>1970-01-01T20:00:00^</StartBoundary^>^ >> "%BLANK_TASK%"
	echo ^<Enabled^>true^</Enabled^>^ >> "%BLANK_TASK%"
	echo ^<ScheduleByDay^>^ >> "%BLANK_TASK%"
	echo ^<DaysInterval^>24^</DaysInterval^>^ >> "%BLANK_TASK%"
	echo ^</ScheduleByDay^>^ >> "%BLANK_TASK%"
	echo ^</CalendarTrigger^>^ >> "%BLANK_TASK%"
	echo ^</Triggers^>^ >> "%BLANK_TASK%"
	echo ^<Settings^>^ >> "%BLANK_TASK%"
	echo ^<StartWhenAvailable^>true^</StartWhenAvailable^>^ >> "%BLANK_TASK%"
	echo ^</Settings^>^ >> "%BLANK_TASK%"
	echo ^<Actions Context="Author"^>^ >> "%BLANK_TASK%"
	echo ^<Exec^>^ >> "%BLANK_TASK%"
	echo ^<Command^>"%THIS_NAME%"^</Command^>^ >> "%BLANK_TASK%"
	echo ^</Exec^>^ >> "%BLANK_TASK%"
	echo ^</Actions^>^ >> "%BLANK_TASK%"
	echo ^</Task^> >> "%BLANK_TASK%"
goto :eof

:End