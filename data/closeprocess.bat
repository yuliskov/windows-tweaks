SET NIRCMD=nircmd-x64.exe
if %PROCESSOR_ARCHITECTURE%==x86 (
  SET NIRCMD=nircmd.exe
)

start /d "%~dp0" /wait %NIRCMD% closeprocess %1