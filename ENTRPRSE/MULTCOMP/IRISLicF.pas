unit IRISLicF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SETUPBAS, ExtCtrls, StdCtrls, WizdMsg, LicDets;

type
  TfrmIRISLicence = class(TSetupTemplate)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ExitBtnClick(Sender: TObject);
  private
    FMode : TAutoRunMode;
    FModeFrame : TFrame;
    FLicence : TLicenceDetails;

    Procedure SetMode (Value : TAutoRunMode);
    Procedure WMUpdateMode (Var Message : TMessage); Message WM_UpdateMode;
  public
    Property Mode : TAutoRunMode Read FMode Write SetMode;
  end;

// Displays the IRIS Licence Update Wizard
Procedure UpdateIRISLicence;

implementation

{$R *.dfm}

Uses Brand, EntLicence, InstallFrame, DownloadFrame, DisplayDetailsFrame,
     ManualWiz1Frame, ManualWiz2Frame, ManualWiz3Frame, VAOUtil,
     GlobVar, VarConst, BtrvU2, BTSupU1;

//=========================================================================

Procedure UpdateIRISLicence;
Var
  frmIRISLicence : TfrmIRISLicence;
  iStatus        : SmallInt;
Begin // UpdateIRISLicence
  // open system file for main company and read in the system setup
  iStatus := Open_File(F[SysF], SetDrive + FileNames[SysF], 0);
  If (iStatus = 0) Then
  Begin
    iStatus := Open_File(F[PwrdF], SetDrive + FileNames[PwrdF], 0);
    If (iStatus = 0) Then
    Begin
      Try
        Init_AllSys;

        frmIRISLicence := TfrmIRISLicence.Create(NIL);
        Try
          // Start at CD or Manual screen
          frmIRISLicence.Mode := amInstall;

          // Show the wizard
          frmIRISLicence.ShowModal;
        Finally
          FreeAndNIL(frmIRISLicence);
        End; // Try..Finally
      Finally
        { close system file for main company }
        Close_File(F[SysF]);
        Close_File(F[PwrdF]);
      End;
    End // If (iStatus = 0)
    Else
      Close_File(F[SysF]);
  End; // If (iStatus = 0)
End; // UpdateIRISLicence

//=========================================================================

procedure TfrmIRISLicence.FormCreate(Sender: TObject);
begin
  inherited;

  // Suppress query message on closure of form
  ExitMsg := 255;

  Caption := 'Update ' + Branding.pbProductName + ' Licence';

  // Create the licence details object and import the current licencing information
  FLicence := TLicenceDetails.Create;

  // Startup the IRIS Licencing COM Object
  If FLicence.InitIRISLicencing Then
  Begin
    FLicence.ldMode := lmUpgrade;

    // Get and import the Exchequer Licence
    FLicence.ImportExchequerLicence(EnterpriseLicence.elLicence);

    // Import the IRIS Licencing info
    FLicence.ldUpgradePath := VAOInfo.vaoCompanyDir;
  End // If FLicence.InitIRISLicencing
  Else
  Begin
    MessageDlg('The Licensing Wizard is unable to connect to the local IRIS Licensing sub-system and ' +
               'cannot check the licensing, please contact your Technical Support', mtError, [mbOK], 0);
    Raise Exception.Create ('Unable to connect to IRIS Licensing sub-system');
  End; // Else
end;

//------------------------------

procedure TfrmIRISLicence.FormDestroy(Sender: TObject);
begin
  FreeAndNIL(FLicence);

  inherited;
end;

//-------------------------------------------------------------------------

// Custom message handler for WM_UpdateMode custom message, this is called
// to change the mode between different frames.
Procedure TfrmIRISLicence.WMUpdateMode (Var Message : TMessage);
Begin // WMUpdateMode
  Mode := TAutoRunMode(Message.LParam);
End; // WMUpdateMode

//------------------------------

Procedure TfrmIRISLicence.SetMode (Value : TAutoRunMode);
Const
  frmTop = 10;
  frmLeft = 167;
Begin // SetMode
  If (Value <> FMode) Then
  Begin
    FMode := Value;

    // Remove any previous frame
    If Assigned(FModeFrame) Then
    Begin
      FreeAndNIL(FModeFrame);
    End; // If Assigned(FModeFrame)

    // Create and initialise the appropriate frame to display
    Case FMode Of
      // Install Lite
      amInstall     : Begin
                        FModeFrame := TfraInstall.Create(Self);
                        With (FModeFrame As TfraInstall) Do
                        Begin
                          Parent := Self;
                          Top := frmTop;
                          Left := frmLeft;

                          InitLicence(FLicence);
                        End; // With (FModeFrame As TfraInstall)

                        BackBtn.Visible := False;

                        NextBtn.OnClick := (FModeFrame As TfraInstall).lblContinue.OnClick;
                        NextBtn.Visible := True;

                        Self.HelpContextID := 10;
                      End; // amInstall

      // Download Licence
      amDownload    : Begin
                        // Set buttons before creating the frame as the constructor uses the buttons
                        BackBtn.Visible := False;
                        NextBtn.Visible := False;

                        FModeFrame := TfraDownload.Create(Self);
                        With (FModeFrame As TfraDownload) Do
                        Begin
                          Parent := Self;
                          Top := frmTop;
                          Left := frmLeft;

                          DownloadLicence(FLicence);
                        End; // With (FModeFrame As TfraDownload)

                        Self.HelpContextID := 11;
                      End; // amDownload

      // Update the licence and display updated details
      amDisplayDets : Begin
                        FModeFrame := TfraDisplaysDets.Create(Self);
                        With (FModeFrame As TfraDisplaysDets) Do
                        Begin
                          Parent := Self;
                          Top := frmTop;
                          Left := frmLeft;

                          InitLicence(FLicence);
                        End; // With (FModeFrame As TfraDisplaysDets)

                        BackBtn.Visible := False;

                        NextBtn.Caption := '&Close';
                        NextBtn.ModalResult := mrOK;
                        NextBtn.OnClick := NIL;
                        NextBtn.Visible := True;

                        Self.HelpContextID := 15;
                      End; // amDisplayDets


      // Manual Licence Entry Wizard - CD-Key & Licence Codes
      amManual1     : Begin
                        FModeFrame := TfraManualWiz1.Create(Self);
                        With (FModeFrame As TfraManualWiz1) Do
                        Begin
                          Parent := Self;
                          Top := frmTop;
                          Left := frmLeft;

                          InitLicence(FLicence);
                        End; // With (FModeFrame As TfraManualWiz1)

                        BackBtn.Visible := False;

                        NextBtn.Caption := '&Next >>';
                        NextBtn.OnClick := (FModeFrame As TfraManualWiz1).lblNext.OnClick;
                        NextBtn.Visible := True;

                        Self.HelpContextID := 12;
                      End; // amManual1

      // Manual Licence Entry Wizard - Company Name / Country / Type / Demo|Live
      amManual2     : Begin
                        FModeFrame := TfraManualWiz2.Create(Self);
                        With (FModeFrame As TfraManualWiz2) Do
                        Begin
                          Parent := Self;
                          Top := frmTop;
                          Left := frmLeft;

                          InitLicence(FLicence);
                        End; // With (FModeFrame As TfraManualWiz2)

                        BackBtn.Caption := '<< &Back';
                        BackBtn.OnClick := (FModeFrame As TfraManualWiz2).lblBack.OnClick;
                        BackBtn.Visible := True;

                        NextBtn.Caption := '&Next >>';
                        NextBtn.OnClick := (FModeFrame As TfraManualWiz2).lblNext.OnClick;
                        NextBtn.Visible := True;

                        Self.HelpContextID := 13;
                      End; // amManual2

      // Manual Licence Entry Wizard - User/Company Counts & Pervasive
      amManual3     : Begin
                        FModeFrame := TfraManualWiz3.Create(Self);
                        With (FModeFrame As TfraManualWiz3) Do
                        Begin
                          Parent := Self;
                          Top := frmTop;
                          Left := frmLeft;

                          InitLicence(FLicence);
                        End; // With (FModeFrame As TfraManualWiz3)

                        BackBtn.Caption := '<< &Back';
                        BackBtn.OnClick := (FModeFrame As TfraManualWiz3).lblBack.OnClick;
                        BackBtn.Visible := True;

                        NextBtn.Caption := '&Finish';
                        NextBtn.OnClick := (FModeFrame As TfraManualWiz3).lblFinish.OnClick;
                        NextBtn.Visible := True;

                        Self.HelpContextID := 14;
                      End; // amManual3
    Else
      Raise Exception.Create ('TfrmAutorun.SetMode: Unknown Mode (' + IntToStr(Ord(FMode)) + ')');
    End; // Case FMode
  End; // If (Value <> FMode)
End; // SetMode

//-------------------------------------------------------------------------

procedure TfrmIRISLicence.ExitBtnClick(Sender: TObject);
begin
  //inherited;
  Close;
end;

//-------------------------------------------------------------------------

end.
