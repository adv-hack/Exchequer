//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop
USERES("QMail32.res");
USEFORMNS("MailForm.pas", Mailform, frmMail);
USEFORMNS("AboutForm.pas", Aboutform, frmAbout);
//---------------------------------------------------------------------------
WINAPI WinMain(HINSTANCE, HINSTANCE, LPSTR, int)
{
 try
 {
   Application->Initialize();
   Application->CreateForm(__classid(TfrmMail), &frmMail);
   Application->Run();
 }
 catch (Exception &exception)
 {
   Application->ShowException(&exception);
 }
 return 0;
}
//---------------------------------------------------------------------------
