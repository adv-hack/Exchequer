//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USEFORMNS("DM.pas", Dm, DataModule2); /* TDataModule: DesignClass */
USEFORMNS("EMailData.pas", Emaildata, frmEMailData);
USEFORMNS("Main.pas", Main, Form1);
//---------------------------------------------------------------------------
WINAPI WinMain(HINSTANCE, HINSTANCE, LPSTR, int)
{
	try
	{
		Application->Initialize();
		Application->CreateForm(__classid(TForm1), &Form1);
		Application->CreateForm(__classid(TDataModule2), &DataModule2);
		Application->Run();
	}
	catch (Exception &exception)
	{
		Application->ShowException(&exception);
	}
	return 0;
}
//---------------------------------------------------------------------------
