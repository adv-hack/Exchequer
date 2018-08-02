@echo off
if not exist ..\Lib\D4\*.* md ..\Lib\D4 >nul
call DelAll.bat
CompAssist SetupD4
if exist CompilePackage.bat call CompilePackage.bat

if errorlevel 1 goto enderror

goto endok
:enderror
echo Error!
Pause
:endok
del CompilePackage.bat
del DCC32.cfg