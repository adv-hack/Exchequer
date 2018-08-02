@echo off
rem Set the current directories on E: and X:
cd "e:\Program Files\Borland\Delphi5\Bin"
cd x:\ebus2\admin
x:

rem make backup copy of cfg file
copy e:dcc32.cfg e:cfg.tmp > NUL

rem copy runtime versions of .INC files in
rem copy "x:\entrprse\r&d\defovr.inc" "x:\entrprse\r&d\defovr.mh"
rem copy "x:\entrprse\r&d\defovr.run" "x:\entrprse\r&d\defovr.inc"
rem copy "x:\entrprse\r&d\debug.inc" "x:\entrprse\r&d\debug.mh"
rem copy "x:\entrprse\r&d\debug.run" "x:\entrprse\r&d\debug.inc"

rem compile EBus Admin module
echo. 
echo Deleting OLD DCU Files, Please Wait...
del compiled\*.dcu > nul

if not exist x:\ebus2\admin\compiled\ebusAdmn.exe goto skipdel
  del x:\ebus2\admin\compiled\ebusAdmn.exe > NUL

:skipdel
copy bebusadm.cfg e:dcc32.cfg > NUL

echo.
echo Compiling EBusAdmn.exe, Please Wait...
e:dcc32 EBusAdmn.dpr > op.txt
If not exist x:\ebus2\admin\compiled\ebusAdmn.exe goto error

rem skip error message 
goto end

:error
  rem Exe not generated
  echo. 
  echo The exe was not generated!
  echo. 
  goto end

:end
  rem restore backup copy of cfg file
  echo.
  copy e:cfg.tmp e:dcc32.cfg > NUL
  del e:cfg.tmp > NUL

  rem restore designtime versions of .INC files
  rem copy "x:\entrprse\r&d\defovr.mh" "x:\entrprse\r&d\defovr.inc"
  rem copy "x:\entrprse\r&d\debug.mh" "x:\entrprse\r&d\debug.inc"

  rem finished - get rid of any DCU files on network
  rem call x:\entrprse\formdes2\delDCUHM.bat
  rem cd x:\entrprse\multcomp
  echo. 

  echo. 
  echo. 
  echo compiled: x:\ebus2\admin\compiled\ebusAdmn.exe
  echo. 
  echo. 

