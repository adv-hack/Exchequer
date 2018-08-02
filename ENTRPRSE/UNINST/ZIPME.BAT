@echo off

If x%1x == xx Goto Error

echo 
echo 
echo Enterprise Uninstall Utility
echo 
echo Zipping To C:\%1.EXE
echo 
echo Press Enter to Continue
echo 

pause > NUL

Rem
Rem Delete any existing backup files
Rem
del c:\%1.zip
del c:\%1.exe

Rem
Rem Zip the stuff
Rem
c:\pk\pkzip -a -p c:\%1.zip *.pas 
c:\pk\pkzip -a -ex -p c:\%1.zip *.dfm
c:\pk\pkzip -a -p c:\%1.zip *.dpr 
c:\pk\pkzip -a -p c:\%1.zip *.dof 
c:\pk\pkzip -a -p c:\%1.zip *.dcr 
c:\pk\pkzip -a -p c:\%1.zip *.inc 
c:\pk\pkzip -a -p c:\%1.zip *.res 
c:\pk\pkzip -a -r -p c:\%1.zip *.ico 
c:\pk\pkzip -a -r -p c:\%1.zip *.bmp 

Rem
Rem Convert Zip File to self unzipping Exe
Rem
c:\pk\zip2exe c:\%1.zip c:\
del c:\%1.zip

Pause Backup Complete - press ENTER to continue... 
Goto End

:Error
  echo error

:End
