@echo off
if not exist ..\Lib\C6\*.* md ..\Lib\C6 >nul
call DelAll.bat
CompAssist SetupC6
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

