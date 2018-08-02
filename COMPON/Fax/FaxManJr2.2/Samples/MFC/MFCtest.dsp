# Microsoft Developer Studio Project File - Name="MFCtest" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Application" 0x0101

CFG=MFCtest - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "MFCtest.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "MFCtest.mak" CFG="MFCtest - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "MFCtest - Win32 Release" (based on "Win32 (x86) Application")
!MESSAGE "MFCtest - Win32 Debug" (based on "Win32 (x86) Application")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
MTL=midl.exe
RSC=rc.exe

!IF  "$(CFG)" == "MFCtest - Win32 Release"

# PROP BASE Use_MFC 6
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 6
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release"
# PROP Intermediate_Dir "Release"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /MD /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /Yu"stdafx.h" /FD /c
# ADD CPP /nologo /MD /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /Yu"stdafx.h" /FD /c
# ADD BASE MTL /nologo /D "NDEBUG" /mktyplib203 /o "NUL" /win32
# ADD MTL /nologo /D "NDEBUG" /mktyplib203 /o "NUL" /win32
# ADD BASE RSC /l 0x409 /d "NDEBUG" /d "_AFXDLL"
# ADD RSC /l 0x409 /d "NDEBUG" /d "_AFXDLL"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 /nologo /subsystem:windows /machine:I386
# ADD LINK32 /nologo /subsystem:windows /machine:I386

!ELSEIF  "$(CFG)" == "MFCtest - Win32 Debug"

# PROP BASE Use_MFC 6
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 6
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug"
# PROP Intermediate_Dir "Debug"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /MDd /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /Yu"stdafx.h" /FD /c
# ADD CPP /nologo /MDd /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /Yu"stdafx.h" /FD /c
# ADD BASE MTL /nologo /D "_DEBUG" /mktyplib203 /o "NUL" /win32
# ADD MTL /nologo /D "_DEBUG" /mktyplib203 /o "NUL" /win32
# ADD BASE RSC /l 0x409 /d "_DEBUG" /d "_AFXDLL"
# ADD RSC /l 0x409 /d "_DEBUG" /d "_AFXDLL"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 /nologo /subsystem:windows /debug /machine:I386 /pdbtype:sept
# ADD LINK32 /nologo /subsystem:windows /debug /machine:I386 /pdbtype:sept

!ENDIF 

# Begin Target

# Name "MFCtest - Win32 Release"
# Name "MFCtest - Win32 Debug"
# Begin Group "Source Files"

# PROP Default_Filter "cpp;c;cxx;rc;def;r;odl;idl;hpj;bat"
# Begin Source File

SOURCE=.\devicedesc.cpp
# End Source File
# Begin Source File

SOURCE=.\faxfinder.cpp
# End Source File
# Begin Source File

SOURCE=.\faxmanjr.cpp
# End Source File
# Begin Source File

SOURCE=.\faxstatusobj.cpp
# End Source File
# Begin Source File

SOURCE=.\fmprinter.cpp
# End Source File
# Begin Source File

SOURCE=.\MFCtest.cpp
# End Source File
# Begin Source File

SOURCE=.\MFCtest.rc
# End Source File
# Begin Source File

SOURCE=.\StdAfx.cpp
# ADD CPP /Yc"stdafx.h"
# End Source File
# Begin Source File

SOURCE=.\testDlg.cpp
# End Source File
# End Group
# Begin Group "Header Files"

# PROP Default_Filter "h;hpp;hxx;hm;inl"
# Begin Source File

SOURCE=.\cregkey.h
# End Source File
# Begin Source File

SOURCE=.\devicedesc.h
# End Source File
# Begin Source File

SOURCE=.\faxfinder.h
# End Source File
# Begin Source File

SOURCE=.\FaxJrEnums.h
# End Source File
# Begin Source File

SOURCE=.\faxmanjr.h
# End Source File
# Begin Source File

SOURCE=.\faxstatusobj.h
# End Source File
# Begin Source File

SOURCE=.\fmprint.h
# End Source File
# Begin Source File

SOURCE=.\fmprinter.h
# End Source File
# Begin Source File

SOURCE=.\MFCtest.h
# End Source File
# Begin Source File

SOURCE=.\Resource.h
# End Source File
# Begin Source File

SOURCE=.\StdAfx.h
# End Source File
# Begin Source File

SOURCE=.\testDlg.h
# End Source File
# End Group
# Begin Group "Resource Files"

# PROP Default_Filter "ico;cur;bmp;dlg;rc2;rct;bin;cnt;rtf;gif;jpg;jpeg;jpe"
# Begin Source File

SOURCE=.\res\idr_main.ico
# End Source File
# Begin Source File

SOURCE=.\MFCtest.ico
# End Source File
# Begin Source File

SOURCE=.\res\MFCtest.ico
# End Source File
# Begin Source File

SOURCE=.\res\MFCtest.rc2
# End Source File
# End Group
# End Target
# End Project
# Section MFCtest : {E3BDB1C1-49AA-11D2-B96B-00A0243D54A2}
# 	2:5:Class:CFmPrint
# 	2:10:HeaderFile:fmprint.h
# 	2:8:ImplFile:fmprint.cpp
# End Section
# Section MFCtest : {A5929EC6-74CF-11D2-BA5E-00002149093D}
# 	2:5:Class:CDeviceDesc
# 	2:10:HeaderFile:devicedesc.h
# 	2:8:ImplFile:devicedesc.cpp
# End Section
# Section MFCtest : {07728B4F-6223-11D2-BA57-00002149093D}
# 	2:5:Class:CFaxManJr
# 	2:10:HeaderFile:faxmanjr.h
# 	2:8:ImplFile:faxmanjr.cpp
# End Section
# Section MFCtest : {E3BDB1C4-49AA-11D2-B96B-00A0243D54A2}
# 	2:21:DefaultSinkHeaderFile:fmprint.h
# 	2:16:DefaultSinkClass:CFmPrint
# End Section
# Section MFCtest : {A5929EC5-74CF-11D2-BA5E-00002149093D}
# 	2:21:DefaultSinkHeaderFile:faxfinder.h
# 	2:16:DefaultSinkClass:CFaxFinder
# End Section
# Section MFCtest : {154E5B72-8874-11D2-BA61-00002149093D}
# 	2:5:Class:CFaxStatusObj
# 	2:10:HeaderFile:faxstatusobj.h
# 	2:8:ImplFile:faxstatusobj.cpp
# End Section
# Section MFCtest : {98C1D998-7B4E-4403-9CED-CE4B9B2D80D2}
# 	2:5:Class:CFmPrinter
# 	2:10:HeaderFile:fmprinter.h
# 	2:8:ImplFile:fmprinter.cpp
# End Section
# Section MFCtest : {A5929EC4-74CF-11D2-BA5E-00002149093D}
# 	2:5:Class:CFaxFinder
# 	2:10:HeaderFile:faxfinder.h
# 	2:8:ImplFile:faxfinder.cpp
# End Section
# Section MFCtest : {07728B50-6223-11D2-BA57-00002149093D}
# 	2:21:DefaultSinkHeaderFile:faxmanjr.h
# 	2:16:DefaultSinkClass:CFaxManJr
# End Section
# Section MFCtest : {CE1191A2-543E-4E06-A9D1-ADCBFCD5D368}
# 	2:21:DefaultSinkHeaderFile:fmprinter.h
# 	2:16:DefaultSinkClass:CFmPrinter
# End Section
