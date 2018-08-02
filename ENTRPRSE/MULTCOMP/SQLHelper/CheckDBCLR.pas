unit CheckDBCLR;

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, WiseUtil, IniFiles;

Function Setup_CheckDBCLR (Var DLLParams: ParamRec) : LongBool;

implementation

Uses ADODB, SQLH_MemMap, ActiveX, CheckSQLObject,ExchConnect;

//=========================================================================

Function Setup_CheckDBCLR (Var DLLParams: ParamRec) : LongBool;
Var
  ADOConnection: TExchConnection;  //RB:28/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
  ADOQuery : TADOQuery;
  W_ServerName, W_ErrorDesc, W_Query : ANSIString;
  ConnectionFailed : Boolean;
Begin // Setup_CheckDBCLR
//ShowMessage ('Setup_CheckSQLObject.Start');
  Result := False;
  ConnectionFailed := False;

  If (GlobalSetupMap.Params = 'jhas23aS') Then
  Begin
    Try
//ShowMessage ('Setup_CheckSQLObject.1');
      CoInitialize(NIL);
//ShowMessage ('Setup_CheckSQLObject.2');
      Try
        GetVariable(DLLParams, 'V_SERVERNAME', W_ServerName);
        W_Query := 'select value_in_use from sys.configurations where configuration_id = 1562';

//ShowMessage ('Setup_CheckSQLObject.3');
        If (Trim(W_ServerName) <> '') Then
        Begin
//ShowMessage ('Setup_CheckSQLObject.4');
          ADOConnection := TExchConnection.Create(NIL);   //RB:28/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
          Try
//ShowMessage ('Setup_CheckSQLObject.5');
            ADOConnection.ConnectionString := Format(CONNECTION_STRING, [W_ServerName]);

            ADOQuery := TADOQuery.Create(NIL);
//ShowMessage ('Setup_CheckSQLObject.6');
            try
              ADOQuery.Connection := ADOConnection;
//ShowMessage ('Setup_CheckSQLObject.7');
              ADOQuery.SQL.Text := W_Query;
//ShowMessage ('Setup_CheckSQLObject.8');

              Try
                ADOQuery.Open;
              Except
                Result := False;
                ConnectionFailed := True;
              End; // Try..Except

              If (Not ConnectionFailed) And (ADOQuery.RecordCount = 1) Then
                Result := (ADOQuery.Fields[0].AsInteger = 1);
            finally
//ShowMessage ('Setup_CheckSQLObject.9');
              ADOQuery.Close;
              ADOQuery.Free;
            end;
          Finally
//ShowMessage ('Setup_CheckSQLObject.10');
            ADOConnection.Close;
            ADOConnection.Free;
          End;
//ShowMessage ('Setup_CheckSQLObject.11');
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

    SetVariable (DLLParams, 'V_CONNECTIONFAILED', IntToStr(Ord(ConnectionFailed)));
  End; // If (GlobalSetupMap.Params = 'jhas56aS')
//ShowMessage ('Setup_CheckSQLObject.Fini');
End; // Setup_CheckDBCLR

//=========================================================================

end.
