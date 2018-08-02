unit GetConnStr;

interface

Uses Classes, StrUtils, Sysutils, ADODB, WiseUtil, SQLH_MemMap;

// Returns the common connection string in V_CONNECTIONSTRING
Function GetConnectionInfo(var DLLParams: ParamRec): LongBool;

implementation

Uses SQLUtils, SQLDataReplication,ExchConnect;

// Returns the common connection string in V_CONNECTIONSTRING
Function GetConnectionInfo(var DLLParams: ParamRec): LongBool;
Var
  ADOConnection: TExchConnection;  //RB:28/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
  slCompanies : TStringList;
  W_MainDir, sLogin, ConnectionString, DataSource, Server : AnsiString;
  I, DLLStatus, iPos : LongInt;

  //------------------------------

  Function GetLogin (Const CompCode : ShortString; Const ReadOnly : Boolean; Var Login : ANSIString) : Boolean;
  Var
    ConnectionString: WideString;  //RB:28/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
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

      iPos := Pos('User Id=', ConnectionString);
      If (iPos > 0) Then
      Begin
        Login := Copy(ConnectionString, iPos+8, 255);
        iPos := Pos(';', Login);
        If (iPos > 0) Then Delete(Login, iPos, 255);
        Login := Trim(Login);
      End // If (iPos > 0)
      Else
        Raise Exception.Create ('SQLHelpr.GetConnectionInfo - Unable to get User ID');
    End  // If Result
    Else
      Raise Exception.Create ('SQLHelpr.GetConnectionInfo - Error ' + IntToStr(Res) + ' retrieving ' + IfThen(ReadOnly, 'Reporting', '') + ' Connection String for ' + CompCode);
  End; // GetLogin

  //------------------------------

Begin // GetConnectionInfo
  DLLStatus := GetCommonConnectionString(ConnectionString, NIL);
  If (DLLStatus = 0) Then
  Begin
    SetVariable (DLLParams, 'V_CONNECTIONSTRING', ConnectionString);
    If (Length(ConnectionString) > 255) Then
      Raise Exception.Create ('SQLHelpr.GetCommonConnectionStr: Connection String Too Long');

    // For each Company get the company Admin and Reporting connection strings and
    // extract the users and drop them
    GetVariable(DLLParams, 'V_MAINDIR', W_MainDir);
    slCompanies := GetCompanyList(W_MainDir);

    GlobalSetupMap.AddVariable('V_SQLCOMPCOUNT', IntToStr(slCompanies.Count));

    // MH 19/06/2012 v7.0 ABSEXCH-12433: Modified loop to set DLLStatus for error handling instead of
    // Result as function return value is based on DLLStatus. Also Result wasn't being initialised and
    // had different default values for different versions of Windows - this code actually failed
    // under Win7 64-bit after returning the first companies Reporting User causing the Perv->SQL
    // Conversion to crash
    For I := 0 To (slCompanies.Count - 1) Do
    Begin
      If GetLogin (slCompanies[I], True, sLogin) Then
        GlobalSetupMap.AddVariable('V_COMP' + IntToStr(I+1) + 'REP', sLogin)
      Else
        DLLStatus := 10001;

      If (DLLStatus = 0) Then
      Begin
        If GetLogin (slCompanies[I], False, sLogin) Then
          GlobalSetupMap.AddVariable('V_COMP' + IntToStr(I+1) + 'ADM', sLogin)
        Else
          DLLStatus := 10002;
      End; // If (DLLStatus = 0)

      If (DLLStatus <> 0) Then
        Break;
    End; // For I
    slCompanies.Free;
  End; // If If (DLLStatus = 0)

  SetVariable(DLLParams, 'V_DLLERROR', IntToStr(DLLStatus));
  Result := (DLLStatus <> 0);
End; // GetConnectionInfo

end.


