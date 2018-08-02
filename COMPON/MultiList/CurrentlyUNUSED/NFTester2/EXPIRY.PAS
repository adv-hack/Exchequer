unit Expiry;

{ nfrewer440 09:07 07/05/2003: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs
  , HelpSupU,APIUtil, ExtCtrls, StdCtrls, Mask, TEditVal, CardProc, VarConst
  , SecSup2U, SecureU, VarRec2U, NeilProc;

type
  TfrmReleaseCode = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lDate: TLabel;
    edSecurity: Text8Pt;
    edRelease: Text8Pt;
    btnOK: TButton;
    btnCancel: TButton;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Bevel2: TBevel;
    Label9: TLabel;
    Bevel1: TBevel;
    Bevel3: TBevel;
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    iTries : byte;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmReleaseCode: TfrmReleaseCode;

implementation

{$R *.DFM}

procedure TfrmReleaseCode.FormShow(Sender: TObject);
var
  bLocked : boolean;
  CurSecy : Integer;
  EXISN : ISNArrayType;
begin
  {* Security Check required *}
  iTries := 0;
  bLocked := TRUE;
  GetMultiSys(TRUE, bLocked);

  fillchar(EXISN,sizeof(EXISN),#0);

  with Syss do begin
    RelDate:=0;  {* Reset Security Date so once triggered,  setting the system date has no effect *}
    CurSecy:=Calc_Security(ExSecurity, FALSE);
    If (CurSecy=0) then Begin
      {20/06/2000 - Re-instated due to incompatibilities with DOS card system}
      CurSecy:=Set_Security;
      ExSecurity:=Calc_SecStr(CurSecy, FALSE);
      PutMultiSys;
{      ExSecurity:=Get_ISNSecurity(EXISN); 20/06/2000 - 4.31 security}
    end;

    edSecurity.Text := ExSecurity;
    lDate.Caption := DateToStr(Date);
  end;{with}
end;

procedure TfrmReleaseCode.btnOKClick(Sender: TObject);
Var
  FullExSec, NextDSec, CurRel, CurSecy : LongInt;
  OK                                   : Boolean;
begin
  inc(iTries);
  { Validate Release Code }
  OK := (Trim(edRelease.Text) <> '');

  If OK Then Begin
    Syss.ExRelease := Trim(edRelease.Text);

    { Calculate valid release codes }
    CurSecy:=Calc_Security(Syss.ExSecurity, FALSE);
    FullExSec:=CurSecy+SecRelCode;
    NextDSec:=CurSecy+SecXtra30Code;

    { Check entered release code }
    CurRel := Calc_Security(Syss.ExRelease, TRUE);
    OK := (CurRel = FullExSec) Or (CurRel = NextDSec);
  End; { If }

  If OK Then
    Begin
      { Check for 30-day code and set expiry date as required }
      Syss.RelDate := 0;

      If (CurRel = NextDSec) Then Begin
        { 30-day }
        Syss.RelDate := CalcNewRelDate(MaxDaysSecy);

        { Set new Security Code and Blank Release Code }
        Syss.ExSecurity := '';
        Syss.ExRelease := '';
      End; { If }
      ModalResult := mrOK;
    End
  else begin
    if iTries >= 3 then
      begin
        MsgBox('You have entered an incorrect release code.' + CHR(13) + CHR(13) +
        'The system will now be closed down.', mtError,[mbOK],mbOK,'Invalid Code');
        ModalResult := mrCancel;
      end
    else begin
      MsgBox('You have entered an incorrect release code.' + CHR(13) + CHR(13) +
      'Please check the code and try again', mtError,[mbOK],mbOK,'Invalid Code');
    end;{if}
  end;{if}
end;

end.
