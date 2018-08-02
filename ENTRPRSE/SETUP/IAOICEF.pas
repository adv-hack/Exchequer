unit IAOICEF;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  setupbas, StdCtrls, ExtCtrls, SetupU, BorBtns, ComCtrls, PreReqs;

type
  TfrmIAOInstallICE = class(TSetupTemplate)
    Label1: TLabel;
    edtUserId: TEdit;
    Label2: TLabel;
    edtPassword1: TEdit;
    Label3: TLabel;
    edtPassword2: TEdit;
    Label4: TLabel;
    lstDomain: TComboBox;
    Label5: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    FDomain : ShortString;
    FUserId : ShortString;
    FPassword : ShortString;
  protected
    Function ValidOk(VCode : Char) : Boolean; Override;
  public
    Property Domain : ShortString Read FDomain;
    Property Password : ShortString Read FPassword;
    Property UserId : ShortString Read FUserId;
  end;

// Decide whether we need to uninstall an existing .NET service, statii are Unknown,
// Running, Stopped, Paused, StartPending, StopPending, ContinuePending, or PausePending
function iaoCheckICEServiceStatus (var DLLParams: ParamRec): LongBool; StdCall; export;

// Called by Install/Upgrade to ask the user if they want to install ICE
function iaoAskInstallICE (var DLLParams: ParamRec): LongBool; StdCall; export;

// Called by Workstation Setup to generate the Instal/Uninstall command lines for registering
// the RemotingClientLib.Dll assembly
function iaoRegisterRemotingCmd (var DLLParams: ParamRec): LongBool; StdCall; export;


implementation

{$R *.dfm}

Uses Brand, APIUtil, CompUtil, StrUtils, IniFiles, DotNet, NetworkUtil;

//=========================================================================

// Called by Workstation Setup to generate the Instal/Uninstall command lines for registering
// the RemotingClientLib.Dll assembly
function iaoRegisterRemotingCmd (var DLLParams: ParamRec): LongBool;
Var
  WiseStr, W_MainDir : String;
Begin // iaoRegisterRemotingCmd
  // Build path to .NET utility for installing/uninstalling .NET services
  WiseStr := WinGetWindowsDir + 'Microsoft.NET\Framework\v2.0.50727\RegAsm.exe';
  SetVariable(DLLParams,'ICE_REGASM_PATH', WiseStr);

  // Get path of IAO/Exchequer install where the .EXE is
  GetVariable(DLLParams, 'V_MAINDIR', W_MainDir);

  // Build installation command line - regasm /codebase path\filename.dll /tlb:path\filename.tlb
  // MH 17/05/06: Removed the unnecessary TLB creation at Vini's suggestion
  //WiseStr := '/codebase ' + W_MainDir + '\RemotingClientLib.dll /tlb:' + W_MainDir + '\RemotingClientLib.tlb';
  WiseStr := '/codebase ' + W_MainDir + '\RemotingClientLib.dll';
  SetVariable(DLLParams,'ICE_INSTALL_PARAMS', WiseStr);

  // Build uninstall command line
  WiseStr := ' ' + W_MainDir + '\RemotingClientLib.dll /unregister';
  SetVariable(DLLParams,'ICE_UNINSTALL_PARAMS', WiseStr);

  Result := TRUE;
End; // iaoRegisterRemotingCmd

//=========================================================================

// Decide whether we need to uninstall an existing .NET service, statii are Unknown,
// Running, Stopped, Paused, StartPending, StopPending, ContinuePending, or PausePending
function iaoCheckICEServiceStatus (var DLLParams: ParamRec): LongBool;
Var
  WiseStr : String;
Begin // iaoCheckICEServiceStatus
  GetVariable(DLLParams,'ICE_SERVICESTATUS', WiseStr);
  WiseStr := Trim(UpperCase(WiseStr));
  SetVariable(DLLParams,'ICE_STOPSERVICE', IfThen(WiseStr <> 'UNKNOWN', 'Y', 'N'));
End; // iaoCheckICEServiceStatus

//=========================================================================

// Called by Install/Upgrade to ask the user if they want to install ICE
function iaoAskInstallICE (var DLLParams: ParamRec): LongBool;
var
  frmIAOInstallICE     : TfrmIAOInstallICE;
  DlgPN, IType, W_Install, W_MainDir, W_InstPath, WiseStr : String;
  bNeedUninstall : Boolean;
Begin // iaoAskInstallICE
  Result := False;

  // Get Installation Source directory for link to help & Lib\
  GetVariable(DLLParams, 'INST', W_InstPath);
  Application.HelpFile := IncludeTrailingPathDelimiter(W_InstPath) + 'SETUP.HLP';

  frmIAOInstallICE := TfrmIAOInstallICE.Create(Application);
  Try
    frmIAOInstallICE.ShowModal;

    If (frmIAOInstallICE.ExitCode = 'N') Then
    Begin
      // Build parameters for granting "Logon As Service" permission using NTRights.Exe
      WiseStr := '+r SeServiceLogonRight -u "' + frmIAOInstallICE.UserId + '"';
      SetVariable(DLLParams,'ICE_NTRIGHTS_PARAMS', WiseStr);

      // Build path to .NET utility for installing/uninstalling .NET services
      WiseStr := WinGetWindowsDir + 'Microsoft.NET\Framework\v2.0.50727\installutil.exe';
      SetVariable(DLLParams,'ICE_INSTALLUTIL_PATH', WiseStr);

      // Get path of IAO/Exchequer install where the .EXE is
      GetVariable(DLLParams, 'V_MAINDIR', W_MainDir);

      // Build installation command line
      WiseStr := '/logtoconsole=false ' +
                 '/logfile ' +
                 '/user=' + frmIAOInstallICE.Domain + '\' + frmIAOInstallICE.UserId + ' ' +
                 '/password=' + frmIAOInstallICE.Password + ' ' +
                 W_MainDir + '\WrapperDSRServer.exe';
      SetVariable(DLLParams,'ICE_DSRINSTALL_PARAMS', WiseStr);

      // Build uninstall command line
      WiseStr := '/logtoconsole=false /u ' + W_MainDir + '\WrapperDSRServer.exe';
      SetVariable(DLLParams,'ICE_DSRUNINSTALL_PARAMS', WiseStr);

      // Install Service
      Result := TRUE;
    End; // If (frmIAOInstallICE.ExitCode = 'N')
  Finally
    frmIAOInstallICE.Free;
  End;
End; // iaoAskInstallICE

//=========================================================================

procedure TfrmIAOInstallICE.FormCreate(Sender: TObject);
begin
  inherited;

  If (Branding.pbProduct = ptExchequer) Then
  Begin
    Self.Caption := 'Exchequer GovLink Setup';
    TitleLbl.Caption := 'Install GovLink Service';
    InstrLbl.Caption := '<APPTITLE> has a GovLink Utility which can be used to send Sub-Contractor Statements to HMRC.';
  End; // If (Branding.pbProduct = ptExchequer)

  // Insert product name into window
  ModifyCaptions ('<APPTITLE>', Branding.pbProductName, [InstrLbl]);

  lstDomain.Items.Add(WinGetComputerName);
  lstDomain.Items.Add(GetNetworkDomain);
  lstDomain.ItemIndex := 0;

  edtUserId.Text := WinGetUserName;
end;

//-------------------------------------------------------------------------

Function TfrmIAOInstallICE.ValidOk(VCode : Char) : Boolean;
Begin // ValidOk
  FDomain := '';
  FUserId := '';
  FPassword := '';

  If (VCode = 'N') Then
  Begin
    Result := False;

    // Check Domain is set
    FDomain := lstDomain.Text;
    If (FDomain <> '') Then
    Begin
      // Check User ID is set
      FUserId := UpperCase(Trim(edtUserId.Text));
      If (FUserId <> '') Then
      Begin
        // Check Password 1 is set
        FPassword := Trim(edtPassword1.Text);
        If (FPassword <> '') Then
        Begin
          // Check Password 2 matches
          If (FPassword = Trim(edtPassword2.Text)) Then
          Begin
            Result := True;
          End // If (FPassword = Trim(edtPassword2.Text))
          Else
          Begin
            MessageDlg ('The original and confirmation passwords do not match', mtWarning, [mbOK], 0);
            If edtPassword1.CanFocus Then edtPassword1.SetFocus;
          End; // Else
        End // If (FPassword <> '')
        Else
        Begin
          MessageDlg ('The Password must be set', mtWarning, [mbOK], 0);
          If edtPassword1.CanFocus Then edtPassword1.SetFocus;
        End; // Else
      End // If (FUserId <> '')
      Else
      Begin
        MessageDlg ('The User ID must be set', mtWarning, [mbOK], 0);
        If edtUserId.CanFocus Then edtUserId.SetFocus;
      End; // Else
    End // If (FDomain <> '')
    Else
    Begin
      MessageDlg ('The Domain must be set', mtWarning, [mbOK], 0);
      If lstDomain.CanFocus Then lstDomain.SetFocus;
    End; // Else
  End // If (VCode = 'N')
  Else
    Result := True;
End; // ValidOk

//-------------------------------------------------------------------------

end.


