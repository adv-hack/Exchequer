unit InstallFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, StrUtils, LicDets, Mask;

type
  TfraInstall = class(TFrame)
    lblTitle: TLabel;
    lblIntro: TLabel;
    radDownload: TRadioButton;
    Label6: TLabel;
    radManual: TRadioButton;
    lblBackToOptions: TLabel;
    lblCDKey: TLabel;
    Label2: TLabel;
    lblContinue: TLabel;
    edtCDKey: TMaskEdit;
    Label1: TLabel;
    procedure DoCheckyChecky(Sender: TObject);
    procedure lblContinueClick(Sender: TObject);
    procedure DownloadClick(Sender: TObject);
    procedure ManualClick(Sender: TObject);
    procedure lblBackToOptionsClick(Sender: TObject);
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

Uses Brand, WizdMsg, Math;

//=========================================================================

procedure TfraInstall.Loaded;
Begin // Loaded
  Inherited;
End; // Loaded

//-------------------------------------------------------------------------

Procedure TfraInstall.InitLicence (Licence : TLicenceDetails);
Begin // InitLicence
  FLicence := Licence;

  // Update Branding
  Case FLicence.ldMode Of
    lmInstall : Begin
                  lblTitle.Caption := 'Install ' + Branding.pbProductName;
                  lblIntro.Caption := ANSIReplaceStr(lblIntro.Caption, '<TYPE>', 'install');
                  lblIntro.Caption := ANSIReplaceStr(lblIntro.Caption, '<APPTITLE>', Branding.pbProductName);
                End; // lmInstall
    lmUpgrade : Begin
                  {$IFDEF COMP}
                    // Licence Update wizard off MCM
                    lblBackToOptions.Visible := False;
                    lblContinue.Visible := False;

                    lblTitle.Caption := 'Update ' + Branding.pbProductName + ' Licence';
                    lblIntro.Caption := 'This wizard allows you to update your ' + Branding.pbProductName + ' licence, please select the method:-';
                  {$ELSE} // COMP
                    // IAO CD Autorun
                    lblTitle.Caption := 'Upgrade ' + Branding.pbProductName;
                    lblIntro.Caption := ANSIReplaceStr(lblIntro.Caption, '<TYPE>', 'upgrade');
                    lblIntro.Caption := ANSIReplaceStr(lblIntro.Caption, '<APPTITLE>', Branding.pbProductName);
                  {$ENDIF} // COMP
                End; // lmUpgrade
  Else
    Raise Exception.Create('TfraInstall.InitLicence: Unhandled Mode (' + IntToStr(Ord(FLicence.ldMode)) + ')');
  End; // Case FLicence.ldMode

  DoCheckyChecky(Self);

  edtCDKey.Text := FLicence.ldCDKey;
End; // InitLicence

//-------------------------------------------------------------------------

procedure TfraInstall.DoCheckyChecky(Sender: TObject);
Var
  GopherIt : Boolean;
Begin // DoCheckyChecky
  // CD-Key field only available when Download option is selected
  edtCDKey.Enabled := radDownload.Checked;
  edtCDKey.Color := IfThen (edtCDKey.Enabled, clWindow, (Owner As TForm).Color);
  lblCDKey.Font.Color := IfThen (edtCDKey.Enabled, clWindowText, clGrayText);
  //lblCDKeyExample.Font.Color := IfThen (edtCDKey.Enabled, clWindowText, clGrayText);

  // If Download option is selected then can only continue with a valid CD-Key
  If radDownload.Checked Then
  Begin
{ TODO : implement correct CD-Key validation }
    GopherIt := (Trim(edtCDKey.Text) <> '');
  End // If radDownload.Checked
  Else
    GopherIt := True;

  lblContinue.Font.Color := IfThen (GopherIt, clBlue, clGray);
End; // DoCheckyChecky

//-------------------------------------------------------------------------

procedure TfraInstall.lblContinueClick(Sender: TObject);
begin
  FLicence.ldCDKey := edtCDKey.Text;

  If radDownload.Checked Then
  Begin
    // Download licence - check it decrypts OK before continueing
    If (FLicence.ldIRISLicence.CustomerNumber <> '0') And (FLicence.ldIRISLicence.Components.Count > 0) Then
    Begin
      PostMessage ((Owner As TForm).Handle, WM_UpdateMode, 0, Ord(amDownload));
    End // If (FLicence.ldIRISLicence.CustomerNumber <> '0') And (FLicence.ldIRISLicence.Components.Count > 0)
    Else
    Begin
      MessageDlg ('The specified CD-Key is not valid, please check that you have entered it correctly', mtWarning, [mbOK], 0);
      If edtCDKey.CanFocus Then edtCDKey.SetFocus;
    End; // Else
  End // If radDownload.Checked
  Else If radManual.Checked Then
  Begin
    // Manual Entry
    PostMessage ((Owner As TForm).Handle, WM_UpdateMode, 0, Ord(amManual1));
  End // If radManual.Checked
  Else
    // WTF?
    Raise Exception.Create ('Unexpected WTF In TfraInstall.lblContinueClick');
end;

//-------------------------------------------------------------------------

procedure TfraInstall.DownloadClick(Sender: TObject);
begin
  radDownload.Checked := True;
end;

//------------------------------

procedure TfraInstall.ManualClick(Sender: TObject);
begin
  radManual.Checked := True;
end;

//-------------------------------------------------------------------------

procedure TfraInstall.lblBackToOptionsClick(Sender: TObject);
begin
  PostMessage ((Owner As TForm).Handle, WM_UpdateMode, 0, Ord(amOptions));
end;

end.
