@ECHO OFF
ECHO. FaxInstall Batch file for FaxMan Version 4

IF ()==(%1) GOTO _USAGE

rundll32 fmprint4.ocx,InstallFaxManPrinter %1 %2 %3 %4 %5 %6 %7 %8

GOTO _EOF

:_USAGE
ECHO.
ECHO "usage: faxinstall <C:\AppPath\App.exe> [optional: "Printer Driver Name"]"
ECHO "alternate usage: faxinstall <"c:\Configuration Path\And File.ini">/"

:_EOF