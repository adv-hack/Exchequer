@echo Off
cd d:\progra~1\borland\delphi6\bin
cd x:\entrprse\formdes2
x:

rem make backup copy of cfg file
copy d:dcc32.cfg d:cfg.tmp > NUL

rem copy runtime versions of .INC files in
copy "x:\entrprse\r&d\defovr.inc" "x:\entrprse\r&d\defovr.mh"
copy "x:\entrprse\r&d\defovr.run" "x:\entrprse\r&d\defovr.inc"
copy "x:\entrprse\r&d\debug.inc" "x:\entrprse\r&d\debug.mh"
copy "x:\entrprse\r&d\debug.run" "x:\entrprse\r&d\debug.inc"

rem compile Form Printing toolkit
echo 
echo Deleting Old DCU Files, Please Wait...
call x:\entrprse\formdes2\delDCUHM.bat
cd x:\entrprse\formtk

if not exist m:\Dev500\entforms.exe goto skipdel1
  del m:\Dev500\entforms.exe > NUL
:skipdel1
copy ftk.cfg d:dcc32.cfg > NUL

echo 
echo Compiling Form Printing Toolkit, Please Wait...
d:dcc32 entforms.dpr > comp.txt

If not exist m:\Dev500\entforms.exe goto error

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
  copy "x:\entrprse\r&d\defovr.mh" "x:\entrprse\r&d\defovr.inc"
  copy "x:\entrprse\r&d\debug.mh" "x:\entrprse\r&d\debug.inc"

  rem finished - get rid of any DCU files on network
  call x:\entrprse\formdes2\delDCUHM.bat
  cd x:\entrprse\formtk
  echo 

