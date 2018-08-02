@echo off
if exist setenv.bat call setenv.bat
computil SetupD6
if exist setenv.bat call setenv.bat
call clean.bat
if not exist ..\D6\*.* md ..\D6 >nul

REM ***************************************************
REM Compile Runtime Package RPRT40XX
REM ***************************************************
copy RPRT40.dpk RPRT40D6.dpk >nul
%NDD6%\bin\dcc32.exe RPRT40D6.dpk /b /h /w /N..\D6 /LE..\D6 /LN..\D6 -$d-l-n+p+r-s-t-w- %1 %2 %3
if errorlevel 1 goto enderror
del RPRT40D6.dpk >nul
copy ..\D6\RPRT40D6.bpl %NDWINSYS% >nul

REM ***************************************************
REM Compile Visual Package RPRV40XX
REM ***************************************************
copy RPRV40.dpk RPRV40D6.dpk >nul
%NDD6%\bin\dcc32.exe RPRV40D6.dpk /b /h /w /N..\D6 /LE..\D6 /LN..\D6 /L..\D6\RPRT40D6.dcp /U..\D6 -$d-l-n+p+r-s-t-w- %1 %2 %3
if errorlevel 1 goto enderror
del RPRV40D6.dpk >nul
copy ..\D6\RPRV40D6.bpl %NDWINSYS% >nul

REM ***************************************************
REM Compile Misc Units
REM ***************************************************
%NDD6%\bin\dcc32.exe RVCsBars.pas /m /h /w /N..\D6 /LE..\D6 /LN..\D6 /U..\D6 -$d-l-n+p+r-s-t-w- %1 %2 %3
%NDD6%\bin\dcc32.exe RPTChart.pas /m /h /w /N..\D6 /LE..\D6 /LN..\D6 /U..\D6 -$d-l-n+p+r-s-t-w- %1 %2 %3

REM ***************************************************
REM Compile Design-time Package RPDT40
REM ***************************************************
copy RPSetFrm.dfm ..\D6 >nul
copy RPStaFrm.dfm ..\D6 >nul
copy RPPreFrm.dfm ..\D6 >nul
%NDD6%\bin\dcc32.exe RPDT40.dpk /b /h /w /N..\D6 /LE..\D6 /LN..\D6 /L..\D6\RPRV40D6.dcp;..\D6\RPRT40D6.dcp /U..\D6 -$d-l-n+p+r-s-t-w- %1 %2 %3
if errorlevel 1 goto enderror

REM ***************************************************
REM Clean-up
REM ***************************************************
del ..\D6\RPDT40.dcu >nul
del ..\D6\RPDT40.dcp >nul
del ..\D6\RPRT40D6.dcu >nul
del ..\D6\RPRT40D6.bpl >nul
del ..\D6\RPRV40D6.dcu >nul
del ..\D6\RPRV40D6.bpl >nul
del ..\D6\RPAddFrm.dcu >nul
del ..\D6\RPSecFrm.dcu >nul
del ..\D6\RPCEdFrm.dcu >nul
del ..\D6\RPExeFrm.dcu >nul
del ..\D6\RPReg.dcu >nul
goto endok
:enderror
call clean
echo Error!
:endok
  Pause