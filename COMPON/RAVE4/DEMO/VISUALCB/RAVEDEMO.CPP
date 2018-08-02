//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USERES("RaveDemo.res");
USEFORM("Main.cpp", Form1);
USEFORM("DM.cpp", DataModule1); /* TDataModule: DesignClass */
//---------------------------------------------------------------------------
WINAPI WinMain(HINSTANCE, HINSTANCE, LPSTR, int)
{
  try
  {
     Application->Initialize();
     Application->CreateForm(__classid(TForm1), &Form1);
     Application->CreateForm(__classid(TDataModule1), &DataModule1);
     Application->Run();
  }
  catch (Exception &exception)
  {
     Application->ShowException(&exception);
  }
  return 0;
}
//---------------------------------------------------------------------------
