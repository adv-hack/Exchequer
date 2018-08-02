unit PreReqsFrame;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, StrUtils, PreReqs;

type
  TfraPreReqs = class(TFrame)
    ScrollBox1: TScrollBox;
    Label1: TLabel;
    lblIntro: TLabel;
    ScrollBox2: TScrollBox;
    panNetFramework: TPanel;
    lblNetFrameworkTitle: TLabel;
    lblNetFrameworkText: TLabel;
    lblNetFrameworkInstall: TLabel;
    panIRISLicencing: TPanel;
    lblIRISLicencingTitle: TLabel;
    lblIRISLicencingInstall: TLabel;
    lblIRISLicencingText: TLabel;
    panSQLExpress: TPanel;
    lblSQLExpressTitle: TLabel;
    lblSQLExpressInstall: TLabel;
    lblSQLExpressText: TLabel;
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
    panPSQLWGE: TPanel;
    lblPSQLWGETitle: TLabel;
    lblPSQLWGEInstall: TLabel;
    lblPSQLWGEText: TLabel;
    procedure lblNetFrameworkInstallClick(Sender: TObject);
    procedure lblIRISLicencingInstallClick(Sender: TObject);
    procedure lblSQLExpressInstallClick(Sender: TObject);
    procedure lblWinInstallerInstallClick(Sender: TObject);
    procedure lblMSXMLInstallClick(Sender: TObject);
    procedure lblMDACInstallClick(Sender: TObject);
    procedure lblPSQLWGEInstallClick(Sender: TObject);
  private
    { Private declarations }
    FPreRequisits : TPreRequisites;

    // Updates the SQL Server configuration for 'IRISSOFTWARE' and restarts the service
    procedure ConfigureSQL;

    // Updates the pre-requisites page after running one of the installs
    procedure UpdateStatus;
  public
    { Public declarations }
    Procedure InitPreReqs (PreRequisits : TPreRequisites);
  end;

implementation

{$R *.dfm}

Uses Brand, APIUtil, WizdMsg, Math, ELITE_COM_TLB, ServiceManager, WinSvc, DateUtils, Registry ;

//=========================================================================

Procedure TfraPreReqs.InitPreReqs (PreRequisits : TPreRequisites);
Var
  PanelArray : Array[TPreReqIndex] Of TPanel;
  iPreReq    : TPreReqIndex;
  iNextTop   : SmallInt;
  bGotOne : Boolean;

  Procedure SetupPanel (Var PreReqPanel : TPanel; Var PreReqTitle, PreReqText, PreReqInstall : TLabel);
  Var
    bDisable : Boolean;
  Begin // SetupPanel
    bDisable := (PreReqPanel.Tag <> 0);
    PreReqTitle.Font.Color := IfThen (bDisable, clWindowText, clGrayText);
    PreReqText.Font.Color := PreReqTitle.Font.Color;
    PreReqInstall.Visible := bDisable;
  End; // SetupPanel

Begin // InitPreReqs
  FPreRequisits := PreRequisits;

  // Build the array of panels for the pre-requisits
  PanelArray[priWinInstaller] := panWinInstaller;
  PanelArray[priMSXML40] := panMSXML;
  PanelArray[priMDAC] := panMDAC;
  PanelArray[priNetFramework] := panNetFramework;
  PanelArray[priSQLExpress] := panSQLExpress;
  PanelArray[priLicencing] := panIRISLicencing;
  PanelArray[priPSQLWGE] := panPSQLWGE;

  // Ensure Scroll-Box is at top
  With ScrollBox2.VertScrollBar Do
  Begin
    Position := 0;
    Tracking := True;
  End; // With ScrollBox2.VertScrollBar

  // Run through the array of pre-req panels enabling them as required and setting
  // up their positions within the scrollbox
  bGotOne := False;
  iNextTop := PanelArray[Low(TPreReqIndex)].Top;
  For iPreReq := Low(iPreReq) To High(iPreReq) Do
  Begin
    PanelArray[iPreReq].Visible := (FPreRequisits.PreReqStatus[iPreReq] <> prsInstalled);
    If PanelArray[iPreReq].Visible Then
    Begin
      // Use the tag to mark the first visible panel so that we can disable all the rest to control
      // the installation order
      PanelArray[iPreReq].Tag := IfThen(bGotOne, 0, 1);
      bGotOne := True;

      PanelArray[iPreReq].Left := 0;//23;
      PanelArray[iPreReq].Top := iNextTop;
      PanelArray[iPreReq].BevelOuter := bvNone;
      PanelArray[iPreReq].Color := Self.Color;
      Inc (iNextTop, PanelArray[iPreReq].Height);
    End; // If PanelArray[iPreReq].Visible
  End; // For iPreReq

  // Update Branding
  lblIntro.Caption := ANSIReplaceStr(lblIntro.Caption, '<APPTITLE>', Branding.pbProductName);
  lblMSXMLText.Caption := ANSIReplaceStr(lblMSXMLText.Caption, '<APPTITLE>', Branding.pbProductName);
  lblNetFrameworkText.Caption := ANSIReplaceStr(lblNetFrameworkText.Caption, '<APPTITLE>', Branding.pbProductName);
  lblSQLExpressText.Caption := ANSIReplaceStr(lblSQLExpressText.Caption, '<APPTITLE>', Branding.pbProductName);
  lblIRISLicencingText.Caption := ANSIReplaceStr(lblIRISLicencingText.Caption, '<APPTITLE>', Branding.pbProductName);
  lblPSQLWGEText.Caption := ANSIReplaceStr(lblPSQLWGEText.Caption, '<APPTITLE>', Branding.pbProductName);

  // Only show the first pre-req as enabled

  // Windows Installer 3.1
  If panWinInstaller.Visible Then
    SetupPanel (panWinInstaller, lblWinInstallerTitle, lblWinInstallerText, lblWinInstallerInstall);

  // MDAC 2.8 SP1
  If panMDAC.Visible Then
    SetupPanel (panMDAC, lblMDACTitle, lblMDACText, lblMDACInstall);

  // MS XML 4.0 SP2
  If panMSXML.Visible Then
    SetupPanel (panMSXML, lblMSXMLTitle, lblMSXMLText, lblMSXMLInstall);

  // .Net Framework
  If panNetFramework.Visible Then
    SetupPanel (panNetFramework, lblNetFrameworkTitle, lblNetFrameworkText, lblNetFrameworkInstall);

  // SQL Server Express
  If panSQLExpress.Visible Then
    SetupPanel (panSQLExpress, lblSQLExpressTitle, lblSQLExpressText, lblSQLExpressInstall);

  // IRIS Licencing 
  If panIRISLicencing.Visible Then
    SetupPanel (panIRISLicencing, lblIRISLicencingTitle, lblIRISLicencingText, lblIRISLicencingInstall);

  // Pervasive.SQL Workgroup Engine
  If panPSQLWGE.Visible Then
    SetupPanel (panPSQLWGE, lblPSQLWGETitle, lblPSQLWGEText, lblPSQLWGEInstall);
End; // InitPreReqs

//-------------------------------------------------------------------------

// Updates the pre-requisites page after running one of the installs
procedure TfraPreReqs.UpdateStatus;
Begin // UpdateStatus
  // Redo the Pre-Req checks as we may be able to install now
  FPreRequisits.CheckPreReqs;

  If FPreRequisits.AllChecksPassed Then
  Begin
    // All pre-requisites available - go to install page
    PostMessage ((Owner As TForm).Handle, WM_UpdateMode, 0, Ord(amOptions));
  End // If FPreRequisits.AllChecksPassed
  Else
    InitPreReqs (FPreRequisits);
End; // UpdateStatus

//-------------------------------------------------------------------------

procedure TfraPreReqs.lblNetFrameworkInstallClick(Sender: TObject);
begin
  RunApp(ExtractFilePath(Application.ExeName) + 'PreReqs\DotNet20\32Bit\DotNetFx.Exe', True);
  UpdateStatus;
end;

//-------------------------------------------------------------------------

// Updates the SQL Server configuration for 'IRISSOFTWARE' and restarts the service
procedure TfraPreReqs.ConfigureSQL;
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
            MessageDlg ('Unable to stop the SQL Server instance for IRIS Accounts Office, please contact your Technical Support',
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
          MessageDlg ('Unable to restart the SQL Server instance for IRIS Accounts Office, please contact your Technical Support',
                      mtError, [mbOK], 0);
      End // If oServiceManager.OpenServiceConnection(PCHAR(PCharStr))
      Else
        MessageDlg ('Unable to connect to the SQL Server instance for IRIS Accounts Office, please contact your Technical Support',
                    mtError, [mbOK], 0);
    End // If oServiceManager.Connect(PCHAR(PCharStr), NIL, SC_MANAGER_ALL_ACCESS)
    Else
      MessageDlg ('Unable to connect to the Service Manager, please contact your Technical Support',
                  mtError, [mbOK], 0);
  Finally
    FreeAndNIL(oServiceManager);
  End; // Try..Finally
end;

//------------------------------

procedure TfraPreReqs.lblSQLExpressInstallClick(Sender: TObject);
begin
  // Run the installer in quiet mode, create a new named instance called "IRISSOFTWARE", only
  // install the SQL Engine, and set authentication to mixed mode
  //RunApp(ExtractFilePath(Application.ExeName) + 'PreReqs\SQLExpress2005\SQLExpr.Exe /qb INSTANCENAME=IRISSOFTWARE ADDLOCAL=SQL_Engine SECURITYMODE=SQL SAPWD=ras48uc4erexaDRa5Tet', True);

  // MH 12/10/06: Modified parameters to auto-enable the SQL Browser - NOTE: String split due to compiler limitations
  RunApp(ExtractFilePath(Application.ExeName) + 'PreReqs\SQLExpress2005\SQLExpr.Exe /qb INSTANCENAME=IRISSOFTWARE ' + 'ADDLOCAL=SQL_Engine SECURITYMODE=SQL SAPWD=ras48uc4erexaDRa5Tet SQLACCOUNT="NT AUTHORITY\SYSTEM" SQLPASSWORD="" SQLBROWSERACCOUNT="NT AUTHORITY\SYSTEM" SQLBROWSERPASSWORD="" SQLAUTOSTART=1 SQLBROWSERAUTOSTART=1', True);

  // MH 13/10/06: Modified to configure the SQL Engine to allow remote connections for the IRISSOFTWARE named instance
  ConfigureSQL;

  UpdateStatus;
end;

//------------------------------

procedure TfraPreReqs.lblIRISLicencingInstallClick(Sender: TObject);
//Var
//  {$Warnings Off}
//  FLicencingInterface : IEliteCom;
//  {$Warnings On}
begin
(*
  // Install IRIS Licencing Database
  RunApp('MSIEXEC.EXE /I "' + ExtractFilePath(Application.ExeName) + 'PreReqs\IRIS Licensing\Network Setup.msi" /qn AllUsers=1', True);

  // Create IRIS Licencing COM OBject (wrapper of .NET class) and Configure Database
  FLicencingInterface := CoLicensingInterface.Create;
  Try
    // Update the scripts with the Server Instance Name
    If FLicencingInterface.SaveSQLServerNameForLocalDB(WinGetComputerName + '\IRISSOFTWARE', '') Then
    Begin
      // Create the Licencing DB
      If (Not FLicencingInterface.InitialiseLicenceMasterDB) Then
        MessageDlg ('An error occurred creating the IRIS Licensing Database', mtError, [mbOK], 0);

      // Create the ICE DB
      If (Not FLicencingInterface.InitialiseICEDB) Then
        MessageDlg ('An error occurred creating the IRIS Client Synchronisation Database', mtError, [mbOK], 0);

      // Setup the LIVE web-service for licensing
      If (Not FLicencingInterface.SaveWebServiceURL('https://www.e-iris-software.co.uk/licensingwebservice/service.asmx')) Then
        MessageDlg ('An error occurred specifying the address of the Licensing Server', mtError, [mbOK], 0);
    End // If FLicencingInterface.SaveSQLServerNameForLocalDB(WinGetComputerName + '\IRISSOFTWARE', '')
    Else
      MessageDlg ('An error occurred updating the Server Name for the IRIS Licensing Database', mtError, [mbOK], 0);
  Finally
    FLicencingInterface := NIL;
  End; // Try..Finally

  UpdateStatus;
*)


  // Install IRIS Licensing
  PostMessage ((Owner As TForm).Handle, WM_UpdateMode, 0, Ord(amInstallLic));
end;

//------------------------------

procedure TfraPreReqs.lblWinInstallerInstallClick(Sender: TObject);
begin
  RunApp(ExtractFilePath(Application.ExeName) + 'PreReqs\WinInst31\WindowsInstaller-KB893803-v2-x86.exe', True);
  UpdateStatus;
end;

//------------------------------

procedure TfraPreReqs.lblMSXMLInstallClick(Sender: TObject);
begin
//  RunApp('MSIEXEC.EXE /I "' + ExtractFilePath(Application.ExeName) + 'PreReqs\MSXML40SP2\msxml.msi" /qn', True);
//  UpdateStatus;

  // Install Microsoft XML Core Services 4.0 SP2
  PostMessage ((Owner As TForm).Handle, WM_UpdateMode, 0, Ord(amInstallXML));
end;

//------------------------------

procedure TfraPreReqs.lblMDACInstallClick(Sender: TObject);
begin
  RunApp(ExtractFilePath(Application.ExeName) + 'PreReqs\MDAC28SP1\MDAC_Typ.exe', True);
  UpdateStatus;
end;

//------------------------------

procedure TfraPreReqs.lblPSQLWGEInstallClick(Sender: TObject);
begin
  // Install WGE
  PostMessage ((Owner As TForm).Handle, WM_UpdateMode, 0, Ord(amInstallPerv));
end;

//-------------------------------------------------------------------------

end.
