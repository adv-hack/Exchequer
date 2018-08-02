//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USERES("RVDBPkgCB5.res");
USEUNIT("DBRV.pas");
USERES("DBRV.dcr");
USEPACKAGE("vcl50.bpi");
USEPACKAGE("vcldb50.bpi");
USEPACKAGE("RVPkgCB5.bpi");
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
