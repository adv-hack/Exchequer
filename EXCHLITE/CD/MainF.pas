unit MainF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, LicDets, OSChecks, PreReqs, WizdMsg;

Type
  TfrmAutorun = class(TForm)
    Image1: TImage;
    lblCopyright: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FMode : TAutoRunMode;
    FModeFrame : TFrame;
    FLicence : TLicenceDetails;
    FOSChecks : TOSChecks;
    FPreRequisits : TPreRequisites;
    FIgnoreBtrieve615Warning : Boolean;
    FCheckListShown : Boolean;

    Procedure SetMode (Value : TAutoRunMode);

    Procedure WMUpdateMode (Var Message : TMessage); Message WM_UpdateMode;
    Procedure WMRestartChecks (Var Message : TMessage); Message WM_RestartChecks;
  public
    { Public declarations }
    Property IgnoreBtrieve615Warning : Boolean Read FIgnoreBtrieve615Warning Write FIgnoreBtrieve615Warning;
    Property CheckListShown : Boolean Read FCheckListShown Write FCheckListShown;
    Property Mode : TAutoRunMode Read FMode Write SetMode;

    Procedure ProcessStartupChecks;
  end;

var
  frmAutorun: TfrmAutorun;

implementation

{$R *.dfm}
{$R WinXPMan.Res}

Uses Brand, PreReqsFrame, OptionsFrame, InstallFrame, DownloadFrame, OSErrorFrame,
     UpgradeFrame, DisplayDetailsFrame, ManualWiz1Frame, ManualWiz2Frame,
     ManualWiz3Frame, InstallPervFrame, PervWarningFrame, PervInfo, InstallXMLFrame,
     InstallILicFrame, Btrieve615Frame, InstallBtr615Frame, CheckListFrame;

//=========================================================================

procedure TfrmAutorun.FormCreate(Sender: TObject);
begin
  // Redirect the branding directory to the 'x86\Lib' directory to prevent duplication
  InitBranding (ExtractFilePath(Application.ExeName) + 'x86\Lib');

  Application.Title := Branding.pbProductName + ' Installation CD';
  //Application.Icon := Branding.pbProductIcon;
  Caption := Application.Title;
  lblCopyright.Caption := Branding.pbCopyright;

  Application.HelpFile := ExtractFilePath(Application.ExeName) + 'Setup.Chm';

  FIgnoreBtrieve615Warning := False;
  FCheckListShown := False;

  FLicence := TLicenceDetails.Create;
  FOSChecks := TOSChecks.Create;
  FPreRequisits := TPreRequisites.Create(prcNetwork);

  ProcessStartupChecks;
End;

//------------------------------

procedure TfrmAutorun.FormDestroy(Sender: TObject);
begin
  FreeAndNIL(FLicence);
  FreeAndNIL(FOSChecks);
  FreeAndNIL(FPreRequisits);
end;

//-------------------------------------------------------------------------

Procedure TfrmAutorun.ProcessStartupChecks;
Begin // ProcessStartupChecks
  If FOSChecks.ocSupportedOS Then
  Begin
    If (Not FCheckListShown) Then
      Mode := amCheckList
    Else
    Begin
      If FPreRequisits.AllChecksPassed Then
        Mode := amOptions
      Else
      Begin
        // MH 01/06/06: Modified to warn user about pre-existing pervasive components
        // MH 26/07/06: Modified to separate out Btrieve v6.15 and offer the Pre-Installer
        If (FPreRequisits.PreReqStatus[priPSQLWGE] <> prsInstalled) Then
        Begin
          // Btrieve 6.15 found and the Pre-Installer hasn't been used
          If (PervasiveInfo.BtrieveInstalled And (Not Btrieve615Info.GotBtr615BackDoor)) And (Not FIgnoreBtrieve615Warning) Then
          Begin
            // Display Btrieve v6.15 warning dialog
            Mode := amBtr615Warning;
          End // If (PervasiveInfo.BtrieveInstalled And (Not Btrieve615Info.GotBtr615BackDoor))
          Else
          Begin
            // Pervasive.SQL Workgroup Engine not installed or of an older version
            // NOTE: Duplicated in x:\entrprse\setup\iaoprereqf.pas
            If PervasiveInfo.ClientInstalled Or PervasiveInfo.ServerInstalled Or PervasiveInfo.WorkgroupInstalled Then
              Mode := amPervWarning
            Else
              Mode := amPreReqs;
          End; // Else
        End // If (FPreRequisits.PreReqStatus[priPSQLWGE] <> prsInstalled)
        Else
          Mode := amPreReqs;
      End; // Else
    End; // Else
  End // If FOSChecks.SupportedOS
  Else
  Begin
    // OS Not supported
    Mode := amOSError;
  End; // Else
End; // ProcessStartupChecks

//------------------------------

// Custom message handler called from the Btrieve v6.15 warning dialog to restart the
// startup OS, Btrieve and Pre-Req checks
Procedure TfrmAutorun.WMRestartChecks (Var Message : TMessage);
Begin // WMRestartChecks
  Case Message.WParam Of
    0 : Begin
          FPreRequisits.CheckPreReqs;
          IgnoreBtrieve615Warning := (Message.LParam = 1);
          ProcessStartupChecks;
        End; // 0 - Btrieve v6.15
    1 : Begin
          CheckListShown := True;
          ProcessStartupChecks;
        End; // 1 - Check List
  End; // Case Message.WParam
End; // WMRestartChecks

//-------------------------------------------------------------------------

// Custom message handler for WM_UpdateMode custom message, this is called
// to change the mode between different frames.
Procedure TfrmAutorun.WMUpdateMode (Var Message : TMessage);
Begin // WMUpdateMode
  Mode := TAutoRunMode(Message.LParam);
End; // WMUpdateMode

//------------------------------

Procedure TfrmAutorun.SetMode (Value : TAutoRunMode);
Const
  frmTop = 100;
  frmLeft = 0;
Begin // SetMode
  If (Value <> FMode) Then
  Begin
    FMode := Value;

    // Remove any previous frame
    If Assigned(FModeFrame) Then
    Begin
      FreeAndNIL(FModeFrame);
    End; // If Assigned(FModeFrame)

    lblCopyright.Visible := True;

    // Create and initialise the appropriate frame to display
    Case FMode Of
      // Pre-Installlation Check List
      amChecklist     : Begin
                          FModeFrame := TfraCheckList.Create(Self);
                          With (FModeFrame As TfraCheckList) Do
                          Begin
                            Parent := Self;
                            Top := frmTop + 2;
                            Left := frmLeft;
                          End; // With (FModeFrame As TfraCheckList)
                          lblCopyright.Visible := False;
                        End;

      // Btrieve v6.15 Warning
      amBtr615Warning : Begin
                          FModeFrame := TfraBtrieve615.Create(Self);
                          With (FModeFrame As TfraBtrieve615) Do
                          Begin
                            Parent := Self;
                            Top := frmTop;
                            Left := frmLeft;
                          End; // With (FModeFrame As TfraBtrieve615)
                        End;

      // Pre-Existing Pervasive.SQL Warning
      amPervWarning : Begin
                        FModeFrame := TfraPervasiveWarning.Create(Self);
                        With (FModeFrame As TfraPervasiveWarning) Do
                        Begin
                          Parent := Self;
                          Top := frmTop;
                          Left := frmLeft;

                          Init;
                        End; // With (FModeFrame As TfraPervasiveWarning)
                      End;

      // Pre-Requisites
      amPreReqs     : Begin
                        FModeFrame := TfraPreReqs.Create(Self);
                        With (FModeFrame As TfraPreReqs) Do
                        Begin
                          Parent := Self;
                          Top := frmTop;
                          Left := frmLeft;

                          InitPreReqs (FPreRequisits);
                        End; // With (FModeFrame As TfraPreReqs)
                      End; // amPreReqs

      // Demo / Install / Upgrade
      amOptions     : Begin
                        // Startup the IRIS Licencing COM Object - cannot do until the pre-reqs are in place
                        If FLicence.InitIRISLicencing Then
                        Begin
                          FModeFrame := TfraOptions.Create(Self);
                          With (FModeFrame As TfraOptions) Do
                          Begin
                            Parent := Self;
                            Top := frmTop;
                            Left := frmLeft;

                            InitLicence(FLicence);
                          End; // With (FModeFrame As TfraOptions)
                        End // If FLicence.InitIRISLicencing
                        Else
                        Begin
                          MessageDlg('The CD Auto-Run is unable to connect to the local IRIS Licencing sub-system and ' +
                                     'cannot install the software, please contact your Technical Support', mtError, [mbOK], 0);
                          Application.Terminate;
                        End; // Else
                      End; // amOptions

      // Install Lite
      amInstall     : Begin
                        FModeFrame := TfraInstall.Create(Self);
                        With (FModeFrame As TfraInstall) Do
                        Begin
                          Parent := Self;
                          Top := frmTop;
                          Left := frmLeft;

                          InitLicence(FLicence);

                          Self.ActiveControl := edtCDKey;
                        End; // With (FModeFrame As TfraInstall)
                      End; // amInstall

      // Download Licence
      amDownload    : Begin
                        FModeFrame := TfraDownload.Create(Self);
                        With (FModeFrame As TfraDownload) Do
                        Begin
                          Parent := Self;
                          Top := frmTop;
                          Left := frmLeft;

                          DownloadLicence(FLicence);
                        End; // With (FModeFrame As TfraDownload)
                      End; // amDownload

      // Upgrade Existing Installation
      amUpgrade     : Begin
                        FModeFrame := TfraUpgrade.Create(Self);
                        With (FModeFrame As TfraUpgrade) Do
                        Begin
                          Parent := Self;
                          Top := frmTop;
                          Left := frmLeft;

                          InitLicence(FLicence);
                        End; // With (FModeFrame As TfraUpgrade)
                      End; // amUpgrade

      // Display licence details before installing/upgrading
      amDisplayDets : Begin
                        FModeFrame := TfraDisplaysDets.Create(Self);
                        With (FModeFrame As TfraDisplaysDets) Do
                        Begin
                          Parent := Self;
                          Top := frmTop;
                          Left := frmLeft;

                          InitLicence(FLicence);
                        End; // With (FModeFrame As TfraDisplaysDets)
                      End; // amDisplayDets

      // Install PErvasive.SQL Workgroup Engine
      amInstallPerv : Begin
                        FModeFrame := TfraInstallPerv.Create(Self);
                        With (FModeFrame As TfraInstallPerv) Do
                        Begin
                          Parent := Self;
                          Top := frmTop;
                          Left := frmLeft;

                          InitLicence(FLicence, FPreRequisits);
                        End; // With (FModeFrame As TfraInstallPerv)
                      End; // amInstallPerv

      // Install Microsoft XML Core Services 4.0 SP2
      amInstallXML  : Begin
                        FModeFrame := TfraInstallXML.Create(Self);
                        With (FModeFrame As TfraInstallXML) Do
                        Begin
                          Parent := Self;
                          Top := frmTop;
                          Left := frmLeft;

                          InitLicence(FLicence, FPreRequisits);
                        End; // With (FModeFrame As TfraInstallXML)
                      End; // amInstallXML

      // Install IRIS Licencing
      amInstallLic  : Begin
                        FModeFrame := TfraInstallIRISLic.Create(Self);
                        With (FModeFrame As TfraInstallIRISLic) Do
                        Begin
                          Parent := Self;
                          Top := frmTop;
                          Left := frmLeft;

                          InitLicence(FLicence, FPreRequisits);
                        End; // With (FModeFrame As TfraInstallIRISLic)
                      End; // amInstallLic

      amInstallBtr615 : Begin
                          FModeFrame := TfraInstallBtrieve615.Create(Self);
                          With (FModeFrame As TfraInstallBtrieve615) Do
                          Begin
                            Parent := Self;
                            Top := frmTop;
                            Left := frmLeft;

                            Init;
                          End; // With (FModeFrame As TfraInstallBtrieve615)
                        End; // amInstallBtr615

      // Manual Licence Entry Wizard - CD-Key & Licence Codes
      amManual1     : Begin
                        FModeFrame := TfraManualWiz1.Create(Self);
                        With (FModeFrame As TfraManualWiz1) Do
                        Begin
                          Parent := Self;
                          Top := frmTop;
                          Left := frmLeft;

                          InitLicence(FLicence);

                          Self.ActiveControl := meCDKey;
                        End; // With (FModeFrame As TfraManualWiz1)
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

                          Self.ActiveControl := edtCompanyName;
                        End; // With (FModeFrame As TfraManualWiz2)
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

                          Self.ActiveControl := edtUserCount;
                        End; // With (FModeFrame As TfraManualWiz3)
                      End; // amManual3

      // OS Not Supported
      amOSError     : Begin
                        FModeFrame := TfraOSError.Create(Self);
                        With (FModeFrame As TfraOSError) Do
                        Begin
                          Parent := Self;
                          Top := frmTop;
                          Left := frmLeft;

                          InitOSInfo (FOSChecks);
                        End; // With (FModeFrame As TfraOSError)
                      End; // amPreReqs
    Else
      Raise Exception.Create ('TfrmAutorun.SetMode: Unknown Mode (' + IntToStr(Ord(FMode)) + ')');
    End; // Case FMode

    // MH 06/06/06: Copy in Help Context Id's from frame
    If Assigned(FModeFrame) Then
      Self.HelpContext := (FModeFrame As TFrame).HelpContext
    Else
      Self.HelpContext := 0;
  End; // If (Value <> FMode)
End; // SetMode

//-------------------------------------------------------------------------

end.
