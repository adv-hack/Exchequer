unit CheckAuthMode;

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, WiseUtil, IniFiles;

Function Setup_CheckAuthenticationMode (Var DLLParams: ParamRec) : LongBool;

implementation

Uses ADODB, SQLH_MemMap, ActiveX, CheckSQLObject, SQLCallerU;

//=========================================================================

Function Setup_CheckAuthenticationMode (Var DLLParams: ParamRec) : LongBool;
Var
  W_ServerName, W_ErrorDesc : ANSIString;
  SQLCaller: TSQLCaller;
  OK : Boolean;
Begin // Setup_CheckAuthenticationMode
  Result := False;

  If (GlobalSetupMap.Params = 'Qha2%daK') Then
  Begin
    Try
      CoInitialize(NIL);
      Try
        GetVariable(DLLParams, 'V_SERVERNAME', W_ServerName);

        If (Trim(W_ServerName) <> '') Then
        Begin
          SQLCaller := TSQLCaller.Create;
          try
            SQLCaller.ConnectionString := Format(CONNECTION_STRING, [W_ServerName]);

            SQLCaller.Select('EXECUTE xp_loginconfig', '');

            With SQLCaller.Records Do
            Begin
              OK := FindFirst;
              While OK Do
              Begin
                If (Fields[0].AsString = 'login mode') Then
                Begin
                  // Known Values = 'Mixed' || 'Windows NT Authentication'
                  Result := (UpperCase(Trim(Fields[1].AsString)) = 'MIXED');
                  Break;
                End // If (Fields[0].AsString = 'login mode')
                Else
                  OK := FindNext;
              End; // While OK
            End; // With SQLCaller.Records
          finally
            SQLCaller.Free;
          end;
        End; // If (Trim(W_ServerName) <> '')
      Finally
        CoUnInitialize;
      End; // Try..Finally
    Except
      On E:Exception Do
      Begin
        W_ErrorDesc := 'The following exception was raised whilst checking the Server''s CLR Integration:-'#13#13 + E.Message +
                       #13#13'Please ensure that the Server and Instance Name are correct';
        Windows.MessageBox(0, PCHAR(W_ErrorDesc), 'CheckSQLObject', MB_OK Or MB_IconStop Or MB_SystemModal);
        Result := False;
        GlobalSetupMap.Exception := E;
      End; // On E:Exception
    End; // Try..Except
  End; // If (GlobalSetupMap.Params = 'jhas56aS')
//ShowMessage ('Setup_CheckSQLObject.Fini');
End; // Setup_CheckAuthenticationMode

//=========================================================================

end.
