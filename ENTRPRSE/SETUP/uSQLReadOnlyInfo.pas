Unit uSQLReadOnlyInfo;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SETUPBAS, ExtCtrls, StdCtrls, SetupU, DB, ADODB;

Type
  TfrmSQLReadOnlyInfo = Class(TSetupTemplate)
    edtDbName: TEdit;
    lblDBNameDesc: TLabel;
    lblDBName: TLabel;
    panReportingUser: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    edtSqlUserName: TEdit;
    edtSQLUserPass: TEdit;
    ADOConnection: TADOConnection;
    ADOQuery: TADOQuery;
    procedure edtDbNameKeyPress(Sender: TObject; var Key: Char);
    procedure edtSqlUserNameKeyPress(Sender: TObject; var Key: Char);
  Private
    FServerName: string;
    FInstallType: string;
    procedure ReadWGEInstallInfo(var DLLParams: ParamRec);
    Function ValidOk(VCode: Char): Boolean; Override;
    //function CheckForSQLObject(const SQLQuery: ANSIString): Boolean;
    function QuerySQL(Const ErrorDesc, SQLQuery: ANSIString): Boolean;
    function SQLLoginExists(Const SQLLogin: string): Boolean;
    function SQLDatabaseExists(Const DatabaseName: string): Boolean;
    function SetEnterprisePath(const Path:String) : LongBool;
  Public
    W_MainDir, W_InstallerDir : ANSIString;
    property InstallType: string read FInstallType write FInstallType;
    property ServerName: string read FServerName write FServerName;
  End;

Function SCD_EntGetSQLReadOnlyInfo(Var DLLParams: ParamRec): LongBool; StdCall; export;

Var
  frmSQLReadOnlyInfo: TfrmSQLReadOnlyInfo;

Implementation

Uses
  Math, strutils, strutil, IniFiles, SQLH_MemMap, APIUtil, SQLUtils;

{$R *.dfm}

Const
  ValidDBNameChars = ['a'..'z', 'A'..'Z', '0'..'9'];

  INSTALL_NEW: string = 'A';
  INSTALL_UPGRADE: string = 'B';
  INSTALL_ADD_COMPANY: string = 'C';

//=========================================================================

Function SCD_EntGetSQLReadOnlyInfo(var DLLParams: ParamRec): LongBool;

// MH 05/09: Modified to use common function in SQL Utils
//  Function GetPassword: String;
//  Const
//    //Symbols : Array[1..10] of String = ('$', '*', '-', '!', '#', '@', '%', '&', '~', '.');
//    Alpha   : Array[1..26] Of String = ('a','b','c','d','e','f','g','h','j','i','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z');
//    Numeric : Array[1..10] Of String = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9');
//  Begin
//    Randomize;
//    Result := '';
//
//    Result := RandomFrom(Alpha) +
//              RandomFrom(Numeric) +
//              UpperCase(RandomFrom(Alpha)) +
//              RandomFrom(Numeric) +
//              UpperCase(RandomFrom(Alpha)) +
//              RandomFrom(Alpha) +
//              UpperCase(RandomFrom(Alpha)) +
//              RandomFrom(Alpha);
//  End; {GetPassword}
//
//  Function GetUsername(CompCode: String): String;
//  Begin
//    Randomize;
//
//    Result := 'REP' + CompCode + PadString(psLeft, inttostr(Random(1000)), '0', 3)
//  End; {GetUsername}

Var
  DlgPN, lServer, lDbName, lUser, lPass, lCompCode, lInstType: String;
Begin
  Result := True;

  GetVariable(DLLParams, 'DLGPREVNEXT', DlgPN); // get next dialog
  GetVariable(DLLParams, 'V_SQLDBNAME', lDbName); //  get sql database name
  GetVariable(DLLParams, 'SQL_USERLOGIN', lUser); // get user login
  GetVariable(DLLParams, 'SQL_USERPASS', lPass); // get user password
  GetVariable(DLLParams, 'V_GETCOMPCODE', lCompCode); // get company code
  GetVariable(DLLParams, 'V_INSTTYPE', lInstType);  // Installation Type - A-Install,B-Upgrade,C-Add Company

  frmSQLReadOnlyInfo := TfrmSQLReadOnlyInfo.Create(Application);

  With frmSQLReadOnlyInfo Do
  Begin
    GetVariable(DLLParams, 'V_MAINDIR', W_MainDir);
    W_MainDir := IncludeTrailingPathDelimiter(W_MainDir);

    GetVariable(DLLParams, 'INST', W_InstallerDir);
    W_InstallerDir := IncludeTrailingPathDelimiter(W_InstallerDir);
    Application.HelpFile := W_InstallerDir + 'SETUP.HLP';

    InstallType := lInstType;

    if ((lInstType = INSTALL_UPGRADE) or (lInstType = INSTALL_ADD_COMPANY)) then
      ReadWGEInstallInfo(DLLParams)
    else
    begin
      GetVariable(DLLParams, 'SQLSERVER', lServer);
      ServerName := lServer;
    end;

    If lDbName <> '' Then
      edtDbName.Text := lDbName
    Else
      edtDbName.Text := 'Exchequer';

    If Trim(lUser) <> '' Then
      edtSqlUserName.Text := Trim(luser)
    Else
      // MH 05/09: Modified to use common function in SQL Utils
      //edtSqlUserName.Text := GetUsername(lCompCode);
      edtSqlUserName.Text := ReportingUser (lCompCode);

    If Trim(lPass) <> '' Then
      edtSQLUserPass.Text := Trim(lPass)
    Else
      // MH 05/09: Modified to use common function in SQL Utils
      //edtSQLUserPass.Text := GetPassword;
      edtSQLUserPass.Text := ReportingPassword;

    If (Trim(lInstType) = 'C') Then
    Begin
      lblDBName.Visible := False;
      lblDBNameDesc.Visible := False;
      edtDbName.Visible := False;
      panReportingUser.Top := 86;
    End; // If (Trim(lInstType) = 'C')

    ShowModal;

    Case frmSQLReadOnlyInfo.ExitCode Of
      'B':
        Begin { Back }
          SetVariable(DLLParams, 'DIALOG', Copy(DlgPN, 1, 3));
        End;
      'N':
        Begin { Next }
          SetVariable(DLLParams, 'DIALOG', Copy(DlgPN, 4, 3));
          SetVariable(DLLParams, 'V_SQLDBNAME', Trim(edtDbName.Text));
          SetVariable(DLLParams, 'SQL_USERLOGIN', Trim(edtSqlUserName.Text));
          SetVariable(DLLParams, 'SQL_USERPASS', Trim(edtSQLUserPass.Text));
        End;
      'X':
        Begin { Exit Installation }
          SetVariable(DLLParams, 'DIALOG', '999')
        End;
    End; { If }
  End; {with frmGetSQLServerMachine do}

  frmSQLReadOnlyInfo.Free;
End;

//=========================================================================

{ TfrmSQLReadOnlyInfo }

//function TfrmSQLReadOnlyInfo.CheckForSQLObject(const SQLQuery: ANSIString): Boolean;
//const
//  CONNECTION_STRING = 'Provider=SQLNCLI.1;Integrated Security=SSPI;Initial Catalog=master;Data Source=%s';
//begin
//  Result := False;
//
//  if (Trim(FServerName) <> '') then
//  try
//    ADOConnection.ConnectionString := Format(CONNECTION_STRING, [ServerName]);
//    try
//      ADOQuery.SQL.Text := SQLQuery;
//      ADOQuery.Open;
//      Result := (ADOQuery.RecordCount > 0);
//    finally
//      ADOQuery.Close;
//    end;
//  finally
//    ADOConnection.Close;
//  end;
//
//end;

// -----------------------------------------------------------------------------

procedure TfrmSQLReadOnlyInfo.ReadWGEInstallInfo(var DLLParams: ParamRec);
var
  W_MainDir                                : String;
  WG_LicKey, WG_PrevServerPC, WG_Installed : String;
begin
  // Get path of Exchequer directory
  GetVariable(DLLParams, 'V_MAINDIR', W_MainDir);
  W_MainDir := IncludeTrailingBackslash(W_MainDir);

  // Open Setup.Usr to check for a WGE Licence from a previous Install/Upgrade
  If FileExists (W_MainDir + 'WSTATION\SETUP.USR') Then
  Begin
    With TIniFile.Create(W_MainDir + 'WSTATION\SETUP.USR') Do
    Begin
      Try
        { Check to see if the section exists }
        If SectionExists('SQLDB') Then
        Begin
          { Read settings from Setup.Usr }
          ServerName := ReadString ('SQLDB', 'Server', '');
        End; // If SectionExists('SQLDB')
      Finally
        Free;
      End;
    End; // With TIniFile.Create(W_MainDir + 'WSTATION\SETUP.USR')
  End; // If FileExists (W_MainDir + 'WSTATION\SETUP.USR')
  SetVariable(DLLParams, 'SQLSERVER', FServerName);
End;

// -----------------------------------------------------------------------------

{ Updates the PATH statement for the current process to include the Enterprise directory }
function TfrmSQLReadOnlyInfo.SetEnterprisePath(const Path:String) : LongBool;
var
  CurrentPath : String;
  EntDir      : String;
  NewPath     : ANSIString;
Begin { SetEnterprisePath }
  // Get current PATH for the process
  CurrentPath := SysUtils.GetEnvironmentVariable('PATH');

  // Check to see if it is already present in the path
  If (Pos(UpperCase(Path), UpperCase(CurrentPath)) = 0) Then Begin
    // Build the new path with the Enterprise directory at the start
    NewPath := Path + ';' + CurrentPath;

    // Update the environment settings for the current process
    SetEnvironmentVariable('PATH', PChar(NewPath));
  End; { If (Pos(UpperCase(EntDir), CurrentPath) = 0) }
End; { SetEnterprisePath }

//-------------------------------------------------------------------------

function TfrmSQLReadOnlyInfo.QuerySQL(Const ErrorDesc, SQLQuery: ANSIString): Boolean;
Var
  LibPath   : ANSIString;
  hSetupSQL : THandle;
  _SQLHLPR_CheckSQLObject : Function (Const SecCode, ExchequerPath, ServerName, SQLQuery : ShortString) : WordBool; StdCall;
Begin // QuerySQL
  Result := False;

  GlobalSetupMap.Clear;
  GlobalSetupMap.Params := 'jhas56aS';
  GlobalSetupMap.FunctionId := fnCheckSQLObject;
  GlobalSetupMap.AddVariable ('V_SERVERNAME', ServerName);
  GlobalSetupMap.AddVariable ('V_QUERY', SQLQuery);
  GlobalSetupMap.AddVariable ('V_ERRORDESC', ErrorDesc);

  // Call the SQL Helper Function - .EXE will be on the CD so we can't use the normal SetupSQL.Dll/SQLHelpr.Exe routing
//ShowMessage ('Run ' + W_InstallerDir + 'SETHELPR.EXE /SETUPBODGE');
  RunApp(W_InstallerDir + 'SETHELPR.EXE /SETUPBODGE', True);

  Result := GlobalSetupMap.Result;


(****
  // Load SetupSQL.DLL dynamically to check whether the company code already exists in Company.Dat
  LibPath := IncludeTrailingPathDelimiter(W_MainDir) + 'SetupSQL.Dll';
  hSetupSQL := LoadLibrary(PCHAR(LibPath));
  If (hSetupSQL = 0) Then
  Begin
    // Failed - try adding the directory into the PATH
    SetEnterprisePath(ExtractFilePath(LibPath));
    hSetupSQL := LoadLibrary(PCHAR(LibPath));
  End; // If (hSetupSQL = 0)

  If (hSetupSQL > HInstance_Error) Then
  Begin
    Try
      _SQLHLPR_CheckSQLObject := GetProcAddress(hSetupSQL, 'SQLHLPR_CheckSO');

      If Assigned(_SQLHLPR_CheckSQLObject) Then
        Result := _SQLHLPR_CheckSQLObject('jhas56aS', W_MainDir, FServerName, Query);
    Finally
      FreeLibrary(hSetupSQL);
    End; // Try..Finally
  End; // If (hSetupSQL > HInstance_Error)
****)
End; // QuerySQL

//-------------------------------------------------------------------------

function TfrmSQLReadOnlyInfo.SQLDatabaseExists(Const DatabaseName: string): Boolean;
begin
  Result := QuerySQL('validating the Database Name', 'select name from sys.databases where name = ''' + DatabaseName + '''');
  //Result := False;
end;

// -----------------------------------------------------------------------------

function TfrmSQLReadOnlyInfo.SQLLoginExists(Const SQLLogin: string): Boolean;
Begin // SQLLoginExists
  Result := QuerySQL('validating the Reporting User', 'select loginname from master.dbo.syslogins where loginname = ''' + SQLLogin + '''');
End; // SQLLoginExists

// -----------------------------------------------------------------------------

Function TfrmSQLReadOnlyInfo.ValidOk(VCode: Char): Boolean;

  Function CheckAlpha(Const Pass: String): Boolean;
  Var
    lCont: Integer;
  Begin
    Result := False;
    For lCont := 1 To Length(Pass) Do
      If Pass[lCont] In ['a'..'z'] Then
      Begin
        Result := True;
        Break;
      End; {if Pass[lCont] in ['a'..'z'] then}
  End; {function CheckAlpha(const Pass: String): Boolean;}

  Function CheckAlphaUP(Const Pass: String): Boolean;
  Var
    lCont: Integer;
  Begin
    Result := False;
    For lCont := 1 To Length(Pass) Do
      If Pass[lCont] In ['A'..'Z'] Then
      Begin
        Result := True;
        Break;
      End; {if Pass[lCont] in ['A'..'Z'] then}
  End; {function CheckAlphaUP(const Pass: String): Boolean;}

  Function CheckNumeric(Const Pass: String): Boolean;
  Var
    lCont: Integer;
  Begin
    Result := False;
    For lCont := 1 To Length(Pass) Do
      If Pass[lCont] In ['0'..'9'] Then
      Begin
        Result := True;
        Break;
      End; {if Pass[lCont] in ['A'..'Z'] then}
  End; {function CheckNumeric(const Pass: String): Boolean;}

  Function CheckNonAlphaNumeric(Const Pass: String): Boolean;
  Var
    lCont: Integer;
  Begin
    Result := False;
    For lCont := 1 To Length(Pass) Do
      If Not CheckAlpha(Pass[lCont]) And Not CheckAlphaUP(Pass[lCont]) And Not
        CheckNumeric(Pass[lCont]) Then
      Begin
        Result := True;
        Break
      End;
  End; {function CheckNonAlphaNumeric(const Pass: String): Boolean;}

  //------------------------------

  // Check the company code to see if it is a) set and b) only contains supported characters
  Function ValidDBName : Boolean;
  Var
    sDBName : ShortString;
    I: SmallInt;
  Begin // ValidDBName
    sDBName := Trim(edtDbName.Text);
    Result := (sDBName <> '') And (Not (sDBName[1] In ['0'..'9']));
    If Result Then
    Begin
      For I := 1 To Length(sDBName) Do
      Begin
        If Not (sDBName[I] In ValidDBNameChars) Then
        Begin
          Result := False;
          Break;
        End; { If }
      End; { For }
    End; { If }
  End; // ValidDBName

  //------------------------------

  Function ValidUserId : Boolean;
  Var
    sUserId : ShortString;
    I: SmallInt;
  Begin // ValidUserId
    sUserId := Trim(edtSqlUserName.Text);
    Result := (sUserId <> '') And (Not (sUserId[1] In ['0'..'9']));
    If Result Then
    Begin
      For I := 1 To Length(sUserId) Do
      Begin
        If Not (sUserId[I] In ValidDBNameChars) Then
        Begin
          Result := False;
          Break;
        End; { If }
      End; { For }
    End; { If }
  End; // ValidUserId

  //------------------------------

Var
  lMachine, lInstance: String;
  lPass: String;
Begin
  Application.ProcessMessages;
  If (VCode = 'N') Then
  Begin
    // Check database name only when installing
    If edtDbName.Visible Then
    Begin
      Result := ValidDBName;
      If Result Then
      Begin
        Result := Not SQLDatabaseExists(edtDbName.Text);
        If (Not Result) Then
          MessageDlg('A Database with that Name already exists in SQL Server', mtError, [mbOk], 0);
      End // If edtDbName.Visible
      Else
        MessageDlg('The Database Name cannot be left blank, can only contain the ' +
                   'characters ''a'' to ''z'', ''A'' to ''Z'' and ''0'' to ''9'' and cannot start ' +
                   'with a number', mtError, [mbOk], 0);
    End // If edtDbName.Visible
    Else
      Result := True;

    If Result Then
    Begin
      // check User Id
      Result := ValidUserId;
      If Result Then
      Begin
        If SQLLoginExists(Trim(edtSqlUserName.Text)) Then
        Begin
          MessageDlg('A user with that User Id already exists in SQL Server', mtError, [mbOk], 0);
          Result := False;
        End; // If SQLLoginExists(Trim(edtSqlUserName.Text))
      End // If Result
      Else
        MessageDlg('The User Id for the Reporting User cannot be left blank, can only contain the ' +
                   'characters ''a'' to ''z'', ''A'' to ''Z'' and ''0'' to ''9'' and cannot start ' +
                   'with a number', mtError, [mbOk], 0);
    End; // If Result

    If Result Then
    Begin
      {check password}
      lPass := Trim(edtSQLUserPass.Text);
      Result := (lPass <> '');
      If Result Then
      Begin
        Result := (CheckAlpha(lPass) And CheckAlphaUP(lPass) And CheckNumeric(lPass)) Or
                  (CheckAlpha(lPass) And CheckAlphaUP(lPass) And CheckNonAlphaNumeric(lPass)) Or
                  (CheckAlpha(lPass) And CheckNumeric(lPass) And CheckNonAlphaNumeric(lPass)) Or
                  (CheckAlphaUP(lPass) And CheckNumeric(lPass) And CheckNonAlphaNumeric(lPass));
        If (Not Result) Then
        Begin
          Result := (MessageDlg('MS SQL Server may consider this password not complex enough, generally a password ' +
                                'should include Uppercase, Lowercase, Numeric and non-Alphanumeric characters.' + #13#10 +
                                'Do you want to continue?', mtWarning, [mbYes, mbNo], 0) = mrYes);
        End; // If (Not Result)
      End // If Result
      Else
        MessageDlg('The Reporting User Password cannot be left blank', mtError, [mbOk], 0);
    End; // If Result
  End { If }
  Else
    Result := True;
End;

// -----------------------------------------------------------------------------

procedure TfrmSQLReadOnlyInfo.edtDbNameKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;

  // Only allow 'A'..'Z' and '0'..'9' plus backspace
  If Not (key In ValidDBNameChars + [#8]) Then
    Key := #0;
end;

//-------------------------------------------------------------------------

procedure TfrmSQLReadOnlyInfo.edtSqlUserNameKeyPress(Sender: TObject; var Key: Char);
begin
  inherited;

  // Only allow 'A'..'Z' and '0'..'9' plus backspace
  If Not (key In ValidDBNameChars + [#8]) Then
    Key := #0;
end;

//=========================================================================

End.

