@echo Off
cd d:\Borland\delphi5\bin
cd x:\entrprse\exdllnew
x:

rem make backup copy of cfg file
copy d:dcc32.cfg d:cfg.tmp > NUL

rem copy runtime/toolkit versions of .INC files in
copy "x:\entrprse\r&d\defovr.inc" "x:\entrprse\r&d\defovr.tk"
copy "x:\entrprse\exdllnew\defovr.inc" "x:\entrprse\r&d\defovr.inc"

rem Compile 32-bit Toolkit DLL
echo 
echo Deleting OLD DCU Files, Please Wait...
call x:\entrprse\formdes2\delDCUHM.bat
cd x:\entrprse\exdllnew

if not exist e:\develop\entdll32\hmdll32.dll goto SkipDel
  del e:\develop\entdll32\hmdll32.dll > NUL
:SkipDel
copy tk32.cfg d:dcc32.cfg > NUL

echo 
echo Compiling 32-bit Toolkit DLL, Please Wait...
d:dcc32 hmdll32.dpr > c:\comp.txt
If not exist e:\develop\entdll32\hmdll32.dll goto error

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
  copy d:cfg.tmp d:dcc32.cfg > NUL
  del d:cfg.tmp > NUL

  rem restore designtime versions of .INC files
  copy "x:\entrprse\r&d\defovr.tk" "x:\entrprse\r&d\defovr.inc"

  rem finished - get rid of any DCU files on network
  call x:\entrprse\formdes2\delDCUHM.bat
  cd x:\entrprse\exdllnew

  echo 
  echo 
  echo compiled: e:\develop\entdll32\hmdll32.dll
  echo 
  echo 

