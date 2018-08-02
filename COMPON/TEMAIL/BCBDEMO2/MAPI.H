//---------------------------------------------------------------------------
#ifndef mapiH
#define mapiH
//---------------------------------------------------------------------------
#include <Classes.hpp>
#include <Controls.hpp>
#include <StdCtrls.hpp>
#include <Forms.hpp>
#include "Email.hpp"
//---------------------------------------------------------------------------
class TfrmTEmailTest : public TForm
{
__published:	// IDE-managed Components
	TEmail *Email1;
	TButton *btnSend;
 TEdit *txtSubject;
	TLabel *Label1;
	TLabel *Label2;
	TEdit *txtTo;
	TLabel *Label3;
	TEdit *txtProfil;
	TLabel *Label4;
	TMemo *txtMemo;
	void __fastcall btnLogonClick(TObject *Sender);
	void __fastcall btnLogoffClick(TObject *Sender);
	void __fastcall btnSendClick(TObject *Sender);
	
private:
public:
	__fastcall TfrmTEmailTest(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TfrmTEmailTest *frmTEmailTest;
//---------------------------------------------------------------------------
#endif
