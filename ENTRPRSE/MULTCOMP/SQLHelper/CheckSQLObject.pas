unit CheckSQLObject;

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, WiseUtil, IniFiles;

Const
  CONNECTION_STRING = 'Provider=SQLOLEDB.1;Integrated Security=SSPI;Initial Catalog=master;Data Source=%s';

Function Setup_CheckSQLObject (Var DLLParams: ParamRec) : LongBool;

implementation

Uses ADODB, SQLH_MemMap, ActiveX,ExchConnect;

//=========================================================================

Function Setup_CheckSQLObject (Var DLLParams: ParamRec) : LongBool;
Var
  ADOConnection: TExchConnection;  //RB:28/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
  ADOQuery : TADOQuery;
  W_ServerName, W_Query, W_ErrorDesc : ANSIString;
Begin // Setup_CheckSQLObject
//ShowMessage ('Setup_CheckSQLObject.Start');
  Result := False;

  If (GlobalSetupMap.Params = 'jhas56aS') Then
  Begin
    Try
//ShowMessage ('Setup_CheckSQLObject.1');
      CoInitialize(NIL);
//ShowMessage ('Setup_CheckSQLObject.2');
      Try
        GetVariable(DLLParams, 'V_SERVERNAME', W_ServerName);
        GetVariable(DLLParams, 'V_QUERY', W_Query);

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
              ADOQuery.Open;
              Result := (ADOQuery.RecordCount > 0);
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
        GetVariable(DLLParams, 'V_ERRORDESC', W_ErrorDesc);
        W_ErrorDesc := 'The following exception was raised whilst ' + W_ErrorDesc + ':-'#13#13 + E.Message +
                       #13#13'Please ensure that the Server and Instance Name are correct';
        Windows.MessageBox(0, PCHAR(W_ErrorDesc), 'CheckSQLObject', MB_OK Or MB_IconStop Or MB_SystemModal);
        Result := False;
      End; // On E:Exception
    End; // Try..Except
  End; // If (GlobalSetupMap.Params = 'jhas56aS')
//ShowMessage ('Setup_CheckSQLObject.Fini');
End; // Setup_CheckSQLObject

//=========================================================================

end.
