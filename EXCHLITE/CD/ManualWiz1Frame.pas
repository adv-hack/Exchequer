unit ManualWiz1Frame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, StrUtils, LicDets, Menus, ComCtrls, Math, Mask;

type
  TfraManualWiz1 = class(TFrame)
    lblTitle: TLabel;
    lblIntro: TLabel;
    lblNext: TLabel;
    lblCDKey: TLabel;
    meCDKey: TMaskEdit;
    Label6: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edtLicenceCode: TEdit;
    procedure lblNextClick(Sender: TObject);
  private
    { Private declarations }
    FLicence : TLicenceDetails;
  public
    { Public declarations }
    Procedure InitLicence (Licence : TLicenceDetails);
  end;

implementation

{$R *.dfm}

Uses Brand, IniFiles, WizdMsg, DebugU, LicRec, LicFuncU;

//=========================================================================

Procedure TfraManualWiz1.InitLicence (Licence : TLicenceDetails);
Begin // InitLicence
  FLicence := Licence;

  {$IFDEF COMP}
    // Licence Update wizard off MCM
    lblNext.Visible := False;
  {$ENDIF} // COMP

  // Default manual details based on supplied licence
  meCDKey.EditText := StringReplace(FLicence.ldCDKey, ' ', '_', [rfReplaceAll]);

  If (FLicence.ldIRISLicence.LicenceCodes.Count > 0) Then
  Begin
    edtLicenceCode.Text := FLicence.ldIRISLicence.LicenceCodes[0].LicenceCode;
  End; // If (FLicence.ldIRISLicence.LicenceCodes.Count > 0)
End; // InitLicence

//-------------------------------------------------------------------------

procedure TfraManualWiz1.lblNextClick(Sender: TObject);
begin
  // Update Licencing object with CD-Key and check the components to indicate success
  // NOTE: Setting the CD-Key only clears out any previously loaded licence codes, restrictions, etc... if changed
  FLicence.ldCDKey := meCDKey.EditText;
  If (FLicence.ldIRISLicence.Components.Count > 0) Then
  Begin
    // Clear out any existing licencing details
    FLicence.ldIRISLicence.LicenceCodes.Clear;

    If (Trim(edtLicenceCode.Text) <> '') Then
    Begin
      // Copy in the Licence Key - if valid this will be decoded and generate licence restrictions
      FLicence.ldIRISLicence.LicenceCodes.Add(Trim(edtLicenceCode.Text));
      If (FLicence.ldIRISLicence.LicenceRestrictions.Count > 0) Then
      Begin
        PostMessage ((Owner As TForm).Handle, WM_UpdateMode, 0, Ord(amManual2));
      End // If (FLicence.ldIRISLicence.LicenceRestrictions.Count > 0)
      Else
      Begin
        MessageDlg ('The specified Licence is not valid, please check that you have entered it correctly', mtError, [mbOK], 0);
        If edtLicenceCode.CanFocus Then edtLicenceCode.SetFocus;
      End; // Else
    End // If (lstLicenceCodes.Count > 0)
    Else
    Begin
      MessageDlg ('The Licence Code must be entered', mtError, [mbOK], 0);
      If edtLicenceCode.CanFocus Then edtLicenceCode.SetFocus;
    End; // Else
  End // If (FLicence.ldIRISLicence.Components.Count > 0)
  Else
  Begin
    MessageDlg ('The specified CD-Key is not valid, please check that you have entered it correctly', mtError, [mbOK], 0);
    If meCDKey.CanFocus Then meCDKey.SetFocus;
  End; // Else
end;

//-------------------------------------------------------------------------

end.

