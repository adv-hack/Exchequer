{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J+,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W+,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $10000000}
{$APPTYPE GUI}
unit SQLUtils;
{
  Interface into BtrvSQL.DLL, which provides functions to connect to the
  SQL Emulator.
}

{$ALIGN 1}
{$REALCOMPATIBILITY ON}
interface

uses GlobVar;

type
  { Callback function for memory test }
  TMemCallback = procedure(Msg: ShortString);

  { Function type for installing callback }
  TSetMemCallbackCall = procedure(Callback: TMemCallback);

  { Function type declarations for DLL calls }
  TSimpleSQLCall = function: Integer; stdcall;

  TSQLCall = function(Code: PChar; ClientID: Pointer): Integer; stdcall;

  TSQLClientIDCall = function(ClientID: Pointer; Remove: Boolean): Integer; stdcall;

  TSQLCreateDatabaseCall = function(ServerName, DatabaseName, UserName, Password: PChar): Integer; stdcall;

  TSQLCreateCompanyCall = function(CompanyCode, CompanyName, CompanyPath, ZIPFileName, UserName, Password,
    ReadOnlyName, ReadOnlyPassword: PChar; ClientID: Pointer): Integer; stdcall;

  TSQLGetConnectionStringCall = function(CompanyCode: PChar; GetReadOnly: Boolean; ConnectionString: PChar; ConnectionStringLength: Integer; ClientID: Pointer): Integer; stdcall;
  //VA:26/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
  TSQLGetConnectionStringWOPassCall = function(CompanyCode: PChar; GetReadOnly: Boolean; ConnectionString: PChar; ConnectionStringLength: Integer; Password: PChar; ClientID: Pointer): Integer; stdcall;
  TSQLGetCommonConnectionStringCall = function(ConnectionString: PChar; ConnectionStringLength: Integer; ClientID: Pointer): Integer; stdcall;
  //SS:26/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
  TSQLGetCommonConnectionStringWOPassCall = function(ConnectionString: PChar;  ConnectionStringLength: Integer; Password : PChar; ClientID: Pointer): Integer; stdcall;
  TSQLValidPathCall = function(Path: PChar): Integer; stdcall;

  TSQLExportCall = function (CompanyCode: PChar; FileName: PChar; ExportType: Integer): Integer; stdcall;
  TSQLImportCall = function(CompanyCode, FileName: PChar): Integer; stdcall;

  TSQLGetErrorInformationCall = function(var ErrorCode: Integer): ShortString; stdcall;
  TSQLGetLongErrorInformationCall = procedure(var ErrorCode: Integer; ErrorString: PChar; ErrorStringLength: Integer); stdcall;

  TUsingSQLCall = function: Boolean; stdcall;

  TOverrideUsingSQLCall = function(Value: Boolean): Integer; stdcall;

  TSQLCopyTableCall = function (FromCompanyCode, ToCompanyCode, TableName, WhereClause: PChar; DeleteIfExists: Boolean): Integer; stdcall;

  TSQLUpdateTableCall = function (CompanyCode, TableName, Values, WhereClause: PChar; ClientID: Pointer): Integer; stdcall;

  TSQLGetDBColumnNameCall = function(BtrieveFileName, FieldName, RecordType, ComputedFieldName: PChar; ComputedFieldNameLength: Integer): ShortString; stdcall;

  TSQLGetDBTableNameCall = function(BtrieveFileName: PChar): ShortString; stdcall;

  TSQLInitialiseCall = function(Path: PChar): Integer; stdcall;

  TSQLOpenCompanyByCodeCall = function(Code: PChar): Integer; stdcall;

  TSQLGetCompanyCodeCall = function(Path: PChar): ShortString; stdcall;

  TSQLSetCacheSizeCall = function(var PosBlock; Size: Integer; var OldSize: Integer; ClientID: Pointer): Integer; stdcall;

  TSQLDeleteRowsCall = function (CompanyCode, Filename, WhereClause: PChar; ClientID: Pointer): Integer; stdcall;

  TSQLCreateCustomPrefillCacheEmulatorCall = function (FileName, WhereClause, Columns: PChar; var ID: LongInt; ClientID: Pointer): Integer; stdcall;
  TSQLUseCustomPrefillCacheEmulatorCall = function (ID: LongInt; ClientID: Pointer): Integer; stdcall;
  TSQLDropCustomPrefillCacheEmulatorCall = function (ID: LongInt; ClientID: Pointer): Integer; stdcall;

  TSQLUseVariantForNextCall = function(var PosBlock; ClientID: Pointer): Integer; stdcall;
  TSQLDiscardCachedDataCall = function(FileName: PChar; ClientID: Pointer): Integer; stdcall;
  TSQLCheckExchRndCall = function: Integer; stdcall;

  TSQLPostToHistoryCall = function (NType: Char; var Code; Purchases, Sales, Cleared, Value1, Value2: double; Currency, Year, Period, DecimalPlaces: Integer; var PreviousBalance: double; var ErrorCode: Integer; ClientID: Pointer): Integer; stdcall;
  TSQLPostToYearDateCall = function (NType: Char; var Code; Purchases, Sales, Cleared, Value1, Value2: double; Currency, Year, Period, DecimalPlaces: Integer; var ErrorCode: Integer; ClientID: Pointer): Integer; stdcall;

  TSQLExecCall = function (QueryStr: PChar; CompanyPath: PChar): Integer; stdcall;
  TLastSQLErrorCall = function: ShortString; stdcall;

  TSQLStockFreezeCall = function(CompanyPath, LocationCode: PChar; UsePostQty: Boolean; Year, Period: Integer; ClientID: Pointer): Integer; stdcall;
  TSQLCheckAllStockCall = function(CompanyPath, StockCode: PChar; StockType: Char; Folio: Integer; ClientID: Pointer): Integer; stdcall;
  TSQLGetLineNumberAccountsCall = function(CompanyPath, Code: PChar; ClientID: Pointer): Integer; stdcall;
  TSQLGetLineNumberStockCall = function(CompanyPath: PChar; Folio: Integer; ClientID: Pointer): Integer; stdcall;
  TSQLResetViewHistoryCall = function (CompanyPath: PChar; NomViewCode: Integer; ClientID: Pointer): Integer; stdcall;
  TSQLResetAuditHistoryCall = function (CompanyPath: PChar; CustCode: PChar; DeleteCCDept: Boolean; PurgeYear: Integer; HistCodeLen: Integer; ClientID: Pointer): Integer; stdcall;
  TSQLStockLocationFilterCall = function (CompanyPath, LocationCode: string; Mode: Integer; ClientID: Pointer): Integer; stdcall;
  TSQLStockAddCustAnalCall = function(CompanyPath, CustCode, StockCode, PDate: PChar; FolioRef, AbsLineNo, Currency, IdDocHed: Integer; LineType: Char; LineTotal: Double; Mode: Byte; ClientID: Pointer): Integer; stdcall;

  // CJS 2016-05-06 - ABSEXCH-17353 - GL Budgets - Extend to include 5 budget revisions
  TSQLTotalProfitToDateRangeCall =
    function (
          CompanyPath: AnsiString; NType: Char; NCode: ShortString;
          PCr, PYr, PPr, PPr2: Integer; Range, SetACHist: Boolean;
      var Purch, PSales, Balance, PCleared, PBudget,
          RevisedBudget1, RevisedBudget2, RevisedBudget3, RevisedBudget4, RevisedBudget5,
          BValue1, BValue2: double; ClientID: Pointer): Integer; stdcall;

  TSQLFillBudgetCall =
    function (CompanyPath: PChar; NType: Integer; var Code;
              Currency, Year, Period, PeriodInYear: Integer; CalcPurgeOB, Range: Boolean;
              PPr2: Integer; ClientID: Pointer): Integer; stdcall;
  TSQLRemoveLastCommitCall = function (CompanyPath: PChar; ClientID: Pointer): Integer; stdcall;
  TSQLPartialUnpostHistoryCall =
    function(CompanyPath: PChar; NType: Char; NCode: Str20;
             PCr, PYr, PPr, PPr2: Integer; Range, SetACHist: Boolean;
             var Purch, PSales, PCleared, PBudget: double; ClientID: Pointer): Integer; stdcall;

  TSQLUpdateCompanyCacheCall = function (CompanyCode, CompanyPath: PChar): Integer; stdcall;

  TUseSQLCacheListCall = procedure;

  TSQLFetchCall = function (const QueryStr, Field, CompanyPath: AnsiString; var Value: Variant): Integer;

const
  EXPORT_ALL = 0;
  EXPORT_COMMON = 1;
  EXPORT_COMPANY = 2;
  // CJS 2012-02-15 - ABSEXCH-11856 - MS SQL Backup/Restore for LIVE
  // Constants for including the LIVE tables. Only use these if the current
  // install of Exchequer is already known to include these tables.
  EXPORT_LIVE_ALL = 3;
  EXPORT_LIVE_COMMON = 4;
  EXPORT_LIVE_COMPANY = 5;

procedure SetMemCallback(Callback: TMemCallback);

function CreateDatabase(ServerName, DatabaseName, UserName, Password: AnsiString): Integer;
function CreateCompany(CompanyCode, CompanyName, CompanyPath, ZIPFileName, ReadOnlyName,
  ReadOnlyPassword: AnsiString; ClientID: Pointer = nil): Integer;
function AttachCompany(CompanyCode: AnsiString; ClientID: Pointer = nil): Integer;
function DetachCompany(CompanyCode: AnsiString; ClientID: Pointer = nil): Integer;
function DeleteCompany(CompanyCode: AnsiString; ClientID: Pointer = nil): Integer;
function RebuildCompanyCache: Integer;
function GetConnectionString(CompanyCode: AnsiString; GetReadOnly: Boolean; var ConnectionString: AnsiString; ClientID: Pointer = nil): Integer;overload;
function GetConnectionString(CompanyCode: AnsiString; GetReadOnly: Boolean; var ConnectionString: WideString; ClientID: Pointer = nil): Integer;overload;
//VA:26/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
function GetConnectionStringWOPass(CompanyCode: AnsiString; GetReadOnly: Boolean; var ConnectionString: WideString; var Password: WideString; ClientID: Pointer = nil): Integer;         //VA:26/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
function GetCommonConnectionString(var ConnectionString: AnsiString; ClientID: Pointer = nil): Integer; overload;
function GetCommonConnectionString(var ConnectionString: WideString; ClientID: Pointer = nil): Integer; overload;
//SS:26/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
function GetCommonConnectionStringWOPass(var ConnectionString: WideString; var Password: WideString; ClientID: Pointer = nil): Integer;
function OpenCompany(Path: AnsiString; ClientID: Pointer = nil): Integer;
function OpenCompanyByCode(Code: AnsiString): Integer;
function GetCompanyCode(ForPath: AnsiString): AnsiString;
function CompanyExists(ForCode: AnsiString; ClientID: Pointer = nil): Integer;
function TableExists(FileSpec: AnsiString; ClientID: Pointer = nil): Boolean;
function CheckTableExists(FileSpec: AnsiString; ClientID: Pointer = nil): Integer;
function DeleteTable(FileSpec: AnsiString; ClientID: Pointer = nil): Integer;
function ValidCompany(FilePath: AnsiString): Boolean;
function ValidSystem(ForPath: AnsiString): Boolean;
function ExclusiveAccess(CompanyPath: AnsiString; ClientID: Pointer = nil): Boolean;
function ExportSQLDataset(CompanyCode: AnsiString; FileName: AnsiString; ExportType: Integer = EXPORT_ALL): Integer;
function ImportSQLDataset(CompanyCode: AnsiString; FileName: AnsiString): Integer;
function GetSQLErrorInformation(var ErrorCode: Integer): AnsiString;
function UsingSQL: Boolean;
function OverrideUsingSQL(Value: Boolean): Integer;
function ExecSQL(QueryStr: AnsiString; CompanyPath: AnsiString = ''): Integer;
function SQLFetch(const QueryStr, Field, CompanyPath: AnsiString; var Value: Variant): Integer;
function LastSQLError: ShortString;
function UpdateCompanyCache(CompanyCode, CompanyPath: AnsiString): Integer;

// MH 13/06/08: Added new function to be used when deciding whether to use alternate
// code added to improve the SQL Edition, returns TRUE if the alternate code should
// be used.  Controlled by '/NoSQLAltFuncs' command-line parameter.
function UsingSQLAlternateFuncs: Boolean;

function CloseClientIdSession(ClientId: Pointer; Remove: Boolean = True): Integer; stdcall;
function CopyTable(FromCompanyCode, ToCompanyCode, TableName, WhereClause: AnsiString; DeleteIfExists: Boolean = False): Integer; stdcall;
function UpdateTable(CompanyCode, TableName, Values, WhereClause: AnsiString; ClientID: Pointer): Integer; stdcall;
function GetDBColumnName(BtrieveFileName, FieldName, RecordType: AnsiString): AnsiString; stdcall;
function GetComputedColumnName(BtrieveFileName, FieldName, RecordType: AnsiString): AnsiString; stdcall;
function GetDBTableName(BtrieveFileName: AnsiString): AnsiString; stdcall;

function SetCacheSize(var PosBlock; Size: Integer; var OldSize: Integer; ClientID: Pointer = nil): Integer; stdcall;
function DeleteRows(CompanyCode, FileName, WhereClause: AnsiString; ClientID: Pointer = nil): Integer;

function CreateCustomPrefillCache(FileName, WhereClause, Columns: AnsiString; var ID: LongInt; ClientID: Pointer = nil): Integer;
function UseCustomPrefillCache(ID: LongInt; ClientID: Pointer = nil): Integer;
function DropCustomPrefillCache(ID: LongInt; ClientID: Pointer = nil): Integer;

function UseVariantForNextCall(var PosBlock; ClientID: Pointer = nil): Integer;
function DiscardCachedData(FileName: AnsiString; ClientID: Pointer = nil): Integer;
procedure UseSQLCacheList;
function CheckExchRnd: Integer;

function PostToHistory(NType: Char; Code: ShortString; Purchases, Sales, Cleared, Value1, Value2: double; Currency, Year, Period, DecimalPlaces: Integer; var PreviousBalance: double; var ErrorCode: Integer; ClientID: Pointer = nil): Integer;
function PostToYearDate(NType: Char; Code: ShortString; Purchases, Sales, Cleared, Value1, Value2: double; Currency, Year, Period, DecimalPlaces: Integer; var ErrorCode: Integer; ClientID: Pointer = nil): Integer;

function StockFreeze(CompanyPath, LocationCode: AnsiString; UsePostQty: Boolean; Year, Period: Integer; ClientID: Pointer = nil): Integer;
function CheckAllStock(CompanyPath, StockCode: AnsiString; StockType: Char; Folio: Integer; ClientID: Pointer = nil): Integer;
function GetLineNumberAccounts(CompanyPath, Code: AnsiString; ClientID: Pointer = nil): Integer;
function GetLineNumberStock(CompanyPath: AnsiString; Folio: Integer; ClientID: Pointer = nil): Integer;
function ResetViewHistory(CompanyPath: AnsiString; NomViewCode: Integer; ClientID: Pointer = nil): Integer;
function ResetAuditHistory(CompanyPath: AnsiString; CustCode: AnsiString; DeleteCCDept: Boolean; PurgeYear: Integer; HistCodeLen: Integer = 7; ClientID: Pointer = nil): Integer;
function StockLocationFilter(CompanyPath, LocationCode: AnsiString; Mode: Integer; ClientID: Pointer = nil): Integer;
function StockAddCustAnal(CompanyPath, CustCode, StockCode, PDate: AnsiString; FolioRef, AbsLineNo, Currency, IdDocHed: Integer; LineType: Char; LineTotal: Double; Mode: Byte; ClientID: Pointer = nil): Integer;

// CJS 2016-05-06 - ABSEXCH-17353 - GL Budgets - Extend to include 5 budget revisions
function TotalProfitToDateRange(
      CompanyPath: AnsiString; NType: Char; NCode: ShortString;
      PCr, PYr, PPr, PPr2: Integer; Range, SetACHist: Boolean;
  var Purch, PSales, Balance, PCleared, PBudget,
      RevisedBudget1, RevisedBudget2, RevisedBudget3, RevisedBudget4, RevisedBudget5,
      BValue1, BValue2: double; ClientID: Pointer = nil): Integer;

function FillBudget(CompanyPath: AnsiString; NType: Integer; Code: ShortString;
  Currency, Year, Period, PeriodInYear: Integer; CalcPurgeOB, Range: Boolean;
  PPr2: Integer; ClientID: Pointer = nil): Integer;
function RemoveLastCommit(CompanyPath: AnsiString; ClientID: Pointer = nil): Integer;
function PartialUnpostHistory(CompanyPath: AnsiString; NType: Char; NCode: Str20;
  PCr, PYr, PPr, PPr2: Integer; Range, SetACHist: Boolean;
  var Purch, PSales, PCleared, PBudget: double; ClientID: Pointer = nil): Integer;

{
  Returns FromStr converted to the Hex equivalent, suitable for using as a
  binary value in SQL queries. If PadTo is specified, the result will be
  padded to this length (or truncated, if the length of FromStr is greater
  than PadTo.
}
function StringToHex(FromStr: string; PadTo: Integer = 0; IncludeLengthByte: Boolean = False; PadWith: string = '20'): string;

function Load_DLL(Path: AnsiString = ''): Boolean;
function Unload_DLL: Boolean;

function AdminUser(CompanyCode: string): string;
Function AdminPassword : ShortString;

// Returns a default Reporting User Id based on the Company Code
Function ReportingUser (CompCode : ShortString) : ShortString;
// Returns a default Reporting User Password based on Random upper and lower-case characters and numbers
Function ReportingPassword : ShortString;

//PR: 07/06/2012 Added procedures to allow alternate sql funcs to be turned on and off during execution
{$IFDEF COMTK}
procedure DisableSQLAlternateFuncs;
procedure EnableSQLAlternateFuncs;
{$ENDIF}

// CJS 2013-03-22 - ABSEXCH-13413 - Added utility function ExecSQLEx to allow
// timeout to be changed for a SQL query.
function ExecSQLEx(QueryStr: AnsiString; CompanyPath: AnsiString; TimeOut: Integer = 30): Integer;

implementation

uses Classes, SysUtils, Windows, Dialogs, StrUtils, Variants, SQLCallerU;

var
  DLLHandle: Integer;

  SetMemCallBackFn: TSetMemCallbackCall;

  { Function pointer variables }
  AttachCompanyFn: TSQLCall;
  DetachCompanyFn: TSQLCall;
  DeleteCompanyFn: TSQLCall;
  RebuildCompanyCacheFn: TSimpleSQLCall;
  OpenCompanyFn: TSQLCall;
  OpenCompanyByCodeFn: TSQLOpenCompanyByCodeCall;
  GetCompanyCodeFn: TSQLGetCompanyCodeCall;
  TableExistsFn: TSQLCall;
  DeleteTableFn: TSQLCall;
  HasExclusiveAccessFn: TSQLCall;
  CreateDatabaseFn: TSQLCreateDatabaseCall;
  CreateCompanyFn: TSQLCreateCompanyCall;
  GetConnectionStringFn: TSQLGetConnectionStringCall;
  GetConnectionStringWOPassFn: TSQLGetConnectionStringWOPassCall;    //VA:26/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
  GetCommonConnectionStringFn: TSQLGetCommonConnectionStringCall;
  GetCommonConnectionStringWOPassFn: TSQLGetCommonConnectionStringWOPassCall;  //SS:26/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
  ValidCompanyFn: TSQLValidPathCall;
  ValidSystemFn: TSQLValidPathCall;
  ExportDatasetFn: TSQLExportCall;
  ImportDatasetFn: TSQLImportCall;
  GetErrorInformationFn: TSQLGetErrorInformationCall;
  GetLongErrorInformationFn: TSQLGetLongErrorInformationCall;
  UsingSQLFn: TUsingSQLCall;
  OverrideUsingSQLFn: TOverrideUsingSQLCall;
  CopyTableFn: TSQLCopyTableCall;
  UpdateTableFn: TSQLUpdateTableCall;
  GetDBColumnNameFn: TSQLGetDBColumnNameCall;
  GetDBTableNameFn: TSQLGetDBTableNameCall;
  InitialiseFn: TSQLInitialiseCall;
  CompanyExistsFn: TSQLCall;
  CloseClientIDSessionFn: TSQLClientIDCall;
  SetCacheSizeFn: TSQLSetCacheSizeCall;
  DeleteRowsFn: TSQLDeleteRowsCall;
  CreateCustomPrefillCacheFn: TSQLCreateCustomPrefillCacheEmulatorCall;
  UseCustomPrefillCacheFn: TSQLUseCustomPrefillCacheEmulatorCall;
  DropCustomPrefillCacheFn: TSQLDropCustomPrefillCacheEmulatorCall;
  PostToHistoryFn: TSQLPostToHistoryCall;
  PostToYearDateFn: TSQLPostToYearDateCall;
  UseVariantForNextCallFn: TSQLUseVariantForNextCall;
  ExecSQLFn: TSQLExecCall;
  LastSQLErrorFn: TLastSQLErrorCall;
  UpdateCompanyCacheFn: TSQLUpdateCompanyCacheCall;
  DiscardCachedDataFn: TSQLDiscardCachedDataCall;
  UseSQLCacheListFn: TUseSQLCacheListCall;
  CheckExchRndFn: TSQLCheckExchRndCall;
  SQLFetchFn: TSQLFetchCall;

  // Stored Procedure calls
  StockFreezeFn: TSQLStockFreezeCall;
  CheckAllStockFn: TSQLCheckAllStockCall;
  GetLineNumberAccountsFn: TSQLGetLineNumberAccountsCall;
  GetLineNumberStockFn: TSQLGetLineNumberStockCall;
  ResetViewHistoryFn: TSQLResetViewHistoryCall;
  ResetAuditHistoryFn: TSQLResetAuditHistoryCall;
  StockLocationFilterFn: TSQLStockLocationFilterCall;
  StockAddCustAnalFn: TSQLStockAddCustAnalCall;
  TotalProfitToDateRangeFn: TSQLTotalProfitToDateRangeCall;
  FillBudgetFn: TSQLFillBudgetCall;
  RemoveLastCommitFn: TSQLRemoveLastCommitCall;
  PartialUnpostHistoryFn: TSQLPartialUnpostHistoryCall;

  DisableSQLAltFuncs : Boolean = False;

const
  NOT_FOUND_MSG = 'Could not find %s function in database connection DLL.';


//=========================================================================

procedure SetMemCallback(Callback: TMemCallback);
begin
  SetMemCallbackFn(Callback);
end;

// Returns a default Reporting User Id based on the Company Code
Function ReportingUser (CompCode : ShortString) : ShortString;
Begin // ReportingUser
  Result := 'REP' + CompCode + Format ('%.3d', [Random(1000)]);
End; // ReportingUser

//------------------------------

// Returns a default Reporting User Password based on Random upper and lower-case characters and numbers
Function ReportingPassword : ShortString;
Const
  Alpha   : Array[1..26] Of String = ('a','b','c','d','e','f','g','h','j','i','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z');
  Numeric : Array[1..10] Of String = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9');
Begin // ReportingPassword
  Result := RandomFrom(Alpha) +
            RandomFrom(Numeric) +
            UpperCase(RandomFrom(Alpha)) +
            RandomFrom(Numeric) +
            UpperCase(RandomFrom(Alpha)) +
            RandomFrom(Alpha) +
            UpperCase(RandomFrom(Alpha)) +
            RandomFrom(Alpha);
End; // ReportingPassword

// -----------------------------------------------------------------------------

function AdminUser(CompanyCode: string): string;
begin
  Result := 'ADM' + FormatDateTime('hhnn', Now) + CompanyCode +
            Format('%.3d', [Random(1000)]);
end;

// -----------------------------------------------------------------------------

//
// MH 17/04/08: Replaces as it was failing the SQL Server password complexity checks
//
//function AdminPassword: string;
//var
//  GUID: TGUID;
//begin
//  CreateGUID(GUID);
//  Result := StringReplace(GUIDToString(GUID), '-', '', [rfReplaceAll]);
//  Result := Copy(Result, 2, Length(Result) - 2);
//end;

Function AdminPassword : ShortString;
Const
  Symbols : Array[1..10] of String = ('$', '*', '-', '!', '#', '@', '%', '&', '~', '.');
  Alpha   : Array[1..26] Of String = ('a','b','c','d','e','f','g','h','j','i','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z');
  Numeric : Array[1..10] Of String = ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9');
Var
  GUID: TGUID;
  sGUID : ShortString;
Begin
  CreateGUID(GUID);
  sGUID := StringReplace(GUIDToString(GUID), '-', '', [rfReplaceAll]);

  // Due to possible password complexity requirements within SQL Server always have 1 symbol + 1 lowercase + 1 uppercase + 1 number
  Result := RandomFrom(Symbols) + RandomFrom(Alpha) + UpperCase(RandomFrom(Alpha)) + RandomFrom(Numeric) + Copy(sGUID, 2, 26);
End;

// -----------------------------------------------------------------------------

function StringToHex(FromStr: string; PadTo: Integer; IncludeLengthByte: Boolean; PadWith: string): string;
var
  i: Integer;
begin
  Result := '';
  if (PadTo = 0) then
    PadTo := Length(FromStr);
  for i := 1 to PadTo do
  begin
    if (i <= Length(FromStr)) then
      Result := Result + IntToHex(Ord(FromStr[i]), 2)
    else
      Result := Result + PadWith;
  end;
  if (IncludeLengthByte) then
    Result := IntToHex(Ord(Length(FromStr)), 2) + Result;
  Result := '0x' + Result;
end;

// -----------------------------------------------------------------------------

function CloseClientIdSession(ClientId: Pointer; Remove: Boolean): Integer; stdcall;
begin
  Result := CloseClientIDSessionFn(ClientID, Remove);
end;

// -----------------------------------------------------------------------------

function CreateDatabase(ServerName, DatabaseName, UserName, Password: AnsiString): Integer;
var
  FuncRes: Integer;
begin
  FuncRes := CreateDatabaseFn(PChar(ServerName), PChar(DatabaseName),
                              PChar(UserName), PChar(Password));
  Result := FuncRes;
end;

// -----------------------------------------------------------------------------

function CreateCompany(CompanyCode, CompanyName, CompanyPath, ZIPFileName, ReadOnlyName,
  ReadOnlyPassword: AnsiString; ClientID: Pointer): Integer;
var
  UserName, Password: AnsiString;
begin
  UserName := AdminUser(CompanyCode);
  Password := AdminPassword;
  if (Trim(ZIPFileName) = '') then
    Result :=
      CreateCompanyFn(
        PChar(CompanyCode),
        PChar(CompanyName),
        PChar(CompanyPath),
        nil,
        PChar(UserName),
        PChar(Password),
        PChar(ReadOnlyName),
        PChar(ReadOnlyPassword),
        PChar(ClientID)
      )
  else
    Result :=
      CreateCompanyFn(
        PChar(CompanyCode),
        PChar(CompanyName),
        PChar(CompanyPath),
        PChar(ZIPFileName),
        PChar(UserName),
        PChar(Password),
        PChar(ReadOnlyName),
        PChar(ReadOnlyPassword),
        PChar(ClientID)
      );
end;

// -----------------------------------------------------------------------------

function DeleteCompany(CompanyCode: AnsiString; ClientID: Pointer): Integer;
begin
  Result := DeleteCompanyFn(PChar(CompanyCode), PChar(ClientID));
end;

// -----------------------------------------------------------------------------

function AttachCompany(CompanyCode: AnsiString; ClientID: Pointer): Integer;
begin
  Result := AttachCompanyFn(PChar(CompanyCode), PChar(ClientID));
end;

// -----------------------------------------------------------------------------

function DetachCompany(CompanyCode: AnsiString; ClientID: Pointer): Integer;
begin
  Result := DetachCompanyFn(PChar(CompanyCode), PChar(ClientID));
end;

// -----------------------------------------------------------------------------

function RebuildCompanyCache: Integer;
begin
  Result := RebuildCompanyCacheFn;
end;



// -----------------------------------------------------------------------------

function GetConnectionString(CompanyCode: AnsiString; GetReadOnly: Boolean; var ConnectionString: AnsiString; ClientID: Pointer): Integer;
var
  Buffer: PChar;
  BufferSize: Integer;

begin
  Result := -1;
  BufferSize := 256;
  Buffer := StrAlloc(BufferSize);
  try
    if not Assigned(GetConnectionStringFn) then
      raise Exception.Create('BtrvDLL not initialised')
    else
    begin
      Result := GetConnectionStringFn(PChar(CompanyCode), GetReadOnly, Buffer, BufferSize, PChar(ClientID));

      if (Result = 0) then
        ConnectionString := Trim(Buffer);

    end;
  finally
    StrDispose(Buffer);
  end;
end;

//VA:26/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
function GetConnectionString(CompanyCode: AnsiString; GetReadOnly: Boolean; var ConnectionString: WideString; ClientID: Pointer = nil): Integer;
var
  Buffer: PChar;
  BufferSize: Integer;

begin
  Result := -1;
  BufferSize := 256;
  Buffer := StrAlloc(BufferSize);
  try
    if not Assigned(GetConnectionStringFn) then
      raise Exception.Create('BtrvDLL not initialised')
    else
    begin
      Result := GetConnectionStringFn(PChar(CompanyCode), GetReadOnly, Buffer, BufferSize, PChar(ClientID));

      if (Result = 0) then
        ConnectionString := Trim(Buffer);

    end;
  finally
    StrDispose(Buffer);
  end;
end;
// -----------------------------------------------------------------------------

//VA:26/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
function GetConnectionStringWOPass(CompanyCode: AnsiString; GetReadOnly: Boolean; var ConnectionString: WideString; var Password: WideString; ClientID: Pointer): Integer;
var
  BufferConnection: PChar;
  BufferPassword: PChar;
  BufferSize: Integer;
  BufferStr : PChar;
begin
  Result := -1;
  BufferSize := 256;
  BufferConnection := StrAlloc(BufferSize);
  BufferPassword := StrAlloc(BufferSize);
  BufferStr := StrAlloc(BufferSize);
  try
    if not Assigned( GetConnectionStringWOPassFn) then
      raise Exception.Create('BtrvDLL not initialised')
    else
    begin
      Result :=  GetConnectionStringWOPassFn(PChar(CompanyCode), GetReadOnly, BufferConnection, BufferSize, BufferPassword, PChar(ClientID));
      if (Result = 0) then
      begin
        ConnectionString := Trim(BufferConnection);
        Password := Trim(BufferPassword);
      end;
    end;
  finally
    StrDispose(BufferConnection);
    StrDispose(BufferPassword);
    StrDispose(BufferStr);
  end;
end;

// -----------------------------------------------------------------------------

function GetCommonConnectionString(var ConnectionString: AnsiString; ClientID: Pointer): Integer;
var
  Buffer: PChar;
  BufferSize: Integer;
begin
  Result := -1;
  BufferSize := 256;
  Buffer := StrAlloc(BufferSize);

  try
    if not Assigned(GetCommonConnectionStringFn) then
      raise Exception.Create('BtrvDLL not initialised')
    else
    begin
      Result := GetCommonConnectionStringFn(Buffer, BufferSize, PChar(ClientID));
      if (Result = 0) then
        ConnectionString := Trim(Buffer);
    end;
  finally
    StrDispose(Buffer);
  end;
end;

//SS:26/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
function GetCommonConnectionString(var ConnectionString: WideString; ClientID: Pointer = nil): Integer; overload;
var
  Buffer: PChar;
  BufferSize: Integer;
begin
  Result := -1;
  BufferSize := 256;
  Buffer := StrAlloc(BufferSize);

  try
    if not Assigned(GetCommonConnectionStringFn) then
      raise Exception.Create('BtrvDLL not initialised')
    else
    begin
      Result := GetCommonConnectionStringFn(Buffer, BufferSize, PChar(ClientID));
      if (Result = 0) then
        ConnectionString := Trim(Buffer);
    end;
  finally
    StrDispose(Buffer);
  end;
end;

// -----------------------------------------------------------------------------
//SS:26/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
function GetCommonConnectionStringWOPass(var ConnectionString: WideString; var Password: WideString; ClientID: Pointer): Integer;
var
  Buffer: PChar;
  BufferSize: Integer;
  BufferPassword : PChar;
begin
  Result := -1;
  BufferSize := 256;
  Buffer := StrAlloc(BufferSize);
  BufferPassword := StrAlloc(BufferSize);
  try
    if not Assigned(GetCommonConnectionStringWOPassFn) then
      raise Exception.Create('BtrvDLL not initialised')
    else
    begin
      Result := GetCommonConnectionStringWOPassFn(Buffer, BufferSize, BufferPassword, PChar(ClientID));
      //Result := GetCommonConnectionStringFn(Buffer, BufferSize, PChar(ClientID));
      if (Result = 0) then
      begin
        ConnectionString := Trim(Buffer);
        Password := Trim(BufferPassword)
      end;
    end;
  finally
    StrDispose(Buffer);
  end;
end;

// -----------------------------------------------------------------------------
function OpenCompany(Path: AnsiString; ClientID: Pointer): Integer;
begin
  Result := OpenCompanyFn(PChar(Path), PChar(ClientID));
end;

// -----------------------------------------------------------------------------

function OpenCompanyByCode(Code: AnsiString): Integer;
begin
  Result := OpenCompanyByCodeFn(PChar(Code));
end;

// -----------------------------------------------------------------------------

function GetCompanyCode(ForPath: AnsiString): AnsiString;
begin
  Result := GetCompanyCodeFn(PChar(ForPath));
end;

// -----------------------------------------------------------------------------

function CompanyExists(ForCode: AnsiString; ClientID: Pointer): Integer;
begin
  Result := CompanyExistsFn(PChar(ForCode), PChar(ClientID));
end;

// -----------------------------------------------------------------------------

function ValidCompany(FilePath: AnsiString): Boolean;
begin
  Result := (ValidCompanyFn(PChar(FilePath)) = 0);
end;

// -----------------------------------------------------------------------------

function ValidSystem(ForPath: AnsiString): Boolean;
begin
  Result := (ValidSystemFn(PChar(ForPath)) = 0);
end;

// -----------------------------------------------------------------------------

function CheckTableExists(FileSpec: AnsiString; ClientID: Pointer = nil): Integer;
begin
  Result := TableExistsFn(PChar(FileSpec), PChar(ClientID));
end;

// -----------------------------------------------------------------------------

function SetCacheSize(var PosBlock; Size: Integer; var OldSize: Integer; ClientID: Pointer): Integer;
begin
  Result := SetCacheSizeFn(PosBlock, Size, OldSize, PChar(ClientID));
end;

// -----------------------------------------------------------------------------

function TableExists(FileSpec: AnsiString; ClientID: Pointer): Boolean;
begin
  Result := (TableExistsFn(PChar(FileSpec), PChar(ClientID)) = 0);
end;

// -----------------------------------------------------------------------------

function DeleteTable(FileSpec: AnsiString; ClientID: Pointer): Integer;
begin
  Result := DeleteTableFn(PChar(FileSpec), PChar(ClientID));
end;

// -----------------------------------------------------------------------------

function ExclusiveAccess(CompanyPath: AnsiString; ClientID: Pointer): Boolean;
begin
  Result := (HasExclusiveAccessFn(PChar(CompanyPath), PChar(ClientID)) <= 1);
end;

// -----------------------------------------------------------------------------

function ExportSQLDataset(CompanyCode: AnsiString; FileName: AnsiString; ExportType: Integer): Integer;
begin
  Result := ExportDatasetFn(PChar(CompanyCode), PChar(FileName), ExportType);
end;

// -----------------------------------------------------------------------------

function ImportSQLDataset(CompanyCode: AnsiString; FileName: AnsiString): Integer;
begin
  Result := ImportDatasetFn(PChar(CompanyCode), PChar(FileName));
end;

// -----------------------------------------------------------------------------

function GetSQLErrorInformation(var ErrorCode: Integer): AnsiString;
var
  Buffer: PChar;
  BufferSize: Integer;
begin
  BufferSize := 10000;
  Buffer := StrAlloc(BufferSize);
  try
    // Call the new version of GetErrorInformation (the previous version
    // returned a ShortString, and truncated long error messages).
    GetLongErrorInformationFn(ErrorCode, Buffer, BufferSize);
    Result := Trim(Buffer);
  finally
    StrDispose(Buffer);
  end;
end;

// -----------------------------------------------------------------------------

function UsingSQL: Boolean;
begin
  Result := UsingSQLFn;
end;

// -----------------------------------------------------------------------------

// MH 13/06/08: Added new function to be used when deciding whether to use alternate
// code added to improve the SQL Edition, returns TRUE if the alternate code should
// be used.  Controlled by '/NoSQLAltFuncs' command-line parameter.
function UsingSQLAlternateFuncs: Boolean;
Begin // UsingSQLAlternateFuncs
  Result := UsingSQL And (Not DisableSQLAltFuncs);
End; // UsingSQLAlternateFuncs

// -----------------------------------------------------------------------------

function OverrideUsingSQL(Value: Boolean): Integer;
begin
  Result := OverrideUsingSQLFn(Value);
end;

// -----------------------------------------------------------------------------

function CopyTable(FromCompanyCode, ToCompanyCode, TableName, WhereClause: AnsiString; DeleteIfExists: Boolean): Integer; stdcall;
begin
  Result := CopyTableFn(PChar(FromCompanyCode), PChar(ToCompanyCode), PChar(TableName), PChar(WhereClause), DeleteIfExists);
end;

// -----------------------------------------------------------------------------

function UpdateTable(CompanyCode, TableName, Values, WhereClause: AnsiString; ClientID: Pointer): Integer;
begin
  Result := UpdateTableFn(PChar(CompanyCode), PChar(TableName), PChar(Values), PChar(WhereClause), PChar(ClientID));
end;

// -----------------------------------------------------------------------------

function GetDBColumnName(BtrieveFileName, FieldName, RecordType: AnsiString): AnsiString;
var
  Buffer: PChar;
  BufferSize: Integer;
begin
  Result := '';
  BufferSize := 256;
  Buffer := StrAlloc(BufferSize);
  try
    if (RecordType = '') then
      Result := GetDBColumnNameFn(PChar(BtrieveFileName), PChar(FieldName), nil, Buffer, 0)
    else
      Result := GetDBColumnNameFn(PChar(BtrieveFileName), PChar(FieldName), PChar(RecordType), Buffer, 0);
  finally
    StrDispose(Buffer);
  end;
end;

// -----------------------------------------------------------------------------

function GetComputedColumnName(BtrieveFileName, FieldName, RecordType: AnsiString): AnsiString; stdcall;
var
  Buffer: PChar;
  BufferSize: Integer;
begin
  Result := '';
  BufferSize := 256;
  Buffer := StrAlloc(BufferSize);
  try
    if (RecordType = '') then
      Result := GetDBColumnNameFn(PChar(BtrieveFileName), PChar(FieldName), nil, Buffer, BufferSize)
    else
      Result := GetDBColumnNameFn(PChar(BtrieveFileName), PChar(FieldName), PChar(RecordType), Buffer, BufferSize);
    if (Result <> '') then
      Result := Trim(Buffer);
  finally
    StrDispose(Buffer);
  end;
end;

// -----------------------------------------------------------------------------

function GetDBTableName(BtrieveFileName: AnsiString): AnsiString;
begin
  Result := GetDBTableNameFn(PChar(BtrieveFileName));
end;

// -----------------------------------------------------------------------------

// CJS 2011-10-19: ABSEXCH-11513 - added ClientID parameter (required by
//                 DiscardCachedData(), which will be called by DeleteRows() in
//                 BtrvSQL.dll).
function DeleteRows(CompanyCode, Filename, WhereClause: AnsiString; ClientID: Pointer): Integer;
begin
  Result := DeleteRowsFn(PChar(CompanyCode), PChar(FileName), PChar(WhereClause), ClientID);
end;

// -----------------------------------------------------------------------------

function CreateCustomPrefillCache(FileName, WhereClause, Columns: AnsiString; var ID: LongInt; ClientID: Pointer = nil): Integer;
begin
  Result := CreateCustomPrefillCacheFn(PChar(FileName), PChar(WhereClause), PChar(Columns), ID, PChar(ClientID));
end;

// -----------------------------------------------------------------------------

function UseCustomPrefillCache(ID: LongInt; ClientID: Pointer = nil): Integer;
begin
  Result := UseCustomPrefillCacheFn(ID, PChar(ClientID));
end;

// -----------------------------------------------------------------------------

function DropCustomPrefillCache(ID: LongInt; ClientID: Pointer = nil): Integer;
begin
  Result := DropCustomPrefillCacheFn(ID, PChar(ClientID));
end;

// -----------------------------------------------------------------------------

function UseVariantForNextCall(var PosBlock; ClientID: Pointer): Integer;
begin
  Result := UseVariantForNextCallFn(PosBlock, ClientID);
end;

// -----------------------------------------------------------------------------

function DiscardCachedData(FileName: AnsiString; ClientID: Pointer = nil): Integer;
begin
  Result := DiscardCachedDataFn(PChar(FileName), ClientID);
end;

// -----------------------------------------------------------------------------

function PostToHistory(NType: Char; Code: ShortString; Purchases, Sales, Cleared, Value1, Value2: double; Currency, Year, Period, DecimalPlaces: Integer; var PreviousBalance: double; var ErrorCode: Integer; ClientID: Pointer): Integer;
begin
  Result := PostToHistoryFn(NType, Code[0], Purchases, Sales, Cleared, Value1, Value2, Currency, Year, Period, DecimalPlaces, PreviousBalance, ErrorCode, ClientID);
end;

// -----------------------------------------------------------------------------

function PostToYearDate(NType: Char; Code: ShortString; Purchases, Sales, Cleared, Value1, Value2: double; Currency, Year, Period, DecimalPlaces: Integer; var ErrorCode: Integer; ClientID: Pointer): Integer;
begin
  Result := PostToYearDateFn(NType, Code[0], Purchases, Sales, Cleared, Value1, Value2, Currency, Year, Period, DecimalPlaces, ErrorCode, ClientID);
end;

// -----------------------------------------------------------------------------

function StockFreeze(CompanyPath, LocationCode: AnsiString; UsePostQty: Boolean; Year, Period: Integer; ClientID: Pointer): Integer;
begin
  Result := StockFreezeFn(PChar(CompanyPath), PChar(LocationCode), UsePostQty, Year, Period, ClientID);
end;

// -----------------------------------------------------------------------------

function CheckAllStock(CompanyPath, StockCode: AnsiString; StockType: Char; Folio: Integer; ClientID: Pointer): Integer;
begin
  Result := CheckAllStockFn(PChar(CompanyPath), PChar(StockCode), StockType, Folio, ClientID);
end;

// -----------------------------------------------------------------------------

function GetLineNumberAccounts(CompanyPath, Code: AnsiString; ClientID: Pointer): Integer;
begin
  Result := GetLineNumberAccountsFn(PChar(CompanyPath), PChar(Code), ClientID);
end;

// -----------------------------------------------------------------------------

function GetLineNumberStock(CompanyPath: AnsiString; Folio: Integer; ClientID: Pointer): Integer;
begin
  Result := GetLineNumberStockFn(PChar(CompanyPath), Folio, ClientID);
end;

// -----------------------------------------------------------------------------

function ResetViewHistory(CompanyPath: AnsiString; NomViewCode: Integer; ClientID: Pointer): Integer;
begin
  Result := ResetViewHistoryFn(PChar(CompanyPath), NomViewCode, ClientID);
end;

// -----------------------------------------------------------------------------

function ResetAuditHistory(CompanyPath: AnsiString; CustCode: AnsiString; DeleteCCDept: Boolean; PurgeYear: Integer; HistCodeLen: Integer; ClientID: Pointer): Integer;
begin
  Result := ResetAuditHistoryFn(PChar(CompanyPath), PChar(CustCode), DeleteCCDept, PurgeYear, HistCodeLen, ClientID);
end;

// -----------------------------------------------------------------------------

function StockLocationFilter(CompanyPath, LocationCode: AnsiString; Mode: Integer; ClientID: Pointer): Integer;
begin
  Result := StockLocationFilterFn(PChar(CompanyPath), PChar(LocationCode), Mode, ClientID);
end;

// -----------------------------------------------------------------------------

function StockAddCustAnal(CompanyPath, CustCode, StockCode, PDate: AnsiString; FolioRef, AbsLineNo, Currency, IdDocHed: Integer; LineType: Char; LineTotal: Double; Mode: Byte; ClientID: Pointer): Integer;
begin
  Result := StockAddCustAnalFn(PChar(CompanyPath), PChar(CustCode), PChar(StockCode), PChar(PDate), FolioRef, AbsLineNo, Currency, IdDocHed, LineType, LineTotal, Mode, ClientID);
end;

// -----------------------------------------------------------------------------

// CJS 2016-05-06 - ABSEXCH-17353 - GL Budgets - Extend to include 5 budget revisions
function TotalProfitToDateRange(
      CompanyPath: AnsiString; NType: Char; NCode: ShortString;
      PCr, PYr, PPr, PPr2: Integer; Range, SetACHist: Boolean;
  var Purch, PSales, Balance, PCleared, PBudget,
      RevisedBudget1, RevisedBudget2, RevisedBudget3, RevisedBudget4, RevisedBudget5,
      BValue1, BValue2: double; ClientID: Pointer): Integer;
begin
  // CJS 2016-05-09 - ABSEXCH-17353 - GL Budgets - Extend to include 5 budget revisions
  // Amended NCode parameter -- this now takes a ShortString, not an untyped parameter
  Result := TotalProfitToDateRangeFn(PChar(CompanyPath), NType, NCode,
              PCr, PYr, PPr, PPr2, Range, SetACHist,
              Purch, PSales, Balance, PCleared, PBudget,
              RevisedBudget1, RevisedBudget2, RevisedBudget3, RevisedBudget4, RevisedBudget5,
              BValue1, BValue2, ClientID);
end;

// -----------------------------------------------------------------------------

function FillBudget(CompanyPath: AnsiString; NType: Integer; Code: ShortString;
  Currency, Year, Period, PeriodInYear: Integer; CalcPurgeOB, Range: Boolean;
  PPr2: Integer; ClientID: Pointer): Integer;
begin
//  Result := FillBudgetFn(PChar(CompanyPath), NType, PChar(StringToHex(Char(20) + Code)), Currency,
//    Year, Period, PeriodInYear, CalcPurgeOB, Range, PPr2, ClientID);
  Result := FillBudgetFn(PChar(CompanyPath), NType, Code, Currency,
    Year, Period, PeriodInYear, CalcPurgeOB, Range, PPr2, ClientID);
end;

// -----------------------------------------------------------------------------

function RemoveLastCommit(CompanyPath: AnsiString; ClientID: Pointer): Integer;
begin
  Result := RemoveLastCommitFn(PChar(CompanyPath), ClientID);
end;

// -----------------------------------------------------------------------------

function PartialUnpostHistory(CompanyPath: AnsiString; NType: Char; NCode: Str20;
  PCr, PYr, PPr, PPr2: Integer; Range, SetACHist: Boolean;
  var Purch, PSales, PCleared, PBudget: double; ClientID: Pointer): Integer;
begin
  Result := PartialUnpostHistoryFn(PChar(CompanyPath), NType, NCode, PCr, PYr,
                                   PPr, PPr2, Range, SetACHist, Purch, PSales,
                                   PCleared, PBudget, ClientID);
end;

// -----------------------------------------------------------------------------

function ExecSQL(QueryStr: AnsiString; CompanyPath: AnsiString): Integer;
begin
  Result := ExecSQLFn(PChar(QueryStr), PChar(CompanyPath));
end;

// -----------------------------------------------------------------------------

function SQLFetch(const QueryStr, Field, CompanyPath: AnsiString; var Value: Variant): Integer;
begin
  Result := SQLFetchFn(PChar(QueryStr), PChar(Field), PChar(CompanyPath), Value);
  if VarIsNull(Value) then
    Value := 0;
end;

// -----------------------------------------------------------------------------

function LastSQLError: ShortString;
begin
  Result := LastSQLErrorFn;
end;

// -----------------------------------------------------------------------------

function UpdateCompanyCache(CompanyCode, CompanyPath: AnsiString): Integer;
begin
  Result := UpdateCompanyCacheFn(PChar(CompanyCode), PChar(CompanyPath));
end;

// -----------------------------------------------------------------------------

procedure UseSQLCacheList;
begin
  UseSQLCacheListFn;
end;

// -----------------------------------------------------------------------------

function CheckExchRnd: Integer;
begin
  Result := CheckExchRndFn;
end;

// =============================================================================
// DLL functions (for accessing the iCore DLL)
// =============================================================================
function Load_DLL(Path: AnsiString): Boolean;

  procedure DisplayLoadingModule;
  var
    Buffer   : PChar;
  begin // GetModulePath
    Buffer := StrAlloc (255);
    try
      GetModuleFileName(HInstance, Buffer, StrBufSize(Buffer));

      ShowMessage('Loading BtrvSQL.DLL from ' + Trim(Buffer));

    finally
      StrDispose(Buffer);
    end; // Try..Finally
  end;

var
  ErrMsg: string;
  DLLSpec: AnsiString;
begin
  Result := False;
  ErrMsg := '';

//DisplayLoadingModule;

  if (Path <> '') then
    Path := IncludeTrailingPathDelimiter(Path);
  DLLSpec := Path + 'BtrvSQL.dll';
  DLLHandle := LoadLibrary(PChar(DLLSpec));

  { Try to get the function addresses from the DLL. }
  if DLLHandle <> 0 then
  begin
    @CreateDatabaseFn     := GetProcAddress(DLLHandle, 'CreateDatabase');
    @CreateCompanyFn      := GetProcAddress(DLLHandle, 'CreateCompany');
    @DeleteCompanyFn      := GetProcAddress(DLLHandle, 'DeleteCompany');
    @OpenCompanyFn        := GetProcAddress(DLLHandle, 'OpenCompany');
    @OpenCompanyByCodeFn  := GetProcAddress(DLLHandle, 'OpenCompanyByCode');
    @GetCompanyCodeFn     := GetProcAddress(DLLHandle, 'GetCompanyCode');
    @TableExistsFn        := GetProcAddress(DLLHandle, 'TableExists');
    @DeleteTableFn        := GetProcAddress(DLLHandle, 'DeleteTable');
    @AttachCompanyFn      := GetProcAddress(DLLHandle, 'AttachCompany');
    @DetachCompanyFn      := GetProcAddress(DLLHandle, 'DetachCompany');
    @ValidCompanyFn       := GetProcAddress(DLLHandle, 'ValidCompany');
    @ValidSystemFn        := GetProcAddress(DLLHandle, 'ValidSystem');
    @GetConnectionStringFn:= GetProcAddress(DLLHandle, 'GetConnectionString');
    @GetConnectionStringWOPassFn:= GetProcAddress(DLLHandle, 'GetConnectionStringWOPass');   //VA:26/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
    @ExportDatasetFn      := GetProcAddress(DLLHandle, 'ExportDataset');
    @ImportDatasetFn      := GetProcAddress(DLLHandle, 'ImportDataset');
    @GetErrorInformationFn:= GetProcAddress(DLLHandle, 'GetErrorInformation');
    @GetLongErrorInformationFn:= GetProcAddress(DLLHandle, 'GetLongErrorInformation');
    @HasExclusiveAccessFn := GetProcAddress(DLLHandle, 'HasExclusiveAccess');
    @UsingSQLFn           := GetProcAddress(DLLHandle, 'UsingSQL');
    @OverrideUsingSQLFn   := GetProcAddress(DLLHandle, 'OverrideUsingSQL');
    @CopyTableFn          := GetProcAddress(DLLHandle, 'CopyTable');
    @UpdateTableFn        := GetProcAddress(DLLHandle, 'UpdateTable');
    @GetDBColumnNameFn    := GetProcAddress(DLLHandle, 'GetDBColumnName');
    @InitialiseFn         := GetProcAddress(DLLHandle, 'Initialise');
    @CompanyExistsFn      := GetProcAddress(DLLHandle, 'CompanyExists');
    @CloseClientIDSessionFn := GetProcAddress(DLLHandle, 'CloseClientIdSession');
    @SetCacheSizeFn       := GetProcAddress(DLLHandle, 'SetCacheSize');
    @DeleteRowsFn         := GetProcAddress(DLLHandle, 'DeleteRows');
    @GetDBTableNameFn     := GetProcAddress(DLLHandle, 'GetDBTableName');
    @CreateCustomPrefillCacheFn := GetProcAddress(DLLHandle, 'CreateCustomPrefillCache');
    @UseCustomPrefillCacheFn := GetProcAddress(DLLHandle, 'UseCustomPrefillCache');
    @DropCustomPrefillCacheFn := GetProcAddress(DLLHandle, 'DropCustomPrefillCache');
    @PostToHistoryFn      := GetProcAddress(DLLHandle, 'PostToHistory');
    @PostToYearDateFn     := GetProcAddress(DLLHandle, 'PostToYearDate');
    @UseVariantForNextCallFn := GetProcAddress(DLLHandle, 'UseVariantForNextCall');
    @ExecSQLFn            := GetProcAddress(DLLHandle, 'ExecSQL');
    @LastSQLErrorFn       := GetProcAddress(DLLHandle, 'LastSQLError');
    @StockFreezeFn        := GetProcAddress(DLLHandle, 'StockFreeze');
    @CheckAllStockFn      := GetProcAddress(DLLHandle, 'CheckAllStock');
    @GetCommonConnectionStringFn:= GetProcAddress(DLLHandle, 'GetCommonConnectionString');
    @GetCommonConnectionStringWOPassFn:= GetProcAddress(DLLHandle, 'GetCommonConnectionStringWOPass');   //SS:26/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
    @GetLineNumberAccountsFn := GetProcAddress(DLLHandle, 'GetLineNumberAccounts');
    @GetLineNumberStockFn := GetProcAddress(DLLHandle, 'GetLineNumberStock');
    @ResetViewHistoryFn := GetProcAddress(DLLHandle, 'ResetViewHistory');
    @ResetAuditHistoryFn := GetProcAddress(DLLHandle, 'ResetAuditHistory');
    @StockLocationFilterFn := GetProcAddress(DLLHandle, 'StockLocationFilter');
    @UpdateCompanyCacheFn := GetProcAddress(DLLHandle, 'UpdateCompanyCache');
    @StockAddCustAnalFn := GetProcAddress(DLLHandle, 'StockAddCustAnal');
    @TotalProfitToDateRangeFn := GetProcAddress(DLLHandle, 'TotalProfitToDateRange');
    @FillBudgetFn := GetProcAddress(DLLHandle, 'FillBudget');
    @RemoveLastCommitFn := GetProcAddress(DLLHandle, 'RemoveLastCommit');
    @PartialUnpostHistoryFn := GetProcAddress(DLLHandle, 'PartialUnpostHistory');
    @RebuildCompanyCacheFn := GetProcAddress(DLLHandle, 'RebuildCompanyCache');
    @DiscardCachedDataFn   := GetProcAddress(DLLHandle, 'DiscardCachedData');
    @UseSQLCacheListFn     := GetProcAddress(DLLHandle, 'UseSQLCacheList');
    @CheckExchRndFn        := GetProcAddress(DLLHandle, 'CheckExchRnd');
    @SetMemCallbackFn      := GetProcAddress(DLLHandle, 'SetMemCallback');
    @SQLFetchFn            := GetProcAddress(DLLHandle, 'SQLFetch');
    if not Assigned(CreateDatabaseFn) then
      ErrMsg := 'CreateDatabase'
    else if not Assigned(CreateCompanyFn) then
      ErrMsg := 'CreateCompany'
    else if not Assigned(DeleteCompanyFn) then
      ErrMsg := 'DeleteCompany'
    else if not Assigned(OpenCompanyFn) then
      ErrMsg := 'OpenCompany'
    else if not Assigned(OpenCompanyByCodeFn) then
      ErrMsg := 'OpenCompanyByCode'
    else if not Assigned(GetCompanyCodeFn) then
      ErrMsg := 'GetCompanyCode'
    else if not Assigned(TableExistsFn) then
      ErrMsg := 'TableExists'
    else if not Assigned(DeleteTableFn) then
      ErrMsg := 'DeleteTable'
    else if not Assigned(AttachCompanyFn) then
      ErrMsg := 'AttachCompany'
    else if not Assigned(DetachCompanyFn) then
      ErrMsg := 'DetachCompany'
    else if not Assigned(GetConnectionStringFn) then
      ErrMsg := 'GetConnectionString'
    else if not Assigned(ExportDatasetFn) then
      ErrMsg := 'ExportDataset'
    else if not Assigned(ImportDatasetFn) then
      ErrMsg := 'ImportDataset'
    else if not Assigned(HasExclusiveAccessFn) then
      ErrMsg := 'HasExclusiveAccess'
    else if not Assigned(GetErrorInformationFn) then
      ErrMsg := 'GetErrorInformation'
    else if not Assigned(GetLongErrorInformationFn) then
      ErrMsg := 'GetLongErrorInformation'
    else if not Assigned(UsingSQLFn) then
      ErrMsg := 'UsingSQL'
    else if not Assigned(OverrideUsingSQLFn) then
      ErrMsg := 'OverrideUsingSQL'
    else if not Assigned(CopyTableFn) then
      ErrMsg := 'CopyTable'
    else if not Assigned(UpdateTableFn) then
      ErrMsg := 'UpdateTable'
    else if not Assigned(GetDBColumnNameFn) then
      ErrMsg := 'GetDBColumnName'
    else if not Assigned(InitialiseFn) then
      ErrMsg := 'Initialise'
    else if not Assigned(CompanyExistsFn) then
      ErrMsg := 'CompanyExists'
    else if not Assigned(CloseClientIDSessionFn) then
      ErrMsg := 'CloseClientIdSession'
    else if not Assigned(SetCacheSizeFn) then
      ErrMsg := 'SetCacheSize'
    else if not Assigned(DeleteRowsFn) then
      ErrMsg := 'DeleteRows'
    else if not Assigned(GetDBTableNameFn) then
      ErrMsg := 'GetDBTableName'
    else if not Assigned(CreateCustomPrefillCacheFn) then
      ErrMsg := 'CreateCustomPrefillCache'
    else if not Assigned(UseCustomPrefillCacheFn) then
      ErrMsg := 'UseCustomPrefillCache'
    else if not Assigned(DropCustomPrefillCacheFn) then
      ErrMsg := 'DropCustomPrefillCache'
    else if not Assigned(PostToHistoryFn) then
      ErrMsg := 'PostToHistory'
    else if not Assigned(PostToYearDateFn) then
      ErrMsg := 'PostToYearDate'
    else if not Assigned(UseVariantForNextCallFn) then
      ErrMsg := 'UseVariantForNextCall'
    else if not Assigned(ExecSQLFn) then
      ErrMsg := 'ExecSQL'
    else if not Assigned(LastSQLErrorFn) then
      ErrMsg := 'LastSQLError'
    else if not Assigned(StockFreezeFn) then
      ErrMsg := 'StockFreeze'
    else if not Assigned(GetCommonConnectionStringFn) then
      ErrMsg := 'GetCommonConnectionString'
    else if not Assigned(CheckAllStockFn) then
      ErrMsg := 'CheckAllStock'
    else if not Assigned(GetLineNumberAccountsFn) then
      ErrMsg := 'GetLineNumberAccounts'
    else if not Assigned(GetLineNumberStockFn) then
      ErrMsg := 'GetLineNumberStock'
    else if not Assigned(ResetViewHistoryFn) then
      ErrMsg := 'ResetViewHistory'
    else if not Assigned(ResetAuditHistoryFn) then
      ErrMsg := 'ResetAuditHistory'
    else if not Assigned(StockLocationFilterFn) then
      ErrMsg := 'StockLocationFilter'
    else if not Assigned(UpdateCompanyCacheFn) then
      ErrMsg := 'UpdateCompanyCache'
    else if not Assigned(StockAddCustAnalFn) then
      ErrMsg := 'StockAddCustAnal'
    else if not Assigned(TotalProfitToDateRangeFn) then
      ErrMsg := 'TotalProfitToDateRange'
    else if not Assigned(FillBudgetFn) then
      ErrMsg := 'FillBudget'
    else if not Assigned(RemoveLastCommitFn) then
      ErrMsg := 'RemoveLastCommit'
    else if not Assigned(PartialUnpostHistoryFn) then
      ErrMsg := 'PartialUnpostHistory'
    else if not Assigned(RebuildCompanyCacheFn) then
      ErrMsg := 'RebuildCompanyCache'
    else if not Assigned(DiscardCachedDataFn) then
      ErrMsg := 'DiscardCachedData'
    else if not Assigned(UseSQLCacheListFn) then
      ErrMsg := 'UseSQLCacheList'
    else if not Assigned(CheckExchRndFn) then
      ErrMsg := 'CheckExchRnd'
{
    else if not Assigned(SetMemCallbackFn) then
      ErrMsg := 'SetMemCallback'
}
    else if not Assigned(SQLFetchFn)then
      ErrMsg := 'SQLFetch'
    else if not Assigned(GetCommonConnectionStringWOPassFn) then
      ErrMsg := 'GetCommonConnectionStringWOPass'   //SS:26/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
    else if not Assigned(GetConnectionStringWOPassFn) then
      ErrMsg := 'GetConnectionStringWOPass'      //VA:26/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords

    else
      { If we have reached here, we have successfully loaded the DLL and
        obtained the addresses of all the required functions. }
      Result := True;
    if ErrMsg <> '' then
      ErrMsg := Format(NOT_FOUND_MSG, [ErrMsg])
    else
      InitialiseFn(PChar(Path));
  end
  else
    ErrMsg := 'Unable to load database connection DLL: ' + DLLSpec;
  if not Result then
  begin
    ShowMessage(ErrMsg + '. Please contact your Technical Support');
    Result := False;
  end;
end;

// -----------------------------------------------------------------------------

function Unload_DLL: Boolean;
begin
  Result := FreeLibrary(DLLHandle);
end;

// -----------------------------------------------------------------------------
//PR: 07/06/2012 Added procedures to allow alternate sql funcs to be turned on and off during execution
{$IFDEF COMTK}
procedure DisableSQLAlternateFuncs;
begin
  DisableSQLAltFuncs := True;
end;

procedure EnableSQLAlternateFuncs;
begin
  DisableSQLAltFuncs := False;
end;
{$ENDIF}

// -----------------------------------------------------------------------------
// CJS 2013-03-22 - ABSEXCH-13413 - Added utility function ExecSQLEx to allow
// timeout to be changed for a SQL query.
function ExecSQLEx(QueryStr: AnsiString; CompanyPath: AnsiString; TimeOut: Integer = 30): Integer;
var
  SQLCaller: TSQLCaller;
  //PR: ABSPLUG-2620 v2017 R2 Changed ConnectionString and CompanyCode to 'AnsiString' to
  //                          allow compilation in D10.
  ConnectionString, Password: WideString;
  CompanyCode: AnsiString;
begin
  SQLCaller := TSQLCaller.Create;
  try
    CompanyCode := SQLUtils.GetCompanyCode(CompanyPath);

    // Get an admin connection string (not read-only)
    //SQLUtils.GetConnectionString(CompanyCode, False, ConnectionString);
    //VA:26/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
    Sqlutils.GetConnectionStringWOPass(CompanyCode, False, ConnectionString, Password) ;
    SQLCaller.ConnectionString := ConnectionString;
    SQLCaller.Connection.Password := Password;

    SQLCaller.Connection.CommandTimeout := TimeOut;
    //VA:06/03/2018:2018-R1:ABSEXCH-19652:Exception in Treconcileobject.delete - The Childrens Trust
    SQLCaller.Query.CommandTimeout := TimeOut ;
    Result := SQLCaller.ExecSQL(QueryStr, CompanyCode);
  finally
    SQLCaller.Free;
  end;
end;

// =============================================================================

initialization
  Randomize;  // Needed for User Ird's and Passwords

//PR: 19/07/2017 ABSEXCH-19019 v2017 R2 Need to avoid loading BtrvSQL for SetHelpr.exe
//after changes in SQLCaller.pas. SQLHelper has EBAD defined, so use that to differentiate
//between the 2 programs. Changes for reconnecting SQL also brought this unit into BtrvSQL
//so we need to make sure we don't try to load BtrvSQL from BtrvSQL
{$IFNDEF BTRVSQL_DLL}
{$If not Defined(SQLHELPER) or Defined(EBAD)}
// MH 05/03/2018 2018-R1 ABSEXCH-19848: Removed loading of SQL Emulator/WBtrv32 for SecRel
{$IFNDEF ENSECREL} // SecRel Only
{$IFNDEF SETUP600}  // The Exchequer set-up program will call Load_DLL at another time.
  if not (Lowercase(ExtractFileName(ParamStr(0))) = 'delphi32.exe') then
    if not Load_DLL then
      Halt;
{$ENDIF}
{$ENDIF ENSECREL} // SecRel Only
{$IfEnd not SQLHELPER}
{$ENDIF BTRVSQL_DLL}
  DisableSQLAltFuncs := FindCmdLineSwitch('NoSQLAltFuncs', ['/', '\', '-'], True);

finalization

//PR: 19/07/2017 ABSEXCH-19019 v2017 R2 Need to avoid loading BtrvSQL for SetHelpr.exe after changes
//in SQLCaller.pas
{$IFNDEF BTRVSQL_DLL}
{$If not Defined(SQLHELPER) or Defined(EBAD)}
// MH 05/03/2018 2018-R1 ABSEXCH-19848: Removed loading of SQL Emulator/WBtrv32 for SecRel
{$IFNDEF ENSECREL} // SecRel Only
{$IFNDEF SETUP600}
  if not (Lowercase(ExtractFileName(ParamStr(0))) = 'delphi32.exe') then
    Unload_DLL;
{$ENDIF}
{$ENDIF ENSECREL} // SecRel Only
{$IfEnd not SQLHELPER}
{$ENDIF BTRVSQL_DLL}

end.

