@echo off
if not exist ..\Lib\C5\*.* md ..\Lib\C5 >nul
call DelAll.bat
CompAssist SetupC5
if exist CompilePackage.bat call CompilePackage.bat

if errorlevel 1 goto enderror

goto endok
:enderror
echo Error!
Pause
:endok
del CompilePackage.bat
del DCC32.cfg
echo Compilation completed successfully. Please close the window.

