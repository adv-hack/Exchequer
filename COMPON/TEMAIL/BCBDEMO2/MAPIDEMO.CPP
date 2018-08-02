//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USERES("MapiDemoPrj.res");
USEFORM("Mapi.cpp", frmTEmailTest);
//---------------------------------------------------------------------------
WINAPI WinMain(HINSTANCE, HINSTANCE, LPSTR, int)
{
 try
 {
   Application->Initialize();
   Application->CreateForm(__classid(TfrmTEmailTest), &frmTEmailTest);
   Application->Run();
 }
 catch (Exception &exception)
 {
   Application->ShowException(&exception);
 }
 return 0;
}
//---------------------------------------------------------------------------
