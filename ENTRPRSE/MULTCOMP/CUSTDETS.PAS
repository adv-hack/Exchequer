unit CustDets;

{ markd6 14:07 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  SetupBas, ExtCtrls, StdCtrls, Mask, TEditVal, ComCtrls, Inifiles, Buttons,
  LicRec;

type
  TAddrIdx = 1..5;
  TStr30 = String[30];
  TStr50 = String[50];
  TCustAddrType = Array[TAddrIdx] Of TStr30;

  TfrmCustDets = class;

  TCustDetsDlg = Class(TObject)
  Private
    FCustAddr    : TCustAddrType;
    FCustContact : TStr30;
    FCustEmail   : TStr50;
    FCustFax     : TStr30;
    FCustName    : TStr30;
    FCustPhone   : TStr30;

    FDealer      : TStr50;
    FDealerTown  : TStr50;

    FMode        : Byte;    { 1=Email, 2=Fax }

    FUsrIniF     : TIniFile;
  Protected
    Function  GetCustAddr(Index : TAddrIdx) : TStr30;
    Procedure SetCustAddr(Index : TAddrIdx; Value : TStr30);
  Public
    Constructor Create (Var LicRec : EntLicenceRecType; Var UsrIniF : TIniFile);

    Property Address[Index : TAddrIdx] : TStr30 Read GetCustAddr Write SetCustAddr;
  Published
    Property Contact : TStr30 Read FCustContact Write FCustContact;
    Property Dealer : TStr50 Read FDealer Write FDealer;
    Property DealerTown : TStr50 Read FDealerTown Write FDealerTown;
    Property EmailAddr : TStr50 Read FCustEmail Write FCustEmail;
    Property Mode : Byte Read FMode Write FMode;
    Property Name : TStr30 Read FCustName Write FCustName;
    Property Fax : TStr30 Read FCustFax Write FCustFax;
    Property Phone : TStr30 Read FCustPhone Write FCustPhone;

    Function Execute (Const Mode : Byte) : Boolean;
  End; { TCustDetsDlg }

  TfrmCustDets = class(TSetupTemplate)
    Label1: TLabel;
    edtDealer: Text8Pt;
    Label3: TLabel;
    edtContact: Text8Pt;
    Label4: TLabel;
    edtAddr1: Text8Pt;
    edtAddr2: Text8Pt;
    edtAddr3: Text8Pt;
    edtAddr4: Text8Pt;
    edtAddr5: Text8Pt;
    Label5: TLabel;
    edtPhone: Text8Pt;
    Label6: TLabel;
    edtFax: Text8Pt;
    Label2: TLabel;
    edtemail: Text8Pt;
    Label7: TLabel;
    edtCompany: Text8Pt;
    Bevel2: TBevel;
    Label8: TLabel;
    edtDealerTown: Text8Pt;
    Label9: TLabel;
    Label10: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    lBinIniF, lUsrIniF : TIniFile;
    lEntDir            : String;
    lGotMapi           : Boolean;
    lCustDetsO         : TCustDetsDlg;
  Protected
    Function  ValidOk(VCode : Char) : Boolean; Override;
  public
    { Public declarations }
    Procedure SetupDlg(Const CustDetsO : TCustDetsDlg);
  end;


implementation

{$R *.DFM}

Uses GlobVar, VarConst, EtDateU, EtStrU, EtMiscU, GlobExch;

{----------------------------------------------------------------------------}

Constructor TCustDetsDlg.Create (Var LicRec : EntLicenceRecType; Var UsrIniF : TIniFile);
Var
  I      : Byte;
Begin { Create }
  Inherited Create;

  FMode := 0;

  FUsrIniF := UsrIniF;

  With FUsrIniF Do Begin
    For I := Low(FCustAddr) To High(FCustAddr) Do
      If (I < High(Syss.DetailAddr)) Then
        FCustAddr[I] := ReadString('CustDets', 'Addr'+IntToStr(I), Syss.DetailAddr[I])
      Else
        FCustAddr[I] := ReadString('CustDets', 'Addr'+IntToStr(I), '');
    FCustContact   := ReadString('CustDets', 'Contact', '');
    FCustEmail     := ReadString('CustDets', 'Email', '');
    FCustFax       := ReadString('CustDets', 'Fax', Syss.DetailFax);
    FCustName      := ReadString('CustDets', 'Name', Syss.UserName);
    FCustPhone     := ReadString('CustDets', 'Phone', Syss.DetailTel);
    FDealer        := ReadString('CustDets', 'Dealer', LicRec.licDealer);
    FDealerTown    := ReadString('CustDets', 'DealerTown', '');
  End; { With }
End; { Create }

Function TCustDetsDlg.Execute (Const Mode : Byte) : Boolean;
Var
  frmCustDets : TfrmCustDets;
  I           : Byte;
Begin { Execute }
  Result := False;

  FMode := Mode;

  Try
    frmCustDets := TfrmCustDets.Create(Application);
    Try
      With frmCustDets Do Begin
        SetupDlg(Self);

        ShowModal;

        Result := (ExitCode = 'N');

        If Result Then Begin
          { User saved details - update user ini file }
          With FUsrIniF Do Begin
            WriteString ('CustDets', 'Dealer',     FDealer);
            WriteString ('CustDets', 'DealerTown', FDealerTown);
            WriteString ('CustDets', 'Name',       FCustName);
            WriteString ('CustDets', 'Contact',    FCustContact);
            For I := Low(FCustAddr) To High(FCustAddr) Do
              WriteString ('CustDets', 'Addr'+IntToStr(I), FCustAddr[I]);
            WriteString ('CustDets', 'Phone',      FCustPhone);
            WriteString ('CustDets', 'Fax',        FCustFax);
            WriteString ('CustDets', 'Email',      FCustEmail);
          End; { With }
        End; { If Result }
      End; { With }
    Finally
      frmCustDets.Free;
    End;
  Except
    On Ex:Exception Do Begin
      GlobExceptHandler(Ex);
      Result := False;
    End;
  End;
End; { Execute }

Function TCustDetsDlg.GetCustAddr(Index : TAddrIdx) : TStr30;
Begin { GetCustAddr }
  Result := FCustAddr[Index];
End; { GetCustAddr }

Procedure TCustDetsDlg.SetCustAddr(Index : TAddrIdx; Value : TStr30);
Begin { SetCustAddr }
  If (Value <> FCustAddr[Index]) Then
    FCustAddr[Index] := Value;
End; { SetCustAddr }

{----------------------------------------------------------------------------}

procedure TfrmCustDets.FormCreate(Sender: TObject);
begin
  inherited;

  ExitMsg := 2;  { Security Code wizard }
end;

Procedure TfrmCustDets.SetupDlg(Const CustDetsO : TCustDetsDlg);
Var
  TmpDir : String;
  I      : LongInt;
Begin { SetupDlg }
  lCustDetsO := CustDetsO;

  With CustDetsO Do Begin
    edtDealer.Text := Dealer;
    edtDealerTown.Text := DealerTown;
    edtCompany.Text := Name;
    edtContact.Text := Contact;
    edtAddr1.Text := Address[1];
    edtAddr2.Text := Address[2];
    edtAddr3.Text := Address[3];
    edtAddr4.Text := Address[4];
    edtAddr5.Text := Address[5];
    edtPhone.Text := Phone;
    edtFax.Text := Fax;
    edtemail.Text := EmailAddr;
  End; { With CustDetsO }


(*
  lEntDir  := EntDir;
  lGotMAPI := GotMAPI;
  lBinIniF := BinIniF;
  lUsrIniF := UsrIniF;

  { General Settings -------------------------------------------------------- }
  Case UsrIniF.ReadInteger ('SecCodeWizard', 'TabIdx', 2) Of
    1 : PageControl1.ActivePage := tabshEmail;
    2 : PageControl1.ActivePage := tabshFax;
    3 : PageControl1.ActivePage := tabshPhone;
  End; { Case }

  { Email Settings ---------------------------------------------------------- }
  If lGotMapi Then Begin
    { Default To MAPI }
    lstEmailMthd.ItemIndex := 0;
  End { If GotMapi }
  Else Begin
    lstEmailMthd.ItemIndex := 1;
    lstEmailMthd.Enabled := False;
  End; { Else }

  I := UsrIniF.ReadInteger ('SecCodeWizard', 'EmlMethod', -1);
  If (I >= 0) And (I < lstEmailMthd.Items.Count) Then Begin
    lstEmailMthd.ItemIndex := I;
  End; { If }
  lstEmailMthdChange(Application);

  { SMTP Server }
  TmpDir := UsrIniF.ReadString ('SecCodeWizard', 'SMTPSvr', '');
  If (Trim(TmpDir) <> '') Then Begin
    edtSMTP.Text := Trim(TmpDir);
  End; { If (Trim(TmpDir) <> '') }

  { Fax Settings ------------------------------------------------------------ }




  { Telephone Settings ------------------------------------------------------ }
  lblPhoneContact.Caption := BinIniF.ReadString('VendorDetails', 'vdPhoneContact', '?');
  lblPhoneNo.Caption := BinIniF.ReadString('VendorDetails', 'vdPhone', '?');

  edtISN.Text := '';
  For I := 1 To 6 Do Begin
    edtISN.Text := edtISN.Text + ByteToHexStr (Syss.ExISN[I]);

    If (I < 6) Then
      edtISN.Text := edtISN.Text + '-';
  End; { For I }

  edtSecCode.Text := Syss.ExSecurity;
  edtRelCode.Text := '';
*)
End; { SetupDlg }

Function TfrmCustDets.ValidOk(VCode : Char) : Boolean;

  { Returns true is string contains MinNums+ number characters }
  Function GotNums(NumStr : String; MinNums : Byte) : Boolean;
  Var
    I, NoNums : SmallInt;
  Begin { GotNums }
    Result := False;

    NumStr := Trim(NumStr);
    NoNums := 0;

    If (Length(NumStr) > 0) Then
      For I := 1 To Length(NumStr) Do
        If (NumStr[I] In ['0'..'9']) Then
          Inc(NoNums);

    Result := (NoNums >= MinNums);
  End; { GotNums }

Begin { ValidOK }
  Result := True;

  If (VCode = 'N') Then Begin
    { Dealer - Cannot be blank }
    Result := (Trim(edtDealer.Text) <> '') And (Trim(edtDealerTown.Text) <> '');
    If Result Then Begin
      lCustDetsO.Dealer := Trim(edtDealer.Text);
      lCustDetsO.DealerTown := Trim(edtDealerTown.Text);
    End { If }
    Else Begin
      MessageDlg ('The details about the Dealer you purchased Exchequer from must be set', mtWarning, [mbOk], 0);
      If (Trim(edtDealer.Text) <> '') Then Begin
        If edtDealerTown.CanFocus Then edtDealerTown.SetFocus;
      End { If }
      Else
        If edtDealer.CanFocus Then edtDealer.SetFocus;
    End; { Else }

    If Result Then Begin
      { Contact }
      Result := (Trim(edtContact.Text) <> '');
      If Result Then
        lCustDetsO.Contact := Trim(edtContact.Text)
      Else Begin
        MessageDlg ('A Contact Name must be given', mtWarning, [mbOk], 0);
        If edtContact.CanFocus Then edtContact.SetFocus;
      End; { Else }
    End; { If }

    If Result Then Begin
      { Company }
      Result := (Trim(edtCompany.Text) <> '');
      If Result Then
        lCustDetsO.Name := Trim(edtCompany.Text)
      Else Begin
        MessageDlg ('Your Company Name must be given', mtWarning, [mbOk], 0);
        If edtCompany.CanFocus Then edtCompany.SetFocus;
      End; { Else }
    End; { If }

    If Result Then Begin
      { Address }
      lCustDetsO.Address[1] := Trim(edtAddr1.Text);
      lCustDetsO.Address[2] := Trim(edtAddr2.Text);
      lCustDetsO.Address[3] := Trim(edtAddr3.Text);
      lCustDetsO.Address[4] := Trim(edtAddr4.Text);
      lCustDetsO.Address[5] := Trim(edtAddr5.Text);
    End; { If Result }

    If Result Then Begin
      { Phone }
      Result := GotNums(edtPhone.Text, 4);
      If Result Then
        lCustDetsO.Phone := Trim(edtPhone.Text)
      Else Begin
        MessageDlg ('Your Telephone Number must be supplied to allow you to be contacted if necessary', mtWarning, [mbOk], 0);
        If edtPhone.CanFocus Then edtPhone.SetFocus;
      End; { Else }
    End; { If }

    If Result Then Begin
      { Fax - mandatory if sending by fax }
      Result := GotNums(edtFax.Text, 4) Or (lCustDetsO.Mode <> 2);
      If Result Then
        lCustDetsO.Fax := Trim(edtFax.Text)
      Else Begin
        MessageDlg ('Your Fax Number must be supplied to allow us to respond', mtWarning, [mbOk], 0);
        If edtFax.CanFocus Then edtFax.SetFocus;
      End; { Else }
    End; { If }

    If Result Then Begin
      { Email Address }
      Result := (Trim(edtemail.Text) <> '') Or (lCustDetsO.Mode <> 1);
      If Result Then
        lCustDetsO.EmailAddr := Trim(edtemail.Text)
      Else Begin
        MessageDlg ('Your Email Address must be supplied to allow us to respond', mtWarning, [mbOk], 0);
        If edtemail.CanFocus Then edtemail.SetFocus;
      End; { Else }
    End; { If }
  End; { If }
End; { ValidOK }

end.
