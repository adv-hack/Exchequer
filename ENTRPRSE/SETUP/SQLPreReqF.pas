unit SQLPreReqF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  setupbas, StdCtrls, ExtCtrls, SetupU, BorBtns, ComCtrls, SQLPreReqs;

type
  TfrmSQLPreRequisits = class(TSetupTemplate)
    ScrollBox2: TScrollBox;
    panWinInstaller: TPanel;
    lblWinInstallerTitle: TLabel;
    lblWinInstallerText: TLabel;
    lblWinInstallerInstall: TLabel;
    panSQLNCli: TPanel;
    lblSQLNCliTitle: TLabel;
    lblSQLNCliText: TLabel;
    lblSQLNCliInstall: TLabel;
    procedure lblWinInstallerInstallClick(Sender: TObject);
    procedure lblSQLNCliInstallClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FPreRequisits : TSQLPreRequisites;
    FCDRoot : ANSIString;
    Procedure SetPreRequisits(Value : TSQLPreRequisites);

    // Updates the pre-requisites page after running one of the installs
    procedure UpdateStatus;
  public
    Property PreRequisits : TSQLPreRequisites Read FPreRequisits Write SetPreRequisits;
  end;


function SCD_CheckForPreReqs (var DLLParams: ParamRec): LongBool; StdCall; export;

implementation

{$R *.dfm}

Uses Brand, APIUtil, CompUtil, StrUtils, Math, IniFiles, ActiveX;

//=========================================================================

function SCD_CheckForPreReqs (var DLLParams: ParamRec): LongBool;
var
  frmSQLPreRequisits     : TfrmSQLPreRequisits;
  oPreReqs               : TSQLPreRequisites;
  DlgPN, IType, W_Install, WiseStr : String;
  Continue, GotBtr615    : Boolean;
Begin // SCD_CheckForPreReqs
  Result := False;

  { Read Previous/Next instructions from Setup Script }
  GetVariable(DLLParams, 'DLGPREVNEXT', DlgPN);

  // Get Installation Source directory for link to help & Lib\
  GetVariable(DLLParams, 'INST', WiseStr);
  Application.HelpFile := IncludeTrailingPathDelimiter(WiseStr) + 'SETUP.HLP';

  // Get Exchequer/IAO directory for the Pre-Req checks
  GetVariable(DLLParams, 'V_MAINDIR', WiseStr);

  // Check to see if any pre-reqs are required
  oPreReqs := TSQLPreRequisites.Create(prcStandard, WiseStr);
  Try
    If (Not oPreReqs.AllChecksPassed) Then
    Begin
      frmSQLPreRequisits := TfrmSQLPreRequisits.Create(Application);
      Try
        // Get CD Root directory
        GetVariable(DLLParams, 'V_CDROOT', frmSQLPreRequisits.FCDRoot);
        frmSQLPreRequisits.FCDRoot := IncludeTrailingPathDelimiter(frmSQLPreRequisits.FCDRoot);

        // Insert product name into window
        frmSQLPreRequisits.ModifyCaptions ('<APPTITLE>', Branding.pbProductName, [frmSQLPreRequisits.InstrLbl]);

        // pass in details of pre-reqs
        frmSQLPreRequisits.PreRequisits := oPreReqs;

        frmSQLPreRequisits.ShowModal;

        Case frmSQLPreRequisits.ExitCode Of
          'B' : Begin { Back }
                  SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 1, 3));
                End;
          'N' : Begin { Next }
                  SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 4, 3));
                End;
          'X' : Begin { Exit Installation }
                  SetVariable(DLLParams,'DIALOG','999')
                End;
        End; { If }
      Finally
        frmSQLPreRequisits.Free;
      End;
    End // If (Not oPreReqs.AllChecksPassed)
    Else
      // AOK - Move to next page
      SetVariable(DLLParams,'DIALOG',Copy(DlgPN, 4, 3));
  Finally
    oPreReqs.Free;
  End; // Try..Finally
End; // SCD_CheckForPreReqs

//=========================================================================

procedure TfrmSQLPreRequisits.FormCreate(Sender: TObject);
begin
  inherited;

  // Need this for some reason otherwise the automatic branding changes don't happen
end;

//-------------------------------------------------------------------------

Procedure TfrmSQLPreRequisits.SetPreRequisits(Value : TSQLPreRequisites);
Var
  PanelArray : Array[1..2] Of TPanel;
  iPreReq    : SmallInt;
  iNextTop   : SmallInt;
  bGotOne    : Boolean;

  Procedure SetupPanel (Var PreReqPanel : TPanel; Var PreReqTitle, PreReqText, PreReqInstall : TLabel);
  Var
    bDisable : Boolean;
  Begin // SetupPanel
    bDisable := (PreReqPanel.Tag <> 0);
    PreReqTitle.Font.Color := IfThen (bDisable, clWindowText, clGrayText);
    PreReqText.Font.Color := PreReqTitle.Font.Color;
    PreReqInstall.Visible := bDisable;
  End; // SetupPanel

Begin // SetPreRequisits
  FPreRequisits := Value;

  // Build the array of panels for the pre-requisits
  panWinInstaller.Visible := FPreRequisits.PreReqStatus[priWinInstaller] <> prsInstalled;
  PanelArray[1] := panWinInstaller;
  panSQLNCli.Visible := FPreRequisits.PreReqStatus[priSQLNCli] <> prsInstalled;
  PanelArray[2] := panSQLNCli;

  // Configure Scroll-Box Scroll Bar - doesn't work if you set them at Design-Time!
  With ScrollBox2.VertScrollBar Do
  Begin
    Position := 0;
    Tracking := True;
  End; // With ScrollBox2.VertScrollBar

  // Run through the array of pre-req panels enabling them as required and setting
  // up their positions within the scrollbox
  bGotOne := False;
  iNextTop := PanelArray[1].Top;
  For iPreReq := Low(PanelArray) To High(PanelArray) Do
  Begin
    If PanelArray[iPreReq].Visible Then
    Begin
      // Use the tag to mark the first visible panel so that we can disable all the rest to control
      // the installation order
      PanelArray[iPreReq].Tag := IfThen(bGotOne, 0, 1);
      bGotOne := True;

      PanelArray[iPreReq].Left := 0;
      PanelArray[iPreReq].Top := iNextTop;
      PanelArray[iPreReq].BevelOuter := bvNone;
      PanelArray[iPreReq].Color := Self.Color;
      Inc (iNextTop, PanelArray[iPreReq].Height);
    End; // If PanelArray[iPreReq].Visible
  End; // For iPreReq

  // Update Branding

  // Check for dependancies

  // Windows Installer 3.1
  If panWinInstaller.Visible Then
    SetupPanel (panWinInstaller, lblWinInstallerTitle, lblWinInstallerText, lblWinInstallerInstall);

  // MS XML 4.0 SP2
  If panSQLNCli.Visible Then
    SetupPanel (panSQLNCli, lblSQLNCliTitle, lblSQLNCliText, lblSQLNCliInstall);

End; // SetPreRequisits

//-------------------------------------------------------------------------

// Updates the pre-requisites page after running one of the installs
procedure TfrmSQLPreRequisits.UpdateStatus;
Begin // UpdateStatus
  // Redo the Pre-Req checks as we may be able to install now
  FPreRequisits.CheckPreReqs;

  If FPreRequisits.AllChecksPassed Then
  Begin
    // All pre-requisites available - go to next page
    ExitCode := 'N';
    Close;
  End // If FPreRequisits.AllChecksPassed
  Else
    SetPreRequisits (FPreRequisits);
End; // UpdateStatus

//-------------------------------------------------------------------------

procedure TfrmSQLPreRequisits.lblWinInstallerInstallClick(Sender: TObject);
begin
//ShowMessage (FCDRoot + 'PreReqs\WinInst31\WindowsInstaller-KB893803-v2-x86.exe');
  RunApp(FCDRoot + 'PreReqs\WinInst31\WindowsInstaller-KB893803-v2-x86.exe', True);
  UpdateStatus;
end;

//------------------------------

procedure TfrmSQLPreRequisits.lblSQLNCliInstallClick(Sender: TObject);
//Var
//  frmInstallXMLCore : TfrmInstallXMLCore;
begin
//ShowMessage ('MSIEXEC.EXE /I "' + FCDRoot + 'PreReqs\SQLNativeClient\sqlncli.msi" ');
  If IsWow64 Then
    RunApp('MSIEXEC.EXE /I "' + FCDRoot + 'PreReqs\SQLNativeClient\sqlncli_x64.msi" /qb', True)
  Else
    RunApp('MSIEXEC.EXE /I "' + FCDRoot + 'PreReqs\SQLNativeClient\sqlncli.msi" /qb', True);

  UpdateStatus;
end;

//=========================================================================

end.
