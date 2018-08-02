//---------------------------------------------------------------------------
#ifndef mapiH
#define mapiH
//---------------------------------------------------------------------------
#include <vcl\Classes.hpp>
#include <vcl\Controls.hpp>
#include <vcl\StdCtrls.hpp>
#include <vcl\Forms.hpp>
#include "Email.hpp"
//---------------------------------------------------------------------------
class TfrmTEmailTest : public TForm
{
__published:	// Composants gérés par l'EDI
	TEmail *Email1;
	TButton *btnSend;
	TEdit *txtSujet;
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
	
private:	// Déclarations de l'utilisateur
public:		// Déclarations de l'utilisateur
	__fastcall TfrmTEmailTest(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern TfrmTEmailTest *frmTEmailTest;
//---------------------------------------------------------------------------
#endif
