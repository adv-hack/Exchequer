//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
USERES("DCLgtRPRC50.res");
USEPACKAGE("vcl50.bpi");
USEPACKAGE("gtRPRC50.bpi");
USEPACKAGE("RPRT40D5.bpi");
USEUNIT("gtRPRender_Reg.pas");
USERES("gtRPRender_Reg.dcr");
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
