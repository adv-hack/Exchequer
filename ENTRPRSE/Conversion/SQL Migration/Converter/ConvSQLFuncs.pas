unit ConvSQLFuncs;

interface

uses Windows, SysUtils, Classes, Forms, Dialogs, ADODB, oConvertOptions;

// Returns TRUE if the specified user existing in the Database Instance
Function DatabaseUserExists (RepUserID : ShortString) : Boolean;

// Drops the Exchequer SQL database on the SQL Server instance.
// Returns TRUE if the database was dropped successfully
Function DropDatabase : Boolean;

implementation

Const
  GenericConnectionString = 'Provider=SQLOLEDB.1;Integrated Security=SSPI;Initial Catalog=%s;Data Source=%s';

//=========================================================================

// Returns TRUE if the specified user existing in the Database Instance
Function DatabaseUserExists (RepUserID : ShortString) : Boolean;
Var
  ADOConnection: TADOConnection;
  ADOQuery : TADOQuery;
  W_ErrorDesc : ANSIString;
Begin // DBUserExists
  Try
    RepUserID := UpperCase(Trim(RepUserId));

    ADOConnection := TADOConnection.Create(NIL);
    Try
      ADOConnection.ConnectionString := Format(GenericConnectionString, ['master', ConversionOptions.coDataSource]);

      ADOQuery := TADOQuery.Create(NIL);
      try
        ADOQuery.Connection := ADOConnection;
        ADOQuery.SQL.Text := 'select loginname from master.dbo.syslogins where loginname = ''' + RepUserId + '''';
        ADOQuery.Open;
        Result := (ADOQuery.RecordCount > 0);
      finally
        ADOQuery.Close;
        ADOQuery.Free;
      end;
    Finally
      ADOConnection.Close;
      ADOConnection.Free;
    End;
  Except
    On E:Exception Do
    Begin
      W_ErrorDesc := 'The following exception was raised whilst validating the User Id ' + RepUserId + ':-'#13#13 + E.Message;
      Windows.MessageBox(0, PCHAR(W_ErrorDesc), 'DBUserExists', MB_OK Or MB_IconStop Or MB_SystemModal);
      Result := False;
    End; // On E:Exception
  End; // Try..Except
End; // DBUserExists


//=========================================================================

// Drops the Exchequer SQL database on the SQL Server instance.
// Returns TRUE if the database was dropped successfully
Function DropDatabase : Boolean;
Var
  ADOConnection: TADOConnection;
  ADOQuery : TADOQuery;
  Tables : TStringList;
  W_ErrorDesc : ANSIString;
  DBMatch : Boolean;
  iLogin : SmallInt;
Begin // DropDatabase
  Result := False;
  Try
    ADOConnection := TADOConnection.Create(NIL);
    Try
      ADOConnection.ConnectionString := Format(GenericConnectionString, [ConversionOptions.coDatabaseName, ConversionOptions.coDataSource]);
      ADOConnection.Open;
      Try
        Tables := TStringList.Create;
        Tables.CaseSensitive := False;
        Try
          // Get a list of the table names in the connected database just to check it is an Exchequer
          // database - it would be embarrassing if we accidentally deleted MS CRM for example!
          ADOConnection.GetTableNames(Tables);
          DBMatch := (Tables.IndexOf ('COMPANY') >= 0) And
                     (Tables.IndexOf ('IRISDatasetConnection') >= 0) And
                     (Tables.IndexOf ('IRISXMLSchema') >= 0) And
                     (Tables.IndexOf ('CUSTSUPP') >= 0) And
                     (Tables.IndexOf ('DOCUMENT') >= 0);

        Finally
          FreeAndNIL(Tables);
        End; // Try..Finally
      Finally
        ADOConnection.Close;
      End; // Try..Finally
    Finally
      ADOConnection.Free;
    End; // Try..Finally

    If DBMatch Then
    Begin
      ADOConnection := TADOConnection.Create(NIL);
      Try
        // Valid Exchequer Database - Re-open connection and Kill It!
        ADOConnection.ConnectionString := Format(GenericConnectionString, ['master', ConversionOptions.coDataSource]);
        ADOConnection.Open;
        Try
          For iLogin := 0 To (ConversionOptions.coSQLLoginCount - 1) Do
            If DatabaseUserExists(ConversionOptions.coSQLLogins[iLogin]) Then
              ADOConnection.Execute ('Drop Login [' + ConversionOptions.coSQLLogins[iLogin] + ']');

          ADOConnection.Execute ('Drop Database [' + ConversionOptions.coDatabaseName + ']');
          Result := True;
        Finally
          ADOConnection.Close;
        End; // Try..Finally
      Finally
        ADOConnection.Free;
      End; // Try..Finally
    End // If DBMatch
    Else
    Begin
      MessageDlg (ConversionOptions.coDatabaseName + ' on ' + ConversionOptions.coDataSource + ' does not appear to be a valid Exchequer SQL Edition database - conversion aborted', mtError, [mbOK], 0);
      Result := False;
    End; // Else
  Except
    On E:Exception Do
    Begin
      W_ErrorDesc := 'The following exception was raised whilst dropping the Database ' + ConversionOptions.coDatabaseName +
                     ' on the server ' + ConversionOptions.coDataSource + ':-'#13#13 + E.Message;
      Windows.MessageBox(0, PCHAR(W_ErrorDesc), 'DBUserExists', MB_OK Or MB_IconStop Or MB_SystemModal);
      Result := False;
    End; // On E:Exception
  End; // Try..Except
End; // DropDatabase

//=========================================================================

end.
