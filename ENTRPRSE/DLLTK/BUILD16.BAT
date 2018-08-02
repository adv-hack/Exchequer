@echo Off
cd c:\progra~1\borland\delphi\bin
cd x:\entrprse\exdlltsh
x:

rem make backup copy of cfg file
copy c:dcc.cfg c:cfg.tmp /Y > NUL

rem copy runtime versions of .INC files in
copy x:\entrprse\r&d\defovr.inc x:\entrprse\r&d\defovr.dl2
copy x:\entrprse\exdlltsh\defovr.run x:\entrprse\r&d\defovr.inc
copy x:\entrprse\r&d\debug.inc x:\entrprse\r&d\debug.dl2
copy x:\entrprse\exdlltsh\debug.run x:\entrprse\r&d\debug.inc

rem compile 16-bit DLL
echo 
echo Compiling 16-bit Toolkit DLL, Please Wait...
call x:\entrprse\exdlltsh\delDCU.bat
del c:\develop\entdll16\entdll16.dll > NUL
copy dll16.cfg c:dcc.cfg /Y > NUL
c:dcc EntDll16.dpr
If not exist c:\develop\entdll16\entdll16.dll goto error

rem compile 16-bit Test Program
echo 
echo Compiling 16-bit Test Program, Please Wait...
call x:\entrprse\exdlltsh\delDCU.bat
del c:\develop\entdll16\test16.exe > NUL
copy test16.cfg c:dcc.cfg /Y > NUL
c:dcc Test16.dpr
If not exist c:\develop\entdll16\Test16.Exe goto error

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
  copy c:cfg.tmp c:dcc.cfg /Y > NUL
  del c:cfg.tmp > NUL

  rem restore design time versions of .INC files
  copy x:\entrprse\r&d\defovr.dl2 x:\entrprse\r&d\defovr.inc
  copy x:\entrprse\r&d\debug.dl2 x:\entrprse\r&d\debug.inc

  rem finished - get rid of any DCU files on network
  call x:\entrprse\exdlltsh\delDCU.bat
  cd x:\entrprse\exdlltsh
  echo 

