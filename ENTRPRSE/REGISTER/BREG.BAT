@echo Off
cd c:\progra~1\Borland\delphi6\bin
cd x:\entrprse\register
x:

rem make backup copy of cfg file
copy c:dcc32.cfg c:cfg.tmp > NUL

rem copy runtime versions of .INC files in
copy "x:\entrprse\r&d\defovr.inc" "x:\entrprse\r&d\defovr.mh"
copy "x:\entrprse\r&d\defovr.run" "x:\entrprse\r&d\defovr.inc"
copy "x:\entrprse\r&d\debug.inc" "x:\entrprse\r&d\debug.mh"
copy "x:\entrprse\r&d\debug.run" "x:\entrprse\r&d\debug.inc"

rem compile OLE Registration Prog
echo 
echo Deleting OLD DCU Files, Please Wait...
call x:\entrprse\formdes2\delDCUHM.bat
cd x:\entrprse\register

if not exist C:\Develop\Dev500\entreg.exe goto SkipDel
  del C:\Develop\Dev500\entreg.exe > NUL
:SkipDel
copy reg.cfg c:dcc32.cfg > NUL

echo 
echo Compiling OLE Registration Utility, Please Wait...
c:dcc32 entreg.dpr
If not exist C:\Develop\Dev500\entreg.exe goto error

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
  cd x:\entrprse\register

  echo 
  echo 
  echo compiled: C:\Develop\Dev500\entreg.exe
  echo 
  echo 

