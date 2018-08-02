unit WSCISDBPreReqF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  setupbas, StdCtrls, ExtCtrls, SetupU, BorBtns, ComCtrls, PreReqs;

type
  TCommonPreReqsDlgMode = (prdmCIS, prdmVAT100);

  TfrmWSDashbPreRequisits = class(TSetupTemplate)
    ScrollBox2: TScrollBox;
    panNetFramework: TPanel;
    lblNetFrameworkTitle: TLabel;
    lblNetFrameworkText: TLabel;
    lblNetFrameworkInstall: TLabel;
    panMSXML: TPanel;
    lblMSXMLTitle: TLabel;
    lblMSXMLText: TLabel;
    lblMSXMLInstall: TLabel;
    panFBI: TPanel;
    lblFBITitle: TLabel;
    lblFBIInstall: TLabel;
    lblFBIText: TLabel;
    Label1: TLabel;
    procedure lblNetFrameworkInstallClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lblFBIInstallClick(Sender: TObject);
  private
    { Private declarations }
    FDialogMode : TCommonPreReqsDlgMode;
    FNeedFBI : Boolean;
    FPreRequisits : TPreRequisites;
    Procedure SetDialogMode (Value : TCommonPreReqsDlgMode);
    Procedure SetPreRequisits(Value : TPreRequisites);

    procedure CheckFBI;
    // Updates the pre-requisites page after running one of the installs
    procedure UpdateStatus;
  public
    Property DialogMode : TCommonPreReqsDlgMode Read FDialogMode Write SetDialogMode;
    Property PreRequisits : TPreRequisites Read FPreRequisits Write SetPreRequisits;

    Function NeedShow : Boolean;
  end;

Function SCD_DotNet20Missing (var DLLParams: ParamRec): LongBool; StdCall; export;
Function SCD_VCCRedistMissing (var DLLParams: ParamRec): LongBool; StdCall; export;
function SCD_WorkstationCISDBPreReqs (var DLLParams: ParamRec): LongBool; StdCall; export;

// MH 29/01/2013 v7.1 ABSEXCH-13793: Added Pre-Reqs for VAT 100
function SCD_WorkstationVAT100PreReqs (var DLLParams: ParamRec): LongBool; StdCall; export;

implementation

{$R *.dfm}

Uses Brand, APIUtil, CompUtil, StrUtils, Math, IniFiles, ActiveX,
     DateUtils, Registry, DotNet;

//=========================================================================

Function SCD_DotNet20Missing (var DLLParams: ParamRec): LongBool;
Begin // SCD_DotNet20Missing
  Result := Not DotNetInfo.Net20Installed;
End; // SCD_DotNet20Missing

//=========================================================================

// Returns TRUE if the installer should install the VC++ 2005 SP1 redistributable
Function SCD_VCCRedistMissing (var DLLParams: ParamRec): LongBool;
Const
  KEY_WOW64_64KEY        = $0100;
Begin // SCD_VCCRedistMissing
  Result := True;//Not DotNetInfo.Net20Installed;

  With TRegistry.Create Do
  Begin
    Try
      Access := KEY_QUERY_VALUE Or KEY_ENUMERATE_SUB_KEYS;
      RootKey := HKEY_LOCAL_MACHINE;

      // MH 23/07/08: Added Win64 support
      If IsWow64 Then
      Begin
        // 64-Bit - need to go to 64-bit key, otherwise we will get redirected to the WOW6432 section which doesn't contain the detail
        Access := Access Or KEY_WOW64_64KEY;

        If OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products\84b9c17023c712640acaf308593282f8\InstallProperties', False) Then
        Begin
          If ValueExists('DisplayVersion') Then
          Begin
            Result := (ReadString('DisplayVersion') < '8.0.56336');
          End; // If ValueExists(InstallValue)
        End; // If OpenKey('SOFTWARE\Microsoft\Windows\...
      End // If IsWow64
      Else
      Begin
        // 32-Bit
        If OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products\b25099274a207264182f8181add555d0\InstallProperties', False) Then
        Begin
          If ValueExists('DisplayVersion') Then
          Begin
            Result := (ReadString('DisplayVersion') < '8.0.56336');
          End; // If ValueExists(InstallValue)
        End; // If OpenKey('SOFTWARE\Microsoft\Windows\...
      End; // Else
    Finally
      Free;
    End; // Try..Finally
  End; // With TRegistry.Create
End; // SCD_VCCRedistMissing

//=========================================================================

function DisplayCommonPreReqsDlg (var DLLParams: ParamRec; Const DlgMode : TCommonPreReqsDlgMode): LongBool;
var
  frmDashbPreRequisits   : TfrmWSDashbPreRequisits;
  oPreReqs               : TPreRequisites;
  DlgPN, IType, W_Install, WiseStr : String;
  Continue, GotBtr615    : Boolean;
Begin // DisplayCommonPreReqsDlg
  Result := False;

  // Get Installation Source directory for link to help & Lib\
  GetVariable(DLLParams, 'INST', WiseStr);
  Application.HelpFile := IncludeTrailingPathDelimiter(WiseStr) + 'SETUP.HLP';

  // Get Exchequer/IAO directory for the Pre-Req checks
  GetVariable(DLLParams, 'V_MAINDIR', WiseStr);

  // Check to see if any pre-reqs are required
  oPreReqs := TPreRequisites.Create(prcExchDSR, WiseStr);
  Try
    frmDashbPreRequisits := TfrmWSDashbPreRequisits.Create(Application);
    Try
      // MH 29/01/2013 v7.1 ABSEXCH-13793: Added Pre-Reqs for VAT 100
      frmDashbPreRequisits.DialogMode := DlgMode;

      // pass in details of pre-reqs
      frmDashbPreRequisits.PreRequisits := oPreReqs;

      If frmDashbPreRequisits.NeedShow Then
      Begin
        frmDashbPreRequisits.ShowModal;
        Result := (frmDashbPreRequisits.ExitCode = 'N');
      End // If frmDashbPreRequisits.NeedShow
      Else
        Result := False;
    Finally
      frmDashbPreRequisits.Free;
    End;
  Finally
    oPreReqs.Free;
  End; // Try..Finally
End; // DisplayCommonPreReqsDlg

//------------------------------

function SCD_WorkstationCISDBPreReqs (var DLLParams: ParamRec): LongBool;
Begin // SCD_WorkstationCISDBPreReqs
  DisplayCommonPreReqsDlg (DLLParams, prdmCIS);
End; // SCD_WorkstationCISDBPreReqs

//------------------------------

// MH 29/01/2013 v7.1 ABSEXCH-13793: Added Pre-Reqs for VAT 100
function SCD_WorkstationVAT100PreReqs (var DLLParams: ParamRec): LongBool;
Begin // SCD_WorkstationVAT100PreReqs
  DisplayCommonPreReqsDlg (DLLParams, prdmVAT100);
End; // SCD_WorkstationVAT100PreReqs

//=========================================================================

procedure TfrmWSDashbPreRequisits.FormCreate(Sender: TObject);
begin
  inherited;
  CheckFBI;
end;

//-------------------------------------------------------------------------

Procedure TfrmWSDashbPreRequisits.SetDialogMode (Value : TCommonPreReqsDlgMode);
Begin // SetDialogMode
  FDialogMode := Value;

  If (FDialogMode = prdmVAT100) Then
  Begin
    TitleLbl.Caption := 'VAT 100 XML Pre-Requisites';

    InstrLbl.Caption := 'This workstation needs the following components installed to allow Exchequer ' +
                        'to create XML format VAT 100s which can be uploaded to the HMRC website.';

    lblFBIText.Caption := 'The Exchequer FBI Subsystem creates the wrapper for the VAT 100 required by the HMRC website.';

    // MH 23/05/2013 v7.0.4 ABSEXCH-14319: Set new help context If for VAT 100 Pre-Reqs
    HelpContextId := 89;
  End; // If (FDialogMode = prdmVAT100)
End; // SetDialogMode

//-------------------------------------------------------------------------

Procedure TfrmWSDashbPreRequisits.SetPreRequisits(Value : TPreRequisites);
Var
  PanelArray : Array[1..3] Of TPanel;
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
  panMSXML.Visible := FPreRequisits.PreReqStatus[priMSXML40] <> prsInstalled;
  PanelArray[1] := panMSXML;

  panNetFramework.Visible := FPreRequisits.PreReqStatus[priNetFramework] <> prsInstalled;
  PanelArray[2] := panNetFramework;

  panFBI.Visible := FNeedFBI;
  PanelArray[3] := panFBI;

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

  // Check for dependancies

  // MS XML 4.0 SP2
  If panMSXML.Visible Then
    SetupPanel (panMSXML, lblMSXMLTitle, lblMSXMLText, lblMSXMLInstall);

  // .Net Framework
  If panNetFramework.Visible Then
    SetupPanel (panNetFramework, lblNetFrameworkTitle, lblNetFrameworkText, lblNetFrameworkInstall);

  // FBI Components
  If panFBI.Visible Then
    SetupPanel (panFBI, lblFBITitle, lblFBIText, lblFBIInstall);
End; // SetPreRequisits

//-------------------------------------------------------------------------

procedure TfrmWSDashbPreRequisits.CheckFBI;
Var
  oReg : TRegistry;
Begin // CheckFBI
  oReg := TRegistry.Create;
  Try
    oReg.Access := KEY_QUERY_VALUE Or KEY_ENUMERATE_SUB_KEYS;
    oReg.RootKey := HKEY_CLASSES_ROOT;

    // Check for COM Object registration Key
    FNeedFBI := Not oReg.KeyExists('Iris_Internet_Filing');
  Finally
    FreeAndNIL(oReg);
  End; // Try..Finally
End; // CheckFBI

//-------------------------------------------------------------------------

Function TfrmWSDashbPreRequisits.NeedShow : Boolean;
Begin // NeedShow
  Result := panMSXML.Visible Or panNetFramework.Visible Or panFBI.Visible;
End; // NeedShow

//-------------------------------------------------------------------------

// Updates the pre-requisites page after running one of the installs
procedure TfrmWSDashbPreRequisits.UpdateStatus;
Begin // UpdateStatus
  // Redo the Pre-Req checks as we may be able to install now
  FPreRequisits.CheckPreReqs;
  CheckFBI;

  If (FPreRequisits.PreReqStatus[priMSXML40] <> prsInstalled) Or (FPreRequisits.PreReqStatus[priNetFramework] <> prsInstalled) Or FNeedFBI Then
    SetPreRequisits (FPreRequisits)
  Else
  Begin
    // All pre-requisites available - go to next page
    ExitCode := 'N';
    Close;
  End; // Else
End; // UpdateStatus

//-------------------------------------------------------------------------

procedure TfrmWSDashbPreRequisits.lblNetFrameworkInstallClick(Sender: TObject);
begin
  //
  RunApp(ExtractFilePath(Application.ExeName) + 'PreReqs\DotNet20\32Bit\DotNetFx.Exe', True);
  UpdateStatus;
end;

//------------------------------

procedure TfrmWSDashbPreRequisits.lblFBIInstallClick(Sender: TObject);
begin
  RunApp(ExtractFilePath(Application.ExeName) + 'PreReqs\FBI Components\Setup.Exe', True);
  UpdateStatus;
end;

//-------------------------------------------------------------------------

end.
