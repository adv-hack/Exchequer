@echo off
if exist setenv.bat call setenv.bat
computil SetupD4
if exist setenv.bat call setenv.bat
call clean.bat
if not exist ..\D4\*.* md ..\D4 >nul

REM ***************************************************
REM Compile Runtime Package RPRT40XX
REM ***************************************************
copy RPRT40.dpk RPRT40D4.dpk >nul
%NDD4%\bin\dcc32.exe RPRT40D4.dpk /b /h /w /N..\D4 /LE..\D4 /LN..\D4 -$d-l-n+p+r-s-t-w- %1 %2 %3
if errorlevel 1 goto enderror
del RPRT40D4.dpk >nul
copy ..\D4\RPRT40D4.bpl %NDWINSYS% >nul

REM ***************************************************
REM Compile Visual Package RPRV40XX
REM ***************************************************
copy RPRV40.dpk RPRV40D4.dpk >nul
%NDD4%\bin\dcc32.exe RPRV40D4.dpk /b /h /w /N..\D4 /LE..\D4 /LN..\D4 /L..\D4\RPRT40D4.dcp /U..\D4 -$d-l-n+p+r-s-t-w- %1 %2 %3
if errorlevel 1 goto enderror
del RPRV40D4.dpk >nul
copy ..\D4\RPRV40D4.bpl %NDWINSYS% >nul

REM ***************************************************
REM Compile Misc Units
REM ***************************************************
%NDD4%\bin\dcc32.exe RVCsBars.pas /m /h /w /N..\D4 /LE..\D4 /LN..\D4 /U..\D4 -$d-l-n+p+r-s-t-w- %1 %2 %3
%NDD4%\bin\dcc32.exe RPTChart.pas /m /h /w /N..\D4 /LE..\D4 /LN..\D4 /U..\D4 -$d-l-n+p+r-s-t-w- %1 %2 %3

REM ***************************************************
REM Compile Design-time Package RPDT40
REM ***************************************************
copy RPSetFrm.dfm ..\d4 >nul
copy RPStaFrm.dfm ..\d4 >nul
copy RPPreFrm.dfm ..\d4 >nul
%NDD4%\bin\dcc32.exe RPDT40.dpk /b /h /w /N..\D4 /LE..\D4 /LN..\D4 /L..\D4\RPRV40D4.dcp;..\D4\RPRT40D4.dcp /U..\D4 -$d-l-n+p+r-s-t-w- %1 %2 %3
if errorlevel 1 goto enderror

REM ***************************************************
REM Clean-up
REM ***************************************************
del ..\D4\RPDT40.dcu >nul
del ..\D4\RPDT40.dcp >nul
del ..\D4\RPRT40D4.dcu >nul
del ..\D4\RPRT40D4.bpl >nul
del ..\D4\RPRV40D4.dcu >nul
del ..\D4\RPRV40D4.bpl >nul
del ..\D4\RPAddFrm.dcu >nul
del ..\D4\RPSecFrm.dcu >nul
del ..\D4\RPCEdFrm.dcu >nul
del ..\D4\RPExeFrm.dcu >nul
del ..\D4\RPReg.dcu >nul
goto endok
:enderror
call clean
echo Error!
:endok