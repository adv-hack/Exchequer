unit CISDBPreReqF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  setupbas, StdCtrls, ExtCtrls, SetupU, BorBtns, ComCtrls, PreReqs;

type
  TfrmDashbPreRequisits = class(TSetupTemplate)
    ScrollBox2: TScrollBox;
    panNetFramework: TPanel;
    lblNetFrameworkTitle: TLabel;
    lblNetFrameworkText: TLabel;
    lblNetFrameworkInstall: TLabel;
    panWinInstaller: TPanel;
    lblWinInstallerTitle: TLabel;
    lblWinInstallerText: TLabel;
    lblWinInstallerInstall: TLabel;
    panMSXML: TPanel;
    lblMSXMLTitle: TLabel;
    lblMSXMLText: TLabel;
    lblMSXMLInstall: TLabel;
    panMDAC: TPanel;
    lblMDACTitle: TLabel;
    lblMDACText: TLabel;
    lblMDACInstall: TLabel;
    panSQLExpress: TPanel;
    lblSQLExpressTitle: TLabel;
    lblSQLExpressInstall: TLabel;
    lblSQLExpressText: TLabel;
    panFBI: TPanel;
    lblFBITitle: TLabel;
    lblFBIInstall: TLabel;
    lblFBIText: TLabel;
    procedure lblNetFrameworkInstallClick(Sender: TObject);
    procedure lblWinInstallerInstallClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lblMDACInstallClick(Sender: TObject);
    procedure lblSQLExpressInstallClick(Sender: TObject);
    procedure lblFBIInstallClick(Sender: TObject);
  private
    { Private declarations }
    FNeedFBI : Boolean;
    FPreRequisits : TPreRequisites;
    procedure CheckFBI;
    Procedure SetPreRequisits(Value : TPreRequisites);

    // Updates the SQL Server configuration for 'IRISSOFTWARE' and restarts the service
    procedure ConfigureSQL;

    // Updates the pre-requisites page after running one of the installs
    procedure UpdateStatus;
  public
    Property NeedFBI : Boolean Read FNeedFBI;
    Property PreRequisits : TPreRequisites Read FPreRequisits Write SetPreRequisits;
  end;


function DashbCheckForPreReqs (var DLLParams: ParamRec): LongBool; StdCall; export;

implementation

{$R *.dfm}

Uses Brand, APIUtil, CompUtil, StrUtils, Math, IniFiles, ActiveX,
  	 ServiceManager, WinSvc, DateUtils, Registry;

//=========================================================================

function DashbCheckForPreReqs (var DLLParams: ParamRec): LongBool;
var
  frmDashbPreRequisits   : TfrmDashbPreRequisits;
  oPreReqs               : TPreRequisites;
  DlgPN, IType, W_Install, WiseStr : String;
  Continue, GotBtr615    : Boolean;
Begin // DashbCheckForPreReqs
  Result := False;

  // Get Installation Source directory for link to help & Lib\
  GetVariable(DLLParams, 'INST', WiseStr);
  Application.HelpFile := IncludeTrailingPathDelimiter(WiseStr) + 'SETUP.HLP';

  // Get Exchequer/IAO directory for the Pre-Req checks
  GetVariable(DLLParams, 'V_MAINDIR', WiseStr);

  // Check to see if any pre-reqs are required
  oPreReqs := TPreRequisites.Create(prcExchDSR, WiseStr);
  Try
    frmDashbPreRequisits := TfrmDashbPreRequisits.Create(Application);
    Try
      // pass in details of pre-reqs
      frmDashbPreRequisits.PreRequisits := oPreReqs;

      If (Not oPreReqs.AllChecksPassed) Or frmDashbPreRequisits.NeedFBI Then
      Begin
        frmDashbPreRequisits.ShowModal;

        Result := (frmDashbPreRequisits.ExitCode = 'N');
      End // If (Not oPreReqs.AllChecksPassed) Or frmDashbPreRequisits.NeedFBI
      Else
        // AOK
        Result := True;
    Finally
      frmDashbPreRequisits.Free;
    End;
  Finally
    oPreReqs.Free;
  End; // Try..Finally
End; // DashbCheckForPreReqs

//=========================================================================

procedure TfrmDashbPreRequisits.FormCreate(Sender: TObject);
begin
  inherited;
  CheckFBI;
end;

//-------------------------------------------------------------------------

procedure TfrmDashbPreRequisits.CheckFBI;
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

Procedure TfrmDashbPreRequisits.SetPreRequisits(Value : TPreRequisites);
Var
  PanelArray : Array[1..6] Of TPanel;
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

  panMSXML.Visible := FPreRequisits.PreReqStatus[priMSXML40] <> prsInstalled;
  PanelArray[2] := panMSXML;

  panMDAC.Visible := FPreRequisits.PreReqStatus[priMDAC] <> prsInstalled;
  PanelArray[3] := panMDAC;

  panNetFramework.Visible := FPreRequisits.PreReqStatus[priNetFramework] <> prsInstalled;
  PanelArray[4] := panNetFramework;

  // MH 12/09/08: Don't check for the Dashboard running under Exchequer
  panSQLExpress.Visible := False;//(FPreRequisits.PreReqStatus[priSQLExpress] <> prsInstalled);
  PanelArray[5] := panSQLExpress;

  panFBI.Visible := FNeedFBI;
  PanelArray[6] := panFBI;

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

  // Windows Installer 3.1
  If panWinInstaller.Visible Then
    SetupPanel (panWinInstaller, lblWinInstallerTitle, lblWinInstallerText, lblWinInstallerInstall);

  // MS XML 4.0 SP2
  If panMSXML.Visible Then
    SetupPanel (panMSXML, lblMSXMLTitle, lblMSXMLText, lblMSXMLInstall);

  // MDAC 2.8 SP1
  If panMDAC.Visible Then
    SetupPanel (panMDAC, lblMDACTitle, lblMDACText, lblMDACInstall);

  // .Net Framework
  If panNetFramework.Visible Then
    SetupPanel (panNetFramework, lblNetFrameworkTitle, lblNetFrameworkText, lblNetFrameworkInstall);

  // SQL Express 2005 SP1
  If panSQLExpress.Visible Then
    SetupPanel (panSQLExpress, lblSQLExpressTitle, lblSQLExpressText, lblSQLExpressInstall);

  // FBI Components
  If panFBI.Visible Then
    SetupPanel (panFBI, lblFBITitle, lblFBIText, lblFBIInstall);
End; // SetPreRequisits

//-------------------------------------------------------------------------

// Updates the pre-requisites page after running one of the installs
procedure TfrmDashbPreRequisits.UpdateStatus;
Begin // UpdateStatus
  // Redo the Pre-Req checks as we may be able to install now
  FPreRequisits.CheckPreReqs;
  CheckFBI;

  If FPreRequisits.AllChecksPassed And (Not FNeedFBI) Then
  Begin
    // All pre-requisites available - go to next page
    ExitCode := 'N';
    Close;
  End // If FPreRequisits.AllChecksPassed
  Else
    SetPreRequisits (FPreRequisits);
End; // UpdateStatus

//-------------------------------------------------------------------------

procedure TfrmDashbPreRequisits.lblWinInstallerInstallClick(Sender: TObject);
begin
  RunApp(ExtractFilePath(Application.ExeName) + 'PreReqs\WinInst31\WindowsInstaller-KB893803-v2-x86.exe', True);
  UpdateStatus;
end;


//------------------------------

procedure TfrmDashbPreRequisits.lblMDACInstallClick(Sender: TObject);
begin
  RunApp(ExtractFilePath(Application.ExeName) + 'PreReqs\MDAC28SP1\MDAC_Typ.exe', True);
  UpdateStatus;
end;

//------------------------------

procedure TfrmDashbPreRequisits.lblNetFrameworkInstallClick(Sender: TObject);
begin
  //
  RunApp(ExtractFilePath(Application.ExeName) + 'PreReqs\DotNet20\32Bit\DotNetFx.Exe', True);
  UpdateStatus;
end;

//------------------------------

// Updates the SQL Server configuration for 'IRISSOFTWARE' and restarts the service
procedure TfrmDashbPreRequisits.ConfigureSQL;
Var
  PCharStr : ANSIString;
  oServiceManager : TServiceManager;
  TimeoutTime : TDateTime;

  Procedure UpdateSQLRegistry;
  Var
    oReg : TRegistry;
    sInstanceName : ShortString;
  Begin // UpdateSQLRegistry
    // Lokup IRISSOFTWARE instance in the registry to identify where the MSSQL registry entries are
    oReg := TRegistry.Create;
    Try
      // Requires write permissions
      //oReg.Access := KEY_QUERY_VALUE Or KEY_ENUMERATE_SUB_KEYS;
      oReg.RootKey := HKEY_LOCAL_MACHINE;

      // Check for the 'IRISSOFTWARE' named instance
      sInstanceName := '';
      If oReg.OpenKey('SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL', False) Then
      Begin
        If oReg.ValueExists('IRISSOFTWARE') Then
        Begin
          // Extract the 'MSSQL.X' name so we can go to the actual settings for IRISSOFTWARE
          sInstanceName := oReg.ReadString('IRISSOFTWARE');
        End; // If oReg.ValueExists('IRISSOFTWARE')
        oReg.CloseKey;

        // Open the section for the IRISSOFTWARE named instance
        If oReg.OpenKey('SOFTWARE\Microsoft\Microsoft SQL Server\' + sInstanceName + '\MSSQLServer\SuperSocketNetLib\Np', False) Then
        Begin
          oReg.WriteInteger('Enabled', 1);
          oReg.CloseKey;
        End; // If oReg.OpenKey('SOFTWARE\...

        // Open the section for the IRISSOFTWARE named instance
        If oReg.OpenKey('SOFTWARE\Microsoft\Microsoft SQL Server\' + sInstanceName + '\MSSQLServer\SuperSocketNetLib\Tcp', False) Then
        Begin
          oReg.WriteInteger('Enabled', 1);
          oReg.CloseKey;
        End; // If oReg.OpenKey('SOFTWARE\...
      End; // If oReg.OpenKey('SOFTWARE\Microsoft\Microsoft SQL Server', False)
    Finally
      FreeAndNIL(oReg);
    End; // Try..Finally
  End; // UpdateSQLRegistry

begin
  oServiceManager := TServiceManager.Create;
  Try
    PCharStr := WinGetComputerName;
    If oServiceManager.Connect(PCHAR(PCharStr), NIL, SC_MANAGER_ALL_ACCESS) Then
    Begin
      PCharStr := 'MSSQL$IRISSOFTWARE';
      If oServiceManager.OpenServiceConnection(PCHAR(PCharStr)) Then
      Begin
        // Stop Service -----------------------------------
        If (oServiceManager.GetStatus = SERVICE_RUNNING) Then
        Begin
          If oServiceManager.StopService Then
          Begin
            // Wait until started - otherwise following pre-reqs may fail
            TimeoutTime := IncSecond(Now, 10); // 10 second timeout
            Repeat
              Sleep(250);  // pause for 1/4 second to allow it do do its thang
            Until oServiceManager.ServiceStopped Or (TimeoutTime < Now);
          End // If oServiceManager.StopService
          Else
            MessageDlg ('Unable to stop the SQL Server instance for the Data Synchronisation Service, please contact your Technical Support',
                        mtError, [mbOK], 0);
        End; // If (oServiceManager.GetStatus = SERVICE_RUNNING)

        // Update Registry --------------------------------
        UpdateSQLRegistry;

        // Restart Service --------------------------------
        If oServiceManager.StartService Then
        Begin
          // Wait until started - otherwise following pre-reqs may fail
          TimeoutTime := IncSecond(Now, 10); // 10 second timeout
          Repeat
            Sleep(250);  // pause for 1/4 second to allow it do do its thang
          Until oServiceManager.ServiceRunning Or (TimeoutTime < Now);
        End // If oServiceManager.StartService
        Else
          MessageDlg ('Unable to restart the SQL Server instance for the Data Synchronisation Service, please contact your Technical Support',
                      mtError, [mbOK], 0);
      End // If oServiceManager.OpenServiceConnection(PCHAR(PCharStr))
      Else
        MessageDlg ('Unable to connect to the SQL Server instance for the Data Synchronisation Service, please contact your Technical Support',
                    mtError, [mbOK], 0);
    End // If oServiceManager.Connect(PCHAR(PCharStr), NIL, SC_MANAGER_ALL_ACCESS)
    Else
      MessageDlg ('Unable to connect to the Service Manager, please contact your Technical Support',
                  mtError, [mbOK], 0);
  Finally
    FreeAndNIL(oServiceManager);
  End; // Try..Finally
end;

procedure TfrmDashbPreRequisits.lblSQLExpressInstallClick(Sender: TObject);
begin
  // MH 12/10/06: Modified parameters to auto-enable the SQL Browser - NOTE: String split due to compiler limitations
  RunApp(ExtractFilePath(Application.ExeName) + 'PreReqs\SQLExpress2005\SQLExpr.Exe /qb INSTANCENAME=IRISSOFTWARE ' + 'ADDLOCAL=SQL_Engine SECURITYMODE=SQL SAPWD=ras48uc4erexaDRa5Tet SQLACCOUNT="NT AUTHORITY\SYSTEM" SQLPASSWORD="" SQLBROWSERACCOUNT="NT AUTHORITY\SYSTEM" SQLBROWSERPASSWORD="" SQLAUTOSTART=1 SQLBROWSERAUTOSTART=1', True);

  // MH 13/10/06: Modified to configure the SQL Engine to allow remote connections for the IRISSOFTWARE named instance
  ConfigureSQL;

  UpdateStatus;
end;

//------------------------------

procedure TfrmDashbPreRequisits.lblFBIInstallClick(Sender: TObject);
begin
  RunApp(ExtractFilePath(Application.ExeName) + 'PreReqs\FBI Components\Setup.Exe', True);
  UpdateStatus;
end;

//-------------------------------------------------------------------------

end.
