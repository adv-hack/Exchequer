//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USERES("CodeBasedC4.res");
USEFORMNS("Adhocprn.PAS", Adhocprn, frmAdhocprn);
USEFORMNS("ChartTest.PAS", Charttest, frmTChartTest);
USEFORMNS("EMailData.pas", Emaildata, frmEMailData);
USEFORMNS("Main.pas", Main, frmMain);
USEFORMNS("MainDataMod.pas", Maindatamod, dmMain); /* TDataModule: DesignClass */
//---------------------------------------------------------------------------
WINAPI WinMain(HINSTANCE, HINSTANCE, LPSTR, int)
{
	try
	{
		Application->Initialize();
		Application->CreateForm(__classid(TfrmMain), &frmMain);
		Application->CreateForm(__classid(TdmMain), &dmMain);
		Application->Run();
	}
	catch (Exception &exception)
	{
		Application->ShowException(&exception);
	}
	return 0;
}
//---------------------------------------------------------------------------
