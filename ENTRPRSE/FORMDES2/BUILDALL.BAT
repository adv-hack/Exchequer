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

rem compile form designer
echo 
echo Deleting Old DCU Files, Please Wait...
call x:\entrprse\formdes2\delDCUHM.bat
cd x:\entrprse\formdes2

if not exist c:\develop\Dev500\formdes.exe goto skipdel1
  del c:\develop\Dev500\formdes.exe > NUL
:skipdel1
copy fdes.cfg c:dcc32.cfg > NUL

echo 
echo Compiling Form Designer, Please Wait...
c:dcc32 formdes.dpr

If not exist c:\Develop\Dev500\formdes.exe goto error

rem compile form designer dll
echo 
echo Deleting Old DCU Files, Please Wait...
call x:\entrprse\formdes2\delDCUHM.bat
cd x:\entrprse\formdes2

if not exist c:\Develop\Dev500\sbsform.dll goto skipdel2
  del c:\Develop\Dev500\sbsform.dll > NUL
:skipdel2
copy sbsf.cfg c:dcc32.cfg > NUL

echo 
echo Compiling Form Designer Dynamic Link Library, Please Wait...
c:dcc32 sbsform.dpr

If not exist c:\Develop\Dev500\sbsform.dll goto error

rem compile form designer dll (Toolkit Ver)
echo 
echo Deleting Old DCU Files, Please Wait...
call x:\entrprse\formdes2\delDCUHM.bat
cd x:\entrprse\formdes2

if not exist c:\Develop\Dev500\sbsform2.dll goto skipdel3
  del c:\Develop\Dev500\sbsform2.dll > NUL
:skipdel3
copy sbsf.cfg c:dcc32.cfg > NUL

echo 
echo Compiling Form Designer Dynamic Link Library (TK), Please Wait...
c:dcc32 sbsform2.dpr

If not exist c:\Develop\Dev500\sbsform2.dll goto error

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

