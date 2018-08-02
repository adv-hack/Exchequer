Unit RecreateLoginsFrmU;

{
--------------------------------------------------------------------------------
NOTE: this Recreate Logins utility relies on iCoreCreateLogin.exe, which is a
command-line tool. Unfortunately, it does not return error codes, instead, it
outputs any error messages or information directly to STDOUT. The
RunShellCommand function captures this output, and passes it to the parse
routines to determine the success or failure of the command by scanning for
specific phrases.

This system is not very robust, but is the best that can be done without
requesting changes to iCoreCreateLogin. It will fail if the messages from
iCoreCreateLogin are changed.
--------------------------------------------------------------------------------
}

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SETUPBAS, StdCtrls, Mask, TEditVal, ExtCtrls, Winsock, ComCtrls;

Type
  TLoginResult = (lrOk, lrInvalidServer, lrInvalidDatabase, lrInvalidPassword,
                  lrAlreadyExists, lrUnknownError);

  TRecreateLoginsFrm = Class(TSetupTemplate)
    btnBrowse: TButton;
    edtSqlServer: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edtInstance: TEdit;
    edtDatabase: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    comboConnectionProtocol: TComboBox;
    Procedure btnBrowseClick(Sender: TObject);
    procedure ValidateEntries(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure NextBtnClick(Sender: TObject);
  private
    defProtocol : string;  // Default protocol for SQL Server connection string
    
    function CheckComputerExists(Const pComputer: String): Boolean;
    function RunShellCommand(CommandSpec: string; var Output: string): Boolean;
    function CreateLogins: Boolean;
    function ParseCompanyLoginResult(Output: string): TLoginResult;
    function ParseServerLoginResult(Output: string): TLoginResult;
    // PKR. 25/10/2013. ABSEXCH-14684
    function ReadProtocolFromConfigFile : string;
    procedure SaveProtocolToConfigFile;
  protected
    function ValidOk(VCode: Char): Boolean; Override;
  end;

Function _BrowseComputer(DialogTitle: String; Var CompName: String;
  bNewStyle: Boolean): Boolean;

Var
  RecreateLoginsFrm: TRecreateLoginsFrm;

Implementation

Uses ShellApi, ShlObj, Activex, Registry, APIUtil, SQLH_MemMap, strutil,
  strutils, SQLUtils, GmXML{, DebugLogU};

{$R *.dfm}

const
  TestStrings: array[lrInvalidServer..lrAlreadyExists] of string =
  (
    'does not exist',
    'Cannot open database',
    'Password validation failed',
    'already exists'
  );

  ResultMessages: array[lrOk..lrUnknownError] of string =
  (
    'Ok',
    'The specified server could not be found, or you do not have access rights to it.',
    'The specified database could not be opened.',
    'Password validation failed.',
    'The login already exists.',
    'An unrecognised error occurred.'
  );

  ErrorMessages: array[0..26] of string =
  (
    '',
    'Invalid Usage',
    'Not enough parameters',
    'Not enough parameters',
    'Invalid argument - must be /F as last parameter\n',
    'Invalid argument - must be /D must be specified.\n',
    'Invalid argument - last parameter can only be /D /F',
    'Registrar startup failed',
    'A default connection already exists!',
    'A connection with visible name %s already exists',
    'A connection with schema name %s already exists	',
    'A default connection already exists with a different schema name	',
    'A default connection already exists with a different login name	',
    'A default connection already exists with a different login name	',
    'Invalid parameter - must be /D must be specified.\n	',
    'Invalid parameter - last parameter can only be /D /F\n	',
    'Registrar startup failed\n	',
    'A default connection already exists!	',
    'A connection with visible name %s already exists	',
    'A connection with schema name %s already exists	',
    'A default connection already exists with a different schema name.	',
    'A default connection already exists with a different login name.	',
    'A default connection already exists with a different read-only login name.	',
    'Registrar startup failed	',
    'Invalid option	',
    'Unhandled COM Exception?',
    'Unhandled Program Exception?'
  );

{-----------------------------------------------------------------------------
  Procedure: GetIPFromHost
  check if we can get a IP address from the network
-----------------------------------------------------------------------------}
Function GetIPFromHost(Const HostName: String): String;
Var
  phe: PHostEnt;
  i: Integer;
  GInitData: TWSAData;
Begin
  Result := '';

  if WSAStartup($101, GInitData) = 0 then
  begin
    phe := GetHostByName(PChar(HostName));
    If phe = Nil Then
      Exit;

    for i := 0 to phe^.h_length - 1 do
      Result := Concat(Result, IntToStr(Ord(phe^.h_addr_list^[i])) + '.');
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

// -----------------------------------------------------------------------------

procedure TRecreateLoginsFrm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
//  inherited;
  CanClose := True;
end;

// -----------------------------------------------------------------------------

procedure TRecreateLoginsFrm.FormCreate(Sender: TObject);
Const
  KEY_WOW64_64KEY        = $0100;
Var
  oReg : TRegistry;
  oStrings : TStringList;
  I: SmallInt;
  KeyOpen : Boolean;
begin
  inherited;
  InstrLbl.Caption := 'In order to re-connect the log-ins for Exchequer we '+
                      'need to know where to find your Microsoft SQL Server ' +
                      'Database Engine.';
  BackBtn.Caption := '&Cancel';
  HelpBtn.Visible := False;
  ExitBtn.Visible := False;
  Caption := 'Exchequer SQL - Recreate Log-ins';

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

  // PKR. 25/10/2013. ABSEXCH-14684
  // Read the Default Protocol from the config file if one exists
  defProtocol := ReadProtocolFromConfigFile;
  
  // Set the combo box to the specified default
  if lowercase(defProtocol) = 'tcp:' then
    comboConnectionProtocol.ItemIndex := 0;
  if lowercase(defProtocol) = 'np:' then
    comboConnectionProtocol.ItemIndex := 1;
  // PKR. 19/11/2013. Added SQL Server Default option.
  if lowercase(defProtocol) = '' then
    comboConnectionProtocol.ItemIndex := 2;
end;

// -----------------------------------------------------------------------------
// PKR. 25/10/2013. ABSEXCH-14684
// Read the default protocol from the ExchSQLSettings.xml file
function TRecreateLoginsFrm.ReadProtocolFromConfigFile : string;
var
  XML            : TGMXML;
  RootNode, Node : TgmXMLNode;
  iNode          : Integer;
begin
  // This is the default default. Returned if no settings file is found
  // 19/11/2013. PKR.  Changed from tcp: to null string 
  Result := '';
  
  XML := TGMXML.Create(nil);
  try
    if FileExists('ExchSQLSettings.xml') then
    begin
      XML.LoadFromFile('ExchSQLSettings.xml');
      RootNode := XML.Nodes.Root;
      if (Lowercase(RootNode.Name) = 'exchequersqlsettings') then
      begin
        for iNode := 0 to RootNode.Children.Count - 1 do
        begin
          Node := RootNode.Children.Node[iNode];
          if (Lowercase(Node.Name) = 'protocol') then
          begin
            Result := Node.AsString;
            break;
          end;
        end;
      end;
    end;
  finally
    XML.Free;
  end;
end;
    
// -----------------------------------------------------------------------------
procedure TRecreateLoginsFrm.SaveProtocolToConfigFile;
var
  XML   : TGMXML;
begin
  XML := TGMXML.Create(nil);
  try
    with XML.Nodes do
    begin
      AddOpenTag('ExchequerSQLSettings');
      AddLeaf('Protocol').AsString := defProtocol;
      AddCloseTag;
    end;

    XML.SaveToFile('ExchSQLSettings.xml');
  finally
    XML.Free;
  end;
end;

    
// -----------------------------------------------------------------------------
Function TRecreateLoginsFrm.ValidOk(VCode: Char): Boolean;
Var
  lMachine : String;
  ConnectionFailed : Boolean;
Begin // ValidOk
  If (VCode = 'N') Then
  Begin
    // PKR. 06/11/2013. ABSEXCH-14684
    // Check that none of the fields contain spaces as it causes ExchSQLCreateLogin.exe
    //  to fail without returning an error.
    if (Pos(' ', Trim(edtSqlServer.Text)) > 0) then
    begin
      MessageDlg('The Microsoft SQL Server''s Computer Name cannot contain spaces', mtWarning, [mbOk], 0);
      Result := False;
      edtSqlServer.SetFocus;
    end;

    if Result then
    begin
      if (Pos(' ', Trim(edtInstance.Text)) > 0) then
      begin
        MessageDlg('The Microsoft SQL Server Instance Name cannot contain spaces', mtWarning, [mbOk], 0);
        Result := False;
        edtInstance.SetFocus;
      end;
    end;

    if Result then
    begin
      if (Pos(' ', Trim(edtDatabase.Text)) > 0) then
      begin
        MessageDlg('The Database Name cannot contain spaces', mtWarning, [mbOk], 0);
        Result := False;
        edtDatabase.SetFocus;
      end;
    end;

    if Result then
    begin
      If (edtSqlServer.Text <> '') Then
      Begin
        lMachine := Trim(edtSqlServer.Text);
        Result := CheckComputerExists(lMachine);

        If Result Then
        Begin
          GlobalSetupMap.Clear;
          GlobalSetupMap.Params := 'jhas23aS';
          GlobalSetupMap.FunctionId := fnCheckSQLDBCLR;
          If (Trim(edtInstance.Text) <> '') Then
            GlobalSetupMap.AddVariable ('V_SERVERNAME', Trim(edtSqlServer.Text) + '\' + Trim(edtInstance.Text))
          Else
            GlobalSetupMap.AddVariable ('V_SERVERNAME', Trim(edtSqlServer.Text));
          GlobalSetupMap.AddVariable ('V_CONNECTIONFAILED', '0');

          // Call the SQL Helper Function - .EXE will be on the CD so we can't use the normal SetupSQL.Dll/SQLHelpr.Exe routing
          RunApp('WSTATION\SETHELPR.EXE /SETUPBODGE', True);

          Result := GlobalSetupMap.Result;
          If Result Then
          Begin
            // Check Authentication Mode - 'Mixed' required
            GlobalSetupMap.Clear;
            GlobalSetupMap.Params := 'Qha2%daK';
            GlobalSetupMap.FunctionId := fnCheckSQLAuthMode;

            If (Trim(edtInstance.Text) <> '') Then
              GlobalSetupMap.AddVariable ('V_SERVERNAME', Trim(edtSqlServer.Text) + '\' + Trim(edtInstance.Text))
            Else
              GlobalSetupMap.AddVariable ('V_SERVERNAME', Trim(edtSqlServer.Text));

            // Call the SQL Helper Function - .EXE will be on the CD so we can't use the normal SetupSQL.Dll/SQLHelpr.Exe routing
            RunApp('WSTATION\SETHELPR.EXE /SETUPBODGE', True);

            Result := GlobalSetupMap.Result;
            If (Not Result) And (Not GlobalSetupMap.ExceptionRaised) Then
            Begin
              // Must be using Mixed Mode Authentication
              MessageDlg('Mixed Mode Authentication must be enabled on the specified SQL Server Instance for Exchequer SQL to install and run, ' +
                         'please notify your Database Administrator.', mtError, [mbOk], 0);
            End; // If (Not Result)
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
                           'Computer Name and Instance Name are correct.', mtError, [mbOk], 0);
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
    end;

    if Result then
      Result := CreateLogins;
  End { If }
  Else
    Result := True;
End; // ValidOk

{-----------------------------------------------------------------------------
  Procedure: btnBrowseClick
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure TRecreateLoginsFrm.btnBrowseClick(Sender: TObject);
Var
  lServer: String;
  Selected: Boolean;
Begin
  Inherited;
  Selected := _BrowseComputer('Select a MS SQL Server computer name', lServer, false);
  BringToFront;
  if Selected then
    edtSqlServer.Text := lServer;
End;

{-----------------------------------------------------------------------------
  Procedure: CheckComputerExists
  Author:    vmoura
-----------------------------------------------------------------------------}
Function TRecreateLoginsFrm.CheckComputerExists(
  Const pComputer: String): Boolean;
Begin
  if (Trim(pComputer) <> '') and (Trim(pComputer) <> '.') then
    Result := GetIPFromHost(Trim(pComputer)) <> ''
  else
    // it can be connect empty or '.' as local machine
    Result := True;
End;

// -----------------------------------------------------------------------------

function TRecreateLoginsFrm.RunShellCommand(CommandSpec: string; var Output: string): Boolean;
const
   BUFFER_SIZE = 2000;
var
  SecurityAttr       : TSecurityAttributes;
  hndRead,hndWrite   : THandle;
  start               : TStartUpInfo;
  ProcessInfo         : TProcessInformation;
  Buffer              : Pchar;
  BytesRead           : DWord;
  WaitResult          : DWord;
  PBytesRead          : ^DWord;
  ExitCode            : DWord;
  MsgBuffer           : string[255];
  PMsgBuffer          : PChar;
begin
  Result := False;
  Output := '';
  With SecurityAttr do
  begin
    nlength              := SizeOf(TSecurityAttributes);
    binherithandle       := true;
    lpsecuritydescriptor := nil;
  end;
  if Createpipe (hndRead, hndWrite, @SecurityAttr, 0) then
  begin
    Buffer  := AllocMem(BUFFER_SIZE + 1);
    FillChar(Start,Sizeof(Start),#0);
    start.cb          := SizeOf(start);
    start.hStdOutput  := hndWrite;
    start.hStdInput   := hndRead;
    start.dwFlags     := STARTF_USESTDHANDLES +
                         STARTF_USESHOWWINDOW;
    start.wShowWindow := SW_HIDE;
    if CreateProcess(nil,
       PChar(CommandSpec),
       @SecurityAttr,
       @SecurityAttr,
       true,
       NORMAL_PRIORITY_CLASS,
       nil,
       nil,
       start,
       ProcessInfo)
    then
    begin
      repeat
        WaitResult := WaitForSingleObject(ProcessInfo.hProcess,100);
        Application.ProcessMessages;
      until (WaitResult <> WAIT_TIMEOUT);
      if GetExitCodeProcess(ProcessInfo.hProcess, ExitCode) then
        Output := ErrorMessages[ExitCode]
      else
      begin
        PMsgBuffer := @MsgBuffer[1];
        FormatMessage(
            FORMAT_MESSAGE_ALLOCATE_BUFFER or FORMAT_MESSAGE_FROM_SYSTEM,
            nil,
            GetLastError(),
            0, // Default language
            PMsgBuffer,
            0,
            nil
        );
        MsgBuffer[0] := Chr(255);
        ShowMessage(MsgBuffer);
      end;
    end;
    FreeMem(Buffer);
    CloseHandle(hndWrite);
    CloseHandle(hndRead);
    CloseHandle(ProcessInfo.hProcess);
    CloseHandle(ProcessInfo.hThread);
    Result := True;
  end;
end;

// -----------------------------------------------------------------------------

function TRecreateLoginsFrm.CreateLogins: Boolean;
var
  CommandSpec, Output: string;
  UserName, Password: string;
  LoginResult: TLoginResult;
  ErrorMsg: string;
  protocol : string;
  value    : string;
begin
  Result := True;
  ErrorMsg := '';
  UserName := Uppercase(Trim(edtDatabase.Text)) + '_ADMIN';
  Password := SQLUtils.AdminPassword;

  // PKR. 24/10/2013. ABSEXCH-14684 Migration from Named Pipes to TCP 
  case comboConnectionProtocol.ItemIndex of
    0: protocol := 'tcp:'; // TCP
    1: protocol := 'np:';  // Named Pipes
    // PKR. 19/11/2013.  Added SQL Server default setting.
    2: protocol := '';     // SQL Server default
  end;
  
  // MH 05/05/2009: Modified to use renamed components under the v10.1 emulator
  // PKR. 24/10/2013. ABSEXCH-14684 Added protocol prefix to the server name.
  if (Trim(edtInstance.Text) <> '') then
  begin
    CommandSpec := 'ExchSQLCreateLogin /S ' +
                   protocol + Trim(edtSQLServer.Text) + '\' + Trim(edtInstance.Text) + ' ' +
                   Trim(edtDatabase.Text) + ' ' +
                   UserName + ' ' +
                   Password;
  end
  else
  begin
    // PKR. 06/11/2013.
    // If a protocol is specified, and there is no Instance name, then including
    //  a trailing \ on the server name causes the connection string to fail.
    CommandSpec := 'ExchSQLCreateLogin /S ' +
                   protocol + Trim(edtSQLServer.Text) + ' ' +
                   Trim(edtDatabase.Text) + ' ' +
                   UserName + ' ' +
                   Password;
  end;

  Screen.Cursor := crHourglass;
  try
    LoginResult := lrOk;
    // Create Server log-in
    if RunShellCommand(CommandSpec, Output) then
    begin
      if (Output <> '') then
      begin
        // We get a very unhelpful message back from ExchSQLCreateLogin.exe, saying
        // 'Unhandled Program exception?' (including the question mark!)
        // This looks very unprofessional, so change it.
        if (Pos('unhandled', Lowercase(Output)) > 0 ) then
        begin
          Output := 'Could not connect to SQL Database using this data.';
        end;
        ErrorMsg := Output + chr(13) + chr(10) + chr(13) + chr(10) +
                    'Please check that the Computer Name, Instance Name, ' + chr(13) + chr(10) +
                    'Connection Protocol and Database Name are correct, ' + chr(13) + chr(10) +
                    'or contact your Database Administrator.';
        Result := False;
      end
      else
      begin
        // PKR. 24/10/2013. ABSEXCH-14684 Migrate to tcp protocol from named pipes.
        // PKR. 19/11/2013. Set the default protocol to the one we've selected.
        defProtocol := protocol;
        SaveProtocolToConfigFile;
      end;
    end
    else
    begin
      ErrorMsg := 'Failed to create log-ins. Error #' + IntToStr(GetLastError) + '. ' +
                  'Please contact your technical support.';
      Result := False;
    end;

    // Re-create User log-ins
    // MH 05/05/2009: Modified to use renamed components under the v10.1 emulator
    CommandSpec := 'ExchSQLCreateLogin /R';
    //CommandSpec := 'iCoreCreateLogin /R';
    if Result then
    begin
      if RunShellCommand(CommandSpec, Output) then
      begin
        if (Output <> '') then
        begin
          ErrorMsg := Output +
                      ' Please check that the database name is correct, or contact your Database Administrator.';
          Result := False;
        end;
      end
      else
      begin
        ErrorMsg := 'Failed to create log-ins. Error #' + IntToStr(GetLastError) + '.' +
                    ' Please contact your technical support.';
        Result := False;
      end;
    end;

    if not Result then
      MessageDlg(ErrorMsg, mtError, [mbOk], 0);

  finally
    Screen.Cursor := crDefault;
  end;
end;

// -----------------------------------------------------------------------------

function TRecreateLoginsFrm.ParseCompanyLoginResult(Output: string): TLoginResult;
begin
  if (Pos('Created login', Output) > 0) then
    Result := lrOk
  else if (Pos('already exists', Output) > 0) then
    Result := lrAlreadyExists
  else
    Result := lrUnknownError;
end;

// -----------------------------------------------------------------------------

function TRecreateLoginsFrm.ParseServerLoginResult(Output: string): TLoginResult;
var
  StrPos: Integer;
  i: TLoginResult;
begin
  Result := lrUnknownError;
  // MH 05/05/2009: Modified to use renamed components under the v10.1 emulator
  StrPos := Pos(UpperCase('exchsqllogin.xml written successfully'), UpperCase(Output));
  if (StrPos > 0) then
    Result := lrOk
  else
  begin
    for i := Low(TestStrings) to High(TestStrings) do
    begin
      StrPos := Pos(TestStrings[i], Output);
      if (StrPos > 0) then
        Result := i;
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TRecreateLoginsFrm.ValidateEntries(Sender: TObject);
begin
  NextBtn.Enabled := (Trim(edtSqlServer.Text) <> '') and
                     (Trim(edtDatabase.Text) <> '');
end;

// -----------------------------------------------------------------------------

procedure TRecreateLoginsFrm.NextBtnClick(Sender: TObject);
begin
  inherited;

end;

// -----------------------------------------------------------------------------
function ReadProtocolFromConfigFile : string;
begin
  
end;


End.

