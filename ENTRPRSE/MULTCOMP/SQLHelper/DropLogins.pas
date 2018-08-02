unit DropLogins;

interface

Uses Classes, Dialogs, StrUtils, Sysutils, Windows, ADODB, WiseUtil, SQLH_MemMap;

// Runs through Company.Dat and drops the SQL Database Engine Logins for each company
Function DropSQLLogins(var DLLParams: ParamRec): LongBool;

implementation

Uses SQLUtils, SQLDataReplication,ExchConnect;

// Runs through Company.Dat and drops the SQL Database Engine Logins for each company
Function DropSQLLogins(var DLLParams: ParamRec): LongBool;
Const
  GenericConnectionString = 'Provider=SQLOLEDB.1;Integrated Security=SSPI;Initial Catalog=%s;Data Source=%s';
Var
  ADOConnection: TExchConnection;  //RB:28/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
  slCompanies, slUsers : TStringList;
  W_MainDir, W_Server, W_ErrorDesc : ANSIString;
  I : SmallInt;

  //------------------------------

  Function GetLogin (Const CompCode : ShortString; Const ReadOnly : Boolean; Var UsersList : TStringList) : Boolean;
  Var
    ConnectionString: WideString;
    UserID : ShortString;
    iPos, Res : LongInt;
  Begin // GetLogin
    Res := GetConnectionString(CompCode, ReadOnly, ConnectionString);

    Result := (Res = 0);

    If Result Then
    Begin
      // Parse connection string into individual elements
      //
      //   e.g.  Provider=SQLOLEDB.1;Data Source=IRIS-6CB13B02D4\IRISSOFTWARE;Initial Catalog=ExchConv;User Id=ExchConv_Admin;Password=Password123
      //

      // Data Source - needed to connect to DB to validate Reporting User Id's etc...
      iPos := Pos('User Id=', ConnectionString);
      If (iPos > 0) Then
      Begin
        UserID := Copy(ConnectionString, iPos+8, 255);
        iPos := Pos(';', UserID);
        If (iPos > 0) Then Delete(UserID, iPos, 255);

        UserId := Trim(UserId);
        If (UserId <> '') Then
          UsersList.Add(UserID);
      End // If (iPos > 0)
      Else
        Raise Exception.Create ('SQLHelpr.DropSQLLogins - Unable to get Data Source');
    End  // If Result
    Else
      Raise Exception.Create ('SQLHelpr.DropSQLLogins - Error ' + IntToStr(Res) + ' retrieving ' + IfThen(ReadOnly, 'Reporting', '') + ' Connection String for ' + CompCode);
  End; // GetLogin

  //------------------------------

Begin // DropSQLLogins
  Result := False;

  GetVariable(DLLParams, 'V_MAINDIR', W_MainDir);
  GetVariable(DLLParams, 'V_SERVER', W_Server);

  slUsers := TStringList.Create;
  Try
    // For each Company get the company Admin and Reporting connection strings and
    // extract the users and drop them
    slCompanies := GetCompanyList(W_MainDir);
    For I := 0 To (slCompanies.Count - 1) Do
    Begin
      Result := GetLogin (slCompanies[I], True, slUsers);
      If Result Then
        Result := GetLogin (slCompanies[I], False, slUsers);

      If (Not Result) Then
        Break;
    End; // For I
    slCompanies.Free;

    If Result and (slUsers.Count > 0) Then
    Begin
      Try
        ADOConnection := TExchConnection.Create(NIL);  //RB:28/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
        Try
          ADOConnection.ConnectionString := Format(GenericConnectionString, ['master', W_Server]);
          ADOConnection.Open;
          Try
            For I := 0 To (slUsers.Count - 1) Do
            Begin
              Try
                ADOConnection.Execute ('Drop Login [' + slUsers[I] + ']');
              Except
                On E:Exception Do
                Begin
                  W_ErrorDesc := 'The following exception was raised whilst dropping the user ' +
                                 QuotedStr(slUsers[I]) + ' on the server ' + W_Server + ':-'#13#13 +
                                 E.Message;
                  Windows.MessageBox(0, PCHAR(W_ErrorDesc), 'DropSQLLogins', MB_OK Or MB_IconStop Or MB_SystemModal);
                  Result := False;
                End; // On E:Exception
              End; // On E:Exception
            End; // For I

            Result := True;
          Finally
            ADOConnection.Close;
          End; // Try..Finally
        Finally
          ADOConnection.Free;
        End; // Try..Finally
      Except
        On E:Exception Do
        Begin
          W_ErrorDesc := 'The following exception was raised whilst dropping the Database Users'+
                         ' on the server ' + W_Server + ':-'#13#13 + E.Message;
          Windows.MessageBox(0, PCHAR(W_ErrorDesc), 'DropSQLLogins', MB_OK Or MB_IconStop Or MB_SystemModal);
          Result := False;
        End; // On E:Exception
      End; // Try..Except
    End; // If Result and (slUsers.Count > 0)
  Finally
    slUsers.Free;
  End; // Try..Finally
End; // DropSQLLogins

end.
