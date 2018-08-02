# Microsoft Developer Studio Generated NMAKE File, Based on MFCtest.dsp
!IF "$(CFG)" == ""
CFG=MFCtest - Win32 Debug
!MESSAGE No configuration specified. Defaulting to MFCtest - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "MFCtest - Win32 Release" && "$(CFG)" !=\
 "MFCtest - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
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
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "MFCtest - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

!IF "$(RECURSE)" == "0" 

ALL : "$(OUTDIR)\MFCtest.exe"

!ELSE 

ALL : "$(OUTDIR)\MFCtest.exe"

!ENDIF 

CLEAN :
	-@erase "$(INTDIR)\devicedesc.obj"
	-@erase "$(INTDIR)\faxfinder.obj"
	-@erase "$(INTDIR)\faxmanjr.obj"
	-@erase "$(INTDIR)\faxstatusobj.obj"
	-@erase "$(INTDIR)\fmprint.obj"
	-@erase "$(INTDIR)\MFCtest.obj"
	-@erase "$(INTDIR)\MFCtest.pch"
	-@erase "$(INTDIR)\MFCtest.res"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\testDlg.obj"
	-@erase "$(INTDIR)\vc50.idb"
	-@erase "$(OUTDIR)\MFCtest.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MD /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D\
 "_AFXDLL" /Fp"$(INTDIR)\MFCtest.pch" /Yu"stdafx.h" /Fo"$(INTDIR)\\"\
 /Fd"$(INTDIR)\\" /FD /c 
CPP_OBJS=.\Release/
CPP_SBRS=.

.c{$(CPP_OBJS)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(CPP_OBJS)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(CPP_OBJS)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.c{$(CPP_SBRS)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(CPP_SBRS)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(CPP_SBRS)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

MTL=midl.exe
MTL_PROJ=/nologo /D "NDEBUG" /mktyplib203 /o NUL /win32 
RSC=rc.exe
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\MFCtest.res" /d "NDEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\MFCtest.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=/nologo /subsystem:windows /incremental:no\
 /pdb:"$(OUTDIR)\MFCtest.pdb" /machine:I386 /out:"$(OUTDIR)\MFCtest.exe" 
LINK32_OBJS= \
	"$(INTDIR)\devicedesc.obj" \
	"$(INTDIR)\faxfinder.obj" \
	"$(INTDIR)\faxmanjr.obj" \
	"$(INTDIR)\faxstatusobj.obj" \
	"$(INTDIR)\fmprint.obj" \
	"$(INTDIR)\MFCtest.obj" \
	"$(INTDIR)\MFCtest.res" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\testDlg.obj"

"$(OUTDIR)\MFCtest.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "MFCtest - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

!IF "$(RECURSE)" == "0" 

ALL : "$(OUTDIR)\MFCtest.exe"

!ELSE 

ALL : "$(OUTDIR)\MFCtest.exe"

!ENDIF 

CLEAN :
	-@erase "$(INTDIR)\devicedesc.obj"
	-@erase "$(INTDIR)\faxfinder.obj"
	-@erase "$(INTDIR)\faxmanjr.obj"
	-@erase "$(INTDIR)\faxstatusobj.obj"
	-@erase "$(INTDIR)\fmprint.obj"
	-@erase "$(INTDIR)\MFCtest.obj"
	-@erase "$(INTDIR)\MFCtest.pch"
	-@erase "$(INTDIR)\MFCtest.res"
	-@erase "$(INTDIR)\StdAfx.obj"
	-@erase "$(INTDIR)\testDlg.obj"
	-@erase "$(INTDIR)\vc50.idb"
	-@erase "$(INTDIR)\vc50.pdb"
	-@erase "$(OUTDIR)\MFCtest.exe"
	-@erase "$(OUTDIR)\MFCtest.ilk"
	-@erase "$(OUTDIR)\MFCtest.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MDd /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS"\
 /D "_AFXDLL" /Fp"$(INTDIR)\MFCtest.pch" /Yu"stdafx.h" /Fo"$(INTDIR)\\"\
 /Fd"$(INTDIR)\\" /FD /c 
CPP_OBJS=.\Debug/
CPP_SBRS=.

.c{$(CPP_OBJS)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(CPP_OBJS)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(CPP_OBJS)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.c{$(CPP_SBRS)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(CPP_SBRS)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(CPP_SBRS)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

MTL=midl.exe
MTL_PROJ=/nologo /D "_DEBUG" /mktyplib203 /o NUL /win32 
RSC=rc.exe
RSC_PROJ=/l 0x409 /fo"$(INTDIR)\MFCtest.res" /d "_DEBUG" /d "_AFXDLL" 
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\MFCtest.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=/nologo /subsystem:windows /incremental:yes\
 /pdb:"$(OUTDIR)\MFCtest.pdb" /debug /machine:I386 /out:"$(OUTDIR)\MFCtest.exe"\
 /pdbtype:sept 
LINK32_OBJS= \
	"$(INTDIR)\devicedesc.obj" \
	"$(INTDIR)\faxfinder.obj" \
	"$(INTDIR)\faxmanjr.obj" \
	"$(INTDIR)\faxstatusobj.obj" \
	"$(INTDIR)\fmprint.obj" \
	"$(INTDIR)\MFCtest.obj" \
	"$(INTDIR)\MFCtest.res" \
	"$(INTDIR)\StdAfx.obj" \
	"$(INTDIR)\testDlg.obj"

"$(OUTDIR)\MFCtest.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(CFG)" == "MFCtest - Win32 Release" || "$(CFG)" ==\
 "MFCtest - Win32 Debug"
SOURCE=.\devicedesc.cpp
DEP_CPP_DEVIC=\
	".\devicedesc.h"\
	".\StdAfx.h"\
	

"$(INTDIR)\devicedesc.obj" : $(SOURCE) $(DEP_CPP_DEVIC) "$(INTDIR)"\
 "$(INTDIR)\MFCtest.pch"


SOURCE=.\faxfinder.cpp
DEP_CPP_FAXFI=\
	".\devicedesc.h"\
	".\faxfinder.h"\
	".\StdAfx.h"\
	

"$(INTDIR)\faxfinder.obj" : $(SOURCE) $(DEP_CPP_FAXFI) "$(INTDIR)"\
 "$(INTDIR)\MFCtest.pch"


SOURCE=.\faxmanjr.cpp

!IF  "$(CFG)" == "MFCtest - Win32 Release"

DEP_CPP_FAXMA=\
	".\faxmanjr.h"\
	".\faxstatusobj.h"\
	

"$(INTDIR)\faxmanjr.obj" : $(SOURCE) $(DEP_CPP_FAXMA) "$(INTDIR)"\
 "$(INTDIR)\MFCtest.pch"


!ELSEIF  "$(CFG)" == "MFCtest - Win32 Debug"

DEP_CPP_FAXMA=\
	".\faxmanjr.h"\
	".\faxstatusobj.h"\
	

"$(INTDIR)\faxmanjr.obj" : $(SOURCE) $(DEP_CPP_FAXMA) "$(INTDIR)"\
 "$(INTDIR)\MFCtest.pch"


!ENDIF 

SOURCE=.\faxstatusobj.cpp
DEP_CPP_FAXST=\
	".\faxstatusobj.h"\
	

"$(INTDIR)\faxstatusobj.obj" : $(SOURCE) $(DEP_CPP_FAXST) "$(INTDIR)"\
 "$(INTDIR)\MFCtest.pch"


SOURCE=.\fmprint.cpp
DEP_CPP_FMPRI=\
	".\fmprint.h"\
	

"$(INTDIR)\fmprint.obj" : $(SOURCE) $(DEP_CPP_FMPRI) "$(INTDIR)"\
 "$(INTDIR)\MFCtest.pch"


SOURCE=.\MFCtest.cpp
DEP_CPP_MFCTE=\
	".\devicedesc.h"\
	".\faxfinder.h"\
	".\FaxJrEnums.h"\
	".\faxmanjr.h"\
	".\faxstatusobj.h"\
	".\fmprint.h"\
	".\MFCtest.h"\
	".\StdAfx.h"\
	".\testDlg.h"\
	

"$(INTDIR)\MFCtest.obj" : $(SOURCE) $(DEP_CPP_MFCTE) "$(INTDIR)"\
 "$(INTDIR)\MFCtest.pch"


SOURCE=.\MFCtest.rc
DEP_RSC_MFCTES=\
	".\MFCtest.ico"\
	".\MFCtest.rc2"\
	

"$(INTDIR)\MFCtest.res" : $(SOURCE) $(DEP_RSC_MFCTES) "$(INTDIR)"
	$(RSC) $(RSC_PROJ) $(SOURCE)


SOURCE=.\StdAfx.cpp
DEP_CPP_STDAF=\
	".\StdAfx.h"\
	

!IF  "$(CFG)" == "MFCtest - Win32 Release"

CPP_SWITCHES=/nologo /MD /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D\
 "_AFXDLL" /Fp"$(INTDIR)\MFCtest.pch" /Yc"stdafx.h" /Fo"$(INTDIR)\\"\
 /Fd"$(INTDIR)\\" /FD /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\MFCtest.pch" : $(SOURCE) $(DEP_CPP_STDAF)\
 "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ELSEIF  "$(CFG)" == "MFCtest - Win32 Debug"

CPP_SWITCHES=/nologo /MDd /W3 /Gm /GX /Zi /Od /D "WIN32" /D "_DEBUG" /D\
 "_WINDOWS" /D "_AFXDLL" /Fp"$(INTDIR)\MFCtest.pch" /Yc"stdafx.h"\
 /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\\" /FD /c 

"$(INTDIR)\StdAfx.obj"	"$(INTDIR)\MFCtest.pch" : $(SOURCE) $(DEP_CPP_STDAF)\
 "$(INTDIR)"
	$(CPP) @<<
  $(CPP_SWITCHES) $(SOURCE)
<<


!ENDIF 

SOURCE=.\testDlg.cpp

!IF  "$(CFG)" == "MFCtest - Win32 Release"

DEP_CPP_TESTD=\
	".\devicedesc.h"\
	".\faxfinder.h"\
	".\FaxJrEnums.h"\
	".\faxmanjr.h"\
	".\faxstatusobj.h"\
	".\fmprint.h"\
	".\MFCtest.h"\
	".\testDlg.h"\
	

"$(INTDIR)\testDlg.obj" : $(SOURCE) $(DEP_CPP_TESTD) "$(INTDIR)"\
 "$(INTDIR)\MFCtest.pch"


!ELSEIF  "$(CFG)" == "MFCtest - Win32 Debug"

DEP_CPP_TESTD=\
	".\devicedesc.h"\
	".\faxfinder.h"\
	".\FaxJrEnums.h"\
	".\faxmanjr.h"\
	".\faxstatusobj.h"\
	".\fmprint.h"\
	".\MFCtest.h"\
	".\testDlg.h"\
	

"$(INTDIR)\testDlg.obj" : $(SOURCE) $(DEP_CPP_TESTD) "$(INTDIR)"\
 "$(INTDIR)\MFCtest.pch"


!ENDIF 


!ENDIF 

