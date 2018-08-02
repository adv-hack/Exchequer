unit ManualWiz3Frame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, StrUtils, LicDets, Menus, ComCtrls, Math, Mask;

type
  TfraManualWiz3 = class(TFrame)
    lblTitle: TLabel;
    lblIntro: TLabel;
    lblCDKey: TLabel;
    lblCompDesc: TLabel;
    lblPervasiveTitle: TLabel;
    lblPervasiveText: TLabel;
    lblFinish: TLabel;
    lblBack: TLabel;
    lblPervasiveLicenceKey: TLabel;
    edtPervasiveLicenceKey: TEdit;
    Label1: TLabel;
    edtUserCount: TEdit;
    udUserCount: TUpDown;
    Label5: TLabel;
    edtCompanyCount: TEdit;
    udCompanyCount: TUpDown;
    procedure lblFinishClick(Sender: TObject);
    procedure lblBackClick(Sender: TObject);
  private
    { Private declarations }
    FLicence : TLicenceDetails;
    Function Form2Lic : SmallInt;
  public
    { Public declarations }
    Procedure InitLicence (Licence : TLicenceDetails);
  end;

implementation

{$R *.dfm}

Uses Brand, IniFiles, WizdMsg, DebugU, LicRec, LicFuncU, oIRISLicence;

//=========================================================================

Procedure TfraManualWiz3.InitLicence (Licence : TLicenceDetails);
Var
  Idx : SmallInt;
Begin // InitLicence
  FLicence := Licence;

  {$IFDEF COMP}
    // Licence Update wizard off MCM
    lblBack.Visible := False;
    lblFinish.Visible := False;
  {$ENDIF} // COMP

  // User Count
  If (FLicence.ldUsers > 0) Then
    udUserCount.Position := FLicence.ldUsers
  Else
    udUserCount.Position := 1;

  // Company Count
  If (FLicence.ldCompanies > 0) Then
    udCompanyCount.Position := FLicence.ldCompanies
  Else
    udCompanyCount.Position := 1;

  // Pervasive Key - Hide fields if Pervasive Version not supported
  Idx := FLicence.ldIRISLicence.LicenceRestrictions.IndexOf(LRPervasiveKey);
  If (Idx <> -1) Then
    edtPervasiveLicenceKey.Text := FLicence.ldPervasiveKey;
End; // InitLicence

//-------------------------------------------------------------------------

// Validates the specified details and copies them into the licencing object
//
//      0  AOK
//   1001  Info set incorrectly
//   1002  Company count not valid
//   1003  User count not valid
//   1004  Not Used
//   1005  Pervasive Key not specified
//
Function TfraManualWiz3.Form2Lic : SmallInt;
Var
  I, Idx : SmallInt;
Begin // Form2Lic
  Result := 0;

  // User Count
  If (udUserCount.Position > 0) Then
    FLicence.ldUsers := udUserCount.Position
  Else
    Result := 1003; // User count not valid

  // Company Count
  If (udCompanyCount.Position > 0) Then
    FLicence.ldCompanies := udCompanyCount.Position
  Else
    Result := 1002; // Company count not valid

  // Pervasive Key
  If (Trim(edtPervasiveLicenceKey.Text) <> '') Then
    FLicence.ldPervasiveKey := edtPervasiveLicenceKey.Text
  Else
    Result := 1005; // Pervasive Key not specified

  If (Result = 0) Then
  Begin
    // Update the licence limits
    FLicence.ldIRISLicence.ClearLicenceLimits;

    // IAO Version Number
    Idx := FLicence.ldIRISLicence.LicenceRestrictions.IndexOf(LRLITEVersion);
    If (Idx >= 0) Then FLicence.ldIRISLicence.LicenceRestrictions[Idx].Value := sCurrentIAOVersion;

    // Company Name
    Idx := FLicence.ldIRISLicence.LicenceRestrictions.IndexOf(LRCompanyName);
    If (Idx >= 0) Then FLicence.ldIRISLicence.LicenceRestrictions[Idx].Value := FLicence.ldCompanyName;

    // Country
    Idx := FLicence.ldIRISLicence.LicenceRestrictions.IndexOf(LRCountryCode);
    If (Idx >= 0) Then FLicence.ldIRISLicence.LicenceRestrictions[Idx].Value := FLicence.ldCountryCode;

    // LITE Version - Customer/Accountant
    Idx := FLicence.ldIRISLicence.LicenceRestrictions.IndexOf(LRLITEType);
    If (Idx >= 0) Then FLicence.ldIRISLicence.LicenceRestrictions[Idx].Value := FLicence.ldLITEType;

    // Theme
    Idx := FLicence.ldIRISLicence.LicenceRestrictions.IndexOf(LRTheme);
    If (Idx >= 0) Then FLicence.ldIRISLicence.LicenceRestrictions[Idx].Value := IntToStr(FLicence.ldTheme);

    // User Count
    Idx := FLicence.ldIRISLicence.LicenceRestrictions.IndexOf(LRUserCount);
    If (Idx >= 0) Then FLicence.ldIRISLicence.LicenceRestrictions[Idx].Value := IntToStr(FLicence.ldUsers);

    // Company Count
    Idx := FLicence.ldIRISLicence.LicenceRestrictions.IndexOf(LRCompanyCount);
    If (Idx >= 0) Then FLicence.ldIRISLicence.LicenceRestrictions[Idx].Value := IntToStr(FLicence.ldCompanies);

    // Pervasive Key
    Idx := FLicence.ldIRISLicence.LicenceRestrictions.IndexOf(LRPervasiveKey);
    If (Idx >= 0) Then FLicence.ldIRISLicence.LicenceRestrictions[Idx].Value := FLicence.ldPervasiveKey;

    // Validate the Licence Keys
    For I := 0 To (FLicence.ldIRISLicence.LicenceCodes.Count - 1) Do
    Begin
      If (Not FLicence.ldIRISLicence.LicenceCodes[I].Validate) Then
      Begin
        Result := 1001;  // Info set incorrectly
        Break;
      End; // If (Not FLicence.ldIRISLicence.LicenceCodes[I].Validate)
    End; // For I
  End; // If (Result = 0)
End; // Form2Lic

//------------------------------

procedure TfraManualWiz3.lblBackClick(Sender: TObject);
begin
  Form2Lic;  // store any valid details so they aren't lost
  PostMessage ((Owner As TForm).Handle, WM_UpdateMode, 0, Ord(amManual2));
end;

//------------------------------

procedure TfraManualWiz3.lblFinishClick(Sender: TObject);
Var
  Res : SmallInt;
begin
  // Validate details and move to next form in wizard
  Res := Form2Lic;
  Case Res Of
    // AOK
    0      : PostMessage ((Owner As TForm).Handle, WM_UpdateMode, 0, Ord(amDisplayDets));

    // Info set incorrectly
    1001   : MessageDlg ('One or more of the Licence Details has been set incorrectly, please check that all the settings are correct',
                         mtError, [mbOK], 0);

    // Company count not valid
    1002   : Begin
               MessageDlg ('The Company Count must be greater than zero', mtError, [mbOK], 0);
               If edtCompanyCount.CanFocus Then edtCompanyCount.SetFocus;
             End; // 1002

    // User count not valid
    1003   : Begin
               MessageDlg ('The User Count must be greater than zero', mtError, [mbOK], 0);
               If edtUserCount.CanFocus Then edtUserCount.SetFocus;
             End; // 1003

    // Pervasive Key not specified
    1005   : Begin
               MessageDlg ('The Pervasive Licence Key must be set', mtError, [mbOK], 0);
               If edtPervasiveLicenceKey.CanFocus Then edtPervasiveLicenceKey.SetFocus;
             End; // 1005
  Else
    Raise Exception.Create ('TfraManualWiz3.lblFinishClick: Unknown Error ' + IntToStr(Res));
  End; // Case Res
end;

//-------------------------------------------------------------------------

end.

