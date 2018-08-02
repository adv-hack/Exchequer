@echo off
if exist setenv.bat call setenv.bat
computil SetupC5
if exist setenv.bat call setenv.bat
call clean.bat
if not exist ..\C5\*.* md ..\C5 >nul
call clean.bat ..\C5\

REM ***************************************************
REM Compile Runtime Package RPRT40
REM ***************************************************
copy RPRT40.dpk RPRT40D5.dpk >nul
%NDC5%\bin\dcc32.exe RPRT40D5.dpk -dbcb /B /H /W /JPHN /LE..\C5 /LN..\C5 /N..\C5 -$d-l-n+p+r-s-t-w-y- %1 %2 %3
if errorlevel 1 goto enderror
copy *.obj ..\C5 >nul
del *.obj >nul
copy *.hpp ..\C5 >nul
del *.hpp >nul
copy rprt40D5.bpi ..\C5 >nul
del rprt40D5.bpi >nul
copy rprt40D5.lsp ..\C5 >nul
del rprt40D5.lsp >nul
%NDC5%\bin\dcc32.exe rprt40D5.dpk -dbcb /H /W /LE..\C5 /LN..\C5 /N..\C5 -$d-l-n+p+r-s-t-w-y- %1 %2 %3
if errorlevel 1 goto enderror
del RPRT40D5.dpk >nul
copy ..\C5\rprt40D5.bpl %NDWINSYS% >nul

REM ***************************************************
REM Create .LIB file
REM ***************************************************
echo Creating RPRT40D5.LIB file, please wait...
for %%9 in (..\C5\*.obj) do %NDC5%\bin\tlib.exe ..\C5\rprt40D5.lib +%%9 >nul
del ..\C5\rprt40D5.bak >nul

REM ***************************************************
REM Compile Visual Package RPRV40XX
REM ***************************************************
copy RPRV40.dpk RPRV40D5.dpk >nul
%NDC5%\bin\dcc32.exe RPRV40D5.dpk -dbcb /B /H /W /JPHN /LE..\C5 /LN..\C5 /N..\C5 /L..\C5\RPRT40D5.dcp /U..\C5 -$d-l-n+p+r-s-t-w-y- %1 %2 %3
if errorlevel 1 goto enderror
copy *.obj ..\C5 >nul
del *.obj >nul
copy *.hpp ..\C5 >nul
del *.hpp >nul
computil HPPModify ..\C5\
copy rprv40D5.bpi ..\C5 >nul
del rprv40D5.bpi >nul
copy rprv40D5.lsp ..\C5 >nul
del rprv40D5.lsp >nul
%NDC5%\bin\dcc32.exe RPRV40D5.dpk -dbcb /H /W /LE..\C5 /LN..\C5 /N..\C5 /L..\C5\RPRT40D5.dcp /U..\C5 -$d-l-n+p+r-s-t-w- %1 %2 %3
if errorlevel 1 goto enderror
del RPRV40D5.dpk >nul
copy ..\C5\RPRV40D5.bpl %NDWINSYS% >nul

REM ***************************************************
REM Compile Misc Units
REM ***************************************************
%NDC5%\bin\dcc32.exe RVCsBars.pas -dbcb /m /h /w /JPHN /N..\C5 /LE..\C5 /LN..\C5 /U..\C5 -$d-l-n+p+r-s-t-w- %1 %2 %3
%NDC5%\bin\dcc32.exe RPTChart.pas -dbcb /m /h /w /JPHN /N..\C5 /LE..\C5 /LN..\C5 /U..\C5 -$d-l-n+p+r-s-t-w- %1 %2 %3
copy *.obj ..\C5 >nul
del *.obj >nul
copy *.hpp ..\C5 >nul
del *.hpp >nul

REM ***************************************************
REM Create .LIB file
REM ***************************************************
echo Creating RPRV40D5.LIB file, please wait...
for %%9 in (..\C5\rv*.obj) do %NDC5%\bin\tlib.exe ..\C5\rprv40D5.lib +%%9 >nul
%NDC5%\bin\tlib.exe ..\C5\rprv40D5.lib +..\C5\rprave.obj
del ..\C5\rprv40D5.bak >nul

REM ***************************************************
REM Compile Design-time Package RPDT40
REM ***************************************************
copy rpsetfrm.dfm ..\C5 >nul
copy rpstafrm.dfm ..\C5 >nul
copy rpprefrm.dfm ..\C5 >nul
%NDC5%\bin\dcc32.exe RPDT40.dpk -dbcb /h /w /N..\C5 /LE..\C5 /LN..\C5 /L..\C5\RPRT40D5.dcp;..\C5\RPRV40D5.dcp /U..\C5 -$d-l-n+p+r-s-t-w-y- %1 %2 %3
if errorlevel 1 goto enderror

REM ***************************************************
REM Clean-up
REM ***************************************************
del ..\C5\rpdt40.dcu >nul
del ..\C5\rpdt40.dcp >nul
del ..\C5\rprt40D5.dcu >nul
del ..\C5\rprt40D5.bpl >nul
del ..\C5\rprv40D5.dcu >nul
del ..\C5\rprv40D5.bpl >nul

goto endok
:enderror
call clean
echo Error!
:endok