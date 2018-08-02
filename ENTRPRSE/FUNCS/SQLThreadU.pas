unit SQLThreadU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  SQLCallerU;

type
  {
    Thread class to run a SQL query. This is intended for potentially
    long-running queries, so that the main thread can continue (and hence the
    GUI can remain responsive) while the SQL query is being processed.
    
    When creating a new instance, the constructor expects to be passed a SQL 
    Caller instance, the query string itself, and the Company Code.
    
    There are two constructors, one for Exec calls, which simply run the SQL
    query, and do not return anything (other than any errors).
    
    The other is for Select calls. On return, the SQL Caller instance will
    contain the requested recordset.
    
    Use:
      
        uses GlobVar, SQLThreadU, SQLCallerU, ADOConnect;
        .
        .
        .
        var
          SQLThread: TSQLThread;
          CompanyCode: string;
          SQLCaller: TSQLCaller;
          Query: string;
        begin
          // Initialise
          SQLCaller := TSQLCaller.Create(GlobalADOConnection);
          CompanyCode := SQLUtils.GetCompanyCode(SetDrive);
          Query := 'SELECT * FROM [COMPANY].CUSTSUPP';
          
          // Create the thread instance (this is always created in
          // suspended mode)
          SQLThread := TSQLThread.CreateForSQLSelect(SQLCaller, Query, CompanyCode);
          
          // Start the thread, and wait for it to finish
          // (Note: a better but more complicated way to do this would be
          // to assign a callback function to the thread's OnTerminate
          // handler, and to continue once this is called.)
          SQLThread.Resume;
          while not StoredProcedureThread.Terminated do
            Application.ProcessMessages;
          
          // Report any errors, otherwise use the results (if required)
          if (SQLThread.ErrorMsg <> '') then
            ShowMessage('SQL Call error: ' + SQLThread.ErrorMsg)
          else
            while not SQLCaller.Records.Eof do
              ...

  }
  TSQLThread = class(TThread)
  private
    FSQLCaller: TSQLCaller;
    FCompanyCode: string;
    FQuery: string;
    FUseRecordSet: Boolean;
    FErrorMsg: string;
  public
    constructor CreateDefault(SQLCaller: TSQLCaller; Query: string; CompanyCode: string);
    constructor CreateForSQLExec(SQLCaller: TSQLCaller; Query: string; CompanyCode: string);
    constructor CreateForSQLSelect(SQLCaller: TSQLCaller; Query: string; CompanyCode: string);
    procedure Execute; override;
    property ErrorMsg: string read FErrorMsg;
    // Raise the visibility of the Terminated property from protected to public
    property Terminated;
  end;

implementation

// =============================================================================
// TSQLThread
// =============================================================================

constructor TSQLThread.CreateDefault(SQLCaller: TSQLCaller;
  Query: string; CompanyCode: string);
begin
  FSQLCaller := SQLCaller;
  FCompanyCode := CompanyCode;
  FQuery := Query;
  FErrorMsg := '';
  inherited Create(True); // Create suspended
end;

// -----------------------------------------------------------------------------

constructor TSQLThread.CreateForSQLExec(SQLCaller: TSQLCaller;
  Query: string; CompanyCode: AnsiString);
begin
  CreateDefault(SQLCaller, Query, CompanyCode);
  FUseRecordSet := False;
end;

// -----------------------------------------------------------------------------

constructor TSQLThread.CreateForSQLSelect(SQLCaller: TSQLCaller;
  Query, CompanyCode: string);
begin
  CreateDefault(SQLCaller, Query, CompanyCode);
  FUseRecordSet := True;
end;

// -----------------------------------------------------------------------------

procedure TSQLThread.Execute;
begin
  try
    if FUseRecordSet then
      FSQLCaller.Select(FQuery, FCompanyCode)
    else
      FSQLCaller.ExecSQL(FQuery, FCompanyCode);
  except
    on E:Exception do
      FErrorMsg := E.Message;
  end;
  Terminate;
end;

// -----------------------------------------------------------------------------

end.

