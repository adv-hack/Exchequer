unit UpgradeFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, StrUtils, LicDets, Registry, EntLicence;

type
  TfraUpgrade = class(TFrame)
    lblTitle: TLabel;
    lblIntro: TLabel;
    Label17: TLabel;
    panFound: TPanel;
    lblFound: TLabel;
    lblFoundDir: TLabel;
    panNotFound: TPanel;
    lblNotFound: TLabel;
    lblFindLITEDir: TLabel;
    lblBackToOptions: TLabel;
    lblBackToOptions2: TLabel;
    lblUpgrade: TLabel;
    procedure lblBackToOptionsClick(Sender: TObject);
    procedure lblFindLITEDirClick(Sender: TObject);
    procedure lblUpgradeClick(Sender: TObject);
  private
    { Private declarations }
    FLicence : TLicenceDetails;
    FExchLicence : TEnterpriseLicence;
  protected
    Procedure Loaded; Override;
  public
    { Public declarations }
    Destructor Destroy; Override;
    Procedure InitLicence (Licence : TLicenceDetails);
  end;

implementation

{$R *.dfm}

Uses Brand, WizdMsg, DateUtils, BrowseF, LicFuncU;

//=========================================================================

procedure TfraUpgrade.Loaded;
Begin // Loaded
  Inherited;

  FExchLicence := NIL;

  // Update Branding
  lblTitle.Caption := ANSIReplaceStr(lblTitle.Caption, '<APPTITLE>', Branding.pbProductName);
  lblIntro.Caption := ANSIReplaceStr(lblIntro.Caption, '<APPTITLE>', Branding.pbProductName);
  lblFound.Caption := ANSIReplaceStr(lblFound.Caption, '<APPTITLE>', Branding.pbProductName);
  lblNotFound.Caption := ANSIReplaceStr(lblNotFound.Caption, '<APPTITLE>', Branding.pbProductName);
End; // Loaded

//------------------------------

Destructor TfraUpgrade.Destroy;
Begin // Destroy
  FreeAndNIL(FExchLicence);

  Inherited Destroy;
End; // Destroy

//-------------------------------------------------------------------------

Procedure TfraUpgrade.InitLicence (Licence : TLicenceDetails);
Var
  oReg            : TRegistry;
  LITEDir, TmpStr : ShortString;
Begin // InitLicence
  FLicence := Licence;

  LITEDir := '';

  // Use the path of the registered OLE Server to find the registered Exch/LITE dir
  oReg := TRegistry.Create;
  Try
    oReg.Access := KEY_READ;
    oReg.RootKey := HKEY_CLASSES_ROOT;

    // Open the OLE Server CLSID key to get the GUID to lookup in the
    // CLSID section - safer than hard-coding the GUID in the code
    If oReg.OpenKey('Enterprise.OLEServer\Clsid', False) Then
    Begin
      // Read CLSID stored in default entry }
      TmpStr := oReg.ReadString ('');
      oReg.CloseKey;

      // Got CLSID - find entry in CLSID Section and check for registered .EXE }
      If oReg.OpenKey('Clsid\'+TmpStr+'\LocalServer32', False) Then
      Begin
        // Get path of registered OLE Server .Exe
        TmpStr := oReg.ReadString ('');

        // Check the OLE Server actually exists and return the path if OK
        If FileExists (TmpStr) Then
        Begin
          LITEDir := ExtractFilePath(TmpStr);
        End; // If FileExists (TmpStr)

        oReg.CloseKey;
      End; // If oReg.OpenKey('Clsid\'+TmpStr+'\LocalServer32', False)
    End; // If oReg.OpenKey('Enterprise.OLEServer\Clsid', False)
  Finally
    FreeAndNIL(oReg);
  End; // Try..Finally

  If (LITEDir <> '') Then
  Begin
    Try
      // Check it is LITE and not Exchequer - don't want to accidentally downgrade Exchequer
      FExchLicence := EnterpriseLicenceFromDir (LITEDir);
      If (FExchLicence.elProductType In [ptLITECust, ptLITEAcct]) Then
      Begin
        panFound.Visible := True;
        lblFoundDir.Caption := LITEDir;
      End // If (FExchLicence.elProductType In [ptLITECust, ptLITEAcct])
      Else
      Begin
        // Not a valid LITE Install
        panNotFound.Visible := True;
        FreeAndNIL(FExchLicence);
      End; // Else
    Except
      On Exception Do
      Begin
        // Error reading licence
        panNotFound.Visible := True;
        FreeAndNIL(FExchLicence);
      End; // On Exception
    End; // Try..ExceptTry
  End // If (LITEDir <> '')
  Else
  Begin
    // OLE Not Registered
    panNotFound.Visible := True;
  End; // Else
End; // InitLicence

//-------------------------------------------------------------------------

procedure TfraUpgrade.lblBackToOptionsClick(Sender: TObject);
begin
  PostMessage ((Owner As TForm).Handle, WM_UpdateMode, 0, Ord(amOptions));
end;

//-------------------------------------------------------------------------

procedure TfraUpgrade.lblFindLITEDirClick(Sender: TObject);
var
  frmBrowseForLITE: TfrmBrowseForLITE;
begin
  frmBrowseForLITE := TfrmBrowseForLITE.Create(Self);
  Try
    frmBrowseForLITE.Licence := FExchLicence;
    If (frmBrowseForLITE.ShowModal = mrOK) Then
    Begin
      panNotFound.Visible := False;
      panFound.Visible := True;
      lblFoundDir.Caption := frmBrowseForLITE.Directory;
      FExchLicence := frmBrowseForLITE.Licence;
    End; // If (frmBrowseForLITE.ShowModal = mrOK)
  Finally
    FreeAndNIL(frmBrowseForLITE);
  End; // Try..Finally
end;

//-------------------------------------------------------------------------

procedure TfraUpgrade.lblUpgradeClick(Sender: TObject);
begin
  // Read licence from identified dir to get previous licence details and
  // the CD-Key which are needed to contact the licencing service and then
  // generate a valid Upgrade licence
  If Assigned(FExchLicence) Then
  Begin
    // Copy the existing licencing details into the Auto-Run licencing details object
    FLicence.ImportExchequerLicence(FExchLicence.elLicence);

    // Copy the directory into the Licencing Object, this is then passed into the
    // installer as a command line parameter - /UD:xxxxx in shortname format
    FLicence.ldUpgradePath := lblFoundDir.Caption;

    // Try the web-service to get updated licencing information
    PostMessage ((Owner As TForm).Handle, WM_UpdateMode, 0, Ord(amInstall));
  End // If Assigned(FExchLicence)
  Else
    ShowMessage ('Wot No Licence');
end;

//-------------------------------------------------------------------------

end.
