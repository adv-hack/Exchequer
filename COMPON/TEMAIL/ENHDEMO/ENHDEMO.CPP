//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USERES("EnhDemo.res");
USEFORMNS("Umapi.pas", Umapi, MainForm);
//---------------------------------------------------------------------------
WINAPI WinMain(HINSTANCE, HINSTANCE, LPSTR, int)
{
 try
 {
   Application->Initialize();
   Application->Title = "TEmail Enhanced Demo Application";
   Application->CreateForm(__classid(TMainForm), &MainForm);
   Application->Run();
 }
 catch (Exception &exception)
 {
   Application->ShowException(&exception);
 }
 return 0;
}
//---------------------------------------------------------------------------
