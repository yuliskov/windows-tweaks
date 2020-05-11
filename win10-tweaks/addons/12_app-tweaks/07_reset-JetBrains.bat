@echo off

echo Running %~n0...

set THIS_NAME=%~dpf0
set BLANK_TASK=%temp%/blank_task.xml
set MY_TASK_NAME="Reset Idea Trial"

if "%1"=="ok" goto ENABLE_CHECK
goto SKIP_CHECK

:ENABLE_CHECK

REM REM seems running from the main script... installing the task....
REM schtasks /query /TN %MY_TASK_NAME% >NUL 2>&1
REM if %errorlevel% EQU 0 (
REM     echo Idea reset task already created... exiting...
REM     goto End
REM )

:SKIP_CHECK

SET CLOSEPROCESS=%~dp0/../../../data/closeprocess

REM TODO: "WebStorm", "IntelliJ", "CLion", "Rider", "GoLand", "PhpStorm"

for /d %%f in ("%UserProfile%\.IntelliJIdea*") do call :IdeaLicenseFix "%%f" idea
for /d %%f in ("%AppData%\JetBrains\IntelliJIdea*") do call :IdeaLicenseFix2 "%%f" idea
for /d %%f in ("%UserProfile%\.CLion*") do call :IdeaLicenseFix "%%f" clion
for /d %%f in ("%AppData%\JetBrains\CLion*") do call :IdeaLicenseFix2 "%%f" clion
for /d %%f in ("%UserProfile%\.Rider*") do call :IdeaLicenseFix "%%f" rider
for /d %%f in ("%AppData%\JetBrains\Rider*") do call :IdeaLicenseFix2 "%%f" rider

REM comment line below to disable task creation
REM call :SetupTask

goto End

:IdeaLicenseFix
    set IDEA_PROFILE_DIR=%1
    set EXE_NAME=%2
	call :IdeaLicenseFix2 "%IDEA_PROFILE_DIR%\config" %EXE_NAME%    
goto :eof

:IdeaLicenseFix2
    set IDEA_CONFIG_DIR=%1
    set EXE_NAME=%2
    echo Processing %IDEA_CONFIG_DIR%...

    REM 0. Closing JetBrains processes...
    call %CLOSEPROCESS% %EXE_NAME%64.exe
    call %CLOSEPROCESS% %EXE_NAME%.exe

    REM 1. Remove trial directory

    rmdir "%IDEA_CONFIG_DIR%\eval" /s /q 2>nul >nul

    REM 2. Edit files (remove trial lines)

    set OPTIONS=%IDEA_CONFIG_DIR%\options

    for %%x in (options other) do (
        if exist "%OPTIONS%\%%x.xml" (
            type "%OPTIONS%\%%x.xml" | findstr /v evlsprt > "%OPTIONS%\%%x_new.xml"
            copy "%OPTIONS%\%%x_new.xml" "%OPTIONS%\%%x.xml" /y >nul
        )
    )

    REM 3. Remove trial reg key

    reg delete "HKEY_CURRENT_USER\Software\JavaSoft\Prefs\jetbrains\%EXE_NAME%" /f >nul 2>nul
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
    echo ^<StartBoundary^>1970-01-01T08:00:00^</StartBoundary^>^ >> "%BLANK_TASK%"
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