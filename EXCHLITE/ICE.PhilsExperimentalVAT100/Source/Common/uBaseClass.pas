{-----------------------------------------------------------------------------
 Unit Name: uBaseClass
 Author:    vmoura
 Date:
 Purpose:
 History:
-----------------------------------------------------------------------------}

Unit uBaseClass;

Interface

Uses

  ADODB
  ;

Type
  _Base = Class
  Private
    fDataPath: String;
    fConnectionString: String;
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Procedure DoLogMessage(Const pWhere: String; pError: Cardinal; Const
      pExtraMsg: String = ''; Const pAddtoLog: Boolean = True; Const pAddToDb:
      Boolean = False); Virtual;
    Procedure LogMessage(Const pMessage: String);
    Procedure LogToDB(Const pWhere, pMsg: String);
  Published
    Property DataPath: String Read fDataPath Write fDataPath;
    Property ConnectionString: String Read fConnectionString Write
      fConnectionString;
  End;

(*  _AdoBaseTable = Class(_Base)
  Private
    fTable: TAdoTable;
    Function GetActive: Boolean;
    Function GetConnection: TADOConnection;
    Procedure SetConnection(Const Value: TADOConnection);
  Protected
    Function DbGetValue(Const pValue: String): String; Virtual; Abstract;
    Procedure DBSetValue(Const pDesc: String; pValue: Variant); Virtual;
      Abstract;
  Public
    Constructor Create;
    Destructor Destroy; Override;
    Procedure Refresh;
  Published
    Property Active: Boolean Read GetActive;
    Property Connection: TADOConnection Read GetConnection Write SetConnection;
    Property Table: TAdoTable Read fTable Write fTable;
  End;*)

Procedure UpdateLog(Const pWhere: String; pError: Cardinal;
  Const pExtraMsg: String = '');

Implementation

Uses uCommon, StrUtils,
  Sysutils;

Procedure UpdateLog(Const pWhere: String; pError: Cardinal;
  Const pExtraMsg: String = '');
Var
  Base: _Base;
Begin
  Base := _Base.Create;
  Try
    Base.DoLogMessage(pWhere, pError, pExtraMsg);
  Finally
    Base.Free;
  End;
End;

{ _Base }

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor _Base.Create;
Begin
  Inherited;
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor _Base.Destroy;
Begin
  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: DoLogMessage
  Author:    vmoura

  I can set a new log message or just use a simple one
-----------------------------------------------------------------------------}
Procedure _Base.DoLogMessage(Const pWhere: String; pError: Cardinal; Const
  pExtraMsg: String = ''; Const pAddtoLog: Boolean = True; Const pAddToDb:
  Boolean = False);
Var
  lMsg: String;
Begin
  If pError > 0 Then
    lMsg := 'Error Code: ' + inttostr(pError) + ' - ' +
      _TranslateErrorCode(pError) + ifThen(pExtraMsg <> '', '[' + pExtraMsg + ']')
  Else
    lMsg := _TranslateErrorCode(pError) + ifThen(pExtraMsg <> '', '[' + pExtraMsg + ']');

  LogMessage(pWhere + ':-' + lMsg);

  { avoid writing to database when its not connected }
  If (Pos('connection to sql server', lowercase(lMsg)) = 0) Or
    (Pos('sql server does not exist or access denied', lowercase(lMsg)) = 0) Then
    If (fConnectionString <> '') And pAddtoDb Then
    Try
      LogToDB(pWhere, lMsg);
    Except
    End;
End;

{-----------------------------------------------------------------------------
  Procedure: LogMessage
  Author:    vmoura

  log to the file
-----------------------------------------------------------------------------}
Procedure _Base.LogMessage(Const pMessage: String);
Begin
  _LogMSG(pMessage);
End;

(*{ _AdoBaseTable }

{-----------------------------------------------------------------------------
  Procedure: Create
  Author:    vmoura
-----------------------------------------------------------------------------}
Constructor _AdoBaseTable.Create;
Begin
  Inherited Create;
  fTable := TAdoTable.Create(Nil);
End;

{-----------------------------------------------------------------------------
  Procedure: Destroy
  Author:    vmoura
-----------------------------------------------------------------------------}
Destructor _AdoBaseTable.Destroy;
Begin
  Try
    fTable.Connection := Nil;
  Except
  End;

  fTable.Close;
  FreeAndNil(fTable);
  Inherited Destroy;
End;

{-----------------------------------------------------------------------------
  Procedure: GetActive
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _AdoBaseTable.GetActive: Boolean;
Begin
  Result := fTable.Active;
End;

{-----------------------------------------------------------------------------
  Procedure: GetConnection
  Author:    vmoura
-----------------------------------------------------------------------------}
Function _AdoBaseTable.GetConnection: TADOConnection;
Begin
  Result := fTable.Connection;
End;

{-----------------------------------------------------------------------------
  Procedure: Refresh
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure _AdoBaseTable.Refresh;
Begin
  Try
    fTable.Refresh;
  Except
  End;
End;

{-----------------------------------------------------------------------------
  Procedure: SetConnection
  Author:    vmoura
-----------------------------------------------------------------------------}
Procedure _AdoBaseTable.SetConnection(Const Value: TADOConnection);
Begin
  fTable.Connection := Value
End;*)

{-----------------------------------------------------------------------------
  Procedure: LogToDB
  Author:    vmoura

  log message to db
-----------------------------------------------------------------------------}
Procedure _Base.LogToDB(Const pWhere, pMsg: String);
Var
  lSp: TADOStoredProc;
Begin
  If fConnectionString <> '' Then
  Try
    Try
      lSp := TADOStoredProc.Create(Nil);
      lSp.ConnectionString := fConnectionString;
      lSp.ProcedureName := 'sp_UPDATE_ICELOG';

      With lSp.Parameters.AddParameter Do
      Begin
        Name := 'pDesc';
        Value := pMsg;
      End;

      With lSp.Parameters.AddParameter Do
      Begin
        Name := 'pLocation';
        Value := pWhere;
      End;

      Try
        lSp.ExecProc;
      Except
      End;
    Finally
      If Assigned(lSp) Then
        FreeAndNil(lSp);
    End; {If fADOConnection.Connected Then}
  Except
  End; {If fConnectionString <> '' Then}
End;

End.

