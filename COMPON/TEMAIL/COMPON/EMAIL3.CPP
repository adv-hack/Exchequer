//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USERES("Email3.res");
USEPACKAGE("VCL35.bpi");
USEUNIT("Smapi.pas");
USEUNIT("email32.pas");
USERES("email32.dcr");
USEUNIT("Email.pas");
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
