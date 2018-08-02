Unit uGetSQLServerMachine;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SETUPBAS, StdCtrls, Mask, TEditVal, ExtCtrls, WiseUtil,

  {uses to load the network machines}
  Winsock, ScktComp, ComCtrls;

//Const
//  CM_SocketCallBack = WM_App + 600;

Type

  TfrmGetSQLServerMachine = Class(TSetupTemplate)
    btnBrowse: TButton;
    edtSqlServer: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edtInstance: TEdit;
    Label4: TLabel;
    cbSQLProtocol: TComboBox;
    Procedure btnBrowseClick(Sender: TObject);
  Private
    //fSocket: Integer;

    //Procedure CMSocketCallBack(Var Msg: TMessage); Message CM_SocketCallBack;
//    Procedure CloseSkt;
//    Procedure LoadInstances;

    Function GetSQLProtocolPrefix : ShortString;
    Function ValidOk(VCode: Char): Boolean; Override;
    Function CheckComputerExists(Const pComputer: String): Boolean;
    //Function CheckSQLExists(Const pComputer: String): Boolean;
    //Procedure ListAvailableSQLServers;
  Public
    W_InstallerDir : ANSIString;
    Property SQLProtocolPrefix : ShortString Read GetSQLProtocolPrefix;
  End;

Function GetServerConnection(Var DLLParams: ParamRec): LongBool;

Function SCD_EntGetSQLServerMachine(Var DLLParams: ParamRec): LongBool; StdCall;
export;

Function _BrowseComputer(DialogTitle: String; Var CompName: String;
  bNewStyle: Boolean): Boolean;

Var
  frmGetSQLServerMachine: TfrmGetSQLServerMachine;

Implementation

Uses ShellApi, ShlObj, Activex, Registry, APIUtil, SQLH_MemMap, strutil, strutils;

{$R *.dfm}

{-----------------------------------------------------------------------------
  Procedure: GetIPFromHost
  check if we can get a IP address from the network
-----------------------------------------------------------------------------}
Function GetIPFromHost(Const HostName: String): String;
Type
  TaPInAddr = Array[0..10] Of PInAddr;
  PaPInAddr = ^TaPInAddr;
Var
  phe: PHostEnt;
  pptr: PaPInAddr;
  i: Integer;
  GInitData: TWSAData;
Begin
  Result := '';

  if WSAStartup($101, GInitData) = 0 then
  begin
    phe := GetHostByName(PChar(HostName));
    If phe = Nil Then
      Exit;

    //pPtr := PaPInAddr(phe^.h_addr_list);

    for i := 0 to phe^.h_length - 1 do
     Result := Concat(Result, IntToStr(Ord(phe^.h_addr_list^[i])) + '.');

//    i := 0;
//    While pPtr^[i] <> Nil Do
//    Begin
//      Result := inet_ntoa(pptr^[i]^);
//      Inc(i);
//    End;

    WSACleanup;
  end; {if WSAStartup($101, GInitData) = 0 then}
End;

{-----------------------------------------------------------------------------
  Procedure: _BrowseComputer
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _BrowseComputer(DialogTitle: String; Var CompName: String;
  bNewStyle: Boolean): Boolean;
  // bNewStyle: If True, this code will try to use the "new"
  // BrowseForFolders UI on Windows 2000/XP
Const
  BIF_USENEWUI = 28;
Var
  BrowseInfo: TBrowseInfo;
  ItemIDList: PItemIDList;
  ComputerName: Array[0..MAX_PATH] Of Char;
  Title: String;
  WindowList: Pointer;
  ShellMalloc: IMalloc;
Begin
  Result := False;
  If Succeeded(SHGetSpecialFolderLocation(Application.Handle, CSIDL_NETWORK,
    ItemIDList)) Then
  Begin
    Try
      FillChar(BrowseInfo, SizeOf(BrowseInfo), 0);
      BrowseInfo.hwndOwner := Application.Handle;
      BrowseInfo.pidlRoot := ItemIDList;
      BrowseInfo.pszDisplayName := ComputerName;
      Title := DialogTitle;
      BrowseInfo.lpszTitle := PChar(Pointer(Title));
      If bNewStyle Then
        BrowseInfo.ulFlags := BIF_BROWSEFORCOMPUTER Or BIF_USENEWUI
      Else
        BrowseInfo.ulFlags := BIF_BROWSEFORCOMPUTER;
      WindowList := DisableTaskWindows(0);
      Try
        Result := SHBrowseForFolder(BrowseInfo) <> Nil;
      Finally
        EnableTaskWindows(WindowList);
      End;
      If Result Then
        CompName := ComputerName;
    Finally
      If Succeeded(SHGetMalloc(ShellMalloc)) Then
        ShellMalloc.Free(ItemIDList);
    End;
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: SCD_EntGetSQLServerMachine
  Author:    vmoura
-----------------------------------------------------------------------------}
Function SCD_EntGetSQLServerMachine(Var DLLParams: ParamRec): LongBool;
Const
  KEY_WOW64_64KEY        = $0100;
Var
  DlgPN, sSQLSERVER : String;
  oReg : TRegistry;
  oStrings : TStringList;
  I, iPos : SmallInt;
  KeyOpen : Boolean;
Begin
  Result := True;

  GetVariable(DLLParams, 'DLGPREVNEXT', DlgPN);
  GetVariable(DLLParams, 'SQLSERVER', sSQLSERVER);

  frmGetSQLServerMachine := TfrmGetSQLServerMachine.Create(Application);

  With frmGetSQLServerMachine Do
  Begin
    GetVariable(DLLParams, 'INST', W_InstallerDir);
    W_InstallerDir := IncludeTrailingPathDelimiter(W_InstallerDir);
    Application.HelpFile := W_InstallerDir + 'SETUP.HLP';

    If (sSQLSERVER <> '') Then
    Begin
      iPos := Pos('\', sSQLServer);
      If (iPos = 0) Then
        edtSqlServer.Text := sSQLSERVER
      Else
      Begin
        edtSqlServer.Text := Copy (sSQLSERVER, 1, iPos-1);
        edtInstance.Text := Copy (sSQLSERVER, iPos+1, Length(sSQLServer));
      End; // Else
    End // If (sSQLSERVER <> '')
    Else
    Begin
      // Check to see if SQL Server installed and extract Instance Name
      oReg := TRegistry.Create;
      Try
        oReg.Access := KEY_READ;
        oReg.RootKey := HKEY_LOCAL_MACHINE;
        KeyOpen := oReg.OpenKey('SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL', False);
        If (Not KeyOpen) Then
        Begin
          // MH 02/11/10: Added Win64 support
          If IsWow64 Then
          Begin
            // 64-Bit - need to go to 64-bit key, otherwise we will get redirected to the WOW6432 section which doesn't contain the detail
            oReg.Access := oReg.Access Or KEY_WOW64_64KEY;
            KeyOpen := oReg.OpenKey('SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL', False);
          End; // If IsWow64
        End; // If (Not KeyOpen)

        If KeyOpen Then
        Begin
          edtSqlServer.Text := WinGetComputerName;

          oStrings := TStringList.Create;
          Try
            oReg.GetValueNames(oStrings);
            If (oStrings.Count > 0) Then
            Begin
              For I := 0 To (oStrings.Count - 1) Do
              Begin
                If (oStrings.Strings[I] <> 'MSSQLSERVER') Then
                Begin
                  edtInstance.Text := oStrings.Strings[I];
                  Break;
                End; // If (oStrings.Strings[I] <> 'MSSQLSERVER')
              End; // For I
            End; // If (oStrings.Count > 0)
          Finally
            FreeAndNIL(oStrings);
          End; // Try..Finally
        End; // If oReg.OpenKey('SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL', False)
      Finally
        FreeAndNIL(oReg);
      End; // Try..Finally
    End; // Else

    ShowModal;

    Case frmGetSQLServerMachine.ExitCode Of
      'B':
        Begin { Back }
          SetVariable(DLLParams, 'DIALOG', Copy(DlgPN, 1, 3));
        End;
      'N':
        Begin { Next }
          SetVariable(DLLParams, 'DIALOG', Copy(DlgPN, 4, 3));
          // MH 22/10/2013 v7.0.7 ABSEXCH-14684: Added support for SQL protocol
          sSQLSERVER := SQLProtocolPrefix + Trim(edtSqlServer.Text);
          If (Trim(edtInstance.Text) <> '') Then
            sSQLSERVER := sSQLSERVER + '\' + Trim(edtInstance.Text);

          SetVariable(DLLParams, 'SQLSERVER', sSQLSERVER);

          // MH 22/10/2013 v7.0.7 ABSEXCH-14684: Added support for SQL protocol
          SetVariable(DLLParams, 'V_SQLPROTOCOL', SQLProtocolPrefix);
        End;
      'X':
        Begin { Exit Installation }
          SetVariable(DLLParams, 'DIALOG', '999')
        End;
    End; { If }
  End; {with frmGetSQLServerMachine do}

  frmGetSQLServerMachine.Free;
End;

Function GetServerConnection(Var DLLParams: ParamRec): LongBool;
Var
  DlgPN, sSQLSERVER : String;
  oReg : TRegistry;
  oStrings : TStringList;
  I, iPos : SmallInt;
Begin
  Result := True;

//  GetVariable(DLLParams, 'DLGPREVNEXT', DlgPN);
//  GetVariable(DLLParams, 'SQLSERVER', sSQLSERVER);

  frmGetSQLServerMachine := TfrmGetSQLServerMachine.Create(Application);

  With frmGetSQLServerMachine Do
  Begin
//    GetVariable(DLLParams, 'INST', W_InstallerDir);
    W_InstallerDir := IncludeTrailingPathDelimiter(W_InstallerDir);
    Application.HelpFile := W_InstallerDir + 'SETUP.HLP';

    If (sSQLSERVER <> '') Then
    Begin
      iPos := Pos('\', sSQLServer);
      If (iPos = 0) Then
        edtSqlServer.Text := sSQLSERVER
      Else
      Begin
        edtSqlServer.Text := Copy (sSQLSERVER, 1, iPos-1);
        edtInstance.Text := Copy (sSQLSERVER, iPos+1, Length(sSQLServer));
      End; // Else
    End // If (sSQLSERVER <> '')
    Else
    Begin
      // Check to see if SQL Server installed and extract Instance Name
      oReg := TRegistry.Create;
      Try
        oReg.RootKey := HKEY_LOCAL_MACHINE;
        If oReg.OpenKey('SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL', False) Then
        Begin
          edtSqlServer.Text := WinGetComputerName;

          oStrings := TStringList.Create;
          Try
            oReg.GetValueNames(oStrings);
            If (oStrings.Count > 0) Then
            Begin
              For I := 0 To (oStrings.Count - 1) Do
              Begin
                If (oStrings.Strings[I] <> 'MSSQLSERVER') Then
                Begin
                  edtInstance.Text := oStrings.Strings[I];
                  Break;
                End; // If (oStrings.Strings[I] <> 'MSSQLSERVER')
              End; // For I
            End; // If (oStrings.Count > 0)
          Finally
            FreeAndNIL(oStrings);
          End; // Try..Finally
        End; // If oReg.OpenKey('SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL', False)
      Finally
        FreeAndNIL(oReg);
      End; // Try..Finally
    End; // Else

    ShowModal;

    Case frmGetSQLServerMachine.ExitCode Of
      'B':
        Begin { Back }
//          SetVariable(DLLParams, 'DIALOG', Copy(DlgPN, 1, 3));
        End;
      'N':
        Begin { Next }
//          SetVariable(DLLParams, 'DIALOG', Copy(DlgPN, 4, 3));
          If (Trim(edtInstance.Text) <> '') Then
            sSQLSERVER := Trim(edtSqlServer.Text) + '\' + Trim(edtInstance.Text)
          Else
            sSQLSERVER := Trim(edtSqlServer.Text);

//          SetVariable(DLLParams, 'SQLSERVER', sSQLSERVER);
        End;
      'X':
        Begin { Exit Installation }
//          SetVariable(DLLParams, 'DIALOG', '999')
        End;
    End; { If }
  End; {with frmGetSQLServerMachine do}

  frmGetSQLServerMachine.Free;
End;

Function TfrmGetSQLServerMachine.ValidOk(VCode: Char): Boolean;
Var
  lMachine : String;
  lPos: Integer;
  ConnectionFailed : Boolean;
Begin // ValidOk
  If (VCode = 'N') Then
  Begin
    If (edtSqlServer.Text <> '') Then
    Begin
      lMachine := Trim(edtSqlServer.Text);
      Result := CheckComputerExists(lMachine);

      If Result Then
      Begin
        GlobalSetupMap.Clear;
        GlobalSetupMap.Params := 'jhas23aS';
        GlobalSetupMap.FunctionId := fnCheckSQLDBCLR;
        // MH 22/10/2013 v7.0.7 ABSEXCH-14684: Added support for SQL protocol
        If (Trim(edtInstance.Text) <> '') Then
          GlobalSetupMap.AddVariable ('V_SERVERNAME', SQLProtocolPrefix + Trim(edtSqlServer.Text) + '\' + Trim(edtInstance.Text))
        Else
          GlobalSetupMap.AddVariable ('V_SERVERNAME', SQLProtocolPrefix + Trim(edtSqlServer.Text));
        GlobalSetupMap.AddVariable ('V_CONNECTIONFAILED', '0');

        // Call the SQL Helper Function - .EXE will be on the CD so we can't use the normal SetupSQL.Dll/SQLHelpr.Exe routing
        RunApp(W_InstallerDir + 'SETHELPR.EXE /SETUPBODGE', True);

        Result := GlobalSetupMap.Result;
        If Result Then
        Begin
          // Check Authentication Mode - 'Mixed' required
          GlobalSetupMap.Clear;
          GlobalSetupMap.Params := 'Qha2%daK';
          GlobalSetupMap.FunctionId := fnCheckSQLAuthMode;

          // MH 22/10/2013 v7.0.7 ABSEXCH-14684: Added support for SQL protocol
          If (Trim(edtInstance.Text) <> '') Then
            GlobalSetupMap.AddVariable ('V_SERVERNAME', SQLProtocolPrefix + Trim(edtSqlServer.Text) + '\' + Trim(edtInstance.Text))
          Else
            GlobalSetupMap.AddVariable ('V_SERVERNAME', SQLProtocolPrefix + Trim(edtSqlServer.Text));

          // Call the SQL Helper Function - .EXE will be on the CD so we can't use the normal SetupSQL.Dll/SQLHelpr.Exe routing
          RunApp(W_InstallerDir + 'SETHELPR.EXE /SETUPBODGE', True);

          Result := GlobalSetupMap.Result;
(*** MH 18/09/2008: Removed as OLE Automation Mode check not neccessary now that the rounding functions have been removed
          If Result Then
          Begin
            // Check OLE Automation Mode
            GlobalSetupMap.Clear;
            GlobalSetupMap.Params := 'jhas23aS';
            GlobalSetupMap.FunctionId := fnCheckSQLOLEAuto;
            GlobalSetupMap.AddVariable ('V_CONNECTIONFAILED', '0');

            If (Trim(edtInstance.Text) <> '') Then
              GlobalSetupMap.AddVariable ('V_SERVERNAME', Trim(edtSqlServer.Text) + '\' + Trim(edtInstance.Text))
            Else
              GlobalSetupMap.AddVariable ('V_SERVERNAME', Trim(edtSqlServer.Text));

            // Call the SQL Helper Function - .EXE will be on the CD so we can't use the normal SetupSQL.Dll/SQLHelpr.Exe routing
            RunApp(W_InstallerDir + 'SETHELPR.EXE /SETUPBODGE', True);

            Result := GlobalSetupMap.Result;
            If (Not Result) Then
            Begin
              // OLE Automation must be enabled
              MessageDlg('OLE Automation must be enabled on the specified SQL Server Instance for Exchequer SQL to install and run, ' +
                         'please notify your Database Administrator.', mtError, [mbOk], 0);
            End; // If (Not Result)
          End // If Result
          Else
***)
          Begin
            If (Not Result) And (Not GlobalSetupMap.ExceptionRaised) Then
            Begin
              // Must be using Mixed Mode Authentication
              MessageDlg('Mixed Mode Authentication must be enabled on the specified SQL Server Instance for Exchequer SQL to install and run, ' +
                         'please notify your Database Administrator.', mtError, [mbOk], 0);
            End; // If (Not Result)
          End; // Else
        End // If Result
        Else
        Begin
          If (Not GlobalSetupMap.ExceptionRaised) Then
          Begin
            ConnectionFailed := (GlobalSetupMap.Variables[GlobalSetupMap.IndexOf ('V_CONNECTIONFAILED')].vdValue = '1');
            If ConnectionFailed Then
            Begin
              // Probably Invalid Server Name or Instance
              MessageDlg('Setup cannot connect to the specified SQL Server Instance, please check that the ' +
                         'Computer Name, Instance Name and Protocol are correct.', mtError, [mbOk], 0);
            End // If ConnectionFailed
            Else
            Begin
              // CLR Not enabled
              MessageDlg('CLR Integration must be enabled on the specified SQL Server Instance for Exchequer SQL to install and run, ' +
                         'please notify your Database Administrator.', mtError, [mbOk, mbHelp], 123);
            End; // Else
          End; // If (Not GlobalSetupMap.ExceptionRaised)
        End; // Else
      End // If Result
      Else
      Begin
        MessageDlg('Setup cannot find "' + lMachine + '".' + #13 + #10 +
                   'Check the spelling and try again, or try searching for the server using the Browse button.',
                   mtWarning, [mbOk], 0);
      End; // Else
    End // If (edtSqlServer.Text <> '')
    Else
    Begin
      MessageDlg('The Microsoft SQL Server''s Computer Name cannot be left blank', mtWarning, [mbOk], 0);
      Result := False;
    End; // Else
  End { If }
  Else
    Result := True;
End; // ValidOk


{-----------------------------------------------------------------------------
  Procedure: btnBrowseClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TfrmGetSQLServerMachine.btnBrowseClick(Sender: TObject);
Var
  lServer: String;
Begin
  Inherited;
  _BrowseComputer('Select a MS SQL Server computer name', lServer, false);
  BringToFront;

  edtSqlServer.Text := lServer;
End;


{-----------------------------------------------------------------------------
  Procedure: CheckComputerExists
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TfrmGetSQLServerMachine.CheckComputerExists(
  Const pComputer: String): Boolean;
Begin
  if (Trim(pComputer) <> '') and (Trim(pComputer) <> '.') then
    Result := GetIPFromHost(Trim(pComputer)) <> ''
  else
    // it can be connect empty or '.' as local machine
    Result := True;
End;

//-------------------------------------------------------------------------

Function TfrmGetSQLServerMachine.GetSQLProtocolPrefix : ShortString;
Begin // GetSQLProtocolPrefix
  If (cbSQLProtocol.ItemIndex = 0) Then
    // TCP/IP (Recommended)
    Result := 'tcp:'
  Else If (cbSQLProtocol.ItemIndex = 1) Then
    // Named Pipes
    Result := 'np:'
  Else
    // SQL Server Default - no prefix as it is controlled by SQL Server Configuration
    Result := '';
End; // GetSQLProtocolPrefix

//=========================================================================

End.

