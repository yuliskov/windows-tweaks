@echo off

cd /d "%~dp0"

set MODULE_TEMPLATE=modules\*.bat
for /r %%f in ("%MODULE_TEMPLATE%") do start /B "" ""%%f""