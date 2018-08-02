@echo Off
cd c:\progra~1\borland\delphi~1.0\bin
cd x:\entrprse\formdes2
x:

rem make backup copy of cfg file
copy c:dcc32.cfg c:cfg.tmp /Y > NUL

rem copy runtime versions of .INC files in
rem copy x:\entrprse\r&d\defovr.inc x:\entrprse\r&d\defovr.mh
rem copy x:\entrprse\r&d\defovr.run x:\entrprse\r&d\defovr.inc
rem copy x:\entrprse\r&d\debug.inc x:\entrprse\r&d\debug.mh
rem copy x:\entrprse\r&d\debug.run x:\entrprse\r&d\debug.inc

rem compile form designer dll
echo 
echo Compiling Form Designer Dynamic Link Library, Please Wait...
call x:\entrprse\formdes2\delDCU.bat
del c:\develop\entrprse\sbsform.dll > NUL
copy sbsform.cfg c:dcc32.cfg /Y > NUL
c:dcc32 sbsform.dpr > c:\mh.txt
If not exist c:\develop\entrprse\sbsform.dll goto error

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
  copy c:cfg.tmp c:dcc32.cfg /Y > NUL
  del c:cfg.tmp > NUL

  rem restore designtime versions of .INC files
  rem copy x:\entrprse\r&d\defovr.mh x:\entrprse\r&d\defovr.inc
  rem copy x:\entrprse\r&d\debug.mh x:\entrprse\r&d\debug.inc

  rem finished - get rid of any DCU files on network
  call x:\entrprse\formdes2\delDCU.bat
  cd x:\entrprse\formdes2
  echo 

