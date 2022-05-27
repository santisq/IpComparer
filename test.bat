@echo off
for /f "skip=1 delims=" %%i in ('wmic cpu get name') do for /f "tokens=*" %%a in ("%%i") do echo Processor : %%a
for /f "skip=1 delims=" %%i in ('wmic baseboard get product^,manufacturer') do for /f "tokens=1,*" %%a in ("%%i") do echo Motherboard : %%a %%b
pause