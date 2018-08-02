@echo Off
cd d:\progra~1\borland\delphi6\bin
cd x:\entrprse\comtk
x:

rem ***************************************************************
rem * Make backup copy of cfg file
rem ***************************************************************
copy d:dcc32.cfg d:cfg.tmp > NUL

rem ***************************************************************
rem * Copy runtime versions of .INC files in
rem ***************************************************************
copy "x:\entrprse\r&d\defovr.inc" "x:\entrprse\r&d\defovr.mh"
copy "x:\entrprse\r&d\defovr.run" "x:\entrprse\r&d\defovr.inc"
copy "x:\entrprse\r&d\debug.inc" "x:\entrprse\r&d\debug.mh"
copy "x:\entrprse\r&d\debug.run" "x:\entrprse\r&d\debug.inc"



rem ***************************************************************
rem * Remove existing DCU's, DLL, EXE's, etc...
rem ***************************************************************
echo 
echo Deleting Old DCU Files, Please Wait...
call x:\entrprse\formdes2\delDCUHM.bat
cd x:\entrprse\comtk
echo 
echo Deleting Old COM Toolkit Library, Please Wait...
if not exist f:\compiled\comtk440\enttoolk.dll goto skipdel1
  del f:\compiled\comtk440\enttoolk.dll > NUL
:skipdel1

rem ***************************************************************
rem * Setup compiler options for COM Toolkit DLL
rem ***************************************************************
copy CTKDLL.cfg d:dcc32.cfg > NUL

rem ***************************************************************
rem * Compile COM Toolkit DLL
rem ***************************************************************
echo 
echo Compiling COM Toolkit DLL, Please Wait...
d:dcc32 EntToolK.dpr
If not exist f:\compiled\comtk440\enttoolk.dll goto error


Goto SkipExe

rem ***************************************************************
rem * Remove existing DCU's, DLL, EXE's, etc...
rem ***************************************************************
echo 
echo Deleting Old DCU Files, Please Wait...
call x:\entrprse\formdes2\delDCUHM.bat
cd x:\entrprse\comtk
echo 
echo Deleting Old COM Toolkit Library, Please Wait...
if not exist f:\compiled\comtk440\enttoolk.exe goto skipdel2
  del f:\compiled\comtk440\enttoolk.exe > NUL
:skipdel2

rem ***************************************************************
rem * Setup compiler options for COM Toolkit EXE
rem ***************************************************************
copy CTKEXE.cfg d:dcc32.cfg > NUL

rem ***************************************************************
rem * Compile COM Toolkit EXE
rem ***************************************************************
echo 
echo Compiling COM Toolkit EXE, Please Wait...
d:dcc32 EntToolK.dpr
If not exist f:\compiled\comtk440\enttoolk.exe goto error

:SkipExe
  echo 
  echo COM Toolkit EXE Disabled
  echo 
  Pause


rem ***************************************************************
rem * Error Handling & Tidy Up
rem ***************************************************************
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
  cd x:\entrprse\comtk
  echo 

