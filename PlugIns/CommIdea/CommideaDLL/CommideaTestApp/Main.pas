unit Main;

{ nfrewer440 12:58 21/01/2004: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, APIUtil, CommideaInt, ExtCtrls;

  function LocalReferralProc(sPhoneNo, sMID : string; CardDetailsRec : TCardDetailsRec; var sAuthCode : String): LongInt;
  function LocalCheckSig : longInt;
  procedure LocalGetStatus(sStatus : string);

type
  TCheckSigProc = function : longInt;
  TGetStatusProc = procedure(sStatus : string);

  TForm2 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    lStatus: TLabel;
    btnClose: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Bevel1: TBevel;
    Label1: TLabel;
    Bevel2: TBevel;
    Label2: TLabel;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
    Button16: TButton;
    Button17: TButton;
    Button18: TButton;
    cbCNP: TCheckBox;
    Button19: TButton;
    Button20: TButton;
    Button21: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Button19Click(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    procedure Button21Click(Sender: TObject);
  private
    {iConfirm,} iResult : integer;
    sAuth, sError : shortstring;
//    procedure AuthoriseAmount(sType, sAmount : string; sPAN : string = ';6331656217930524=06072010300000000000?');
    procedure AuthoriseAmountSwipe(sType, sAmount : string; sPAN : string = ';4539789391917127=10102010300000000000?');
    procedure AuthoriseAmountManual(sType, sAmount : string; sPAN : string = '5301250070000191/0808/1111/'; iPrinter : integer = -1; bCheckSig : boolean = FALSE);
    procedure EnableDisable(bSetTo : boolean);
  public

  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
begin
  AuthoriseAmountSwipe(TX_SALE, '23.23');
end;

//procedure TForm2.AuthoriseAmountSwipe(sType, sAmount : string; sPAN : string = ';6331656217930524=06072010300000000000?');
procedure TForm2.AuthoriseAmountSwipe(sType, sAmount : string; sPAN : string = ';4539789391917127=10102010300000000000?');
begin
  EnableDisable(FALSE);
  sAuth := 'T0000001';
  iResult := ExCommideaAuthorise(sPAN, sAmount, sType, sError, sAuth
  , LocalCheckSig, LocalReferralProc, LocalGetStatus, 2, not cbCNP.Checked);
// if ExCommideaAuthorise('XXX', 'YYY')
  MsgBox('Result = ' + IntToStr(iResult) + #13#13 + sError + #13#13 + sAuth
  , mtInformation,[mbOK], mbOK,'Info');
  lStatus.Caption := 'Process Completed';
  EnableDisable(TRUE);
end;

//procedure TForm2.AuthoriseAmountManual(sType, sAmount : string; sPAN : string = '5301250070000191/0106/1207/'; iPrinter : integer = -1; bCheckSig : boolean = FALSE);
procedure TForm2.AuthoriseAmountManual(sType, sAmount : string; sPAN : string = '5301250070000191/0808/1111/'; iPrinter : integer = -1; bCheckSig : boolean = FALSE);
begin
  EnableDisable(FALSE);
  if bCheckSig then
  begin
    sAuth := 'T0000002';
    iResult := ExCommideaAuthorise(sPAN, sAmount, sType, sError, sAuth
    , LocalCheckSig, LocalReferralProc, LocalGetStatus, iPrinter, not cbCNP.Checked);
  end else
  begin
    sAuth := 'T0000003';
    iResult := ExCommideaAuthorise(sPAN, sAmount, sType, sError, sAuth
    , nil, LocalReferralProc, LocalGetStatus, iPrinter, not cbCNP.Checked);
  end;{if}

  MsgBox('Result = ' + IntToStr(iResult) + #13#13 + sError + #13#13 + sAuth
  , mtInformation,[mbOK], mbOK,'Info');
  lStatus.Caption := 'Process Completed';
  EnableDisable(TRUE);
end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  AuthoriseAmountSwipe(TX_SALE, '0.22');
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
  AuthoriseAmountSwipe(TX_SALE, '00.05');
end;

procedure TForm2.Button4Click(Sender: TObject);
begin
  AuthoriseAmountSwipe(TX_SALE, '75.00');
end;

function LocalCheckSig : longInt;
begin
  if MsgBox('Is the signature OK ?', mtConfirmation, [mbYes, mbNo], mbYes, 'OK ?') = mrYes
  then Result := MR_SIGNATURE_OK
  else Result := MR_SIGNATURE_NOT_OK;
end;

function LocalReferralProc(sPhoneNo, sMID : string; CardDetailsRec : TCardDetailsRec; var sAuthCode : String): LongInt;
begin
  if InputQuery(sPhoneNo + '/' + sMID, CardDetailsRec.CardNumber + '/'
  + '/' + CardDetailsRec.StartDate + '/' + CardDetailsRec.ExpiryDate + '/'
  + CardDetailsRec.IssueNumber, sAuthCode)
  then begin
    Result := MR_REFERRAL_OK;
  end else
  begin
    Result := MR_REFERRAL_NOT_OK;
  end;{if}
end;

procedure LocalGetStatus(sStatus : string);
begin
  Form2.lStatus.Caption := sStatus;
end;

procedure TForm2.btnCloseClick(Sender: TObject);
begin
  close;
end;

procedure TForm2.Button5Click(Sender: TObject);
begin
  AuthoriseAmountSwipe(TX_REFUND, '10.00');
end;

procedure TForm2.Button6Click(Sender: TObject);
begin
  AuthoriseAmountSwipe(TX_SALE, '9.13', ';0123456789012347=12062010300000000000?');
end;

procedure TForm2.Button7Click(Sender: TObject);
begin
  AuthoriseAmountSwipe(TX_SALE, '129.13', ';374281041092002=12062010300000000000?');
end;

procedure TForm2.Button8Click(Sender: TObject);
begin
  AuthoriseAmountSwipe(TX_SALE, '1219.13', ';4929854830292=12062010300000000000?');
end;

procedure TForm2.Button9Click(Sender: TObject);
begin
  AuthoriseAmountSwipe(TX_SALE, '1219.13', ';6319071201200601=02042010300000000000?');
end;

procedure TForm2.Button10Click(Sender: TObject);
begin
  AuthoriseAmountSwipe(TX_SALE, '74.99', ';5404635120249689=12062010300000000000?');
end;

procedure TForm2.Button11Click(Sender: TObject);
begin
  AuthoriseAmountManual(TX_SALE, '1.00', '5301250070000191/0808/1111/');
end;

procedure TForm2.Button12Click(Sender: TObject);
begin
  AuthoriseAmountManual(TX_SALE, '1.00', ';4539789391917127=06072010300000000000?');
end;

procedure TForm2.EnableDisable(bSetTo: boolean);
var
  iComp : integer;
begin
  For iComp := 0 to ComponentCount-1 do
  begin
    if Components[iComp] is TButton
    then TButton(Components[iComp]).Enabled := bSetTo;
  end;

  if bSetTo then Screen.Cursor := crDefault
  else Screen.Cursor := crHourglass;
end;

procedure TForm2.Button13Click(Sender: TObject);
begin
  AuthoriseAmountManual(TX_REFUND, '-1.00', '5301250070000191/0808/1111/');
end;

procedure TForm2.Button14Click(Sender: TObject);
begin
  AuthoriseAmountManual(TX_REFUND, '-25.00', '4000000000000002//1212/');
end;

procedure TForm2.Button15Click(Sender: TObject);
begin
  AuthoriseAmountManual(TX_SALE, '35.02', '4000000000000002//1212/');
end;

procedure TForm2.Button16Click(Sender: TObject);
begin
  AuthoriseAmountManual(TX_SALE, '45.05', '4000000000000002//1212/');
end;

procedure TForm2.Button17Click(Sender: TObject);
begin
  AuthoriseAmountManual(TX_SALE, '150.00', '5301250070000191//1212//000');
end;

procedure TForm2.Button18Click(Sender: TObject);
begin
  AuthoriseAmountManual(TX_SALE, '155.00', '4000000000000002//1212//999');
end;

procedure TForm2.Button19Click(Sender: TObject);
begin
  AuthoriseAmountManual(TX_REFUND, '-150.00', '4000000000000002//1212/');
end;

procedure TForm2.Button20Click(Sender: TObject);
begin
  AuthoriseAmountManual(TX_SALE, '4.00', '6767051323183400359//1210/0');
end;

procedure TForm2.Button21Click(Sender: TObject);
begin
  AuthoriseAmountManual(TX_SALE, '8.00', '4917480000000008//1210//');
end;

end.
