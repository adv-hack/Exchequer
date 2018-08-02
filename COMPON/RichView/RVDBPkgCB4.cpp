//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USERES("RVDBPkgCB4.res");
USEUNIT("DBRV.pas");
USERES("DBRV.dcr");
USEPACKAGE("vcl40.bpi");
USEPACKAGE("RVPkgCB4.bpi");
USEPACKAGE("vcldb40.bpi");
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------
//   Package source.
//---------------------------------------------------------------------------
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
    return 1;
}
//---------------------------------------------------------------------------
