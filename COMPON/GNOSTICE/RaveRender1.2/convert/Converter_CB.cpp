//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USERES("Converter_CB.res");
USEFORMNS("Main.pas", Main, frmMain);
//---------------------------------------------------------------------------
WINAPI WinMain(HINSTANCE, HINSTANCE, LPSTR, int)
{
  try
  {
     Application->Initialize();
     Application->CreateForm(__classid(TfrmMain), &frmMain);
     Application->Run();
  }
  catch (Exception &exception)
  {
     Application->ShowException(&exception);
  }
  return 0;
}
//---------------------------------------------------------------------------
