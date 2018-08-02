unit lwCust;

{ markd6 10:48 31/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Mask, TEditVal, IniFiles;

type
  TfrmLicWiz8 = class(TForm)
    Label2: TLabel;
    Label3: TLabel;
    Bevel2: TBevel;
    btnNext: TButton;
    edtCompany: TEdit;
    Label1: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    btnPrevious: TButton;
    Label6: TLabel;
    lstDealer: TComboBox;
    Label7: TLabel;
    meESN1: TMaskEdit;
    meESN2: TMaskEdit;
    Label8: TLabel;
    Label9: TLabel;
    lstIssueNo: TComboBox;
    Label10: TLabel;
    edtCode: TEdit;
    procedure btnNextClick(Sender: TObject);
    procedure btnPreviousClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure meESN1Exit(Sender: TObject);
    procedure meESN2Exit(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    WizMod : SmallInt;
    procedure ReInit;
  end;


Procedure LicWiz_CustDets (Var   WizForm           : TfrmLicWiz8;
                           Var   WizNo, LastWiz    : Byte;
                           Const WizPrev, WizNext  : Byte;
                           Var   Done, Aborted     : Boolean);

implementation

{$R *.DFM}

Uses LicRec, LicVar, RSyncU, ESNImpU, APIUtil, LicFuncU;


Procedure LicWiz_CustDets (Var   WizForm           : TfrmLicWiz8;
                           Var   WizNo, LastWiz    : Byte;
                           Const WizPrev, WizNext  : Byte;
                           Var   Done, Aborted     : Boolean);
Begin { LicWiz_CustDets }
  // HM 22/06/01: Added ESN screen to Auto-Upgrade licences
  //If (LicenceInfo.licType In [0, 1]) Then Begin
    { Create Form as and when necessary }
    If Not Assigned(WizForm) Then Begin
      WizForm := TfrmLicWiz8.Create(Application.MainForm);
    End; { If Not Assigned(frmWiz10)  }

    { Re-Initialise forms return value }
    WizForm.ReInit;

    { Display Form }
    WizForm.ShowModal;

    { Process return value }
    Case WizForm.WizMod Of
      Wiz_Abort  : Aborted := True;

      Wiz_Prev   : WizNo := WizPrev;

      Wiz_Next   : WizNo := WizNext;
    End; { Case }
  (*End { If (LicenceInfo.licType In [0, 1]) }
  Else Begin
    If (LastWiz = WizPrev) Then
      WizNo := WizNext
    Else
      WizNo := WizPrev;
  End; { Else }*)

  LastWiz := Wiz_CustDets;
End; { LicWiz_CustDets }

{----------------------------------------------------------------------------}

procedure TfrmLicWiz8.FormCreate(Sender: TObject);
Var
  IniF : TIniFile;
  sIssue : String[3];
  iIssue : SmallInt;
begin
  licInitWin (Self, Wiz_CustDets);

  ReInit;

  { Initialise screen values }
  edtCompany.Text := LicenceInfo.licCompany;

  IniF := TIniFile.Create (ChangeFileExt (Application.ExeName, '.INI'));
  Try
    lstDealer.Items.LoadFromFile (ExtractFilePath(Application.ExeName) + 'Dealers.Lst');
    If (LicenceInfo.licDealer = '') Then
      lstDealer.ItemIndex := lstDealer.Items.IndexOf (IniF.ReadString ('Defaults', 'DefDlr', 'Exchequer Software Ltd'))
    Else
      lstDealer.ItemIndex := lstDealer.Items.IndexOf (LicenceInfo.licDealer);

    meESN1.Text := ESN2ByteToStr(LicenceInfo.licESN);
    meESN2.Text := ESN2ByteToStr(LicenceInfo.licESN2);

    lstIssueNo.Items.LoadFromFile (ExtractFilePath(Application.ExeName) + 'Issues.Lst');
    If (LicenceInfo.licAutoUpgIssue = 0) Then
      lstIssueNo.ItemIndex := lstIssueNo.Items.IndexOf (IniF.ReadString ('Defaults', 'IssueNo', ''))
    Else
    Begin
      sIssue := Format ('%3.3d', [LicenceInfo.licAutoUpgIssue]);
      For iIssue := 0 To (lstIssueNo.Items.Count - 1) Do
      Begin
        If (Pos(sIssue, lstIssueNo.Items[iIssue]) = 1) Then
        Begin
          lstIssueNo.ItemIndex := iIssue;
          Break;
        End; // If (Pos(sIssue, lstIssueNo.Items[iIssue]) = 1)
      End; // For iIssue
    End; // Else
  Finally
    IniF.Free;
  End;
end;

procedure TfrmLicWiz8.ReInit;
Var
  TmpStr : ShortString;
begin
  { Init local variables }
  WizMod := Wiz_Abort;

  { HM 22/06/01: Added ESN's to Auto-Upgrade licences }
  meESN1.Enabled := (LicenceInfo.licType In [1, 2]);
  meESN2.Enabled := meESN1.Enabled;
  Label4.Enabled := meESN1.Enabled;
  Label5.Enabled := meESN1.Enabled;
  Label7.Enabled := meESN1.Enabled;

  { HM 22/06/01: Added ESN's to Auto-Upgrade licences }
  lstIssueNo.Enabled := (LicenceInfo.licType = 2);
  Label8.Enabled := lstIssueNo.Enabled;
  Label9.Enabled := lstIssueNo.Enabled;
end;

procedure TfrmLicWiz8.btnNextClick(Sender: TObject);
Var
  Issue, Err : LongInt;
  OK         : Boolean;
begin
  btnNext.SetFocus;

  { Check Company Details have been selected }
  If ((Trim(edtCode.Text) <> '') And (Trim(edtCompany.Text) <> '')) Or (LicenceInfo.licType = 2) Then Begin
    OK := True;

    If (LicenceInfo.licType = 1) Then Begin
      { Upgrade - get Installation Serial number }
      OK := ProcessESNStr (LicenceInfo.licESN, meESN1);

      { Check not all zero }
      OK := (LicenceInfo.licESN[1] <> 0) Or (LicenceInfo.licESN[2] <> 0) Or
            (LicenceInfo.licESN[3] <> 0) Or (LicenceInfo.licESN[4] <> 0) Or
            (LicenceInfo.licESN[5] <> 0) Or (LicenceInfo.licESN[6] <> 0);

      If Not OK Then Begin
        { Check not all 0 as only 1 in 281.4 Billion probability of all 0's being correct }
        OK := (MessageDlg ('ESN 1 has not been set. Is this correct?', mtConfirmation, [mbYes, mbNo], 0) = mrYes);
      End; { If OK }

      If OK Then
        OK := ProcessESNStr (LicenceInfo.licESN2, meESN2);
    End; { If }

    { HM 06/07/01: Added auto-Upgrade Issue Number }
    If OK And (LicenceInfo.licType = 2) Then Begin
      { Auto-Upgrade - get Issue number }
      OK := (lstIssueNo.ItemIndex > -1);
      If OK Then Begin
        { Issue number set - extract issue number for licence }
        Val (Copy (lstIssueNo.Text, 1, 3), Issue, Err);
        OK := (Err = 0);
        If OK Then
          LicenceInfo.licAutoUpgIssue := Issue
        Else Begin
          MessageDlg('The Auto-Upgrade Issue Number is Invalid', mtError, [mbOK], 0);
          If lstIssueNo.CanFocus Then lstIssueNo.SetFocus;
        End; { Else }
      End { If OK }
      Else Begin
        MessageDlg('The Auto-Upgrade Issue Number must be set', mtError, [mbOK], 0);
        If lstIssueNo.CanFocus Then lstIssueNo.SetFocus;
      End; { Else }
    End; { If OK And (LicenceInfo.licType = 2) }

    If OK Then Begin
      LicenceInfo.licCompany := Trim(edtCompany.Text);
      LicenceInfo.licDealer := Trim(Copy (lstDealer.Text, 10, 255));

      CDGenInfo.AccountCode := UpperCase(edtCode.Text);
      CDGenInfo.DealerCode := UpperCase(Copy (lstDealer.Text, 1, 6));

      WizMod := Wiz_Next;
      Close;
    End; { If }
  End { If }
  Else
    ShowMessage ('The Company Details must be set before you can continue');
end;

procedure TfrmLicWiz8.btnPreviousClick(Sender: TObject);
begin
  WizMod := Wiz_Prev;
  Close;
end;

procedure TfrmLicWiz8.Label4Click(Sender: TObject);
{Var
  Msg, Capt           : ANSIString;
  sCheck, sCheck2     : ShortString;
  Y, M, D, YInc, WInc : Word;
  YearStart           : TDateTime;}
begin
(*
  // Move to company field to ensure all ESN fields are validated
  If edtCompany.CanFocus Then edtCompany.SetFocus;

  sCheck  := '';
  sCheck2 := '';

  // Fixed calculation used up to b431.009 - 17/07/00
  With LicenceInfo Do
    If ProcessESNStr (licESN, meESN1) Then Begin
      sCheck := sCheck + Chr(Ord('A') + (LicESN[1] Mod 12));
      sCheck := sCheck + Chr(Ord('A') + (licESN[2] Mod 12));
      sCheck := sCheck + Chr(Ord('A') + (licESN[3] Mod 12));
      sCheck := sCheck + Chr(Ord('A') + (licESN[4] Mod 12));
      sCheck := sCheck + Chr(Ord('A') + (licESN[5] Mod 12));
      sCheck := sCheck + Chr(Ord('A') + (licESN[6] Mod 12));

      // Date Driven calculation used from b431.010 - 17/07/00
      sCheck2 := CalcRSysnc (Now,
                             licESN[1],
                             licESN[2],
                             licESN[3],
                             licESN[4],
                             licESN[5],
                             licESN[6]);

      Capt := '/RSYNC: Checksums - ' + FormatDateTime ('DD/MM/YYYY', Now);
      Msg := '--> MCM b431.009: ' + sCheck + #13 +
             'MCM b431.011 -->: ' + sCheck2;
      Application.MessageBox (PChar(Msg), PChar(Capt), MB_ICONINFORMATION);
    End; { If }
*)    
end;

procedure TfrmLicWiz8.Label1Click(Sender: TObject);
begin
  edtCode.Text := '******';
  edtCompany.Text := 'Internal Test - ' + WinGetUserName;
  edtCompany.SelStart := Length(edtCompany.Text);

  lstDealer.ItemIndex := 0;
end;

procedure TfrmLicWiz8.meESN1Exit(Sender: TObject);
begin
  ProcessESNStr (LicenceInfo.licESN, meESN1);
end;

procedure TfrmLicWiz8.meESN2Exit(Sender: TObject);
begin
  ProcessESNStr (LicenceInfo.licESN2, meESN2);
end;

procedure TfrmLicWiz8.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  { Save positions into ini file }
  licSaveCoords (Self);
end;

end.
