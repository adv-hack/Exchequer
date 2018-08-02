@echo off
if exist setenv.bat call setenv.bat
computil SetupC4
if exist setenv.bat call setenv.bat
call clean.bat
if not exist ..\C4\*.* md ..\C4 >nul

REM ***************************************************
REM Compile Runtime Package RPRT40
REM ***************************************************
copy RPRT40.dpk RPRT40D4.dpk >nul
%NDC4%\bin\dcc32.exe RPRT40D4.dpk /B /H /W /JPHN /LE..\C4 /LN..\C4 /N..\C4 -$d-l-n+p+r-s-t-w-y- %1 %2 %3
if errorlevel 1 goto enderror
copy *.obj ..\c4 >nul
del *.obj >nul
copy *.hpp ..\c4 >nul
del *.hpp >nul
copy rprt40d4.bpi ..\c4 >nul
del rprt40d4.bpi >nul
copy rprt40d4.lsp ..\c4 >nul
del rprt40d4.lsp >nul
%NDC4%\bin\dcc32.exe rprt40d4.dpk /H /W /LE..\C4 /LN..\C4 /N..\C4 -$d-l-n+p+r-s-t-w-y- %1 %2 %3
if errorlevel 1 goto enderror
del RPRT40d4.dpk >nul
copy ..\c4\rprt40d4.bpl %NDWINSYS% >nul

REM ***************************************************
REM Create .LIB file
REM ***************************************************
echo Creating RPRT40D4.LIB file, please wait...
if exist ..\C4\rprt40d4.lib del ..\C4\rprt40d4.lib >nul
for %%9 in (..\c4\*.obj) do %NDC4%\bin\tlib.exe ..\c4\rprt40d4.lib +%%9 >nul
del ..\C4\rprt40d4.bak >nul

REM ***************************************************
REM Compile Visual Package RPRV40XX
REM ***************************************************
copy RPRV40.dpk RPRV40D4.dpk >nul
%NDC4%\bin\dcc32.exe RPRV40D4.dpk /B /H /W /JPHN /LE..\C4 /LN..\C4 /N..\C4 /L..\C4\RPRT40D4.dcp /U..\C4 -$d-l-n+p+r-s-t-w-y- %1 %2 %3
if errorlevel 1 goto enderror
copy *.obj ..\c4 >nul
del *.obj >nul
copy *.hpp ..\c4 >nul
del *.hpp >nul
computil HPPModify ..\C4\
copy rprv40d4.bpi ..\c4 >nul
del rprv40d4.bpi >nul
copy rprv40d4.lsp ..\c4 >nul
del rprv40d4.lsp >nul
%NDC4%\bin\dcc32.exe RPRV40D4.dpk /H /W /LE..\C4 /LN..\C4 /N..\C4 /L..\C4\RPRT40D4.dcp /U..\C4 -$d-l-n+p+r-s-t-w- %1 %2 %3
if errorlevel 1 goto enderror
del RPRV40D4.dpk >nul
copy ..\C4\RPRV40D4.bpl %NDWINSYS% >nul

REM ***************************************************
REM Compile Misc Units
REM ***************************************************
%NDC4%\bin\dcc32.exe RVCsBars.pas /m /h /w /JPHN /N..\C4 /LE..\C4 /LN..\C4 /U..\C4 -$d-l-n+p+r-s-t-w- %1 %2 %3
%NDC4%\bin\dcc32.exe RPTChart.pas /m /h /w /JPHN /N..\C4 /LE..\C4 /LN..\C4 /U..\C4 -$d-l-n+p+r-s-t-w- %1 %2 %3
copy *.obj ..\c4 >nul
del *.obj >nul
copy *.hpp ..\c4 >nul
del *.hpp >nul

REM ***************************************************
REM Create .LIB file
REM ***************************************************
echo Creating RPRV40D4.LIB file, please wait...
if exist ..\C4\rprv40d4.lib del ..\C4\rprv40d4.lib >nul
for %%9 in (..\c4\rv*.obj) do %NDC4%\bin\tlib.exe ..\c4\rprv40d4.lib +%%9 >nul
%NDC4%\bin\tlib.exe ..\c4\rprv40d4.lib +..\c4\rprave.obj
del ..\c4\rprv40d4.bak >nul

REM ***************************************************
REM Compile Design-time Package RPDT40
REM ***************************************************
copy rpsetfrm.dfm ..\C4 >nul
copy rpstafrm.dfm ..\C4 >nul
copy rpprefrm.dfm ..\C4 >nul
%NDC4%\bin\dcc32.exe RPDT40.dpk /h /w /N..\C4 /LE..\C4 /LN..\C4 /L..\C4\RPRT40D4.dcp;..\C4\RPRV40D4.dcp /U..\C4 -$d-l-n+p+r-s-t-w-y- %1 %2 %3
if errorlevel 1 goto enderror

REM ***************************************************
REM Clean-up
REM ***************************************************
del ..\C4\rpdt40.dcu >nul
del ..\C4\rpdt40.dcp >nul
del ..\C4\rprt40d4.dcu >nul
del ..\C4\rprt40d4.bpl >nul
del ..\C4\rprv40d4.dcu >nul
del ..\C4\rprv40d4.bpl >nul

goto endok
:enderror
call clean
echo Error!
:endok