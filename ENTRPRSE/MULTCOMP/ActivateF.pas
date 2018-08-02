unit ActivateF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SETUPBAS, StdCtrls, Mask, ExtCtrls, LicRec, LicDets, StrUtils;

type
  TfrmActivateSystem = class(TSetupTemplate)
    lblTitle: TLabel;
    lblIntro: TLabel;
    Label6: TLabel;
    lblCDKey: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    radDownload: TRadioButton;
    radManual: TRadioButton;
    edtCDKey: TMaskEdit;
    edtActivationCode: TEdit;
    lblActivationCode: TLabel;
    lblManualInfo: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure DoCheckyChecky(Sender: TObject);
    procedure BackBtnClick(Sender: TObject);
    procedure NextBtnClick(Sender: TObject);
  private
    { Private declarations }
    FLicence : TLicenceDetails;

  public
    { Public declarations }
  end;

Function IAO_ActivationWizard (Const CompDir, EntDir : ShortString;
                               Const Mode            : Byte;
                               Var   TempLicR        : EntLicenceRecType;
                               Var   SetRelCode      : Byte) : LongInt;

implementation

{$R *.dfm}

Uses Brand, EntLicence, VAOUtil, GlobVar, VarConst, ETDateU, Math,
  oIRISLicence, SecSup2U, ActiveX;

//=========================================================================

Function IAO_ActivationWizard (Const CompDir, EntDir : ShortString;
                               Const Mode            : Byte;
                               Var   TempLicR        : EntLicenceRecType;
                               Var   SetRelCode      : Byte) : LongInt;
var
  frmActivateSystem: TfrmActivateSystem;
Begin { Exchequer_MCM_SECWIZARD }
  Result := 0;

  // Needed when loaded under Exchequer/IAO
  If (Mode = 4) Then CoInitialize(NIL);
  Try
    frmActivateSystem := TfrmActivateSystem.Create(Application.MainForm);
    Try
      If (frmActivateSystem.ShowModal = mrOK) Then
      Begin
        SetRelCode := 1;  // Release Code Updated
      End; // If (frmActivateSystem.ShowModal = mrOK)
    Finally
      frmActivateSystem.Free;
    End; // Try..Finally
  Finally
    // Needed when loaded under Exchequer/IAO
    If (Mode = 4) Then CoUninitialize;
  End; // Try..Finally
End; // IAO_MCM_SECWIZARD

//=========================================================================

procedure TfrmActivateSystem.FormCreate(Sender: TObject);
var
  RelDateStr : LongDate;
  Rd,Rm,Ry   : Word;
  ExpDays    : LongInt;
begin
  inherited;

  // Suppress queries on close
  ExitMsg := 255;

  // Insert product name into window
  Caption := Branding.pbProductName + ' Activation Wizard';
  ModifyCaptions ('<APPTITLE>', Branding.pbProductName, [lblTitle, lblIntro]);

  If Branding.BrandingFileExists(ebfCore) Then
  Begin
    With Branding.pbCoreData Do
    Begin
      ModifyCaptions ('<ACTNAME>', GetString('ActivationName', 'IRIS Software Ltd'), [lblManualInfo]);
      ModifyCaptions ('<ACTPHONE>', GetString('ActivationPhone', '?'), [lblManualInfo]);
    End; // With Branding.pbCoreData
  End; // If Branding.BrandingFileExists(ebfCore)

  // Load in the existing licence to get the CD-Key
  FLicence := TLicenceDetails.Create;

  // Startup the IRIS Licencing COM Object
  If FLicence.InitIRISLicencing Then
  Begin
    FLicence.ldMode := lmUpgrade;

    // Get and import the Exchequer Licence
    FLicence.ImportExchequerLicence(EnterpriseLicence.elLicence);

    // Import the IRIS Licencing info
    FLicence.ldUpgradePath := VAOInfo.vaoCompanyDir;

    // Set the expiry message
    JulCal(Syss.RelDate,Rd,Rm,Ry);
    RelDateStr:=StrDate(Ry,Rm,Rd);
    ExpDays := NoDays(Today,RelDateStr);

    If (Syss.GracePeriod = 0) Then
    Begin
      // Standard Activation / Release Code
      lblIntro.Caption := 'Warning: Your licence ';
      If (ExpDays < 0) Then
        lblIntro.Caption := lblIntro.Caption + 'has expired and this system is in read-only mode.'
      Else If (ExpDays = 0) Then
        lblIntro.Caption := lblIntro.Caption + 'expires tomorrow.'
      Else
        lblIntro.Caption := lblIntro.Caption + 'expires in ' + IntToStr(ExpDays + 1) + ' days.';
    End // If (Syss.GracePeriod = 0)
    Else
    Begin
      // IAO Grace Period
      lblIntro.Caption := 'Warning: Your licence has expired, this system ';
      If (ExpDays < 0) Then
        lblIntro.Caption := lblIntro.Caption + 'is in read-only mode.'  // NOTE: Shouldn't happen as the above section should kick in
      Else If (ExpDays = 0) Then
        lblIntro.Caption := lblIntro.Caption + 'will enter read-only mode tomorrow.'
      Else
        lblIntro.Caption := lblIntro.Caption + 'will enter read-only mode in ' + IntToStr(ExpDays + 1) + ' days.';
    End; // Else

    // Default manual details based on supplied licence
    edtCDKey.EditText := StringReplace(FLicence.ldCDKey, ' ', '_', [rfReplaceAll]);

    DoCheckyChecky(Self);
  End // If FLicence.InitIRISLicencing
  Else
  Begin
    MessageDlg('The Activation Wizard is unable to connect to the local IRIS Licencing sub-system and ' +
               'cannot check the Licencing, please contact your Technical Support', mtError, [mbOK], 0);
    Raise Exception.Create ('Unable to connect to IRIS Licencing sub-system');
  End; // Else
end;

//-------------------------------------------------------------------------

procedure TfrmActivateSystem.DoCheckyChecky(Sender: TObject);
Begin // DoCheckyChecky
  // CD-Key and ACtivation Code fields only available when Manual option is selected
  lblCDKey.Font.Color := IfThen (radManual.Checked, clWindowText, clGrayText);
  edtCDKey.Enabled := radManual.Checked;

  lblActivationCode.Font.Color := lblCDKey.Font.Color;
  edtActivationCode.Enabled := radManual.Checked;
  edtActivationCode.Color := IfThen (edtActivationCode.Enabled, clWindow, clBtnFace);
End; // DoCheckyChecky

//-------------------------------------------------------------------------

// Save
procedure TfrmActivateSystem.BackBtnClick(Sender: TObject);
Var
  sError        : ANSIString;
  tdd, tmm, tyy : Word;
  sActName, sActPhone : ShortString;
begin
  //inherited;

  If radDownload.Checked Then
  Begin
    // Download
    If FLicence.ldIRISLicence.GetActivationKey(sError) Then
    Begin
      edtActivationCode.Text := FLicence.ldIRISLicence.ActivationKey + ' (' + FormatDateTime('DD/MM/YYYY',FLicence.ldIRISLicence.ActivationDate) + ')';

      // Update Expiry Date
      DateStr(FormatDateTime('YYYYMMDD',FLicence.ldIRISLicence.ActivationDate), tdd, tmm, tyy);
      Syss.RelDate := caljul(tdd, tmm, tyy);

      // Set new Security Code and Blank Release Code - probably not necessary - but may as well
      Syss.ExSecurity := Generate_ESN_BaseSecurity (Syss.EXISN, 0, 0, 0);
      Syss.ExRelease := '';

      ModalResult := mrOK;
    End // If FLicence.ldIRISLicence.GetActivationKey(sError)
    Else
    Begin
      // Error
      If Branding.BrandingFileExists(ebfCore) Then
      Begin
        With Branding.pbCoreData Do
        Begin
          sActName := GetString('ActivationName', 'IRIS Software Ltd');
          sActPhone := GetString('ActivationPhone', '0870 243 1956');
        End; // With Branding.pbCoreData Do
      End // If Branding.BrandingFileExists(ebfCore)
      Else
      Begin
        // Defaults if branding is missing
        sActName := 'IRIS Software Ltd';
        sActPhone := '0870 243 1956';
      End; // Else

      MessageDlg ('The system was unable to download a valid Activation Code, please contact ' +
                  sActName + ' on ' + sActPhone + ' to get ' +
                  'an Activation Code', mtInformation, [mbOK], 0);
    End; // Else
  End // If radDownload.Checked
  Else If radManual.Checked Then
  Begin
    // Manual
    If (Trim(edtActivationCode.Text) <> '') Then
    Begin
      If FLicence.ldIRISLicence.DecodeActivationKey(edtActivationCode.Text, sError) Then
      Begin
        // Update Expiry Date
        DateStr(FormatDateTime('YYYYMMDD',FLicence.ldIRISLicence.ActivationDate), tdd, tmm, tyy);
        Syss.RelDate := caljul(tdd, tmm, tyy);

        // Set new Security Code and Blank Release Code - probably not necessary - but may as well
        Syss.ExSecurity := Generate_ESN_BaseSecurity (Syss.EXISN, 0, 0, 0);
        Syss.ExRelease := '';

        ModalResult := mrOK;
      End // If FLicence.ldIRISLicence.DecodeActivationKey(edtActivationCode.Text, sError)
      Else
        // Error
        MessageDlg ('The specified Activation Code is not valid for this installation', mtInformation, [mbOK], 0);
    End // If (Trim(edtActivationCode.Text) <> '')
    Else
    Begin
      // Error
      MessageDlg ('The Activation Code cannot be blank', mtInformation, [mbOK], 0);
      If edtActivationCode.CanFocus Then edtActivationCode.SetFocus;
    End; // Else
  End; // If radManual.Checked
end;

//------------------------------

// Cancel
procedure TfrmActivateSystem.NextBtnClick(Sender: TObject);
begin
  //inherited;

  ModalResult := mrCancel;
end;

//-------------------------------------------------------------------------

end.
