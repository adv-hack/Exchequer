//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
USERES("tmsxlsc5.res");
USEPACKAGE("vcl50.bpi");
USEUNIT("xlsadapter\AdvGridExcel.pas");
USEPACKAGE("vcljpg50.bpi");
USEPACKAGE("tmsc5.bpi");
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------

//   Package source.
//---------------------------------------------------------------------------

#pragma argsused
int WINAPI DllEntryPoint(HINSTANCE hinst, unsigned long reason, void*)
{
        return 1;
}
//---------------------------------------------------------------------------
