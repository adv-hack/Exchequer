@echo off

if exist %1*.dcu Del %1*.dcu
if exist %1*.lsp Del %1*.lsp
if exist %1*.bpi Del %1*.bpi
if exist %1*.bpl Del %1*.bpl
if exist %1*.dsk Del %1*.dsk
if exist %1*.tds Del %1*.tds
if exist %1*.~* Del %1*.~*

if exist ..\Lib\%1*.~* /S Del ..\Lib\*.~* /S
if exist ..\Lib\%1*.~* /S Del ..\Lib\*.tds /S
if exist ..\Lib\%1*.~* /S Del ..\Lib\*.~* /S

if exist CompilePackage.bat  del CompilePackage.bat
