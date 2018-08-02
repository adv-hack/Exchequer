@echo Off
cd f:\progra~1\borland\delphi6\bin
cd x:\entrprse\dlltk
x:

rem make backup copy of cfg file
copy f:dcc32.cfg f:cfg.tmp

rem copy runtime versions of .INC files in
;copy "x:\entrprse\r&d\defovr.inc" "x:\entrprse\r&d\defovr.pr"
;copy "x:\entrprse\r&d\defovr.run" "x:\entrprse\r&d\defovr.inc"
;copy "x:\entrprse\r&d\debug.inc" "x:\entrprse\r&d\debug.pr"
;copy "x:\entrprse\r&d\debug.run" "x:\entrprse\r&d\debug.inc"
beep

rem compile SOP Dll
echo 
echo Deleting Old DCU Files, Please Wait...
call x:\entrprse\dlltk\delDCUPR.bat
cd x:\entrprse\dlltk

if not exist f:\compiled\entdllsp.dll goto skipdel
  del f:\compiled\entdllsp.dll > NUL
:skipdel

copy dllsp.cfg f:dcc32.cfg 

echo 
echo Compiling SOP DLL, Please Wait...
f:dcc32 entdllsp.dpr > x:\entrprse\dlltk\spdll.txt
If not exist f:\compiled\entdllsp.dll goto error

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
  copy f:cfg.tmp f:dcc32.cfg 
  del f:cfg.tmp

  rem restore designtime versions of .INC files
;  copy "x:\entrprse\r&d\defovr.pr" "x:\entrprse\r&d\defovr.inc"
;  copy "x:\entrprse\r&d\debug.pr" "x:\entrprse\r&d\debug.inc"
beep

  rem finished - get rid of any DCU files on network
  call x:\entrprse\dlltk\delDCUPR.bat
  cd x:\entrprse\dlltk
  echo 

