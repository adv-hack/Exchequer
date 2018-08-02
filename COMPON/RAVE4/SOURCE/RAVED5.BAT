@echo off
if exist setenv.bat call setenv.bat
computil SetupD5
if exist setenv.bat call setenv.bat
call clean.bat
if not exist ..\RV\*.* md ..\RV >nul

REM ***************************************************
REM Compile Designtime Packages RVCL#40
REM ***************************************************
%NDD5%\bin\dcc32.exe RVCL40.dpk /b /h /w /z /N..\RV /LE..\RV /LN..\RV /U..\RV -$d-l-n+p+r-s-t-w- /DDESIGNER %1 %2 %3
if errorlevel 1 goto enderror
%NDD5%\bin\dcc32.exe RVCLB40.dpk /m /h /w /z /N..\RV /LE..\RV /LN..\RV /U..\RV -$d-l-n+p+r-s-t-w- /DDESIGNER %1 %2 %3
if errorlevel 1 goto enderror
%NDD5%\bin\dcc32.exe RVCLG40.dpk /m /h /w /z /N..\RV /LE..\RV /LN..\RV /U..\RV -$d-l-n+p+r-s-t-w- /DDESIGNER %1 %2 %3
if errorlevel 1 goto enderror
%NDD5%\bin\dcc32.exe RVCLS40.dpk /m /h /w /z /N..\RV /LE..\RV /LN..\RV /U..\RV -$d-l-n+p+r-s-t-w- /DDESIGNER %1 %2 %3
if errorlevel 1 goto enderror
%NDD5%\bin\dcc32.exe RVCLR40.dpk /m /h /w /z /N..\RV /LE..\RV /LN..\RV /U..\RV -$d-l-n+p+r-s-t-w- /DDESIGNER %1 %2 %3
if errorlevel 1 goto enderror
attrib RVLESys.inc -r
RVS2INC SYSFUNC.RVS RV*.RVS
%NDD5%\bin\dcc32.exe RVCLLE40.dpk /m /h /w /z /N..\RV /LE..\RV /LN..\RV /U..\RV -$d-l-n+p+r-s-t-w- /DDESIGNER %1 %2 %3
if errorlevel 1 goto enderror
%NDD5%\bin\dcc32.exe RVCLLD40.dpk /m /h /w /z /N..\RV /LE..\RV /LN..\RV /U..\RV -$d-l-n+p+r-s-t-w- /DDESIGNER %1 %2 %3
if errorlevel 1 goto enderror
%NDD5%\bin\dcc32.exe RVCLWZ40.dpk /m /h /w /z /N..\RV /LE..\RV /LN..\RV /U..\RV -$d-l-n+p+r-s-t-w- /DDESIGNER %1 %2 %3
if errorlevel 1 goto enderror
copy ..\RV\rvcl*.bpl .. >nul
del ..\RV\rvcl*.bpl >nul
copy rv*.res ..\rv >nul
copy rv*.dfm ..\rv >nul
copy rpsetfrm.dfm ..\rv >nul
copy rpstafrm.dfm ..\rv >nul
copy rpprefrm.dfm ..\rv >nul
del ..\RV\rvcl40.dcu >nul
del ..\RV\rvcl?40.dcu >nul
del ..\RV\rvcl??40.dcu >nul
goto endok
:enderror
call clean
echo Error!
:endok