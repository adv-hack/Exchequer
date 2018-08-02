unit ManualWiz2Frame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, StrUtils, LicDets, Menus, ComCtrls, Math, Mask;

type
  TfraManualWiz2 = class(TFrame)
    lblTitle: TLabel;
    lblIntro: TLabel;
    lblCDKey: TLabel;
    lblCompDesc: TLabel;
    lblTypeTitle: TLabel;
    Label3: TLabel;
    lblNext: TLabel;
    lblBack: TLabel;
    lstCountry: TComboBox;
    Label2: TLabel;
    lstLITEType: TComboBox;
    Label4: TLabel;
    edtCompanyName: TEdit;
    Label1: TLabel;
    lstLITEEdition: TComboBox;
    procedure lblNextClick(Sender: TObject);
    procedure lblBackClick(Sender: TObject);
  private
    { Private declarations }
    FLicence : TLicenceDetails;
    Function Form2Lic : SmallInt;
  protected
    Procedure Loaded; Override;
  public
    { Public declarations }
    Procedure InitLicence (Licence : TLicenceDetails);
  end;

implementation

{$R *.dfm}

Uses Brand, IniFiles, WizdMsg, DebugU, LicRec, LicFuncU, oIRISLicence;

//=========================================================================

procedure TfraManualWiz2.Loaded;
Var
  I : SmallInt;
Begin // Loaded
  Inherited;

  {$IFDEF COMP}
    // Licence Update wizard off MCM
    lblBack.Visible := False;
    lblNext.Visible := False;
  {$ENDIF} // COMP

  // Update Branding
  lblCompDesc.Caption := ANSIReplaceStr(lblCompDesc.Caption, '<APPTITLE>', Branding.pbProductName);
  lblTypeTitle.Caption := ANSIReplaceStr(lblTypeTitle.Caption, '<APPTITLE>', Branding.pbProductName);

  // Load supported countries skipping 'Any'
  lstCountry.Items.Clear;
  lstCountry.Sorted := True;
  For I := 1 To High(sCountries) Do
  Begin
    lstCountry.Items.Add (sCountries[I,2]);
  End; // For I
End; // Loaded

//-------------------------------------------------------------------------

Procedure TfraManualWiz2.InitLicence (Licence : TLicenceDetails);
Var
  Idx : SmallInt;
  sValue : ShortString;
Begin // InitLicence
  FLicence := Licence;

  // Company Name
  edtCompanyName.Text := FLicence.ldCompanyName;

  // Country
  sValue := ISO3166CountryCodeToString (FLicence.ldCountryCode);
  Idx := lstCountry.Items.IndexOf(sValue);
  If (Idx <> -1) Then
    lstCountry.ItemIndex := Idx
  Else
    lstCountry.ItemIndex := lstCountry.Items.IndexOf(ISO3166CountryCodeToString ('UK'));

  // Type
//  lstLITEType.ItemIndex := lstLITEType.Items.IndexOf(FLicence.ldLITEType);
//  If (lstLITEType.ItemIndex = -1) Then lstLITEType.ItemIndex := 0;
  sValue := UpperCase(Trim(FLicence.ldLITEType));
  If (sValue = 'CUSTOMER') Then
    lstLITEType.ItemIndex := 0  // Standard
  Else If (sValue = 'ACCOUNTANT') Then
    lstLITEType.ItemIndex := 1  // Practice
  Else
    lstLITEType.ItemIndex := 0; // Select first one automatically

  // Edition/Theme
  lstLITEEdition.ItemIndex := FLicence.ldTheme - 1;
End; // InitLicence

//-------------------------------------------------------------------------

// Validates the specified details and copies them into the licencing object
//
//   0     AOK
//   1001  Country Code not specified
//   1002  Type not specified
//   1003  Company Name not specified
//   1004  Edition/Theme not specified
//
Function TfraManualWiz2.Form2Lic : SmallInt;
Begin // Form2Lic
  Result := 0;

  // Company Name
  If (Trim(edtCompanyName.Text) <> '') Then
    FLicence.ldCompanyName := edtCompanyName.Text
  Else
    Result := 1003; // Company Name not specified

  // Country
  If (lstCountry.ItemIndex <> -1) Then
    FLicence.ldCountryCode := CountryStringToISO3166Code (lstCountry.Text)
  Else
    If (Result = 0) Then Result := 1001; // Country Code not specified

  // Product Type - Customer or Accountant
//  If (lstLITEType.ItemIndex <> -1) Then
//    FLicence.ldLITEType := lstLITEType.Text
//  Else
//    If (Result = 0) Then Result := 1002; // Type not specified
  Case lstLITEType.ItemIndex Of
    0 : FLicence.ldLITEType := 'Customer';
    1 : FLicence.ldLITEType := 'Accountant';
  Else
    If (Result = 0) Then Result := 1002; // Type not specified
  End; // Case lstLITEType.ItemIndex

  // Theme / Edition
  If (lstLITEEdition.ItemIndex <> -1) Then
    FLicence.ldTheme := lstLITEEdition.ItemIndex + 1
  Else
    If (Result = 0) Then Result := 1004; // Type not specified
End; // Form2Lic

//------------------------------

procedure TfraManualWiz2.lblBackClick(Sender: TObject);
begin
  Form2Lic;  // store any valid details so they aren't lost
  PostMessage ((Owner As TForm).Handle, WM_UpdateMode, 0, Ord(amManual1));
end;

//------------------------------

procedure TfraManualWiz2.lblNextClick(Sender: TObject);
Var
  Res : SmallInt;
begin
  // Validate details and move to next form in wizard
  Res := Form2Lic;
  Case Res Of
    // AOK
    0      : PostMessage ((Owner As TForm).Handle, WM_UpdateMode, 0, Ord(amManual3));

    // Country Code not specified
    1001   : Begin
               MessageDlg ('The Country Code must be specified', mtError, [mbOK], 0);
               If lstCountry.CanFocus Then lstCountry.SetFocus;
             End; // 1001

    // Type not specified
    1002   : Begin
               MessageDlg ('The Licence Type must be specified', mtError, [mbOK], 0);
               If lstLITEType.CanFocus Then lstLITEType.SetFocus;
             End; // 1002

    // Company Name not specified
    1003   : Begin
               MessageDlg ('The Company Name must be specified', mtError, [mbOK], 0);
               If edtCompanyName.CanFocus Then edtCompanyName.SetFocus;
             End; // 1003
    // Edition/Theme not specified
    1004   : Begin
               MessageDlg ('The Edition must be specified', mtError, [mbOK], 0);
               If lstLITEEdition.CanFocus Then lstLITEEdition.SetFocus;
             End; // 1004
  Else
    Raise Exception.Create ('TfraManualWiz2.lblNextClick: Unknown Error ' + IntToStr(Res));
  End; // Case Res
end;

//-------------------------------------------------------------------------

end.

