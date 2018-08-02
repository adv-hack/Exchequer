unit ManualFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, StrUtils, LicDets, Menus, ComCtrls, Math, Mask;

type
  TfraManual = class(TFrame)
    lblTitle: TLabel;
    lblIntro: TLabel;
    lblInstall: TLabel;
    PopupMenu1: TPopupMenu;
    cmbSystemType: TComboBox;
    cmbCountry: TComboBox;
    cmbVersion: TComboBox;
    Label1: TLabel;
    edtUserCount: TEdit;
    udUsers: TUpDown;
    Label2: TLabel;
    edtCompanyCount: TEdit;
    udCompanies: TUpDown;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    edtWGEKey: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    edtCompanyName: TEdit;
    lblCDKey: TLabel;
    edtCDKey: TMaskEdit;
    lblCDKeyExample: TLabel;
    procedure ClickMenuItem(Sender: TObject);
    procedure lblInstallClick(Sender: TObject);
  private
    { Private declarations }
    FLicence : TLicenceDetails;
  protected
    Procedure Loaded; Override;
  public
    { Public declarations }
    Procedure InitLicence (Licence : TLicenceDetails);
  end;

implementation

{$R *.dfm}

Uses Brand, IniFiles, WizdMsg, DebugU, LicRec, LicFuncU;

//=========================================================================

procedure TfraManual.Loaded;
Var
  IniF : TIniFile;
  Sections : TStringList;
  MenuItem : TMenuItem;
  iSection : Byte;
Begin // Loaded
  Inherited;

  // Update Branding
  lblIntro.Caption := ANSIReplaceStr(lblIntro.Caption, '<APPTITLE>', Branding.pbProductName);

  If DebugMode And FileExists('C:\LITECD.INI') Then
  Begin
    // Build Popup Menu for automating manual licences
    IniF := TIniFile.Create('C:\LITECD.INI');
    Sections := TStringList.Create;
    Try
      IniF.ReadSections(Sections);
      If (Sections.Count > 0) Then
      Begin
        For iSection := 0 To (Sections.Count - 1) Do
        Begin
          MenuItem := TMenuItem.Create(PopupMenu1);
          MenuItem.Caption := Sections[iSection];
          MenuItem.OnClick := ClickMenuItem;
          PopupMenu1.Items.Add(MenuItem);
        End; // For iSection
      End; // If (Sections.Count > 0)
    Finally
      FreeAndNIL(IniF);
      FreeAndNIL(Sections);
    End; // Try..Finally

    If (PopupMenu1.Items.Count > 0) Then
    Begin
      lblTitle.PopupMenu := PopupMenu1;
    End; // If (PopupMenu1.Items.Count > 0)
  End; // If DebugMode And FileExists('C:\LITECD.INI')
End; // Loaded

//-------------------------------------------------------------------------

Procedure TfraManual.InitLicence (Licence : TLicenceDetails);
Begin // InitLicence
  FLicence := Licence;

  lblInstall.Caption := IfThen (FLicence.ldCDLicence.licType=0, 'Install', 'Upgrade');

  // Default manual details based on supplied licence
  edtCDKey.EditText := FLicence.ldCDKey;
  cmbCountry.ItemIndex := FLicence.ldCDLicence.licCountry - 1;
  cmbSystemType.ItemIndex := FLicence.ldCDLicence.licProductType - 1; // 0=Exchequer, 1=LITE Customer, 2=LITE Accountant
  edtCompanyName.Text := FLicence.ldCDLicence.licCompany;
  If (FLicence.ldCDLicence.licEntCVer = 0) Then
    cmbVersion.ItemIndex := FLicence.ldCDLicence.licEntModVer
  Else
    cmbVersion.ItemIndex := FLicence.ldCDLicence.licEntModVer + 3;
  udUsers.Position := FLicence.ldCDLicence.licUserCnt;            // Enterprise User Count

  //licEntEdition   := SmallInt;

  udCompanies.Position := FLicence.ldCDLicence.licUserCounts[ucCompanies];

  edtWGEKey.Text := FLicence.ldCDLicence.licPSQLLicKey; // P.SQL v8 licence string (C/s + WGE)
End; // InitLicence

//-------------------------------------------------------------------------

procedure TfraManual.ClickMenuItem(Sender: TObject);
Var
  IniF : TIniFile;
  sSection, sValue : ShortString;
begin
  IniF := TIniFile.Create('C:\LITECD.INI');
  Try
    sSection := (Sender As TMenuItem).Caption;

    // Country
    sValue := IniF.ReadString (sSection, 'Country', cmbCountry.Text);
    cmbCountry.ItemIndex := cmbCountry.Items.IndexOf(sValue);
    If (cmbCountry.ItemIndex = -1) Then cmbCountry.ItemIndex := 0;

    // Type
    sValue := IniF.ReadString (sSection, 'Type', cmbSystemType.Text);
    cmbSystemType.ItemIndex := cmbSystemType.Items.IndexOf(sValue);
    If (cmbSystemType.ItemIndex = -1) Then cmbSystemType.ItemIndex := 0;

    // Version
    sValue := IniF.ReadString (sSection, 'Version', cmbVersion.Text);
    cmbVersion.ItemIndex := cmbVersion.Items.IndexOf(sValue);
    If (cmbVersion.ItemIndex = -1) Then cmbVersion.ItemIndex := 0;

    // Users
    udUsers.Position := IniF.ReadInteger(sSection, 'Users', 1);

    // Companies
    udCompanies.Position := IniF.ReadInteger(sSection, 'Companies', 3);

    // WGE Licence Key
    edtWGEKey.Text := IniF.ReadString (sSection, 'WGEKey', edtWGEKey.Text);
  Finally
    FreeAndNIL(IniF);
  End; // Try..Finally
end;

//-------------------------------------------------------------------------

procedure TfraManual.lblInstallClick(Sender: TObject);
begin
  With FLicence.ldCDLicence Do
  Begin
    licCDKey := ExtractCDKeyForLicence (edtCDKey.Text);

    licCountry := cmbCountry.ItemIndex + 1;

    licCompany := edtCompanyName.Text;
    licProductType := cmbSystemType.ItemIndex + 1; // 0=Exchequer, 1=LITE Customer, 2=LITE Accountant
    licEntCVer   := IfThen (cmbVersion.ItemIndex > 2, 2, 0);     // 0-Prof, 1-Euro, 2-MC
    licEntModVer := cmbVersion.ItemIndex Mod 3; // 0-Basic, 1-Stock, 2-SPOP
    licUserCnt   := udUsers.Position;            // Enterprise User Count

    //licEntEdition   := SmallInt;

    licUserCounts[ucCompanies] := udCompanies.Position;

    If (edtWGEKey.Text <> '') Then
    Begin
      licPSQLLicKey   := edtWGEKey.Text; // P.SQL v8 licence string (C/s + WGE)
      licPSQLWGEVer   := 1;              // 0=Not Licenced, 1=P.SQL WGE v8,
    End; // If (edtWGEKey.Text <> '')
  End; // With FLicence.ldCDLicence

  FLicence.StartInstaller;
end;

//-------------------------------------------------------------------------

end.

