//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "mapi.h"
//---------------------------------------------------------------------------
#pragma link "Email"
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
int result;
Screen->Cursor = crHourGlass;
result = Email1->Logon();
if (result != 0)
	{
    char ch[200];
    wsprintf(ch, "logon error %d", result);
    Screen->Cursor = crDefault;
	ShowMessage(String(ch));
    }
Screen->Cursor = crDefault;
}
//---------------------------------------------------------------------------
void __fastcall TfrmTEmailTest::btnLogoffClick(TObject *Sender)
{
int result;
result = Email1->Logoff();
if (result != 0)
	{
    char ch[200];
    wsprintf(ch, "logoff error %d", result);
    Screen->Cursor = crDefault;
	ShowMessage(String(ch));
    }
}
//---------------------------------------------------------------------------
void __fastcall TfrmTEmailTest::btnSendClick(TObject *Sender)
{
int result = 0;
if (txtProfil->Text == "")
	{
    ShowMessage("empty profile");
    return;
    }
if (txtSujet->Text == "")
	{
    ShowMessage("empty subject");
    return;
    }
if (txtTo->Text == "")
	{
    ShowMessage("empty recipient");
    return;
    }
Screen->Cursor = crHourGlass;
Email1->Profile = txtProfil->Text;
try
	{
    result = Email1->Logon();
    }
catch (Exception &e)
	{
    ShowMessage(e.Message);
    result = -1;
    }
if (result != 0)
	{
    char ch[200];
    wsprintf(ch, "logon error %d", result);
    Screen->Cursor = crDefault;
    if (result != -1)
    	ShowMessage(String(ch));
    return;
    }

Email1->Subject = txtSujet->Text;
Email1->Recipient->Clear();
Email1->Recipient->Add(txtTo->Text);
Email1->Text = txtMemo->Text;
Email1->ShowDialog = false;
result = Email1->SendMail();
if (result != 0)
	{
    char ch[200];
    wsprintf(ch, "send mail error %d", result);
    Screen->Cursor = crDefault;
    ShowMessage(String(ch));
    }
result = Email1->Logoff();
if (result != 0)
	{
    char ch[200];
    wsprintf(ch, "logoff error %d", result);
    Screen->Cursor = crDefault;
	ShowMessage(String(ch));
    }
Screen->Cursor = crDefault;
}
//---------------------------------------------------------------------------
