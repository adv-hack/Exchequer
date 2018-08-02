unit CheckOLEAuto;

interface

Uses Classes, Dialogs, Forms, SysUtils, Windows, WiseUtil, IniFiles;

Function Setup_CheckOLEAuto (Var DLLParams: ParamRec) : LongBool;

implementation

Uses ADODB, SQLH_MemMap, ActiveX, CheckSQLObject,ExchConnect;

//=========================================================================

Function Setup_CheckOLEAuto (Var DLLParams: ParamRec) : LongBool;
Var
  ADOConnection: TExchConnection;  //RB:28/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
  ADOQuery : TADOQuery;
  W_ServerName, W_ErrorDesc, W_Query : ANSIString;
  ConnectionFailed : Boolean;
Begin // Setup_CheckOLEAuto
//ShowMessage ('Setup_CheckOLEAuto.Start');
  Result := False;
  ConnectionFailed := False;

  If (GlobalSetupMap.Params = 'jhas23aS') Then
  Begin
    Try
      CoInitialize(NIL);
      Try
        GetVariable(DLLParams, 'V_SERVERNAME', W_ServerName);
        W_Query := 'select value_in_use from sys.configurations where configuration_id = 16388';

        If (Trim(W_ServerName) <> '') Then
        Begin
          ADOConnection := TExchConnection.Create(NIL);   //RB:28/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
          Try
            ADOConnection.ConnectionString := Format(CONNECTION_STRING, [W_ServerName]);

            ADOQuery := TADOQuery.Create(NIL);
            try
              ADOQuery.Connection := ADOConnection;
              ADOQuery.SQL.Text := W_Query;

              Try
                ADOQuery.Open;
              Except
                Result := False;
                ConnectionFailed := True;
              End; // Try..Except

              If (Not ConnectionFailed) And (ADOQuery.RecordCount = 1) Then
                Result := (ADOQuery.Fields[0].AsInteger = 1);
            finally
              ADOQuery.Close;
              ADOQuery.Free;
            end;
          Finally
            ADOConnection.Close;
            ADOConnection.Free;
          End;
        End; // If (Trim(W_ServerName) <> '')
      Finally
        CoUnInitialize;
      End; // Try..Finally
    Except
      On E:Exception Do
      Begin
        W_ErrorDesc := 'The following exception was raised whilst checking the Server''s OLE Automation Setting:-'#13#13 + E.Message +
                       #13#13'Please ensure that the Server and Instance Name are correct';
        Windows.MessageBox(0, PCHAR(W_ErrorDesc), 'CheckOLEAuto', MB_OK Or MB_IconStop Or MB_SystemModal);
        Result := False;
        GlobalSetupMap.Exception := E;
      End; // On E:Exception
    End; // Try..Except

    SetVariable (DLLParams, 'V_CONNECTIONFAILED', IntToStr(Ord(ConnectionFailed)));
  End; // If (GlobalSetupMap.Params = 'jhas56aS')
//ShowMessage ('Setup_CheckOLEAuto.Fini');
End; // Setup_CheckOLEAuto

//=========================================================================

end.
