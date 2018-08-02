//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "mapi.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TfrmTEmailTest *frmTEmailTest;
//---------------------------------------------------------------------------
__fastcall TfrmTEmailTest::TfrmTEmailTest(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TfrmTEmailTest::btnLogonClick(TObject *Sender)
{

  Screen->Cursor = crHourGlass;

  try {
    int Result = Email1->Logon();

    if (Result != EMAIL_OK) {

        AnsiString ErrorMessage = Format("Logon error %d", ARRAYOFCONST((int(Result))));

        Screen->Cursor = crDefault;

        ShowMessage(ErrorMessage);
    }
  }
  __finally
  {
    Screen->Cursor = crDefault;
  }

}
//---------------------------------------------------------------------------
void __fastcall TfrmTEmailTest::btnLogoffClick(TObject *Sender)
{

  int Result = Email1->Logoff();

  if (Result != EMAIL_OK) {
      AnsiString ErrorMessage = Format( "Logon error %d", ARRAYOFCONST( (int(Result)) ) );

      Screen->Cursor = crDefault;

      ShowMessage(ErrorMessage);
  }
}
//---------------------------------------------------------------------------
void __fastcall TfrmTEmailTest::btnSendClick(TObject *Sender)
{
  if (txtProfil->Text == "") {
    ShowMessage("Empty profile");
    return;
  };

  if (txtSubject->Text == "") {
    ShowMessage("Empty subject field");
    return;
  };

  if (txtTo->Text == "") {
    ShowMessage("Empty recipient field");
    return;
  };

  Screen->Cursor = crHourGlass;

  Email1->Profile = txtProfil->Text;

  int Result = Email1->Logon();

  if (Result != EMAIL_OK) {
    AnsiString ErrorMessage = Format( "Logon error %d", ARRAYOFCONST( (int(Result)) ) );

    Screen->Cursor = crDefault;

    ShowMessage(ErrorMessage);
    return;
  };

  Email1->Subject = txtSubject->Text;
  Email1->Recipient->Clear();
  Email1->Recipient->Add(txtTo->Text);
  Email1->Text = txtMemo->Text;
  Email1->ShowDialog = false;

  Result = Email1->SendMail();
  if (Result != EMAIL_OK) {

    AnsiString ErrorMessage = Format( "Send mail error %d", ARRAYOFCONST( (int(Result)) ) );

    Screen->Cursor = crDefault;

    ShowMessage(ErrorMessage);
  };

  Result = Email1->Logoff();
  if (Result != EMAIL_OK) {

    AnsiString ErrorMessage = Format( "Logoff error %d", ARRAYOFCONST( (int(Result)) ) );

    Screen->Cursor = crDefault;

    ShowMessage(ErrorMessage);
  };

  Screen->Cursor = crDefault;
}
//---------------------------------------------------------------------------
