@echo off

If x%1x == xx Goto Error

echo 
echo 
echo Enterprise Form Designer Backup  
echo 
echo Zipping To M:\BACKUPS\%1.EXE
echo 
echo Press Enter to Continue
echo 

pause > NUL

Rem
Rem Delete any existing backup files
Rem
del M:\BACKUPS\%1.zip
del M:\BACKUPS\%1.exe

Rem
Rem Zip the stuff
Rem
c:\pk\pkzip -a -p M:\BACKUPS\%1.zip *.pas 
c:\pk\pkzip -a -p M:\BACKUPS\%1.zip *.dfm 
c:\pk\pkzip -a -p M:\BACKUPS\%1.zip *.dpr 
c:\pk\pkzip -a -p M:\BACKUPS\%1.zip *.dof 
c:\pk\pkzip -a -p M:\BACKUPS\%1.zip *.dcr 
c:\pk\pkzip -a -p M:\BACKUPS\%1.zip *.inc 
c:\pk\pkzip -a -p M:\BACKUPS\%1.zip *.res 
c:\pk\pkzip -a -r M:\BACKUPS\%1.zip *.ico 
c:\pk\pkzip -a -p M:\BACKUPS\%1.zip *.bmp 
c:\pk\pkzip -a -p M:\BACKUPS\%1.zip history.txt

Rem
Rem Convert Zip File to self unzipping Exe
Rem
c:\pk\zip2exe M:\BACKUPS\%1.zip c:\
del M:\BACKUPS\%1.zip

Pause Backup Complete - press ENTER to continue... 
Goto End

:Error
  echo error

:End
