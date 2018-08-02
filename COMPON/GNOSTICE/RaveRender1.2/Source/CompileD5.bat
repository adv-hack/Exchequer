@echo off
if not exist ..\Lib\D5\*.* md ..\Lib\D5 >nul
call DelAll.bat
CompAssist SetupD5
if exist CompilePackage.bat call CompilePackage.bat

if errorlevel 1 goto enderror

goto endok
:enderror
Pause
echo Error!
:endok
del CompilePackage.bat
del DCC32.cfg