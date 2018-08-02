@echo Off
cd c:\progra~1\borland\delphi6\bin
cd x:\entrprse\multcomp
x:

rem make backup copy of cfg file
copy c:dcc32.cfg c:cfg.tmp > NUL

rem copy runtime versions of .INC files in
copy "x:\entrprse\r&d\defovr.inc" "x:\entrprse\r&d\defovr.mh"
copy "x:\entrprse\r&d\defovr.run" "x:\entrprse\r&d\defovr.inc"
copy "x:\entrprse\r&d\debug.inc" "x:\entrprse\r&d\debug.mh"
copy "x:\entrprse\r&d\debug.run" "x:\entrprse\r&d\debug.inc"

rem compile Multi-Company Manager Dll (EntComp.DLL)
echo 
echo Deleting OLD DCU Files, Please Wait...
call x:\entrprse\formdes2\delDCUHM.bat
cd x:\entrprse\multcomp

if not exist C:\Develop\Dev500\entcomp.dll goto skipdel
  del C:\Develop\Dev500\entcomp.dll > NUL
:skipdel
copy comp.cfg c:dcc32.cfg > NUL

echo 
echo Compiling EntComp.Dll, Please Wait...
c:dcc32 entcomp.dpr > NUL
If not exist C:\Develop\Dev500\entcomp.dll goto error


rem compile Multi-Company Manager Dll (EntComp2.DLL)
echo 
echo Deleting OLD DCU Files, Please Wait...
call x:\entrprse\formdes2\delDCUHM.bat
cd x:\entrprse\multcomp

if not exist C:\Develop\Dev500\entcomp2.dll goto skipdel
  del C:\Develop\Dev500\entcomp2.dll > NUL
:skipdel
copy comp2.cfg c:dcc32.cfg > NUL

echo 
echo Compiling EntComp2.Dll, Please Wait...
c:dcc32 entcomp2.dpr > NUL
If not exist C:\Develop\Dev500\entcomp2.dll goto error


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
  echo 
  copy c:cfg.tmp c:dcc32.cfg > NUL
  del c:cfg.tmp > NUL

  rem restore designtime versions of .INC files
  copy "x:\entrprse\r&d\defovr.mh" "x:\entrprse\r&d\defovr.inc"
  copy "x:\entrprse\r&d\debug.mh" "x:\entrprse\r&d\debug.inc"

  rem finished - get rid of any DCU files on network
  call x:\entrprse\formdes2\delDCUHM.bat
  cd x:\entrprse\multcomp
  echo 

  echo 
  echo 
  echo compiled: C:\Develop\Dev500\entcomp.dll
  echo compiled: C:\Develop\Dev500\entcomp2.dll
  echo 
  echo 

