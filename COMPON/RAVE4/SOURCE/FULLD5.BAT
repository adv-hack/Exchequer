rem @echo off
if exist setenv.bat call setenv.bat
computil SetupD5
if exist setenv.bat call setenv.bat
call clean.bat
if not exist ..\D5\*.* md ..\D5 >nul

REM ***************************************************
REM Compile Runtime Package RPRT40XX
REM ***************************************************
copy RPRT40.dpk RPRT40D5.dpk >nul
%NDD5%\bin\dcc32.exe RPRT40D5.dpk /b /h /w /N..\D5 /LE..\D5 /LN..\D5 -$d-l-n+p+r-s-t-w- %1 %2 %3
if errorlevel 1 goto enderror
del RPRT40D5.dpk >nul
copy ..\D5\RPRT40D5.bpl %NDWINSYS% >nul

REM ***************************************************
REM Compile Visual Package RPRV40XX
REM ***************************************************
copy RPRV40.dpk RPRV40D5.dpk >nul
%NDD5%\bin\dcc32.exe RPRV40D5.dpk /b /h /w /N..\D5 /LE..\D5 /LN..\D5 /L..\D5\RPRT40D5.dcp /U..\D5 -$d-l-n+p+r-s-t-w- %1 %2 %3
if errorlevel 1 goto enderror
del RPRV40D5.dpk >nul
copy ..\D5\RPRV40D5.bpl %NDWINSYS% >nul

REM ***************************************************
REM Compile Misc Units
REM ***************************************************
%NDD5%\bin\dcc32.exe RVCsBars.pas /m /h /w /N..\D5 /LE..\D5 /LN..\D5 /U..\D5 -$d-l-n+p+r-s-t-w- %1 %2 %3
%NDD5%\bin\dcc32.exe RPTChart.pas /m /h /w /N..\D5 /LE..\D5 /LN..\D5 /U..\D5 -$d-l-n+p+r-s-t-w- %1 %2 %3

REM ***************************************************
REM Compile Design-time Package RPDT40
REM ***************************************************
copy RPSetFrm.dfm ..\d5 >nul
copy RPStaFrm.dfm ..\d5 >nul
copy RPPreFrm.dfm ..\d5 >nul
%NDD5%\bin\dcc32.exe RPDT40.dpk /b /h /w /N..\D5 /LE..\D5 /LN..\D5 /L..\D5\RPRV40D5.dcp;..\D5\RPRT40D5.dcp /U..\D5 -$d-l-n+p+r-s-t-w- %1 %2 %3
if errorlevel 1 goto enderror

REM ***************************************************
REM Clean-up
REM ***************************************************
del ..\D5\RPDT40.dcu >nul
del ..\D5\RPDT40.dcp >nul
del ..\D5\RPRT40D5.dcu >nul
del ..\D5\RPRT40D5.bpl >nul
del ..\D5\RPRV40D5.dcu >nul
del ..\D5\RPRV40D5.bpl >nul
del ..\D5\RPAddFrm.dcu >nul
del ..\D5\RPSecFrm.dcu >nul
del ..\D5\RPCEdFrm.dcu >nul
del ..\D5\RPExeFrm.dcu >nul
del ..\D5\RPReg.dcu >nul
goto endok
:enderror
call clean
echo Error!
:endok
