unit lwClSvr;

{ markd6 10:48 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, ComCtrls;

type
  TfrmLicWiz7 = class(TForm)
    Label2: TLabel;
    Label3: TLabel;
    Bevel2: TBevel;
    btnNext: TButton;
    btnPrevious: TButton;
    lstCSEngine: TListBox;
    Label1: TLabel;
    lstClUsers: TComboBox;
    UpDown1: TUpDown;
    Label4: TLabel;
    Label10: TLabel;
    edtLicence: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure btnPreviousClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure lstCSEngineClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Label10Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    WizMod : SmallInt;
  end;


Procedure LicWiz_ClServer (Var   WizForm           : TfrmLicWiz7;
                           Var   WizNo, LastWiz    : Byte;
                           Const WizPrev, WizNext  : Byte;
                           Var   Done, Aborted     : Boolean);


implementation

{$R *.DFM}

Uses LicRec, LicVar, Math;


Procedure LicWiz_ClServer (Var   WizForm           : TfrmLicWiz7;
                           Var   WizNo, LastWiz    : Byte;
                           Const WizPrev, WizNext  : Byte;
                           Var   Done, Aborted     : Boolean);
Begin { LicWiz_ClServer }
  // MH 12/07/2013: Removed Pervasive dialogs at Martin's request
  If FALSE And (LicenceInfo.licType In [0, 1]) And (LicenceInfo.licEntClSvr = 1) Then Begin
    If (LicenceInfo.licEntDB = DBBtrieve) Then
    Begin
      { Create Form as and when necessary }
      If Not Assigned(WizForm) Then Begin
        WizForm := TfrmLicWiz7.Create(Application.MainForm);
      End; { If Not Assigned(WizForm)  }

      { Re-Initialise forms return value }
      WizForm.WizMod := Wiz_Abort;

      { Display Form }
      WizForm.ShowModal;

      { Process return value }
      Case WizForm.WizMod Of
        Wiz_Abort  : Aborted := True;

        Wiz_Prev   : WizNo := WizPrev;

        Wiz_Next   : WizNo := WizNext;
      End; { Case }
    End // If (LicenceInfo.licEntDB = DBBtrieve)
    Else
      WizNo := IfThen (LastWiz = WizPrev, WizNext, WizPrev);
  End { If (LicenceInfo.licType In [0, 1]) }
  Else Begin
    { Deselect C/S Engine }
    LicenceInfo.licClServer := 0;
    LicenceInfo.licCSUserCnt := 0;

    If (LastWiz = WizPrev) Then
      WizNo := WizNext
    Else
      WizNo := WizPrev;
  End; { Else }

  LastWiz := Wiz_ClServer;
End; { LicWiz_ClServer }

{----------------------------------------------------------------------------}


procedure TfrmLicWiz7.FormCreate(Sender: TObject);
begin
  licInitWin (Self, Wiz_ClServer);

  { Init local variables }
  WizMod := Wiz_Abort;

  { Initialise screen values }
  If ConfigInfo.AddMode Then
  Begin
    If (LicenceInfo.licEntClSvr = 1) And (LicenceInfo.licType = 0) Then
      { Install Ent C/S - default to NT }
      LicenceInfo.licClServer := 1
    Else
      { Not Install or Not C/S - default to None }
      LicenceInfo.licClServer := 0;
  End; // If ConfigInfo.AddMode

  lstCSEngine.ItemIndex := LicenceInfo.licClServer;
  lstCSEngineClick(Sender);

  UpDown1.Position := LicenceInfo.licCSUserCnt;

  edtLicence.Text := LicenceInfo.licPSQLLicKey;
end;

procedure TfrmLicWiz7.btnPreviousClick(Sender: TObject);
begin
  WizMod := Wiz_Prev;
  Close;
end;

procedure TfrmLicWiz7.btnNextClick(Sender: TObject);
Var
  IntVal  : LongInt;
  ErrCode : Integer;
  OK      : Boolean;
begin
  { Do validation }
  OK := (lstCSEngine.ItemIndex >= 0);

  If OK Then Begin
    { Init CS-Engine values }
    LicenceInfo.licCSUserCnt := 0;
    LicenceInfo.licClServer := lstCSEngine.ItemIndex;
    LicenceInfo.licPSQLLicKey := '';

    If (lstCSEngine.ItemIndex > 0) Then Begin
      { An engine has been selected - check the user count }
      Val (lstClUsers.Text, IntVal, ErrCode);
      OK := (ErrCode = 0) And (IntVal >= 1) And (IntVal <= 999);
      If OK Then
        LicenceInfo.licCSUserCnt := IntVal
      Else
        ShowMessage ('The Engine User Count is invalid');
    End; { If (lstCSEngine.ItemIndex > 0) }

    { HM 22/06/01: Check C/S Ucount against Enterprise's if supplying engine }
    If OK And (LicenceInfo.licClServer > 0) Then Begin
      { C/S U?count should be at least the same as the Enterprise UCount }
      OK := (LicenceInfo.licCSUserCnt >= LicenceInfo.licUserCnt);
      If (Not OK) Then
        { Ask user if they want to ignore problem }
        OK := (MessageDlg ('The Enterprise User Count is higher than the Client-Server ' +
                           'Engine User-Count:- ' + #13#13 +
                           'Enterprise: ' + IntToStr(LicenceInfo.licUserCnt) + '  Pervasive.SQL: ' +
                           IntToStr(LicenceInfo.licCSUserCnt) + #13#13 + 'Do you want to continue?',
                           mtConfirmation, [mbYes, mbNo], 0) = mrYes);

      If OK Then
      Begin
        LicenceInfo.licPSQLLicKey := UpperCase(Trim(edtLicence.Text));
        OK := (Length(LicenceInfo.licPSQLLicKey) = 24);
        If (Not OK) Then
          ShowMessage ('A valid Licence Key must be specified');
      End // If OK
      Else
    End; { If OK }

    If OK Then Begin
      WizMod := Wiz_Next;
      Close;
    End; { If }
  End { If }
  Else
    ShowMessage ('A C/S Engine Version must be selected');
end;

procedure TfrmLicWiz7.lstCSEngineClick(Sender: TObject);
begin
  lstClUsers.Enabled := (lstCSEngine.ItemIndex > 0);
end;

procedure TfrmLicWiz7.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  { Save positions into ini file }
  licSaveCoords (Self);
end;

procedure TfrmLicWiz7.Label10Click(Sender: TObject);
begin
  edtLicence.Text := 'CS:DEFGHIJKLMNOPQRSTUVwx';
end;

end.
