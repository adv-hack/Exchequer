@echo Off
cd c:\progra~1\borland\delphi~1.0\bin
cd x:\entrprse\exdlltsh
x:

rem make backup copy of cfg file
copy c:dcc32.cfg c:cfg.tmp /Y > NUL

rem copy runtime versions of .INC files in
copy x:\entrprse\r&d\defovr.inc x:\entrprse\r&d\defovr.dl2
copy x:\entrprse\exdlltsh\defovr.run x:\entrprse\r&d\defovr.inc
copy x:\entrprse\r&d\debug.inc x:\entrprse\r&d\debug.dl2
copy x:\entrprse\exdlltsh\debug.run x:\entrprse\r&d\debug.inc

rem compile 32-bit DLL
echo 
echo Compiling 32-bit Toolkit DLL, Please Wait...
call x:\entrprse\exdlltsh\delDCU.bat
del c:\develop\entdll32\entdll32.dll > NUL
copy dll32.cfg c:dcc32.cfg /Y > NUL
c:dcc32 EntDll32.dpr
If not exist c:\develop\entdll32\entdll32.dll goto error

rem compile 32-bit Test Program
echo 
echo Compiling 32-bit Test Program, Please Wait...
call x:\entrprse\exdlltsh\delDCU.bat
del c:\develop\entdll32\Test32.Exe > NUL
copy Test32.cfg c:dcc32.cfg /Y > NUL
c:dcc32 Test32.dpr
If not exist c:\develop\entdll32\Test32.Exe goto error

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
  copy x:\entrprse\r&d\defovr.dl2 x:\entrprse\r&d\defovr.inc
  copy x:\entrprse\r&d\debug.dl2 x:\entrprse\r&d\debug.inc

  rem finished - get rid of any DCU files on network
  call x:\entrprse\exdlltsh\delDCU.bat
  cd x:\entrprse\exdlltsh
  echo 

