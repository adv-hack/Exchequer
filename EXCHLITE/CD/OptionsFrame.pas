unit OptionsFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, StrUtils, LicDets;

type
  TfraOptions = class(TFrame)
    Label1: TLabel;
    lblIntro: TLabel;
    Label2: TLabel;
    Label6: TLabel;
    lblInstallDemo: TLabel;
    Label3: TLabel;
    Label9: TLabel;
    lblInstallLITE: TLabel;
    Label4: TLabel;
    Label10: TLabel;
    lblUpgradeLITE: TLabel;
    procedure lblInstallDemoClick(Sender: TObject);
    procedure lblInstallLITEClick(Sender: TObject);
    procedure lblUpgradeLITEClick(Sender: TObject);
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

Uses Brand, WizdMsg, PervInfo;

//=========================================================================

procedure TfraOptions.Loaded;
Begin // Loaded
  Inherited;

  // Update Branding
  lblIntro.Caption := ANSIReplaceStr(lblIntro.Caption, '<APPTITLE>', Branding.pbProductName);
  Label2.Caption := ANSIReplaceStr(Label2.Caption, '<APPTITLE>', Branding.pbProductName);
  Label6.Caption := ANSIReplaceStr(Label6.Caption, '<APPTITLE>', Branding.pbProductName);
  Label3.Caption := ANSIReplaceStr(Label3.Caption, '<APPTITLE>', Branding.pbProductName);
  Label9.Caption := ANSIReplaceStr(Label9.Caption, '<APPTITLE>', Branding.pbProductName);
  Label4.Caption := ANSIReplaceStr(Label4.Caption, '<APPTITLE>', Branding.pbProductName);
  Label10.Caption := ANSIReplaceStr(Label10.Caption, '<APPTITLE>', Branding.pbProductName);
End; // Loaded

//-------------------------------------------------------------------------

Procedure TfraOptions.InitLicence (Licence : TLicenceDetails);
Begin // InitLicence
  FLicence := Licence;
End; // InitLicence

//-------------------------------------------------------------------------

// Install a demo version of LITE
procedure TfraOptions.lblInstallDemoClick(Sender: TObject);
begin
  // Create a standard demo licence
  FLicence.ldMode := lmDemo;

  //FLicence.StartInstaller;
  PostMessage ((Owner As TForm).Handle, WM_UpdateMode, 0, Ord(amDisplayDets));
end;

//-------------------------------------------------------------------------

procedure TfraOptions.lblInstallLITEClick(Sender: TObject);
begin
  FLicence.ldMode := lmInstall;
  PostMessage ((Owner As TForm).Handle, WM_UpdateMode, 0, Ord(amInstall));
end;

//-------------------------------------------------------------------------

procedure TfraOptions.lblUpgradeLITEClick(Sender: TObject);
begin
  FLicence.ldMode := lmUpgrade;
  PostMessage ((Owner As TForm).Handle, WM_UpdateMode, 0, Ord(amUpgrade));
end;

//-------------------------------------------------------------------------

end.
