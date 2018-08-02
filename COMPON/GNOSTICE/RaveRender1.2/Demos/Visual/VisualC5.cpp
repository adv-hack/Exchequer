//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop
USERES("VisualC5.res");
USEFORMNS("Main.pas", Main, Form1);
USEFORMNS("DM.pas", Dm, DataModule2); /* TDataModule: File Type */
USEFORMNS("EMailData.pas", Emaildata, frmEMailData);
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
