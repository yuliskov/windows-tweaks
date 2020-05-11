@echo off

echo Running %~n0...

cd /d "%~dp0"

REM ================================================================

set DATA_DIR=..\..\data

REM Keybinding tweaks + blank page tweaks
copy /y "%DATA_DIR%\Normal.dotm" "%AppData%\Microsoft\Templates\Normal.dotm" >nul
