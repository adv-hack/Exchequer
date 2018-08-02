@echo off
if not exist ..\Lib\D6\*.* md ..\Lib\D6 >nul
call DelAll.bat
CompAssist SetupD6
if exist CompilePackage.bat call CompilePackage.bat

if errorlevel 1 goto enderror

goto endok
:enderror
echo Error!
Pause
:endok
del CompilePackage.bat
del DCC32.cfg