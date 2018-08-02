unit DownloadFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, StrUtils, LicDets;

type
  TfraDownload = class(TFrame)
    lblTitle: TLabel;
    lblIntro: TLabel;
    lblContinue: TLabel;
    lblInfo: TLabel;
    lblRetryDownload: TLabel;
    procedure lblContinueClick(Sender: TObject);
    procedure lblRetryDownloadClick(Sender: TObject);
  private
    { Private declarations }
    FLicence : TLicenceDetails;
  public
    { Public declarations }
    Procedure DownloadLicence (Licence : TLicenceDetails);
  end;

implementation

{$R *.dfm}

Uses Brand, WizdMsg, {$IFDEF COMP}IRISLicF,{$ENDIF} DateUtils;

//=========================================================================

Procedure TfraDownload.DownloadLicence (Licence : TLicenceDetails);
Var
  ErrStr : ANSIString;
Begin // DownloadLicence
  FLicence := Licence;

  // Update Branding and text - phrasing is depedant on what is happening
  lblTitle.Caption := ANSIReplaceStr(lblTitle.Caption, '<APPTITLE>', Branding.pbProductName);

  // Update screen for download
  lblInfo.Caption := 'Connecting to Licence Server, Please Wait...';
  lblContinue.Visible := False;
  lblRetryDownload.Visible := False;

  Parent.Refresh;

  If FLicence.DownloadLicence (ErrStr) Then
  Begin
    // Wahey - move to next phase
    lblInfo.Caption := 'Download Successful';
    lblInfo.Hint := '';

    // Success - got to Display Details
    PostMessage ((Owner As TForm).Handle, WM_UpdateMode, 0, Ord(amDisplayDets))
  End // If FLicence.DownloadLicence
  Else
  Begin
    // Tits-Up - go manual
    lblInfo.Caption := 'Connection Failed, Please enter your licence manually';
    lblInfo.Hint := ErrStr;

    {$IFDEF COMP}
      // Licence Update wizard off MCM
      With (Owner As TfrmIRISLicence) Do
      Begin
        BackBtn.Caption := 'Retry';
        BackBtn.OnClick := lblRetryDownload.OnClick;
        BackBtn.Visible := True;

        NextBtn.Caption := 'Manual';
        NextBtn.OnClick := lblContinue.OnClick;
        NextBtn.Visible := True;
      End; // With (Owner As TfrmIRISLicence)
    {$ELSE} // COMP
      // IAO CD Autorun
      lblContinue.Caption := 'Manual Licence';
      lblContinue.Visible := True;

      lblRetryDownload.Visible := True;
    {$ENDIF} // COMP
  End; // Else
End; // DownloadLicence

//-------------------------------------------------------------------------

procedure TfraDownload.lblRetryDownloadClick(Sender: TObject);
begin
  DownloadLicence (FLicence);
end;

//-------------------------------------------------------------------------

procedure TfraDownload.lblContinueClick(Sender: TObject);
begin
  // Failed - go to manual entry
  PostMessage ((Owner As TForm).Handle, WM_UpdateMode, 0, Ord(amManual1))
end;

//-------------------------------------------------------------------------

end.
