@echo Off
cd c:\progra~1\borland\delphi6\bin
cd x:\entrprse\formdes2
x:

rem make backup copy of cfg file 
copy c:dcc32.cfg c:cfg.tmp > NUL

rem copy runtime versions of .INC files in
copy "x:\entrprse\r&d\defovr.inc" "x:\entrprse\r&d\defovr.mh"
copy "x:\entrprse\r&d\defovr.run" "x:\entrprse\r&d\defovr.inc"
copy "x:\entrprse\r&d\debug.inc" "x:\entrprse\r&d\debug.mh"
copy "x:\entrprse\r&d\debug.run" "x:\entrprse\r&d\debug.inc"

rem compile Enterprise EDF Reader
echo 
echo Deleting Old DCU Files, Please Wait...
call x:\entrprse\formdes2\delDCUHM.bat
cd x:\entrprse\formdes2

if not exist C:\Develop\Dev500\edfreadr.exe goto skipdel1
  del C:\Develop\Dev500\edfreadr.exe > NUL
:skipdel1
copy edfr.cfg c:dcc32.cfg > NUL

echo 
echo Compiling EDF/EDZ Reader, Please Wait...
c:dcc32 edfreadr.dpr

If not exist C:\Develop\Dev500\edfreadr.exe goto error

rem skip error message 
goto end

:error
  rem SNAFU
  echo 
  echo An Error has occured
  echo 
  goto end

:end
  rem restore backup copy of cfg file
  copy c:cfg.tmp c:dcc32.cfg > NUL
  del c:cfg.tmp > NUL

  rem restore designtime versions of .INC files
  copy "x:\entrprse\r&d\defovr.mh" "x:\entrprse\r&d\defovr.inc"
  copy "x:\entrprse\r&d\debug.mh" "x:\entrprse\r&d\debug.inc"

  rem finished - get rid of any DCU files on network
  call x:\entrprse\formdes2\delDCUHM.bat
  cd x:\entrprse\formdes2
  echo 

