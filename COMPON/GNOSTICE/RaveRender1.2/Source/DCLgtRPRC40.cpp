//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USERES("DCLgtRPRC40.res");
USEPACKAGE("vcl40.bpi");
USEUNIT("gtRPRender_Reg.pas");
USERES("gtRPRender_Reg.dcr");
USEPACKAGE("gtRPRC40.bpi");
USEPACKAGE("RPRV40D4.bpi");
USEPACKAGE("RPRT40D4.bpi");
USEPACKAGE("VCLX40.bpi");
USEPACKAGE("VCLJPG40.bpi");
USEPACKAGE("VCLDB40.bpi");
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
