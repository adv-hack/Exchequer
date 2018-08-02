unit BtrvSQLU;
{
  This is a 'switch and wrapper' unit for database access. It uses the
  Exchequer Licence file to determine whether the database type is Btrieve or
  SQL Server, and loads the appropriate DLL (WBTRV32.DLL or iCoreBtrv.DLL).
}

{$ALIGN 1}
{$REALCOMPATIBILITY ON}

interface

type
  { Callback function for memory test }
  TMemCallback = procedure(Msg: ShortString);

  { Function type declarations for DLL calls }
  TBTRCall = function(
                      operation: WORD;
                  var posblk;
                  var databuf;
                  var datalen  : WORD;
                  var keybuf;
                      keylen   : BYTE;
                      keynum   : Integer
                     ): SmallInt; StdCall;

  TBTRCallID = function(
                        operation: WORD;
                    var posblk;
                    var databuf;
                    var datalen  : WORD;
                    var keybuf;
                        keylen   : BYTE;
                        keynum   : Integer;
                        clientid : PChar
                       ): SmallInt; StdCall;

  TWBTRVInit = function(var InitializationString): Integer; StdCall;

  TWBTRVStop = function: Integer; StdCall;

  Str20 = string[20];

{ int SetCacheSize(BTI_BUFFER_PTR ClientId, BTI_VOID_PTR posBlock, int nSize, int* oldSize); }
  TSQLSetCacheSizeCall = function(
                           SecuritySignature: PChar;
                           ClientId: PChar;
                           var posblk;
                           Size: Integer;
                           var OldSize: Integer
                         ): SmallInt; StdCall;

{ INT  DeleteRows(char* SecuritySignature, char* CompanyCode, char* Filename, char* WhereClause); }
  TSQLDeleteRowsCall = function(
                         SecuritySignature: PChar;
                         CompanyCode: PChar;
                         FileName: PChar;
                         WhereClause: PChar
                       ): SmallInt; stdcall;

  TSQLCall = function
             (
               ClientID: PChar;
               SecuritySignature: PChar;
               Code: PChar
             ): Integer; stdcall;


  TSQLClientIDCall = function
                     (
                       ClientID: PChar
                     ): Integer; stdcall;

  TSQLCreateDatabaseCall = function
             (
               ClientID: PChar;
               SecuritySignature: PChar;
               Code: PChar;
               Username: PChar;
               Password: PChar
             ): Integer; stdcall;

  TSQLCreateCompanyCall = function
                          (
                            SecuritySignature: PChar;
                            ClientId: PChar;
                            Username: PChar;
                            Password: PChar;
                            ReadonlyUsername: PChar;
                            ReadonlyPassword: PChar;
                            CompanyCode: PChar;
                            CompanyName: PChar;
                            ImportZipFileName: PChar
                          ): Integer; stdcall;

  TSQLConnectionStringCall = function
                             (
                               SecuritySignature: PChar;
                               ClientId: PChar;
                               CompanyCode: PChar;
                               ConnectionBuffer: Pointer;
                               BufferSize: Pointer
                             ): Integer; stdcall;

  //VA:26/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
  TSQLConnectionStringWOPassCall = function
                                   (
                                     SecuritySignature: PChar;
                                     ClientId: PChar;
                                     CompanyCode: PChar;
                                     ConnectionBuffer: Pointer;
                                     BufferSize: Pointer;
                                     PasswordBuffer: Pointer): Integer; stdcall;

  TSQLCommonConnectionStringCall =
  function
  (
     SecuritySignature: PChar;
     ClientId: PChar;
     ConnectionBuffer: Pointer;
     BufferSize: Pointer
  ): Integer; stdcall;

  //SS:26/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
  TSQLCommonConnectionStringWOPassCall = function
                                         (
                                           SecuritySignature: PChar;
                                           ClientId: PChar;
                                           ConnectionBuffer: Pointer;
                                           BufferSize: Pointer;
                                           PasswordBuffer: Pointer): Integer; stdcall;

{
INT GetCommonConnectionString(	char* SecuritySignature,
char* ClientId,
char** ConnectionBuffer,
int* BufferSize,
int Readonly )
}

  TSQLImportCall = function
                   (
                     SecuritySignature: PChar;
                     CompanyCode: PChar;
                     FileName: PChar
                   ): Integer; stdcall;

  TSQLExportCall = function
                   (
                     SecuritySignature: PChar;
                     CompanyCode: PChar;
                     FileName: PChar;
                     DatasetName: PChar
                   ): Integer; stdcall;

  TSQLErrorInformationCall = function
                             (
                               ErrorCode: Integer;
                               ClientId: PChar;
                               ErrorBuffer: Pointer;
                               BufferSize: Integer
                             ): Integer; stdcall;

  TSQLExclusiveAccessCall = function
                            (
                              SecuritySignature: PChar;
                              ClientId: PChar;
                              CompanyCode: PChar;
                              Users: Pointer
                            ): Integer; stdcall;

  TSQLCopyTableCall = function
                      (
                        SecuritySignature: PChar;
                        ExistingCompanyCode: PChar;
                        NewCompanyCode: PChar;
                        TableName: PChar;
                        WhereClause: PChar;
                        DeleteIfExists: Integer
                      ): Integer; stdcall;

  TSQLUpdateTableCall = function
                        (
                          SecuritySignature: PChar;
                          ClientId: PChar;
                          CompanyCode: PChar;
                          TableName: PChar;
                          SetValues: PChar;
                          WhereClause: PChar
                        ): Integer; stdcall;

  TSQLGetDBColumnNameCall = function
                            (
                              BtrieveFileName: PChar;
                              FieldName: PChar;
                              RecordType: PChar;
                              DBFieldNameBuffer: Pointer;
                              BufferSize: Pointer;
                              DBComputedFieldNameBuffer: Pointer;
                              ComputedFieldBufferSize: Pointer
                            ): Integer; stdcall;

  TSQLGetDBTableNameCall = function
                            (
                              BtrieveFileName: PChar;
                              DBFieldNameBuffer: Pointer;
                              BufferSize: Pointer
                            ): Integer; stdcall;

  TSQLCreateCustomPrefillCacheEmulatorCall =
    function
    (
      SecuritySignature: PChar;
      ClientId: PChar;
      BtrieveFilename: PChar;
      WhereClause: PChar;
      Columns: PChar;
      var ID: LongInt
    ): Integer; stdcall;

  TSQLUseCustomPrefillCacheEmulatorCall =
    function
    (
      SecuritySignature: PChar;
      ClientId: PChar;
      Id: LongInt
    ): Integer; stdcall;

  TSQLDropCustomPrefillCacheEmulatorCall =
    function
    (
      SecuritySignature: PChar;
      ClientId: PChar;
      Id: LongInt
    ): Integer; stdcall;
{
INT  UseVariantForNextCall(char* SecuritySignature,
char* szClientId,
void* lPosBlock);
}
  TSQLUseVariantForNextCall =
    function
    (
      SecuritySignature: PChar;
      ClientId: PChar;
      var PosBlock
    ): Integer; stdcall;

  TSQLPostToHistoryCall =
    function
    (
      ClientID: PChar;
      NType: integer;
      var Code;
      Purchases: double;
      Sales: double;
      Cleared: double;
      Value1: double;
      Value2: double;
      Currency: Integer;
      Year: Integer;
      Period: Integer;
      DecimalPlaces: Integer;
      var PreviousBalance: double;
      var ErrorCode: Integer
    ): Integer; stdcall;

{
  INT  PostToHistory(
    char* ClientId,
    Int Type,
    Void* Code,
    Double Purchases,
    Double Sales,
    Double Cleared,
    Double Value1,
    Double Value2,
    Int Currency,
    Int Year,
    Int Period,
    Int DecimalPlaces,
    double* PreviousBalance,
    Int* ErrorMessageCode
  );
}

  TSQLPostToYearDateCall =
    function
    (
      ClientID: PChar;
      NType: integer;
      var Code;
      Purchases: double;
      Sales: double;
      Cleared: double;
      Value1: double;
      Value2: double;
      Currency: Integer;
      Year: Integer;
      Period: Integer;
      DecimalPlaces: Integer;
      var ErrorCode: Integer
    ): Integer; stdcall;
{
INT PostToYearDate(
  char* ClientId,
  int Type,
  void* Code,
  int Purchases,
  double Sales,
  double Cleared,
  double Value1,
  double Value2,
  int Currency,
  int Year,
  char* WhereClause
);
}

  TSQLFillBudgetCall =
    function
    (
      ClientID: PChar;
      NType: Integer;
      var Code;
      Currency: Integer;
      Year: Integer;
      Period: Integer;
      PeriodInYear: Integer;
      CalcPurgeOB: Boolean;
      Range: Boolean;
      PPr2: Integer
    ): Integer; stdcall;
{
INT FillBudget(
  char* szClientId,
  int NType,
  char* Code,
  int Currency,
  int Year,
  int Period,
  int PeriodInYear,
  bool CalcPurgeOB,
  bool Range,
  int PPr2
);
}

  TSQLStockFreezeCall =
    function
    (
      ClientID: PChar;
      CompanyCode: PChar;
      LocationCode: PChar;
      UsePostQty: Boolean;
      Year: Integer;
      Period: Integer
    ): Integer; stdcall;
{
INT StockFreeze(
  char* szClientId,
  char* ComapnyCode,
  char* LocationCode,
  bool UsePostQty,
  int Year,
  int Period
);
}

  TSQLCheckAllStockCall =
    function
    (
      ClientID: PChar;
      CompanyCode: PChar;
      StockCode: PChar;
      StockType: Char;
      Folio: Integer
    ): Integer; stdcall;

{
INT CheckAllStock(
  char* szClientId,
  char* ComapnyCode,
  char* StockCode,
  char StockType,
  int Folio
);
}

  TSQLGetLineNumberAccountsCall =
    function
    (
      ClientID: PChar;
      Code: PChar;
      var ResultValue: Integer
    ): Integer; stdcall;

{
INT GetLineNumberAccounts(
  char* szClientId,
  char* Code,
  int* ResultValue
);
}

  TSQLGetLineNumberStockCall =
    function
    (
      ClientID: PChar;
      Folio: Integer;
      var ResultValue: Integer
    ): Integer; stdcall;

{
INT GetLineNumberStock(
  char* szClientId,
  Int Folio,
  int* ResultValue
);
}

  TSQLResetViewHistoryCall =
    function
    (
      ClientID: PChar;
      CompanyCode: PChar;
      NomViewCode: Integer
    ): Integer; stdcall;

{
INT ResetViewHistory(
  char* szClientId,
  char* CompanyCode,
  int NomViewcode
);
}

  TSQLResetAuditHistoryCall =
    function
    (
      ClientID: PChar;
      CompanyCode: PChar;
      CustCode: PChar;
      DeleteCCDept: Boolean;
      PurgeYear: Integer;
      HistCodeLen: Integer
    ): Integer; stdcall;

{
INT ResetAuditHistory(
  char* szClientId,
  char* CompanyCode,
  char* CustCode,
  bool DeleteCCDept,
  int PurgeYear,
  int HistCodeLen
);
}

  TSQLStockLocationFilterCall =
    function
    (
      ClientID: PChar;
      CompanyCode: PChar;
      LocationCode: PChar;
      Mode: Integer
    ): Integer; stdcall;

{
INT StockLocationFilter(
  char* szClientId,
  char* CompanyCode,
  char* LocationCode,
  int Mode
);
}

  TSQLStockAddCustAnalCall =
    function
    (
      ClientID: PChar;
      CustCode: PChar;
      StockCode: PChar;
      PDate: PChar;
      FolioRef: Integer;
      AbsLineNo: Integer;
      Currency: Integer;
      IdDocHead: Integer;
      LineType: Char;
      LineTotal: Double;
      Mode: Integer
    ): Integer; stdcall;

{
INT StockAddCustAnal(
  char* szClientId,
  char* CustCode,
  char* StockCode,
  char* PDate,
  int FolioRef,
  int AbsLineNo,
  int Currency,
  int IdDocHead,
  char LineType,
  double LineTotal,
  int Mode
);
}

  // CJS 2016-05-06 - ABSEXCH-17353 - GL Budgets - Extend to include 5 budget revisions
  TSQLTotalProfitToDateRangeCall =
    function
    (
      ClientID: PChar;
//      CustCode: PChar;
      NType: Char;
      var NCode;
      PCr: Integer;
      PYr: Integer;
      PPr: Integer;
      PPr2: Integer;
      Range: Boolean;
      SetACHist: Boolean;
      var Purch: Double;
      var PSales: Double;
      var Balance: Double;
      var PCleared: Double;
      var PBudget: Double;
      var RevisedBudget1: Double;
      var RevisedBudget2: Double;
      var RevisedBudget3: Double;
      var RevisedBudget4: Double;
      var RevisedBudget5: Double;
      var BValue1: Double;
      var BValue2: Double
    ): Integer; stdcall;

{
INT TotalProfitToDateRange(
  char* szClientId,
  char* CustCode,
  char NType,
  char* NCode,
  int PCr,
  int PYr,
  int PPr,
  int PPr2,
  bool Range,
  bool SetACHist,
  double* Purch,
  double* PSales,
  double* Balance,
  double* PCleared,
  double* PBudget,
  double* PRBudget,
  double* BValue1,
  double* BValue2);
}

  TSQLRemoveLastCommitCall =
    function
    (
      ClientID: PChar
    ): Integer; stdcall;

  TSQLDiscardCachedDataCall =
    function
    (
      ClientID: PChar;
      FileName: PChar
    ): Integer; stdcall;

{
INT  DiscardCachedData (
  char* szClientId,
  char* szFileName
);
}

{ === Exported functions ===================================================== }

procedure SetMemCallback(Callback: TMemCallBack);

{
  The four Btrieve functions, BTRCALL, BTRCALLID, WBTRVINIT, and WBTRVSTOP, can
  be called under both Btrieve and the SQL Emulator -- the calls will be
  directed to the appropriate database access DLL.

  Most of the other functions in this unit should only be called when running
  under the SQL Emulator (exceptions are noted in the descriptions of the
  individual functions).
}
function BTRCALL(
                 operation : WORD;
             var posblk;
             var databuf;
             var datalen   : WORD;
             var keybuf;
                 keylen    : BYTE;
                 keynum    : Integer
                ) : SmallInt; StdCall;

function BTRCALLID(
                   operation : WORD;
               var posblk;
               var databuf;
               var datalen   : WORD;
               var keybuf;
                   keylen    : BYTE;
                   keynum    : Integer;
               var clientid
                  ) : SmallInt; StdCall;


{
  Sets the cache size for the Emulator to use for the file specified by the
  supplied PosBlock. Returns the previous size in OldSize.
}
function SetCacheSize(var PosBlock; Size: Integer; var OldSize: Integer; ClientID: Pointer = nil): Integer; stdcall;

{
  Deletes records from the specified table, filtering them by the supplied
  Where clause.
}
function DeleteRows(CompanyCode, Filename, WhereClause: PChar; ClientID: Pointer): Integer; stdcall;

function WBTRVINIT(var InitializationString): Integer; StdCall;
function WBTRVSTOP: Integer; StdCall;

function CreateDatabase(ServerName, DatabaseName, UserName, Password: PChar): Integer; stdcall;
function CreateCompany(CompanyCode, CompanyName, CompanyPath, ZIPFileName, UserName, Password,
  ReadOnlyName, ReadOnlyPassword: PChar; ClientID: Pointer): Integer; stdcall;
function AttachCompany(CompanyCode: PChar; ClientID: Pointer): Integer; stdcall;
function DetachCompany(CompanyCode: PChar; ClientID: Pointer): Integer; stdcall;
function DeleteCompany(CompanyCode: PChar; ClientID: Pointer): Integer; stdcall;
function RebuildCompanyCache: Integer; stdcall;

{
  CloseClientIDSession should be called after making use of a Client ID, to
  ensure that the Client ID is released by the Emulator.
}
function CloseClientIdSession(ClientId: Pointer; Remove: Boolean): Integer; stdcall;

{
  GetConnectionString returns the database connection string for access to the
  specified company. If GetReadOnly is True, the connection string will contain
  the username and password for the read-only user -- this is the connection
  string which is usually made available for third-party access. If read-only
  is False, the Admin user name and password are used, allowing full access to
  the company tables.
}
function GetConnectionString(CompanyCode: PChar; GetReadOnly: Boolean;
  ConnectionString: PChar; ConnectionStringLength: Integer;
  ClientID: Pointer): Integer; stdcall;

 //VA:26/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
function GetConnectionStringWOPass(CompanyCode: PChar; GetReadOnly: Boolean; ConnectionString: PChar;
  ConnectionStringLength: Integer; Password: PChar; ClientID: Pointer): Integer; stdcall;

function GetCommonConnectionString(ConnectionString: PChar;
  ConnectionStringLength: Integer; ClientID: Pointer): Integer; stdcall;
 //SS:26/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
function GetCommonConnectionStringWOPass(ConnectionString: PChar;
  ConnectionStringLength: Integer; Password: PChar; ClientID: Pointer): Integer; stdcall;

{
  CopyTable copies records from a table in one company to the equivalent table
  in another company. The WhereClause can be used to select the records to be
  copied.
}
function CopyTable(FromCompanyCode, ToCompanyCode, TableName, WhereClause: PChar; DeleteIfExists: Boolean): Integer; stdcall;

{
  UpdateTable updates fields in the records identified by the WhereClause. The
  Values parameter should hold a comma-separated list of fields and values.

  Example:
    nSuccess := UpdateTable('ZZZZ01', 'JOBDET.DAT', 'RecpFix = ''J'', SubType=''M''', '(RecpFix = ''T'' and SubType=''Z'')');
}
function UpdateTable(CompanyCode, TableName, Values, WhereClause: PChar; ClientID: Pointer): Integer; stdcall;

{
  GetDBColumnName returns the actual database column name, given the field name
  in the schema file (note that this column name is sometimes the same as the
  Toolkit field name, sometimes the name of the record structure field, and
  sometimes a name unique to the schema).

  Examples:
    FieldName := GetDbColumnNameFromSchemaName('JOBDET.DAT', 'posted', 'JE');
    FieldName := GetDbColumnNameFromSchemaName('DOCUMENT.DAT', 'f_run_no', '');

  RecordType can be left blank for non-variant types.
}
function GetDBColumnName(BtrieveFileName, FieldName, RecordType: PChar; ComputedColumnName: PChar; ComputedColumnNameLength: Integer): ShortString; stdcall;

{
  GetDBTableName returns the actual database table matching the supplied
  Btrieve file name.
}
function GetDBTableName(BtrieveFileName: PChar): ShortString; stdcall;

function OpenCompany(Path: PChar; ClientID: Pointer): Integer; stdcall;
function OpenCompanyByCode(Code: PChar): Integer; stdcall;
function GetCompanyCode(ForPath: PChar): ShortString; stdcall;
function CompanyExists(ForCode: PChar; ClientID: Pointer): Integer; stdcall;

{
  If running under the SQL Emulator, TableExists returns True if the specified
  table is found in the current company (note that FileSpec should still include
  a full company path).

  If running under Btrieve, TableExists actually does a FileExists against the
  specified file.
}
function TableExists(FileSpec: PChar; ClientID: Pointer): Integer; stdcall;

{
  If running under the SQL emulator, DeleteTable deletes the specified table
  from the current company (note that FileSpec should still include the full
  company path).

  If running under Btrieve, DeleteTable actually does a DeleteFile on the
  specified file.
}
function DeleteTable(FileSpec: PChar; ClientID: Pointer): Integer; stdcall;

function ValidCompany(FilePath: PChar): Integer; stdcall;
function ValidSystem(ForPath: PChar): Integer; stdcall;

{
  HasExclusiveAccess returns True if there are no other users accessing the
  database.

  At the moment this routine is rather unpredictable (it checks the count of the
  number of users accessing the system, and assumes that if there are less than
  two users, the current user must be the only user in the system).

  Note also that it checks for access to the entire system, NOT to a specific
  company -- checking for access to a company is not supported by the Emulator
  (the company path parameter of this function is actually ignored, and is not
  passed on to the Emulator).
}
function HasExclusiveAccess(CompanyPath: PChar; ClientID: Pointer): Integer; stdcall;

{ Exports all data from the company to the ZIP file specified by FileName. }
function ExportDataset(CompanyCode: PChar; FileName: PChar; ExportType: Integer): Integer; stdcall;

{
  Imports all data from the ZIP file specified by FileName, into the company
  identified by CompanyCode. Existing data will be deleted.
}
function ImportDataset(CompanyCode: PChar; FileName: PChar): Integer; stdcall;

{
  GetErrorInformation returns the description matching the Emulator error
  code. GetLongErrorInformation is a newer version which will return longer
  error messages -- this is the version which is called by SQLUtils.
}
function GetErrorInformation(var ErrorCode: Integer): ShortString; stdcall;
procedure GetLongErrorInformation(var ErrorCode: Integer; ErrorString: PChar; ErrorStringLength: Integer); stdcall;

{
  The UsingSQL function returns True if the database type is SQL Server,
  otherwise it returns False.
}
function UsingSQL: Boolean; StdCall;

{
  The OverrideUsingSQL function allows the calling process to specify whether
  Btrieve or SQL should be used, overriding whatever has been determined from
  the licence. This is used by the Setup program, which needs to be able to
  specify the database type, because the Licence will not yet be available.

  Calling this function will release any existing database-access DLL, and
  load the required DLL.
}
function OverrideUsingSQL(Value: Boolean): Integer; stdcall;

{
  Initialise loads the appropriate DLL from the specified path. If the path is
  not specified, the DLL will be loaded from the Exchequer installation path.

  There is generally no need to call this function, and it is called
  automatically (with no path) from the first call to BTRCall or BTRCallID, if
  it has not already been called.

  The path is normally only used by the Setup program (which *does* call this
  function), because it will be run from a path other than the installation
  path, and needs to tell this DLL where to find the database-access DLLs.
}
function Initialise(Path: PChar): Integer; stdcall;

{
  The CreateCustomPrefillCache sets up the emulator to use a pre-filled
  cache based on the supplied Where clause and column names. Columns is a
  comma-separated list of column names.
}
function CreateCustomPrefillCache(FileName, WhereClause, Columns: PChar; var ID: LongInt; ClientID: Pointer): Integer; stdcall;

{
  Use the Prefilled Cache for the next BTRVCALL or BTRVCALLID function call.
  The ID is the ID returned by CreateCustomPrefillCache.
}
function UseCustomPrefillCache(ID: LongInt; ClientID: Pointer): Integer; stdcall;

{
  Drops the specified prefilled cache. This must be called when the cache is
  no longer required.
}
function DropCustomPrefillCache(ID: LongInt; ClientID: Pointer): Integer; stdcall;

{
  For the next BTRVCALL or BTRVCALLID function call, only return the columns
  relevant to the required variant record. The Emulator will determine the
  correct variant on the basis of the key that is passed to the Btrieve call.
}
function UseVariantForNextCall(var PosBlock; ClientID: Pointer): Integer; stdcall;

{
  Calls the PostToHistory stored procedure.
}
function PostToHistory(NType: Char; var Code; Purchases, Sales, Cleared, Value1, Value2: double; Currency, Year, Period, DecimalPlaces: Integer; var PreviousBalance: double; var ErrorCode: Integer; ClientID: Pointer): Integer; stdcall;

{
  Calls the PostToYearDate stored procedure.
}
function PostToYearDate(NType: Char; var Code; Purchases, Sales, Cleared, Value1, Value2: double; Currency, Year, Period, DecimalPlaces: Integer; var ErrorCode: Integer; ClientID: Pointer): Integer; stdcall;

{
  Executes an arbitrary SQL query.
}
function ExecSQL(QueryStr: PChar; CompanyPath: PChar): Integer; stdcall;

{
  Executes an arbitrary SQL query, and returns the value of Field in Value. This
  is used (for example) for SUM and COUNT queries, where the result can be
  returned in Value. The Field parameter specifies the field that holds the
  required result:

    Res := SQLFetch('SELECT COUNT(acCode) AS custcount FROM [COMPANY].CUSTSUPP,
                    'custcount',
                    'C:\EXCHSQL\COMPANY', // or pass SetDrive
                    CountResult);

  Any error will return an error code 10. LastSQLError will hold the error
  description.
}
function SQLFetch(const QueryStr, Field, CompanyPath: PChar; var Value: Variant): Integer;

procedure EnteringModule(ModuleName: PChar); stdcall;
procedure LeavingModule(ModuleName: PChar); stdcall;
{
  Stored Procedure calls
}
function StockFreeze(CompanyPath, LocationCode: PChar; UsePostQty: Boolean; Year, Period: Integer; ClientID: Pointer): Integer; stdcall;
function CheckAllStock(CompanyPath: PChar; StockCode: PChar; StockType: Char; Folio: Integer; ClientID: Pointer): Integer; stdcall;
function GetLineNumberAccounts(CompanyPath, Code: PChar; ClientID: Pointer): Integer; stdcall;
function GetLineNumberStock(CompanyPath: PChar; Folio: Integer; ClientID: Pointer): Integer; stdcall;
function ResetViewHistory(CompanyPath: PChar; NomViewCode: Integer; ClientID: Pointer): Integer; stdcall;
function ResetAuditHistory(CompanyPath: PChar; CustCode: PChar; DeleteCCDept: Boolean; PurgeYear: Integer; HistCodeLen: Integer; ClientID: Pointer): Integer; stdcall;
function StockLocationFilter(CompanyPath, LocationCode: string; Mode: Integer; ClientID: Pointer): Integer; stdcall;
function StockAddCustAnal(CompanyPath, CustCode, StockCode, PDate: PChar; FolioRef, AbsLineNo, Currency, IdDocHed: Integer; LineType: Char; LineTotal: Double; Mode: Byte; ClientID: Pointer): Integer; stdcall;

// CJS 2016-05-09 - ABSEXCH-17353 - GL Budgets - Extend to include 5 budget revisions
// Amended NCode parameter -- this now takes a ShortString, not an untyped parameter
function TotalProfitToDateRange(CompanyPath: PChar; NType: Char; NCode: ShortString;
  PCr, PYr, PPr, PPr2: Integer; Range, SetACHist: Boolean;
  var Purch, PSales, Balance, PCleared, PBudget,
  RevisedBudget1, RevisedBudget2, RevisedBudget3, RevisedBudget4, RevisedBudget5,
  BValue1, BValue2: double; ClientID: Pointer): Integer; stdcall;

function FillBudget(CompanyPath: PChar; NType: Integer; var Code;
  Currency, Year, Period, PeriodInYear: Integer; CalcPurgeOB, Range: Boolean;
  PPr2: Integer; ClientID: Pointer): Integer; stdcall;
function RemoveLastCommit(CompanyPath: PChar; ClientID: Pointer): Integer; stdcall;
function PartialUnpostHistory(CompanyPath: PChar; NType: Char; NCode: Str20;
  PCr, PYr, PPr, PPr2: Integer; Range, SetACHist: Boolean;
  var Purch, PSales, PCleared, PBudget: double; ClientID: Pointer): Integer; stdcall;
function CheckExchRnd: Integer; stdcall;

function DiscardCachedData(FileName: PChar; ClientID: Pointer): Integer; stdcall;

function UpdateCompanyCache(CompanyCode, CompanyPath: PChar): Integer; stdcall;

function LastSQLError: ShortString; stdcall;

function Load_DLL(Path: PChar): Boolean;

function Unload_DLL: Boolean;

var
  Redirected: Boolean;

implementation

uses SysUtils, Classes, Windows, Registry, IniFiles, Dialogs, ActiveX, SyncObjs,
  Contnrs,
  ADODB,
  DB,
  Variants,
{$IFDEF SQLDEBUG}
  BtrvU2,
{$ENDIF}
  ETStrU,
  EntLic,
  LicRec,
  DebugLogU,
  ClientIdU,
  SQLCallerU,
  SQLCompany,
  SQLCache,
  SQLLockU,
  SQLVariantsU,
  SQLStructuresU,
  SQLRedirectorU,
  StrUtils;

var
  DLLPath: AnsiString;
  DLLHandle: LongWord;
  ClientIDs: TClientIDs;

  FLastSQLError: ShortString;

  { Function pointer variables }
  BTRCallFn:     TBTRCall;
  BTRCallIDFn:   TBTRCallID;
  WBTRVInitFn:   TWBTRVInit;
  WBTRVStopFn:   TWBTRVStop;

  CreateDatabaseFn:       TSQLCreateDatabaseCall;
  CreateCompanyFn:        TSQLCreateCompanyCall;
  DeleteCompanyFn:        TSQLCall;
  ConnectionStringFn:     TSQLConnectionStringCall;
  CommonConnectionStringFn: TSQLCommonConnectionStringCall;
  ConnectionStringWOPassFn: TSQLConnectionStringWOPassCall;   //VA:26/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
  CommonConnectionStringWOPassFn: TSQLCommonConnectionStringWOPassCall;   //SS:26/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
  AttachCompanyFn:        TSQLCall;
  DetachCompanyFn:        TSQLCall;
  OpenCompanyFn:          TSQLCall;
  TableExistsFn:          TSQLCall;
  DeleteTableFn:          TSQLCall;
  ExportDatasetFn:        TSQLExportCall;
  ImportDatasetFn:        TSQLImportCall;
  GetSQLErrorInfoFn:      TSQLErrorInformationCall;
  HasExclusiveAccessFn:   TSQLExclusiveAccessCall;
  CopyTableFn:            TSQLCopyTableCall;
  UpdateTableFn:          TSQLUpdateTableCall;
  GetDBColumnNameFn:      TSQLGetDBColumnNameCall;
  GetDBTableNameFn:       TSQLGetDBTableNameCall;
  CloseClientIdSessionFn: TSQLClientIDCall;
  SetCacheSizeFn:         TSQLSetCacheSizeCall;
  DeleteRowsFn:           TSQLDeleteRowsCall;
  CreateCustomPrefillCacheEmulatorFn: TSQLCreateCustomPrefillCacheEmulatorCall;
  UseCustomPrefillCacheEmulatorFn: TSQLUseCustomPrefillCacheEmulatorCall;
  DropCustomPrefillCacheEmulatorFn: TSQLDropCustomPrefillCacheEmulatorCall;
  PostToHistoryFn:        TSQLPostToHistoryCall;
  PostToYearDateFn:       TSQLPostToYearDateCall;
  UseVariantForNextCallFn:  TSQLUseVariantForNextCall;
  DiscardCachedDataFn:    TSQLDiscardCachedDataCall;

  StockFreezeFn:          TSQLStockFreezeCall;
  CheckAllStockFn:        TSQLCheckAllStockCall;
  GetLineNumberAccountsFn:TSQLGetLineNumberAccountsCall;
  GetLineNumberStockFn:   TSQLGetLineNumberStockCall;
  ResetViewHistoryFn:     TSQLResetViewHistoryCall;
  ResetAuditHistoryFn:    TSQLResetAuditHistoryCall;
  StockLocationFilterFn:  TSQLStockLocationFilterCall;
  StockAddCustAnalFn:     TSQLStockAddCustAnalCall;
  TotalProfitToDateRangeFn: TSQLTotalProfitToDateRangeCall;
  FillBudgetFn:           TSQLFillBudgetCall;
  RemoveLastCommitFn:     TSQLRemoveLastCommitCall;

  MemCallbackFn: TMemCallBack;

  IsSQL: Boolean;
  IsInitialised: Boolean;

  PreviousPath: string;
  CompanyCode: string;

  BTRCallProtector: TMultiReadExclusiveWriteSynchronizer;

const
  NOT_FOUND_MSG = 'Could not find %s function in database connection DLL.';

  EXPORT_ALL = 0;
  EXPORT_COMMON = 1;
  EXPORT_COMPANY = 2;
  // CJS 2012-02-15 - ABSEXCH-11856 - MS SQL Backup/Restore for LIVE
  // Constants for including the LIVE tables. Only use these if the current
  // install of Exchequer is already known to include these tables.
  EXPORT_LIVE_ALL = 3;
  EXPORT_LIVE_COMMON = 4;
  EXPORT_LIVE_COMPANY = 5;

{$IFDEF SQLDEBUG}
type
  TSQLFile = class(TObject)
  public
    PosBlock: Integer;
    FileSpec: string;
  end;
  TSQLFiles = class(TObject)
  private
    FList: TObjectList;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(PosBlock: Integer; FileSpec: string);
    function FileSpec(PosBlock: Integer): string;
    function IndexOf(PosBlock: Integer): Integer;
    function IsRecorded(PosBlock: Integer): Boolean;
  end;

var
  SQLFiles: TSQLFiles;
{$ENDIF}

// =============================================================================
// Support Routines
// =============================================================================
procedure SetMemCallback(Callback: TMemCallBack);
begin
  MemCallbackFn := Callback;
  MemCallbackFn('Callback installed');
end;

procedure CheckOpenCompanyID(FileSpec: string; var ClientID);

  // ...........................................................................
  function FilePath(NewFileSpec: string): string;
  const
    Files: array[0..94] of string =
    (
      'CCDEPTV.DAT',
      'COMPANY.DAT',
      'CONTACT.DAT',
	    'CURRENCYHISTORY.DAT',
      'EBUS.DAT',
      'EBUS\EBUSDETL.DAT',
      'EBUS\EBUSDOC.DAT',
      'EBUS\EBUSLKUP.DAT',
      'EBUS\EBUSNOTE.DAT',
      'FAXSRV\FAXES.DAT',
      'GROUPCMP.DAT',
      'GROUPS.DAT',
      'GROUPUSR.DAT',
      'IMPORTJOB.DAT',
      'SCHEDCFG.DAT',
      'SENTSYS.DAT',
      'TRADE\TILLNAME.DAT',
      'TOOLS.DAT',
      'EXCHQSS.DAT',
      'EXCHQNUM.DAT',
      'CUST\CUSTSUPP.DAT',
      'CUST\CONTACTROLE.DAT',
      'CUST\ACCOUNTCONTACT.DAT',
      'CUST\ACCOUNTCONTACTROLE.DAT',
      'FORMS\PAPRSIZE.DAT',
      'JC\MCPAY.DAT',
      'JC\EMPPAY.DAT',
      'JOBS\JOBCTRL.DAT',
      'JOBS\JOBDET.DAT',
      'JOBS\JOBHEAD.DAT',
      'JOBS\JOBMISC.DAT',
      'JOBS\ANALYSISCODEBUDGET.DAT',
      'JOBS\JOBTOTALSBUDGET.DAT',
      'MISC\ANONYMISATIONDIARY.DAT',    // MH 11/12/2017 2018-R1 ABSEXCH-19487: Added support for new Anonymisation Diary Table
      'MISC\CUSTOMERDISCOUNT.DAT',
      'MISC\EXCHQCHK.DAT',
      'MISC\EXSTKCHK.DAT',
      'MISC\FINANCIALMATCHING.DAT',
      'MISC\MULTIBUY.DAT',
      'MISC\SETTINGS.DAT',
      'MISC\SORTVIEW.DAT',
      'MISC\SVUSRDEF.DAT',
      'MISC\TRANSACTIONNOTE.DAT',
      'MISC\SERIALBATCH.DAT',
      'MISC\WINDOWSETTING.DAT',
      'MISC\FIFO.DAT',
      'MISC\CUSTOMFIELDS.DAT',  // CJS 2011-11-03: ABSEXCH-12083
      'MISC\QTYBREAK.DAT',      // CJS 2012-02-20 ABSEXCH-9795
      'MISC\SYSTEMSETUP.DAT',   // CJS 2015-07-06 - added in v7.0.14
      'MISC\VAT100.DAT',        // CJS 2015-07-06 - added in v7.0.14
      'MISC\ORDERPAYMENTSMATCHING.DAT',
      'MISC\TaxCodes.DAT',       // CJS 2016-05-24 - ABSEXCH-17469 - Multi-Region Tax
      'MISC\TaxRegions.DAT',     // CJS 2016-05-24 - ABSEXCH-17469 - Multi-Region Tax
      'MISC\RegionTaxCodes.DAT', // CJS 2016-05-24 - ABSEXCH-17469 - Multi-Region Tax
      'PROMPAY\PPCUST.DAT',
      'PROMPAY\PPDEBT.DAT',
      'PROMPAY\PPSETUP.DAT',
      'REPORTS\DICTNARY.DAT',
      'REPORTS\REPORTS.DAT',
      'REPORTS\VRWSEC.DAT',
      'REPORTS\VRWTREE.DAT',
      'SALESCOM\SCTYPE.DAT',
      'SALESCOM\SALECODE.DAT',
      'SALESCOM\COMMSSN.DAT',
      'SCHEDULE\SCHEDULE.DAT',
      'SMAIL\SENT.DAT',
      'SMAIL\SENTLINE.DAT',
      'STOCK\MLOCSTK.DAT',
      'STOCK\STOCK.DAT',
      'STOCK\CUSTOMERSTOCKANALYSIS.DAT',
      'STOCK\LOCATION.DAT',
      'STOCK\STOCKLOCATION.DAT',
      'STOCK\ALLOCWIZARDSESSION.DAT',
      'STOCK\StockTaxCodes.DAT', // CJS 2016-05-24 - ABSEXCH-17469 - Multi-Region Tax
      'TRADE\LBIN.DAT',
      'TRADE\LHEADER.DAT',
      'TRADE\LLINES.DAT',
      'TRADE\LSERIAL.DAT',
      'TRANS\DETAILS.DAT',
      'TRANS\DOCUMENT.DAT',
      'TRANS\HISTORY.DAT',
      'TRANS\NOMINAL.DAT',
      'TRANS\NOMVIEW.DAT',
      'TRANS\OPVATPAY.DAT',
	    'TRANS\GLBUDGETHISTORY.DAT',
      'UDENTITY.DAT',
      'UDFIELD.DAT',
      'UDITEM.DAT',
      'VATPER\VATPRD.DAT',
      'VATPER\VATOPT.DAT',
      'WORKFLOW\PAAUTH.DAT',
      'WORKFLOW\PACOMP.DAT',
      'WORKFLOW\PAEAR.DAT',
      'WORKFLOW\PAGLOBAL.DAT',
      'WORKFLOW\PAUSER.DAT'
    );
  var
    i: Integer;
    Found: Boolean;
    CheckPos, FoundPos: Integer;
  begin
    Result := '';
    Found  := False;
//Log('FilePath: Parsing path ' + NewFileSpec);
    for i := Low(Files) to High(Files) do
    begin
      CheckPos := Length(NewFileSpec) - (Length(Files[i]) - 1);
      if (CheckPos > 0) then
      begin
        FoundPos := Pos(Files[i], NewFileSpec);
        if FoundPos = CheckPos then
        begin
//Log('FilePath: Found match: ' + Files[i]);
          Result := Copy(NewFileSpec, 1, FoundPos - 1);
//Log('FilePath: Extracted path: ' + Result);
          Found  := True;
          break;
        end;
      end;
    end;
    if not Found then
      Result := ExtractFilePath(NewFileSpec);
  end;
  // ...........................................................................
  function RemoveLastDirectory(FromPath: string): string;
  var
    CharPos: Integer;
  begin
    CharPos := LastDelimiter('\:', FromPath);
    if (CharPos > 2) then
      Result := Copy(FromPath, 1, CharPos - 1)
    else
      Result := '';
  end;
  // ...........................................................................
  function IsCommon(FullFileSpec: string): Boolean;
  const
    Files: array[0..20] of string =
    (
      'COMPANY.DAT',
      'CONTACT.DAT',
      'DICTNARY.DAT',
      'EBUS.DAT',
      'EMPPAY.DAT',
      'FAXES.DAT',
      'GROUPCMP.DAT',
      'GROUPS.DAT',
      'GROUPUSR.DAT',
      'IMPORTJOB.DAT',
      'MCPAY.DAT',
      'PAAUTH.DAT',
      'PACOMP.DAT',
      'PAEAR.DAT',
      'PAGLOBAL.DAT',
      'PAUSER.DAT',
      'SETTINGS.DAT',
      'SCHEDCFG.DAT',
      'SENTSYS.DAT',
      'TILLNAME.DAT',
      'TOOLS.DAT'
    );
  var
    i: Integer;
    FileToCheck: string;
    StrSize: Integer;
  begin
    Result := False;
    for i := Low(Files) to High(Files) do
    begin
      FileToCheck := Files[i];
      StrSize := Length(FileToCheck);
      if (Pos(FileToCheck, FullFileSpec) = (Length(FileSpec) - (StrSize - 1))) then
      begin
        Result := True;
        break;
      end;
    end;
  end;
  // ...........................................................................
  function IsSwap(FullFileSpec: string): Boolean;
  begin
    Result := (Pos('\SWAP', Uppercase(FullFileSpec)) <> 0);
  end;

var
  NewCode: AnsiString;
  Path, NewPath: string;
  ClientIDLink: PClientIDLink;
//  IsCompany: Boolean;
begin

Log('CheckOpenCompanyID: ' + Path);

  FileSpec := Uppercase(FileSpec);

  Path := FilePath(FileSpec);
  Path := CompanyTable.LongPathToShortPath(Path);

  { Look for an existing Client ID link record against the Client ID. (If
    the Client ID is nil, the link record for the main thread will be
    returned). }
  ClientIDLink := ClientIDs.ID(Pointer(ClientID));

  BTRCallProtector.BeginWrite;
  try
    if (ClientIDLink = nil) then
    begin
      { New Client ID. Add the record and the path. }
      ClientIDLink := ClientIDs.AddID(Pointer(ClientID), '');
    end;

    if (ClientIDLink.Path = '') and (not IsCommon(FileSpec)) then
    begin
  //    Path := FilePath(Path);
      ClientIDLink.Path := Path;
  Log('CheckOpenCompanyID: Opening company for "' + Path + '"');
      OpenCompany(PChar(Path), Pointer(ClientID));
    end
    else if (not IsCommon(FileSpec) and not IsSwap(FileSpec)) then
    begin
  //    Path := FilePath(Path);
      if (Path <> ClientIDLink.Path) then
      begin

  Log('CheckOpenCompanyID: Company path was "' + ClientIDLink.Path + '"');
  Log('CheckOpenCompanyID: New company path is "' + Path + '"');

        while (Path <> '') do
        begin

  Log('CheckOpenCompanyID: Checking path ' + Path);

          NewCode := FindCompanyCodeFromSubFolder(Path, Pointer(ClientID));
          if (NewCode <> '') then
            break;

  Log('CheckOpenCompanyID: Extracting company path from ' + Path);

          NewPath := RemoveLastDirectory(Path);

          { Sanity check - make sure we actually have a different path now. }
          if (NewPath <> Path) then
            Path := NewPath
          else
            break;

        end;
        if (NewCode = '') then
        begin
          { Error -- no matching company path could be found. }

  Log('CheckOpenCompanyID: Could not find matching company');

          ShowMessage('Failed to find company for ' + Path);

        end
        else
        begin
          { Does this differ from the last company path? If so, open the new
            company. }
  //        if (NewCode <> CompanyCode) and (CompanyCode <> '') then
  //        if (NewCode <> CompanyCode) then
  //        if (ClientIDLink.Path <> Path) then
          begin

  Log('CheckOpenCompanyID: Changing from ' + CompanyCode + ' to ' + NewCode);

            ClientIDLink.Path := Path;
            CompanyCode := NewCode;

            if (Pointer(ClientID) <> nil) then
            begin
              CloseClientIDSessionFn(Pointer(ClientID));
            end;

            OpenCompany(PChar(Path), PChar(ClientID));

          end;
        end;
      end;
    end;
  finally
    BTRCallProtector.EndWrite;
  end;
end;

// -----------------------------------------------------------------------------

procedure CheckOpenCompany(Path: string);
var
  ClientID: Pointer;
begin

//Log('CheckOpenCompany: ' + Path);

  ClientID := nil;
  CheckOpenCompanyID(Path, ClientID);
end;

// -----------------------------------------------------------------------------

// =============================================================================
// Licence functions
// =============================================================================
function GetModulePath : ShortString;
var
  Buffer   : PChar;
  Len      : SmallInt;
begin // GetModulePath

//Log('GetModulePath');

  Buffer := StrAlloc (255);
  try
    Len := GetModuleFileName(HInstance, Buffer, StrBufSize(Buffer));
    if (Len > 0) Then
      Result := ExtractFilePath(Buffer)
    else
      raise Exception.Create ('BtrvSQL - Unable to extract module pathing information, please contact your Technical Support');
  finally
    StrDispose(Buffer);
  end; // Try..Finally
end; // GetModulePath

// -----------------------------------------------------------------------------

function GetOLEServerPath(var OLEServerPath: ShortString): Boolean;

  function GetRegistryPath: String;
  var
    TmpStr: ShortString;
  begin

//Log('GetOLEServerPath: searching registry for OLE Server entry');

    Result := '';
    with TRegistry.Create do
    try
      Access := KEY_READ;
      RootKey := HKEY_CLASSES_ROOT;
      // Open the OLE Server CLSID key to get the GUID to lookup in the
      // CLSID section - safer than hard-coding the GUID in the code
      if OpenKey('Enterprise.OLEServer\Clsid', False) then
      begin
        // Read CLSID stored in default entry }
        TmpStr := ReadString ('');
        CloseKey;
        // Got CLSID - find entry in CLSID Section and check for registered .EXE }
        if OpenKey('Clsid\'+TmpStr+'\LocalServer32', False) then
        begin
          // Get path of registered OLE Server .Exe
          TmpStr := ReadString ('');
          // Check the OLE Server actually exists and return the path if OK
          if FileExists (TmpStr) then
          begin
            Result := ExtractFilePath(TmpStr);
          end;
          CloseKey;
        end;
      end;
    finally
      Free;
    end;
  end;

const
  {
    Originally we searched the Registry, and used the module path if a
    registry entry could not be found.

    This caused problems, because the Registry entry might be for a different
    company.

    Instead, the routine was changed to use the module path, and to only search
    the registry if the module path was invalid.

    I have refactored the code to make it easier to switch between the two
    options by changing the SEARCH_REGISTRY_FIRST constant.

    At some point we need to decide what is the best option!

    -- CJS: 20/08/2007
  }
  SEARCH_REGISTRY_FIRST = False;
Var
  FileFound : Boolean;
  I : Integer;
begin

//Log('GetOLEServerPath');

  { The set-up program temporarily installs this environment variable for the
    path, which should be used (if found) in preference to any other source for
    the path. }
  OLEServerPath := SysUtils.GetEnvironmentVariable('EXCHEQUERINSTALLDIR');
  if (Trim(OLEServerPath) = '') then
  begin

//Log('GetOLEServerPath: EXCHEQUERINSTALLDIR not found');

    if SEARCH_REGISTRY_FIRST then
    begin
      OLEServerPath := GetRegistryPath;
      if (OLEServerPath = '') then
      begin

//Log('GetOLEServerPath: OLEServer entry not found. Using module path instead.');

        OLEServerPath := IncludeTrailingPathDelimiter(GetModulePath);
        if (not FileExists(OLEServerPath + 'Enter1.exe')) then
        begin

Log('GetOLEServerPath: Enter1.exe not found in module path');

        end;
      end;
    end
    else
    begin
      OLEServerPath := IncludeTrailingPathDelimiter(GetModulePath);
      //if (not FileExists(OLEServerPath + 'Enter1.exe')) then

      // MH 30/05/2014 ABSEXCH-15402: Bodge added as a Windows Defender Update is causing a
      // FileExists check to fail incorrectly - a short delay (approx 5 seconds, but might be
      // machine dependant) seems to fix the problem - we suspect Windows Defender is scanning
      // the file, but don't know for sure. Tried using FindFirst instead of FileExists but
      // it still failed.
      For I := 1 To 40 Do
      Begin
        FileFound := FileExists(OLEServerPath + 'Enter1.exe');
        If (Not FileFound) Then
          Sleep (250)  // Total wait = 10 seconds
        Else
          Break;
      End; // For I

      If (Not FileFound) Then
      begin

Log('GetOLEServerPath: Enter1.exe not found in module path. Using OLEPath instead. ');

        OLEServerPath := GetRegistryPath;

      end;
    end; // if SEARCH_REGISTRY_FIRST then...
  end;

//Log('GetOLEServerPath: path ' + OLEServerPath);

  // Check the path being returned is set
  Result := (Trim(OLEServerPath) <> '');

  SQLCompany.SystemPath := OLEServerPath;
end; // GetOLEServerPath

// -----------------------------------------------------------------------------

function GetLocalProgramsPath(AppDir: ShortString; var LPFPath: ShortString): Boolean;
begin // GetLocalProgramsPath

//Log('GetLocalProgramsPath: ' + AppDir);

  with TIniFile.Create(AppDir + 'ENTWREPL.INI') Do
  Begin
    Try
      LPFPath := ReadString ('UpdateEngine', 'NetworkDir', '');
    Finally
      Free;
    End; // Try..Finally
  End; // With TIniFile.Create (FAppsDir + 'ENTWREPL.INI')
  // Check the path being returned
  Result := (Trim(LPFPath) <> '');
  LPFPath := IncludeTrailingPathDelimiter(LPFPath);
End; // GetLocalProgramsPath

// -----------------------------------------------------------------------------

function InitLicence(Path: string): Boolean;
var
  OLEPath, LocalDir, Dir: ShortString;
  LicR : EntLicenceRecType;
type
  TelDatabaseType = (dbBtrieve=0, dbMSSQL=1);
begin

Log('InitLicence: ' + Path);

  if (Path <> '') then
    Dir := Path
  else
  begin
    Result := GetOLEServerPath(Dir);
    if not Result then
      ShowMessage('The OLE Server on this workstation is incorrectly configured, please contact your Technical Support');
  end;

  // CJS 2013-12-12 - ABSEXCH-14859 - Hosted BtrvSQL fails to find the licence file
  OLEPath := Dir;

  // Check for Local Program Files
  if FileExists(IncludeTrailingPathDelimiter(Dir) + 'ENTWREPL.INI') Then
  begin
    // Get the path from EntWRepl.Ini
    if GetLocalProgramsPath(Dir, LocalDir) then
      Dir := LocalDir;
  end;

Log('InitLicence: reading licence from ' + IncludeTrailingPathDelimiter(Dir) + EntLicFName);

  Result := ReadEntLic(IncludeTrailingPathDelimiter(Dir) + EntLicFName, LicR);
  if not Result then
  begin
    // CJS 2013-12-12 - ABSEXCH-14859 - Hosted BtrvSQL fails to find the licence file
    Result := ReadEntLic(IncludeTrailingPathDelimiter(OLEPath) + EntLicFName, LicR);
    if not Result then
      ShowMessage('Unable to read Licence Information ' + Dir);
//    raise Exception.Create('Unable to read Licence Information ' + Dir);
  end;

Log('InitLicence: licence details read. Database type: ' + IntToStr(Ord(TelDatabaseType(LicR.licEntDB))));

  IsSQL := (TelDatabaseType(LicR.licEntDB) = dbMSSQL);
//  IsSQL := True;
end;

// =============================================================================
// Exported DLL functions
// =============================================================================
function Initialise(Path: PChar): Integer; stdcall;
begin
  Result := 0;
  if (BTRCallProtector = nil) then
  begin
    BTRCallProtector := TMultiReadExclusiveWriteSynchronizer.Create;

//Log('Initialising BtrvSQL with path "' + Path + '"');

    if not Load_DLL(Path) then
      Result := -1
    else
    begin
      Result := 0;
      IsInitialised := True;
    end;
  end;
end;

// -----------------------------------------------------------------------------

function ClientIDStr(var clientid): ShortString;
begin
  if Assigned(Pointer(@clientid)) then
  begin
    with TClientID(clientid) do
    begin
      if (AppID[1] = #0) and (AppID[2] = #0) then
        Result := ''
      else
        Result := AppID + ' ' + Form_Int(TaskID, 2);
    end;
  end
  else
    Result := '';
end;

// -----------------------------------------------------------------------------

function CheckLock(
                 FuncRes: Integer;
                 operation : WORD;
             var posblk;
             var databuf;
             var datalen   : WORD;
             var keybuf;
                 keylen    : BYTE;
                 keynum    : Integer;
             var clientid     ) : SmallInt;
var
  Lock: TLock;
  LockType: TLockType;
  RecordAddress: Integer;
  RecordAddressLen: WORD;
  DataBuffer: ^Char;
  Locked: Boolean;
  Retries: Integer;
  IDStr: string;
begin
  Result := FuncRes;
  { Lock handling }
  if isSQL and (FuncRes = 0) then
  begin
    IDStr := ClientIDStr(clientid);
    LockType := LockKeeper.LockType(operation);
    { If the operation includes a lock, record the details in the LockKeeper. }
    if (LockType in [ltSingleNoWait, ltMultiNoWait]) then
    begin
      RecordAddressLen := 4;
      if (IDStr = '') then
        BTRCallFn(22, posblk, RecordAddress, RecordAddressLen, keybuf, keylen, keynum)
      else
        BTRCallIDFn(22, posblk, RecordAddress, RecordAddressLen, keybuf, keylen, keynum, Pointer(@clientid));

      LockKeeper.AddLock(LockType, Integer(Pointer(@posblk)), RecordAddress, IDStr);
    end
    { If the operation is one which will release a lock, remove the lock from
      the LockKeeper. }
    else if (LockType = ltRelease) then
    begin
      RecordAddressLen := 4;
      if (IDStr = '') then
        BTRCallFn(22, posblk, RecordAddress, RecordAddressLen, keybuf, keylen, keynum)
      else
        BTRCallIDFn(22, posblk, RecordAddress, RecordAddressLen, keybuf, keylen, keynum, Pointer(@clientid));
      Lock := LockKeeper.FindLock(Integer(Pointer(@posblk)), RecordAddress, IDStr);
      if (Lock <> nil) and (Lock.LockType = ltSingleNoWait) then
        LockKeeper.DeleteLock(Integer(Pointer(@posblk)), RecordAddress, IDStr);
    end
    else if (LockType = ltReleaseAny) then
    begin
      if (keynum = -2) then
        LockKeeper.DeleteAllLocks(Integer(Pointer(@posblk)), IDStr)
      else
      begin
        RecordAddressLen := 4;
        if (IDStr = '') then
          BTRCallFn(22, posblk, RecordAddress, RecordAddressLen, keybuf, keylen, keynum)
        else
          BTRCallIDFn(22, posblk, RecordAddress, RecordAddressLen, keybuf, keylen, keynum, Pointer(@clientid));
        LockKeeper.DeleteLock(Integer(Pointer(@posblk)), RecordAddress, IDStr);
      end;
    end
    { If the operation is one which will release multiple locks, remove the
      locks from the LockKeeper. }
    else if (LockType = ltReleaseAll) then
    begin
      LockKeeper.DeleteAllLocks(Integer(Pointer(@posblk)), IDStr);
    end;
  end
  { If deadlock has occurred, release the lock, allowing the
    other process to continue, then re-apply the lock. }
  else if (isSql and (FuncRes = 78)) then
  begin
    Log('Deadlock detected. Releasing lock and re-trying.');
    { Get the record position. }
    RecordAddressLen := 4;
    if (IDStr = '') then
      BTRCallFn(22, posblk, RecordAddress, RecordAddressLen, keybuf, keylen, keynum)
    else
      BTRCallIDFn(22, posblk, RecordAddress, RecordAddressLen, keybuf, keylen, keynum, Pointer(@clientid));
    { Get the lock details }
    Lock := LockKeeper.FindLock(Integer(Pointer(@posblk)), RecordAddress, IDStr);
    { Prepare a dummy buffer, so that the existing data buffer does not get
      overwritten. }
    GetMem(DataBuffer, 10000);
    try
      if (Lock <> nil) then
      begin
        { Release the existing lock. Note that because we only record No Wait
          locks, we don't need to check for other types of lock.  }
        if (Lock.LockType = ltSingleNoWait) then
        begin
          if (IDStr = '') then
            Result := BTRCallFn(27, posblk, DataBuffer^, datalen, keybuf, keylen, 0)
          else
            Result := BTRCallIDFn(27, posblk, DataBuffer^, datalen, keybuf, keylen, 0, Pointer(@clientid));
        end
        else if (Lock.LockType = ltMultiNoWait) then
        begin
          if (IDStr = '') then
            Result := BTRCallFn(27, posblk, RecordAddress, RecordAddressLen, keybuf, keylen, -1)
          else
            Result := BTRCallIDFn(27, posblk, RecordAddress, RecordAddressLen, keybuf, keylen, -1, Pointer(@clientid));
        end;
        { Pause to allow the other process time to continue and release the
          lock. }
        Sleep(LockKeeper.SleepTime + Random(LockKeeper.RandomSleepTime));
        { Use a GetDirect with a lock to re-establish the position. }
        Locked := False;
        Retries := 0;
        while (not Locked) and (Retries < LockKeeper.MaxRetries) do
        begin
          RecordAddress := Lock.RecordAddress;
          Move(RecordAddress, DataBuffer^, SizeOf(RecordAddress));
          if (IDStr = '') then
            Result := BTRCallFn(23 + (100 * Ord(Lock.LockType)), posblk, DataBuffer^, datalen, keybuf, keylen, keynum)
          else
            Result := BTRCallIDFn(23 + (100 * Ord(Lock.LockType)), posblk, DataBuffer^, datalen, keybuf, keylen, keynum, Pointer(@clientid));
          if (Result = 0) then
          begin
            Locked := True;
          end
          else
          begin
            Retries := Retries + 1;
            { Pause between each retry }
            Sleep(LockKeeper.SleepTime + Random(LockKeeper.RandomSleepTime));
          end;
        end;
        { If the record was successfully locked, retry the failed operation
          again. }
        if Locked then
        begin
          if (IDStr = '') then
            Result := BTRCallFn(operation, posblk, databuf, datalen, keybuf, keylen, keynum)
          else
            Result := BTRCallIDFn(operation, posblk, databuf, datalen, keybuf, keylen, keynum, Pointer(@clientid));
        end;
      end;
    finally
      FreeMem(DataBuffer);
    end;
  end;
end;

// -----------------------------------------------------------------------------

function BTRCALL(
                 operation : WORD;
             var posblk;
             var databuf;
             var datalen   : WORD;
             var keybuf;
                 keylen    : BYTE;
                 keynum    : Integer
                 ) : SmallInt;
var
  ClientID: TClientID;
  RecAddr: Integer;
  Redirector: TSQLRedirector;
  DataLength: WORD;
begin

  if not Assigned(BTRCallFn) then
    Initialise('');

  if (operation = 28) then
  begin
    Log('Reset');
    if IsSQL then
    begin
      Log('- ignored, not supported');
      Result := 0;
      Exit;
    end
  end;

  // Ignore STOP operation -- not supported by Emulator at present.
  // (See Pivotal Issue 33652, 28 March 2008)
  if (IsSQL and (operation = 25)) then
  begin
    Log('Stop - ignored, not supported');
    Result := 0;
    Exit;
  end;

  if IsSQL and (operation = 0) then
  begin
    CheckOpenCompany(PChar(@keybuf));
    SQLVariants.OnOpenFile(keybuf, posblk);
{$IFDEF SQLDEBUG}
    SQLFiles.Add(Integer(Pointer(@posblk)), PChar(@keybuf));
{$ENDIF}
  end
  else if IsSQL and (operation = 1) then
    SQLVariants.OnCloseFile(posblk);

{$IFDEF SQLDEBUG}
if Redirected then
  Log('REDIRECTED BTRCALL: op=' + BtrOpDesc(operation) + ', key ' + PChar(@keybuf) +
      ', key num ' + IntToStr(keynum) + ' ' + SQLFiles.FileSpec(Integer(Pointer(@posblk))) +
      '(' + IntToStr(Integer(Pointer(@posblk))) + ')' )
else
  Log('BTRCALL: op=' + BtrOpDesc(operation) + ', key ' + PChar(@keybuf) +
      ', key num ' + IntToStr(keynum) + ' ' + SQLFiles.FileSpec(Integer(Pointer(@posblk))) +
      '(' + IntToStr(Integer(Pointer(@posblk))) + ')' );
{$ELSE}
if Redirected then
  Log('REDIRECTED BTRCALL: op=' + BtrOpDesc(operation) + ', key ' + PChar(@keybuf) +
      ', key num ' + IntToStr(keynum) + ' posblok ' + IntToStr(Integer(Pointer(@posblk))) )
else
  Log('BTRCALL: op=' + BtrOpDesc(operation) + ', key ' + PChar(@keybuf) +
      ', key num ' + IntToStr(keynum) + ' posblok ' + IntToStr(Integer(Pointer(@posblk))) );
{$ENDIF}

  BTRCallProtector.BeginRead;
  try
    FillChar(ClientID, SizeOf(TClientID), 0);
    //PR 09/09/2008
    CheckCacheList(operation, posblk, keybuf);

    if Assigned(MemCallbackFn) then
      MemCallbackFn('Before BTRCALL: op=' + BtrOpDesc(operation) + ', key ' + PChar(@keybuf));

    if IsSQL then
      Redirector := RedirectorFactory.GetRedirector(operation, posblk, databuf, keybuf)
    else
      Redirector := nil;
    if Assigned(Redirector) then
    begin
      DataLength := datalen;
      Result := Redirector.BTRCall(operation, posblk, databuf, DataLength,
                                   keybuf, keylen, keynum);
    end
    else
    begin
      if SQLVariants.CanUseVariant(operation, posblk) then
        UseVariantForNextCall(posblk, nil);
      Result := BTRCallFn(operation, posblk, databuf, datalen, keybuf, keylen, keynum);
      Result := CheckLock(Result, operation, posblk, databuf, datalen, keybuf, keylen, keynum, ClientID);
    end;

    if Assigned(MemCallbackFn) then
      MemCallbackFn('After BTRCALL: op=' + BtrOpDesc(operation) + ', key ' + PChar(@keybuf));

  finally
    BTRCallProtector.EndRead;
  end;

  if IsSQL and (Result = 0) and (operation = 0) then
  begin
    SQLVariants.AfterOpenFile(keybuf, posblk);
  end;

  if (Result <> 0) then
  begin
    if (operation = 23) then  // GetDirect
    begin
      Move(databuf, RecAddr, SizeOf(RecAddr));
      Log('- failed: ' + IntToStr(Result) + ', rec ' + IntToStr(RecAddr) + ', op ' + IntToStr(operation) + ', key ' + PChar(@keybuf));
    end
    else
      Log('- failed: ' + IntToStr(Result) + ', op ' + IntToStr(operation) + ', key ' + PChar(@keybuf));
  end;

end;

// -----------------------------------------------------------------------------

function BTRCALLID(
                 operation : WORD;
             var posblk;
             var databuf;
             var datalen   : WORD;
             var keybuf;
                 keylen    : BYTE;
                 keynum    : Integer;
             var clientid     ) : SmallInt;

var
  InternalClientID: PClientID;
  LogStr: ShortString;
  Redirector: TSQLRedirector;
  DataLength: WORD;
begin

  try

    BTRCallProtector.BeginRead;
    try

      if (operation = 28) then
      begin
        Log('Reset');
        if IsSQL then
        begin
          Log('- ignored, not supported');
          Result := 0;
          Exit;
        end
      end;

      if not Assigned(BTRCallIDFn) then
        Initialise('');

      // Ignore STOP operation -- not supported by Emulator at present.
      // (See Pivotal Issue 33652, 28 March 2008)
      if (IsSQL and (operation = 25)) then
      begin
        Log('Stop - ignored, not supported');
        Result := 0;
        Exit;
      end;

      if IsSQL and (operation = 0) then
      begin
        New(InternalClientID);
        Move(clientid, InternalClientID^, SizeOf(TClientID));
        CheckOpenCompanyID(PChar(@keybuf), InternalClientID);
        Dispose(InternalClientID);
        // CJS 2014-09-23 - ABSEXCH-15660 - BtrvSQL does not record the ClientID for variant files
        // Corrected the passing of the Client ID
        SQLVariants.OnOpenFile(keybuf, posblk, Pointer(@clientid));
{$IFDEF SQLDEBUG}
        SQLFiles.Add(Integer(Pointer(@posblk)), PChar(@keybuf));
{$ENDIF}
      end
      else if IsSQL and (operation = 1) then
        SQLVariants.OnCloseFile(posblk);

{$IFDEF SQLDEBUG}
if Redirected then
  Log('REDIRECTED BTRCALLID: op=' + BtrOpDesc(operation) + ', key ' + PChar(@keybuf) +
      ', key num ' + IntToStr(keynum) + ' ' + SQLFiles.FileSpec(Integer(Pointer(@posblk))) +
      '(' + IntToStr(Integer(Pointer(@posblk))) + ')' )
else
  Log('BTRCALLID: op=' + BtrOpDesc(operation) + ', key ' + PChar(@keybuf) +
      ', key num ' + IntToStr(keynum) + ' ' + SQLFiles.FileSpec(Integer(Pointer(@posblk))) +
      '(' + IntToStr(Integer(Pointer(@posblk))) + ')' );
{$ELSE}
if Redirected then
  Log('REDIRECTED BTRCALLID: op=' + BtrOpDesc(operation) + ', key ' + PChar(@keybuf) +
      ', key num ' + IntToStr(keynum) + ' posblok ' + IntToStr(Integer(Pointer(@posblk))) )
else
  Log('BTRCALLID: op=' + BtrOpDesc(operation) + ', key ' + PChar(@keybuf) +
      ', key num ' + IntToStr(keynum) + ' posblok ' + IntToStr(Integer(Pointer(@posblk))) );
{$ENDIF}

      //PR 09/09/2008
      CheckCacheList(operation, posblk, keybuf, clientid);

      if Assigned(MemCallbackFn) then
        MemCallbackFn('Before BTRCALLID: op=' + BtrOpDesc(operation) + ', key ' + PChar(@keybuf));

      if IsSQL then
        Redirector := RedirectorFactory.GetRedirector(operation, posblk, databuf, keybuf)
      else
        Redirector := nil;
      if Assigned(Redirector) then
      begin
        DataLength := datalen;
        Result := Redirector.BTRCall(operation, posblk, databuf, DataLength,
                                     keybuf, keylen, keynum, Pointer(@ClientID));
      end
      else
      begin
        if SQLVariants.CanUseVariant(operation, posblk) then
          UseVariantForNextCall(posblk, Pointer(@clientid));
        Result := BTRCallIDFn(operation, posblk, databuf, datalen, keybuf, keylen, keynum, Pointer(@clientid));
        Result := CheckLock(Result, operation, posblk, databuf, datalen, keybuf, keylen, keynum, ClientID);
      end;

      if Assigned(MemCallbackFn) then
        MemCallbackFn('After BTRCALLID: op=' + BtrOpDesc(operation) + ', key ' + PChar(@keybuf));

      Result := CheckLock(Result, operation, posblk, databuf, datalen, keybuf, keylen, keynum, clientid);

if (Result <> 0) then
begin
  LogStr := ('- failed: ' + Form_Int(Result, 4) + ', op ' + Form_Int(operation, 2) + ', key ' + PChar(@keybuf) +
      ', clientid ' + ClientIDStr(clientid));
  Log(LogStr);
end;

    finally
      BTRCallProtector.EndRead;
    end;

  except
    on E:Exception do
    begin
      Result := 999;
      OutputDebugString(PChar(E.Message));
    end;
  end;

end;

// -----------------------------------------------------------------------------

function WBTRVINIT(var InitializationString): Integer;
begin

//Log('WBTRVINIT');
  BTRCallProtector.BeginRead;
  try
    Result := WBTRVInitFn(InitializationString);
  finally
    BTRCallProtector.EndRead;
  end;

end;

// -----------------------------------------------------------------------------

function WBTRVSTOP: Integer;
begin

//Log('WBTRVSTOP');

  BTRCallProtector.BeginRead;
  try
    Result := WBTRVStopFn;
  finally
    BTRCallProtector.EndRead;
  end;

end;

// -----------------------------------------------------------------------------

function UsingSQL: Boolean;
begin
  Result := IsSQL;
end;

// -----------------------------------------------------------------------------

function CreateDatabase(ServerName, DatabaseName, UserName, Password: PChar): Integer;
var
  FuncRes: Integer;
begin

//ShowMessage('CreateDatabase');

Log('CreateDatabase: ' + ServerName + ', ' + DatabaseName + ', ' + UserName + ', ' + Password);

//  CompanyTable.Close;

//  BTRCallProtector.BeginRead;
  try
    FuncRes := CreateDatabaseFn('WMIT_CD', ServerName, DatabaseName,
                                UserName, Password);
  finally
//    BTRCallProtector.EndRead;
  end;

  Result := FuncRes;
end;

// -----------------------------------------------------------------------------

function CreateCompany(CompanyCode, CompanyName, CompanyPath, ZIPFileName, UserName, Password,
  ReadOnlyName, ReadOnlyPassword: PChar; ClientID: Pointer): Integer;
var
  ErrMsg: string;

begin

Log('CreateCompany: ' + CompanyCode + ', ' + CompanyName + ', ' + CompanyPath +
    ', ' + ZIPFileName + ', ' + UserName + ', ' + Password + ', ' +
    ReadOnlyName + ', ' + ReadOnlyPassword);

  BTRCallProtector.BeginRead;
  try
    Result :=
      CreateCompanyFn(
        'WMIT_CC',
        PChar(ClientID),
        UserName,
        Password,
        ReadOnlyName,
        ReadOnlyPassword,
        CompanyCode,
        CompanyName,
        ZIPFileName
      );
  finally
    BTRCallProtector.EndRead;
  end;

  if (Result = 0) then
  begin
Log('Adding company to COMPANY.DAT');
    if (ZIPFileName <> nil) then
      Result := CompanyTable.Add(CompanyCode, CompanyName, CompanyPath, (Pos('DEMO', Uppercase(ZIPFileName)) <> 0))
    else
      Result := CompanyTable.Add(CompanyCode, CompanyName, CompanyPath, False);
    if (Result <> 0) then
    begin

Log('CreateCompany failed, error ' + IntToStr(Result));

    end;
  end
  else
  begin

ErrMsg := GetErrorInformation(Result);
Log('CreateCompany failed, error ' + IntToStr(Result) + ': ' + ErrMsg);

  end;
end;

// -----------------------------------------------------------------------------

function DeleteCompany(CompanyCode: PChar; ClientID: Pointer): Integer;
begin

//Log('DeleteCompany: ' + CompanyCode);

  BTRCallProtector.BeginRead;
  try
    Result := DeleteCompanyFn('WMIT_DC', PChar(ClientID), CompanyCode);
  finally
    BTRCallProtector.EndRead;
  end;

//  if (Result = 0) then
//    Result := CompanyTable.Delete(CompanyCode, ClientID);
end;

// -----------------------------------------------------------------------------

function AttachCompany(CompanyCode: PChar; ClientID: Pointer): Integer;
begin

//Log('AttachCompany: ' + CompanyCode);

  BTRCallProtector.BeginRead;
  try
    Result := AttachCompanyFn('WMIT_AC', PChar(ClientID), CompanyCode);
  finally
    BTRCallProtector.EndRead;
  end;

end;

// -----------------------------------------------------------------------------

function DetachCompany(CompanyCode: PChar; ClientID: Pointer): Integer;
begin

//Log('DetachCompany: ' + CompanyCode);

  BTRCallProtector.BeginRead;
  try
    Result := DetachCompanyFn('WMIT_DC', PChar(ClientID), CompanyCode);
  finally
    BTRCallProtector.EndRead;
  end;

end;

// -----------------------------------------------------------------------------

function RebuildCompanyCache: Integer;
begin
  Result := CompanyTable.InitCache;
end;

// -----------------------------------------------------------------------------

function GetConnectionString(CompanyCode: PChar; GetReadOnly: Boolean; ConnectionString: PChar;
  ConnectionStringLength: Integer; ClientID: Pointer): Integer;
begin

//Log('GetConnectionString: ' + CompanyCode);

  BTRCallProtector.BeginRead;
  try
    if GetReadOnly then
    begin
      Result := ConnectionStringFn('WMIT_GCRO', PChar(ClientID), CompanyCode, @ConnectionString, @ConnectionStringLength);
    end
    else
    begin
      Result := ConnectionStringFn('WMIT_GCG', PChar(ClientID), CompanyCode, @ConnectionString, @ConnectionStringLength);
    end;
  finally
    BTRCallProtector.EndRead;
  end;

//Log('GetConnectionString result: #' + IntToStr(Result));
//Log('GetConnectionString: "' + Trim(ConnectionString) + '"');

end;

// -----------------------------------------------------------------------------
 //VA:26/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
function GetConnectionStringWoPass(CompanyCode: PChar; GetReadOnly: Boolean; ConnectionString: PChar; ConnectionStringLength: Integer; Password: PChar; ClientID: Pointer): Integer;
begin

//Log('GetConnectionString: ' + CompanyCode);

  BTRCallProtector.BeginRead;
  try
    if GetReadOnly then
    begin
      Result := ConnectionStringWOPassFn('WMIT_GCRO', PChar(ClientID), CompanyCode, @ConnectionString, @ConnectionStringLength, @Password);
    end
    else
    begin
      Result := ConnectionStringWOPassFn('WMIT_GCG', PChar(ClientID), CompanyCode, @ConnectionString, @ConnectionStringLength, @Password);
    end;
  finally
    BTRCallProtector.EndRead;
  end;

//Log('GetConnectionString result: #' + IntToStr(Result));
//Log('GetConnectionString: "' + Trim(ConnectionString) + '"');

end;

// -----------------------------------------------------------------------------

function GetCommonConnectionString(ConnectionString: PChar;
  ConnectionStringLength: Integer; ClientID: Pointer): Integer; stdcall;
begin

//Log('GetCommonConnectionString');

  BTRCallProtector.BeginRead;
  try
    Result := CommonConnectionStringFn('WMIT_GCC', PChar(ClientID), @ConnectionString, @ConnectionStringLength);
  finally
    BTRCallProtector.EndRead;
  end;

//Log('GetCommonConnectionString result: #' + IntToStr(Result));
//Log('GetCommonConnectionString: "' + Trim(ConnectionString) + '"');

end;

// -----------------------------------------------------------------------------

function GetCommonConnectionStringWoPass(ConnectionString: PChar; ConnectionStringLength: Integer; Password : PChar; ClientID: Pointer): Integer; stdcall;
begin

//Log('GetCommonConnectionString');

  BTRCallProtector.BeginRead;
  try
    Result := CommonConnectionStringWOPassFn('WMIT_GCC', PChar(ClientID), @ConnectionString, @ConnectionStringLength, @Password);
  finally
    BTRCallProtector.EndRead;
  end;

//Log('GetCommonConnectionString result: #' + IntToStr(Result));
//Log('GetCommonConnectionString: "' + Trim(ConnectionString) + '"');

end;

// -----------------------------------------------------------------------------

function OpenCompany(Path: PChar; ClientID: Pointer): Integer;
var
  CodeStr: AnsiString;
begin

//Log('OpenCompany: ' + Path);

  if IsSQL then
  begin
    CodeStr := FindCompanyCode(Path);
    if (CodeStr <> '') then
    begin
      BTRCallProtector.BeginRead;
      try

        if Assigned(MemCallbackFn) then
          MemCallbackFn('Before OpenCompany: ' + Path);

        Result := OpenCompanyFn('WMIT_OC', PChar(ClientID), PChar(CodeStr));
{$IFDEF SQLDEBUG}
        if (Result = 0) then
          SQLFiles.Add(Integer(@F[21]), 'COMPANY.DAT');
{$ENDIF}

        if Assigned(MemCallbackFn) then
          MemCallbackFn('After OpenCompany: ' + Path);

      finally
        BTRCallProtector.EndRead;
      end;
    end
    else
      Result := 4; // Company not found.
  end
  else
  begin
//Log('OpenCompany: Not SQL');
    Result := 0;
  end;

if (Result <> 0) then
  Log('OpenCompany failed, error #' + IntToStr(Result));

end;

// -----------------------------------------------------------------------------

function OpenCompanyByCode(Code: PChar): Integer;
begin

//Log('OpenCompanyByCode: ' + Code);

  if IsSQL then
  begin
    BTRCallProtector.BeginRead;
    try

      if Assigned(MemCallbackFn) then
        MemCallbackFn('Before OpenCompany: ' + Code);

      Result := OpenCompanyFn('WMIT_OC', nil, PChar(Code));

      if Assigned(MemCallbackFn) then
        MemCallbackFn('After OpenCompany: ' + Code);

    finally
      BTRCallProtector.EndRead;
    end;
  end
  else
    Result := 0;

end;

// -----------------------------------------------------------------------------

function CloseClientIdSession(ClientId: Pointer; Remove: Boolean): Integer;
begin
  Result := 0;
  if IsSQL and (ClientID <> nil) then
  begin
    ClientIDs.RemoveID(ClientID, Remove);
    BTRCallProtector.BeginRead;
    try
      if Assigned(MemCallbackFn) then
        MemCallbackFn('Before CloseClientIDSession: ' + ClientIDStr(ClientId));

      Result := CloseClientIDSessionFn(ClientID);

      if Assigned(MemCallbackFn) then
        MemCallbackFn('After CloseClientIDSession: ' + ClientIDStr(ClientId));

    finally
      BTRCallProtector.EndRead;
    end;
  end;
end;

// -----------------------------------------------------------------------------

function GetCompanyCode(ForPath: PChar): ShortString;
begin
  Result := FindCompanyCode(ForPath);
end;

// -----------------------------------------------------------------------------

function CompanyExists(ForCode: PChar; ClientID: Pointer): Integer;
begin

//Log('CompanyExists:' + ForCode);

  Result := FindCompany(ForCode, ClientID);
end;

// -----------------------------------------------------------------------------

function ValidCompany(FilePath: PChar): Integer;
var
  Path: string;
begin
  Result := 4;

//Log('ValidCompany: ' + FilePath);

  Path := DelimitedPath(FilePath);
  if (DirectoryExists(Path) and
      FileExists(Path + 'COMPANY.SYS')) then
    Result := 0;
end;

// -----------------------------------------------------------------------------

function ValidSystem(ForPath: PChar): Integer;
var
  Path: string;
begin
  Result := 4;

//Log('ValidSystem: ' + ForPath);

  Path := DelimitedPath(ForPath);
  if (DirectoryExists(Path + 'LIB') and
      FileExists(Path + 'ENTER1.EXE') and
      FileExists(Path + 'ENTRPRSE.DAT') and
      FileExists(Path + 'EXCHEQR.SYS')) then
    Result := 0;
end;

// -----------------------------------------------------------------------------

function TableExists(FileSpec: PChar; ClientID: Pointer): Integer;
var
  FileName: AnsiString;
begin

//Log('TableExists: ' + FileSpec);

  if UsingSQL then
  begin
    FileName := ExtractFileName(FileSpec);
//    FileName := FileSpec;
    BTRCallProtector.BeginRead;
    try

      if Assigned(MemCallbackFn) then
        MemCallbackFn('Before TableExists: ' + FileName);

      Result := TableExistsFn('WMIT_TE', PChar(ClientID), PChar(FileName));

      if Assigned(MemCallbackFn) then
        MemCallbackFn('After TableExists: ' + FileName);

    finally
      BTRCallProtector.EndRead;
    end;
  end
  else
  begin
    if FileExists(FileSpec) then
      Result := 0
    else
      Result := 3;
  end;
end;

// -----------------------------------------------------------------------------

function DeleteTable(FileSpec: PChar; ClientID: Pointer): Integer;
var
  FileName, FilePath: AnsiString;
  FuncRes: LongInt;
begin

//Log('DeleteTable: ' + FileSpec);

  Result := 0;
  if UsingSQL then
  begin
    FilePath := ExtractFilePath(FileSpec);
    FileName := ExtractFileName(FileSpec);
//    if ValidCompany(PChar(FilePath)) = 0 then
    begin
      BTRCallProtector.BeginRead;
      try

        if Assigned(MemCallbackFn) then
          MemCallbackFn('Before DeleteTable: ' + FileSpec);

        FuncRes := DeleteTableFn('WMIT_DT', PChar(ClientID), PChar(FileSpec));

        if Assigned(MemCallbackFn) then
          MemCallbackFn('After DeleteTable: ' + FileSpec);

      finally
        BTRCallProtector.EndRead;
      end;
      if (FuncRes <> 0) and (FuncRes <> 3) then
      begin

      end;
      Result := FuncRes;
    end;
  end
  else
  begin
    FileName := FileSpec;
    DeleteFile(PChar(FileName));
  end;
end;

// -----------------------------------------------------------------------------

function HasExclusiveAccess(CompanyPath: PChar; ClientID: Pointer): Integer;
var
  FuncRes: Integer;
  Users: Integer;
  CompanyCode: string;
(*
  Qry: string;
  Count: Integer;
  ConnectionStr: PChar;
  BufferSize: Integer;
  SQLCaller: TSQLCaller;
*)
begin

  CompanyCode := FindCompanyCode(CompanyPath);

//Log('HasExclusiveAccess: ' + CompanyPath);

  Users := 0;

  BTRCallProtector.BeginRead;
  try

    // Original Version
    if Assigned(MemCallbackFn) then
      MemCallbackFn('Before HasExclusiveAccess: ' + CompanyCode);

    FuncRes := HasExclusiveAccessFn('WMIT_XA', PChar(ClientID), PChar(CompanyCode), @Users);

    if Assigned(MemCallbackFn) then
      MemCallbackFn('After HasExclusiveAccess: ' + CompanyCode);

    if (FuncRes <> 0) then
    begin
      FLastSQLError := GetErrorInformation(FuncRes);
      Log(FLastSQLError);
    end;

    // Revised Version
(*
    { Prepare a buffer to hold the returned connection string }
    BufferSize := 256;
    ConnectionStr := StrAlloc(BufferSize);

    GetCommonConnectionString(ConnectionStr, BufferSize, ClientID);

    Qry := Format('SELECT common.[ifn_GetCompanyCurrentProcessCount] (''%s'') AS UserCount', [CompanyCode]);
    SQLCaller := TSQLCaller.Create;
    try
      SQLCaller.ConnectionString := ConnectionStr;
      SQLCaller.Select(Qry, CompanyCode);

      try
        Users := SQLCaller.Records.Fields[0].AsInteger;
        FLastSQLError := SQLCaller.ErrorMsg;
      finally
        SQLCaller.Close;
      end;
    finally
      SQLCaller.Free;
    end;
*)
  finally
    BTRCallProtector.EndRead;
  end;
  Result := Users;
end;

// -----------------------------------------------------------------------------

function ExportDataset(CompanyCode: PChar; FileName: PChar; ExportType: Integer): Integer;
var
  ExportSet: AnsiString;
begin

//Log('ExportDataset: ' + CompanyCode + ', ' + FileName);

  case ExportType of
    EXPORT_ALL: ExportSet := 'CommonAndCompany';
    EXPORT_COMMON: ExportSet := 'Common';
    EXPORT_COMPANY: ExportSet := 'Company';
    // CJS 2012-02-15 - ABSEXCH-11856 - MS SQL Backup/Restore for LIVE
    // Constants for including the LIVE tables. Only use these if the current
    // install of Exchequer is already known to include these tables.
    EXPORT_LIVE_ALL: ExportSet := 'CommonAndCompanyAndLIVE';
    EXPORT_LIVE_COMMON: ExportSet := 'CommonAndLIVE';
    EXPORT_LIVE_COMPANY: ExportSet := 'CompanyAndLIVE';
  end;

  BTRCallProtector.BeginRead;
  try
    Result := ExportDatasetFn('WMIT_XD', CompanyCode, FileName, PChar(ExportSet));
  finally
    BTRCallProtector.EndRead;
  end;

end;

// -----------------------------------------------------------------------------

function ImportDataset(CompanyCode: PChar; FileName: PChar): Integer;
begin

//Log('ImportDataset: ' + CompanyCode + ', ' + FileName);

  BTRCallProtector.BeginRead;
  try
    Result := ImportDatasetFn('WMIT_ID', CompanyCode, FileName);
  finally
    BTRCallProtector.EndRead;
  end;

end;

// -----------------------------------------------------------------------------

procedure GetLongErrorInformation(var ErrorCode: Integer; ErrorString: PChar; ErrorStringLength: Integer);
var
  FuncRes: Integer;
begin

//Log('GetErrorInformation: ' + IntToStr(ErrorCode));

  BTRCallProtector.BeginRead;
  try

    if Assigned(MemCallbackFn) then
      MemCallbackFn('Before GetSQLErrorInfo (long): ' + IntToStr(ErrorCode));

    FuncRes := GetSQLErrorInfoFn(ErrorCode, nil, @ErrorString, ErrorStringLength);

    if Assigned(MemCallbackFn) then
      MemCallbackFn('After GetSQLErrorInfo (long): ' + IntToStr(ErrorCode));

  finally
    BTRCallProtector.EndRead;
  end;

//Log('GetErrorInformation: ' + Trim(Buffer));

end;

// -----------------------------------------------------------------------------

function GetErrorInformation(var ErrorCode: Integer): ShortString;
var
  FuncRes: Integer;
  Buffer: PChar;
  BufferSize: Integer;
begin

//Log('GetErrorInformation: ' + IntToStr(ErrorCode));

  BufferSize := 10000;
  Buffer := StrAlloc(BufferSize);
  try
    BTRCallProtector.BeginRead;
    try
      if Assigned(MemCallbackFn) then
        MemCallbackFn('Before GetSQLErrorInfo: ' + IntToStr(ErrorCode));

      FuncRes := GetSQLErrorInfoFn(ErrorCode, nil, @Buffer, BufferSize);

      if Assigned(MemCallbackFn) then
        MemCallbackFn('After GetSQLErrorInfo: ' + IntToStr(ErrorCode));

    finally
      BTRCallProtector.EndRead;
    end;
//    ErrorCode := FuncRes;
    Result := Trim(Buffer);

//Log('GetErrorInformation: ' + Trim(Buffer));

  finally
    StrDispose(Buffer);
  end;
end;

// -----------------------------------------------------------------------------

function CopyTable(FromCompanyCode, ToCompanyCode, TableName, WhereClause: PChar; DeleteIfExists: Boolean): Integer; stdcall;
var
  DeleteFlag: Integer;
begin

//Log('CopyTable: "' + FromCompanyCode + '", "' + ToCompanyCode + '", "' + TableName +
//    '", "' + WhereClause + '"');

  if (DeleteIfExists) then
    DeleteFlag := -1
  else
    DeleteFlag := 0;

  BTRCallProtector.BeginRead;
  try
    Result := CopyTableFn('WMIT_CT', FromCompanyCode, ToCompanyCode, TableName, WhereClause, DeleteFlag);
  finally
    BTRCallProtector.EndRead;
  end;

if (Result <> 0) then
  Log('CopyTable failed, error ' + IntToStr(Result));
//  Result := CopyTableFn('WMIT_CT', 'ZZZZ01', 'ZZZZ02', 'JOBDET.DAT', '(RecpFix = ''J'' and SubType=''M'')');
end;

// -----------------------------------------------------------------------------

function UpdateTable(CompanyCode, TableName, Values, WhereClause: PChar; ClientID: Pointer): Integer; stdcall;
begin

//Log('CopyTable: ' + CompanyCode + ', ' + TableName + ', ' + Values + ', ' +
//    WhereClause);

  BTRCallProtector.BeginRead;
  try
    Result := UpdateTableFn('WMIT_UT', PChar(ClientId), CompanyCode, TableName, Values, WhereClause);
  finally
    BTRCallProtector.EndRead;
  end;

end;

// -----------------------------------------------------------------------------

function GetDBColumnName(BtrieveFileName, FieldName, RecordType: PChar; ComputedColumnName: PChar; ComputedColumnNameLength: Integer): ShortString;
var
  FuncRes: Integer;
  Buffer: PChar;
  BufferSize: Integer;
begin

//Log('GetDBColumnName: ' + BtrieveFileName + ', ' + FieldName + ', ' + RecordType);

  if (RecordType = '') then
    RecordType := nil;

  { Prepare a buffer to hold the returned column name }
  BufferSize := 256;
  Buffer := StrAlloc(BufferSize);
  try
    BTRCallProtector.BeginRead;
    try

      if Assigned(MemCallbackFn) then
        MemCallbackFn('Before GetDBColumnName: ' + BtrieveFileName + '.' + FieldName);

      if (ComputedColumnNameLength = 0) then
        FuncRes := GetDBColumnNameFn(BtrieveFileName, FieldName, RecordType, @Buffer, @BufferSize, nil, nil)
      else
        FuncRes := GetDBColumnNameFn(BtrieveFileName, FieldName, RecordType, @Buffer, @BufferSize, @ComputedColumnName, @ComputedColumnNameLength);

      if Assigned(MemCallbackFn) then
        MemCallbackFn('After GetDBColumnName: ' + BtrieveFileName + '.' + FieldName);

    finally
      BTRCallProtector.EndRead;
    end;
    if (FuncRes = 0) then
      Result := Trim(Buffer)
    else
      Result := 'Not found';
  finally
    StrDispose(Buffer);
  end;
end;

// -----------------------------------------------------------------------------

function GetDBTableName(BtrieveFileName: PChar): ShortString;
var
  FuncRes: Integer;
  Buffer: PChar;
  BufferSize: Integer;
begin

//Log('GetDBTableName: ' + BtrieveFileName);

  { Prepare a buffer to hold the returned table name }
  BufferSize := 256;
  Buffer := StrAlloc(BufferSize);
  try
    BTRCallProtector.BeginRead;
    try
      if Assigned(MemCallbackFn) then
        MemCallbackFn('Before GetDBTableName: ' + BtrieveFileName);

      FuncRes := GetDBTableNameFn(BtrieveFileName, @Buffer, @BufferSize);

      if Assigned(MemCallbackFn) then
        MemCallbackFn('After GetDBTableName: ' + BtrieveFileName);

    finally
      BTRCallProtector.EndRead;
    end;
    if (FuncRes = 0) then
      Result := Trim(Buffer)
    else
      Result := 'Not found';
  finally
    StrDispose(Buffer);
  end;
end;

// -----------------------------------------------------------------------------

function CreateCustomPrefillCache(FileName, WhereClause, Columns: PChar; var ID: LongInt; ClientID: Pointer): Integer;
begin
  if (strlen(WhereClause) = 0) then
    WhereClause := '1=1';

  if Assigned(MemCallbackFn) then
    MemCallbackFn('Before CreateCustomPrefillCache: ' + FileName);

  if (strlen(Columns) = 0) then
    Result := CreateCustomPrefillCacheEmulatorFn('WMIT_CPC', PChar(ClientID), FileName, WhereClause, nil, ID)
  else
    Result := CreateCustomPrefillCacheEmulatorFn('WMIT_CPC', PChar(ClientID), FileName, WhereClause, Columns, ID);

  SQLVariants.OnCreateCache(FileName, ID, ClientID);

  if Assigned(MemCallbackFn) then
    MemCallbackFn('After CreateCustomPrefillCache: ' + FileName);

end;

// -----------------------------------------------------------------------------

function UseCustomPrefillCache(ID: LongInt; ClientID: Pointer): Integer; stdcall;
begin
  if Assigned(MemCallbackFn) then
    MemCallbackFn('Before UseCustomPrefillCache');

  Result := UseCustomPrefillCacheEmulatorFn('WMIT_UPC', PChar(ClientID), ID);

  if Assigned(MemCallbackFn) then
    MemCallbackFn('After UseCustomPrefillCache');

end;

// -----------------------------------------------------------------------------

function DropCustomPrefillCache(ID: LongInt; ClientID: Pointer): Integer; stdcall;
begin
  if Assigned(MemCallbackFn) then
    MemCallbackFn('Before DropCustomPrefillCache');

  SQLVariants.OnDropCache(ID, ClientID);

  Result := DropCustomPrefillCacheEmulatorFn('WMIT_DPC', PChar(ClientID), ID);

  if Assigned(MemCallbackFn) then
    MemCallbackFn('After DropCustomPrefillCache');

end;

// -----------------------------------------------------------------------------

function PostToHistory(NType: Char; var Code; Purchases, Sales, Cleared, Value1, Value2: double; Currency, Year, Period, DecimalPlaces: Integer; var PreviousBalance: double; var ErrorCode: Integer; ClientID: Pointer): Integer;
begin
  if Assigned(MemCallbackFn) then
    MemCallbackFn('Before PostToHistory: ' + NType);

  Result := PostToHistoryFn(PChar(ClientID), Ord(NType), Code, Purchases, Sales, Cleared, Value1, Value2, Currency, Year, Period, DecimalPlaces, PreviousBalance, ErrorCode);

  if Assigned(MemCallbackFn) then
    MemCallbackFn('After PostToHistory: ' + NType);

  if (Result <> 0) then
    FLastSQLError := GetErrorInformation(Result)
  else if (ErrorCode <> 0) then
    FLastSQLError := 'Unknown SQL error, #' + IntToStr(ErrorCode);
end;

// -----------------------------------------------------------------------------

function PostToYearDate(NType: Char; var Code; Purchases, Sales, Cleared, Value1, Value2: double; Currency, Year, Period, DecimalPlaces: Integer; var ErrorCode: Integer; ClientID: Pointer): Integer;
begin
  if Assigned(MemCallbackFn) then
    MemCallbackFn('Before PostToYearDate: ' + NType);

  Result := PostToYearDateFn(PChar(ClientID), Ord(NType), Code, Purchases, Sales, Cleared, Value1, Value2, Currency, Year, Period, DecimalPlaces, ErrorCode);

  if Assigned(MemCallbackFn) then
    MemCallbackFn('After PostToYearDate: ' + NType);

  if (Result <> 0) then
    FLastSQLError := GetErrorInformation(Result)
  else if (ErrorCode <> 0) then
    FLastSQLError := 'Unknown SQL error, #' + IntToStr(ErrorCode);
end;

// -----------------------------------------------------------------------------

function UseVariantForNextCall(var PosBlock; ClientID: Pointer): Integer;
begin
  BTRCallProtector.BeginRead;
  try
    if Assigned(MemCallbackFn) then
      MemCallbackFn('Before UseVariantForNextCall');

    Result := UseVariantForNextCallFn('WMIT_UVF', PChar(ClientID), PosBlock);

    if Assigned(MemCallbackFn) then
      MemCallbackFn('After UseVariantForNextCall');

  finally
    BTRCallProtector.EndRead;
  end;
end;

// -----------------------------------------------------------------------------

function DiscardCachedData(FileName: PChar; ClientID: Pointer): Integer; stdcall;
begin
  if Assigned(MemCallbackFn) then
    MemCallbackFn('Before DiscardCachedData');

  Result := DiscardCachedDataFn(PChar(ClientID), FileName);

  if Assigned(MemCallbackFn) then
    MemCallbackFn('After DiscardCachedData');

end;

// -----------------------------------------------------------------------------

function StockFreeze(CompanyPath, LocationCode: PChar; UsePostQty: Boolean; Year, Period: Integer; ClientID: Pointer): Integer; stdcall;
var
  CompanyCode: string;
(*
  ConnectionStr: PChar;
  BufferSize: Integer;
  SQLCaller: TSQLCaller;
  QueryStr: string;
*)
begin
  CompanyCode := FindCompanyCode(CompanyPath);
  Result := StockFreezeFn(ClientID, PChar(CompanyCode), PChar(LocationCode), UsePostQty, Year, Period);
(*
  { Prepare a buffer to hold the returned connection string }
  BufferSize := 256;
  ConnectionStr := StrAlloc(BufferSize);

//  GetConnectionString(PChar(CompanyCode), False, ConnectionStr, BufferSize, nil);
  GetCommonConnectionString(ConnectionStr, BufferSize, ClientID);

  try
    SQLCaller := TSQLCaller.Create;
    try
      SQLCaller.ConnectionString := ConnectionStr;
      QueryStr := Format('EXECUTE [common].[isp_StkFreeze] ''%s'', ''%s'', %d, %d, %d', [CompanyCode, LocationCode, Ord(UsePostQty), Year, Period]);
      Result := SQLCaller.ExecSQL(QueryStr, CompanyCode);
      FLastSQLError := SQLCaller.ErrorMsg;
    finally
      SQLCaller.Free;
    end;
  finally
    StrDispose(ConnectionStr);
  end;
*)
end;

// -----------------------------------------------------------------------------

function CheckAllStock(CompanyPath: PChar; StockCode: PChar; StockType: Char; Folio: Integer; ClientID: Pointer): Integer; stdcall;
var
  CompanyCode: string;
(*
  ConnectionStr: PChar;
  BufferSize: Integer;
  SQLCaller: TSQLCaller;
  QueryStr: string;
*)
begin

  CompanyCode := FindCompanyCode(CompanyPath);
  Result := CheckAllStockFn(ClientID, PChar(CompanyCode), PChar(StockCode), StockType, Folio);

(*
  { Prepare a buffer to hold the returned connection string }
  BufferSize := 256;
  ConnectionStr := StrAlloc(BufferSize);

//  GetConnectionString(PChar(CompanyCode), False, ConnectionStr, BufferSize, nil);
  GetCommonConnectionString(ConnectionStr, BufferSize, ClientID);

  try
    SQLCaller := TSQLCaller.Create;
    try
      SQLCaller.ConnectionString := ConnectionStr;
      QueryStr := Format('EXECUTE [common].[isp_CheckStkLocHistory] ''%s'', ''%s'', ''%s'', %d', [CompanyCode, StockCode, StockType, Folio]);
      Result := SQLCaller.ExecSQL(QueryStr, CompanyCode);
      FLastSQLError := SQLCaller.ErrorMsg;
    finally
      SQLCaller.Free;
    end;
  finally
    StrDispose(ConnectionStr);
  end;
*)
end;

// -----------------------------------------------------------------------------

function GetLineNumberAccounts(CompanyPath, Code: PChar; ClientID: Pointer): Integer;
var
  FuncRes: Integer;
(*
  CompanyCode: string;
  ConnectionStr: PChar;
  BufferSize: Integer;
  SQLCaller: TSQLCaller;
  QueryStr: string;
*)
begin
  FuncRes := GetLineNumberAccountsFn(ClientID, PChar(Code), Result);
(*
  CompanyCode := FindCompanyCode(CompanyPath);

  { Prepare a buffer to hold the returned connection string }
  BufferSize := 256;
  ConnectionStr := StrAlloc(BufferSize);

//  GetConnectionString(PChar(CompanyCode), False, ConnectionStr, BufferSize, nil);
  GetCommonConnectionString(ConnectionStr, BufferSize, ClientID);

  try
    SQLCaller := TSQLCaller.Create;
    try
      SQLCaller.ConnectionString := ConnectionStr;
      QueryStr := Format('SELECT [COMPANY].[ifn_GetLineNumberAccounts] (''%s'')', [Code]);
      SQLCaller.Select(QueryStr, CompanyCode);
      FLastSQLError := SQLCaller.ErrorMsg;
      if (LastSQLError = '') then
      begin
        Result := SQLCaller.Records.Fields[0].AsInteger;
      end
      else
        Result := -1;
    finally
      SQLCaller.Free;
    end;
  finally
    StrDispose(ConnectionStr);
  end;
*)
end;

// -----------------------------------------------------------------------------

function GetLineNumberStock(CompanyPath: PChar; Folio: Integer; ClientID: Pointer): Integer;
var
  FuncRes: Integer;
(*
  CompanyCode: string;
  ConnectionStr: PChar;
  BufferSize: Integer;
  SQLCaller: TSQLCaller;
  QueryStr: string;
*)
begin
  FuncRes := GetLineNumberStockFn(ClientID, Folio, Result);
(*
  CompanyCode := FindCompanyCode(CompanyPath);

  { Prepare a buffer to hold the returned connection string }
  BufferSize := 256;
  ConnectionStr := StrAlloc(BufferSize);

//  GetConnectionString(PChar(CompanyCode), False, ConnectionStr, BufferSize, nil);
  GetCommonConnectionString(ConnectionStr, BufferSize, ClientID);

  try
    SQLCaller := TSQLCaller.Create;
    try
      SQLCaller.ConnectionString := ConnectionStr;
      QueryStr := Format('SELECT [COMPANY].[ifn_GetLineNumberStock] (%d)', [Folio]);
      SQLCaller.Select(QueryStr, CompanyCode);
      FLastSQLError := SQLCaller.ErrorMsg;
      if (LastSQLError = '') then
      begin
        Result := SQLCaller.Records.Fields[0].AsInteger;
      end
      else
        Result := -1;
    finally
      SQLCaller.Free;
    end;
  finally
    StrDispose(ConnectionStr);
  end;
*)
end;

// -----------------------------------------------------------------------------

function ResetViewHistory(CompanyPath: PChar; NomViewCode: Integer; ClientID: Pointer): Integer;
var
  CompanyCode: string;
(*
  ConnectionStr: PChar;
  BufferSize: Integer;
  SQLCaller: TSQLCaller;
  QueryStr: string;
*)
begin
  CompanyCode := FindCompanyCode(CompanyPath);
  Result := ResetViewHistoryFn(ClientID, PChar(CompanyCode), NomViewCode);

(*
  { Prepare a buffer to hold the returned connection string }
  BufferSize := 256;
  ConnectionStr := StrAlloc(BufferSize);

//  GetConnectionString(PChar(CompanyCode), False, ConnectionStr, BufferSize, nil);
  GetCommonConnectionString(ConnectionStr, BufferSize, ClientID);

  try
    SQLCaller := TSQLCaller.Create;
    try
      SQLCaller.ConnectionString := ConnectionStr;
      if (NomViewCode = 0) then
        QueryStr := Format('EXECUTE [common].[isp_ResetViewHistory] ''%s''', [CompanyCode])
      else
        QueryStr := Format('EXECUTE [common].[isp_ResetViewHistory] ''%s'', %d', [CompanyCode, NomViewCode]);
      Result := SQLCaller.ExecSQL(QueryStr, CompanyCode);
      FLastSQLError := SQLCaller.ErrorMsg;
    finally
      SQLCaller.Free;
    end;
  finally
    StrDispose(ConnectionStr);
  end;
*)
end;

// -----------------------------------------------------------------------------

function ResetAuditHistory(CompanyPath: PChar; CustCode: PChar; DeleteCCDept: Boolean; PurgeYear: Integer; HistCodeLen: Integer; ClientID: Pointer): Integer;
var
  CompanyCode: string;
(*
  ConnectionStr: PChar;
  BufferSize: Integer;
  SQLCaller: TSQLCaller;
  QueryStr: string;
*)
begin
  CompanyCode := FindCompanyCode(CompanyPath);
  Result := ResetAuditHistoryFn(ClientID, PChar(CompanyCode), PChar(CustCode),
                                DeleteCCDept, PurgeYear, HistCodeLen);
(*
  { Prepare a buffer to hold the returned connection string }
  BufferSize := 256;
  ConnectionStr := StrAlloc(BufferSize);

//  GetConnectionString(PChar(CompanyCode), False, ConnectionStr, BufferSize, nil);
  GetCommonConnectionString(ConnectionStr, BufferSize, ClientID);

  try
    SQLCaller := TSQLCaller.Create;
    try
      SQLCaller.ConnectionString := ConnectionStr;
      QueryStr := Format('EXECUTE [common].[isp_ResetAuditHistory] ''%s'', ''%s'', %d, %d, %d', [CompanyCode, CustCode, Ord(DeleteCCDept), PurgeYear, HistCodeLen]);
      Result := SQLCaller.ExecSQL(QueryStr, CompanyCode);
      FLastSQLError := SQLCaller.ErrorMsg;
    finally
      SQLCaller.Free;
    end;
  finally
    StrDispose(ConnectionStr);
  end;
*)
end;

// -----------------------------------------------------------------------------

function StockLocationFilter(CompanyPath, LocationCode: string; Mode: Integer; ClientID: Pointer): Integer;
var
  CompanyCode: string;
(*
  ConnectionStr: PChar;
  BufferSize: Integer;
  SQLCaller: TSQLCaller;
  QueryStr: string;
*)
begin
  CompanyCode := FindCompanyCode(CompanyPath);
  Result := StockLocationFilterFn(ClientID, PChar(CompanyCode), PChar(LocationCode), Mode);
(*
  { Prepare a buffer to hold the returned connection string }
  BufferSize := 256;
  ConnectionStr := StrAlloc(BufferSize);

//  GetConnectionString(PChar(CompanyCode), False, ConnectionStr, BufferSize, nil);
  GetCommonConnectionString(ConnectionStr, BufferSize, ClientID);

  try
    SQLCaller := TSQLCaller.Create;
    try
      SQLCaller.ConnectionString := ConnectionStr;
      QueryStr := Format('EXECUTE [common].[isp_StkLocORReplaceInter] ''%s'', ''%s'', %d', [CompanyCode, LocationCode, Mode]);
      Result := SQLCaller.ExecSQL(QueryStr, CompanyCode);
      FLastSQLError := SQLCaller.ErrorMsg;
    finally
      SQLCaller.Free;
    end;
  finally
    StrDispose(ConnectionStr);
  end;
*)
end;

// -----------------------------------------------------------------------------

function StockAddCustAnal(CompanyPath, CustCode, StockCode, PDate: PChar; FolioRef, AbsLineNo, Currency, IdDocHed: Integer; LineType: Char; LineTotal: Double; Mode: Byte; ClientID: Pointer): Integer; stdcall;
//var
//  Qry: string;
begin
{
  PROCEDURE [ZZZZ01].[isp_StockAddCustAnal]	(
      @iv_CustCode		VARCHAR(6)
    , @iv_StockCode		VARCHAR(16)
    , @iv_PDate			  VARCHAR(8)
    , @iv_FolioRef		INT
    , @iv_AbsLineNo		INT
    , @iv_Currency		INT
    , @iv_IdDocHed		INT
    , @iv_LineType		VARCHAR(1)
    , @iv_LineTotal		FLOAT
    , @iv_Mode			  BIT
  )
}
  Result := StockAddCustAnalFn(ClientID, PChar(CustCode), PChar(StockCode),
                               PChar(PDate), FolioRef, AbsLineNo, Currency,
                               IdDocHed, LineType, LineTotal, Mode);
(*
  Qry := Format('EXECUTE [COMPANY].[isp_StockAddCustAnal] ''%s'', ''%s'', ''%s'', %d, %d, %d, %d, ''%s'', %.6f, %d',
                [CustCode, StockCode, PDate, FolioRef, AbsLineNo, Currency, IdDocHed, LineType, LineTotal, Mode]);
  Result := ExecSQL(PChar(Qry), CompanyPath);
*)
end;

// -----------------------------------------------------------------------------

// CJS 2016-05-09 - ABSEXCH-17353 - GL Budgets - Extend to include 5 budget revisions
// Amended NCode parameter -- this now takes a ShortString, not an untyped parameter
function TotalProfitToDateRange(CompanyPath: PChar; NType: Char; NCode: ShortString;
  PCr, PYr, PPr, PPr2: Integer; Range, SetACHist: Boolean;
  var Purch, PSales, Balance, PCleared, PBudget,
  RevisedBudget1, RevisedBudget2, RevisedBudget3, RevisedBudget4, RevisedBudget5,
  BValue1, BValue2: double; ClientID: Pointer): Integer;
var
  CompanyCode: string;
  ConnectionStr: PChar;
  ConnectionStrSize: Integer;
  SQLCaller: TSQLCaller;
  QueryStr, NCodeStr: AnsiString;
  FuncRes: Integer;

  Buffer: Variant;
  TempBuffer: string[21];
  BufferStr: string[20];
  i: Integer;
  lErrInformation: String;
begin
  BufferStr := NCode + StringOfChar(Char(32), 20 - Length(NCode));

  if Assigned(MemCallbackFn) then
    MemCallbackFn('Before TotalProfitToDateRange ' + NType);

  // CJS 2016-05-06 - ABSEXCH-17353 - GL Budgets - Extend to include 5 budget revisions
  Result := TotalProfitToDateRangeFn(ClientID, NType, BufferStr[1], PCr, PYr,
                                     PPr, PPr2, Range, SetACHist, Purch, PSales,
                                     Balance, PCleared, PBudget,
                                     RevisedBudget1, RevisedBudget2, RevisedBudget3,
                                     RevisedBudget4, RevisedBudget5,
                                     BValue1, BValue2);


  if Assigned(MemCallbackFn) then
    MemCallbackFn('After TotalProfitToDateRange ' + NType);

  if Result <> 0 then
  begin
    //RB 17/08/2017 2017-R2 ABSEXCH-18990: Error Message CEXCHESQLInterface::TotalProfitToDateRange
    //After reconnection, even if TotalProfitToDateRange stored procedure executed currectly, emulator throws general network error.
    //So we will just ignore this exception because at this time Connection is OK.
    lErrInformation := GetErrorInformation(Result);
    if (Not AnsiContainsText(lErrInformation, 'Connection failure')) and  (Not AnsiContainsText(lErrInformation, 'General network error')) then
      ShowMessage(lErrInformation);
  end;

(*
  CompanyCode := FindCompanyCode(CompanyPath);

  { Prepare a buffer to hold the returned connection string }
  ConnectionStrSize := 256;
  ConnectionStr := StrAlloc(ConnectionStrSize);

  Move(NCode, BufferStr[0], 20);

  // Copy the contents (excluding the length byte) of the code into the
  // buffer.
  Buffer := VarArrayCreate([0, Ord(BufferStr[0]) - 1], varByte);
  for i := 1 to Ord(BufferStr[0]) do
    Buffer[i - 1] := Ord(BufferStr[i]);

  GetCommonConnectionString(ConnectionStr, ConnectionStrSize, ClientID);

  try
    SQLCaller := TSQLCaller.Create;
    try
      SQLCaller.ConnectionString := ConnectionStr;
{
      QueryStr := Format('EXEC [COMPANY].[isp_TotalProfitToDateRange] ''%s'', ''%s'', %d, %d, %d, %d, %d, %d, ' +
                         ':ov_Purch    OUTPUT, ' +
												 ':ov_PSales	  OUTPUT, ' +
												 ':ov_Balance	OUTPUT, ' +
												 ':ov_PCleared	OUTPUT, ' +
												 ':ov_PBudget	OUTPUT, ' +
												 ':ov_PRBudget	OUTPUT, ' +
												 ':ov_BValue1	OUTPUT, ' +
												 ':ov_BValue2	OUTPUT',
                         [
                          NType,
                          NCode,
                          PCr,
                          PYr,
                          PPr,
                          PPr2,
                          Ord(Range),
                          Ord(SetACHist)
                         ]);
}
      if (CompanyCode <> '') then
        QueryStr := StringReplace('[COMPANY].[isp_TotalProfitToDateRange]', '[COMPANY]', '[' + CompanyCode + ']', [rfReplaceAll])
      else
        QueryStr := '[COMPANY].[isp_TotalProfitToDateRange]';

      with SQLCaller.StoredProcedure do
      begin
        ProcedureName := QueryStr;
        with Parameters.AddParameter do
        begin
          Direction := pdReturnValue;
          Name := 'ReturnCode';
          DataType := ftInteger;
        end;
        with Parameters.AddParameter do
        begin
          Direction := pdInput;
          Name := 'NType';
          DataType := ftFixedChar;
          Size := 1;
          Value := NType;
        end;
        with Parameters.AddParameter do
        begin
          Direction := pdInput;
          Name := 'NCode';

          DataType := ftBytes;
          Size := Ord(BufferStr[0]);
          Value := Buffer;

{
          DataType := ftString;
          NCodeStr := BufferStr;
          Value := NCodeStr;
}
        end;
        with Parameters.AddParameter do
        begin
          Direction := pdInput;
          Name := 'PCr';
          DataType := ftSmallInt;
          Value := PCr;
        end;
        with Parameters.AddParameter do
        begin
          Direction := pdInput;
          Name := 'PYr';
          DataType := ftSmallInt;
          Value := PYr;
        end;
        with Parameters.AddParameter do
        begin
          Direction := pdInput;
          Name := 'PPr';
          DataType := ftSmallInt;
          Value := PPr;
        end;
        with Parameters.AddParameter do
        begin
          Direction := pdInput;
          Name := 'PPr2';
          DataType := ftSmallInt;
          Value := PPr2;
        end;
        with Parameters.AddParameter do
        begin
          Direction := pdInput;
          Name := 'Range';
          DataType := ftSmallInt;
          Value := Ord(Range);
        end;
        with Parameters.AddParameter do
        begin
          Direction := pdInput;
          Name := 'SetACHist';
          DataType := ftSmallInt;
          Value := Ord(SetACHist);
        end;
        with Parameters.AddParameter do
        begin
          Direction := pdOutput;
          Name := 'ov_Purch';
          DataType := ftFloat;
        end;
        with Parameters.AddParameter do
        begin
          Direction := pdOutput;
          Name := 'ov_PSales';
          DataType := ftFloat;
        end;
        with Parameters.AddParameter do
        begin
          Direction := pdOutput;
          Name := 'ov_Balance';
          DataType := ftFloat;
        end;
        with Parameters.AddParameter do
        begin
          Direction := pdOutput;
          Name := 'ov_PCleared';
          DataType := ftFloat;
        end;
        with Parameters.AddParameter do
        begin
          Direction := pdOutput;
          Name := 'ov_PBudget';
          DataType := ftFloat;
        end;
        with Parameters.AddParameter do
        begin
          Direction := pdOutput;
          Name := 'ov_PRBudget';
          DataType := ftFloat;
        end;
        with Parameters.AddParameter do
        begin
          Direction := pdOutput;
          Name := 'ov_BValue1';
          DataType := ftFloat;
        end;
        with Parameters.AddParameter do
        begin
          Direction := pdOutput;
          Name := 'ov_BValue2';
          DataType := ftFloat;
        end;
      end;

      if (not SQLCaller.Connection.Connected) then
        SQLCaller.Connection.Open;

      SQLCaller.StoredProcedure.ExecProc;
      FuncRes := SQLCaller.StoredProcedure.Parameters.ParamValues['ReturnCode'];
      FLastSQLError := SQLCaller.ErrorMsg;
      if (LastSQLError = '') and (FuncRes = 0) then
      begin
        Result := 0;
        if not VarIsNull(SQLCaller.StoredProcedure.Parameters.ParamByName('ov_Purch').Value) then
        begin
          Purch := SQLCaller.StoredProcedure.Parameters.ParamByName('ov_Purch').Value;
          PSales := SQLCaller.StoredProcedure.Parameters.ParamByName('ov_PSales').Value;
          Balance := SQLCaller.StoredProcedure.Parameters.ParamByName('ov_Balance').Value;
          PCleared := SQLCaller.StoredProcedure.Parameters.ParamByName('ov_PCleared').Value;
          PBudget := SQLCaller.StoredProcedure.Parameters.ParamByName('ov_PBudget').Value;
          PRBudget := SQLCaller.StoredProcedure.Parameters.ParamByName('ov_PRBudget').Value;
          BValue1 := SQLCaller.StoredProcedure.Parameters.ParamByName('ov_BValue1').Value;
          BValue2 := SQLCaller.StoredProcedure.Parameters.ParamByName('ov_BValue2').Value;
        end;
      end
      else
        Result := -1;
    finally
      SQLCaller.Free;
    end;
  finally
    StrDispose(ConnectionStr);
  end;
*)
end;

// -----------------------------------------------------------------------------

function FillBudget(CompanyPath: PChar; NType: Integer; var Code;
  Currency, Year, Period, PeriodInYear: Integer; CalcPurgeOB, Range: Boolean;
  PPr2: Integer; ClientID: Pointer): Integer;
var
  Qry: string;
begin
{
CREATE PROCEDURE [!ActiveSchema!].[isp_LFillBudget]	(
	    @iv_Type              INT
	  , @iv_Code              VARBINARY(21)
	  , @iv_Currency		  INT
	  , @iv_Year              INT
	  , @iv_Period            INT
	  , @iv_PeriodInYear      INT
	  , @iv_CalcPurgeOB		  BIT
	  , @iv_Range			  BIT
	  , @iv_PPr2			  INT		-- 0 in this case
  )
}
{
  Qry := Format('EXECUTE [COMPANY].[isp_LFillBudget] %d, %s, %d, %d, %d, %d, %d, %d, %d',
                [NType, Code, Currency, Year, Period, PeriodInYear,
                 Ord(CalcPurgeOB), Ord(Range), PPr2]);
  Result := ExecSQL(PChar(Qry), CompanyPath);
}
  Result := FillBudgetFn(ClientID, NType, Code, Currency, Year, Period,
                         PeriodInYear, CalcPurgeOB, Range, PPr2);
end;

// -----------------------------------------------------------------------------

function RemoveLastCommit(CompanyPath: PChar; ClientID: Pointer): Integer;
var
  Qry: string;
begin
{
  Qry := 'EXECUTE [COMPANY].[isp_RemoveLastCommit]';
  Result := ExecSQL(PChar(Qry), CompanyPath);
}
  if Assigned(MemCallbackFn) then
    MemCallbackFn('Before RemoveLastCommit');

  Result := RemoveLastCommitFn(ClientID);

  if Assigned(MemCallbackFn) then
    MemCallbackFn('After RemoveLastCommit');

  if (Result <> 0) then
  begin
    FLastSQLError := GetErrorInformation(Result);
    Log('RemoveLastCommit failed, error ' + IntToStr(Result) + ' : ' + FLastSQLError);
  end;
end;

// -----------------------------------------------------------------------------

function PartialUnpostHistory(CompanyPath: PChar; NType: Char; NCode: Str20;
  PCr, PYr, PPr, PPr2: Integer; Range, SetACHist: Boolean;
  var Purch, PSales, PCleared, PBudget: double; ClientID: Pointer): Integer;
var
  CompanyCode: string;
  ConnectionStr: PChar;
  BufferSize: Integer;
  SQLCaller: TSQLCaller;
  QueryStr, NCodeStr: string;
  FuncRes: Integer;
begin
{
  [COMPANY].[isp_PartialUnPostHistory]
  (
      @iv_NType			CHAR(1)
    , @iv_NCode			VARCHAR(21)
    , @iv_PCr			BIT					-- Currency
    , @iv_PYr			INT					-- hiYear
    , @iv_PPr			INT					-- hiPeriod
    , @iv_PPr2			INT					-- hiPreviousPeriod
    , @iv_Range			BIT
    , @iv_SetACHist		BIT
    , @ov_Purch			FLOAT = 0 OUTPUT
    , @ov_PSales		FLOAT = 0 OUTPUT
    , @ov_PCleared		FLOAT = 0 OUTPUT
    , @ov_PBudget		FLOAT = 0 OUTPUT
  )
}

  CompanyCode := FindCompanyCode(CompanyPath);

  { Prepare a buffer to hold the returned connection string }
  BufferSize := 256;
  ConnectionStr := StrAlloc(BufferSize);

  GetConnectionString(PChar(CompanyCode), False, ConnectionStr, BufferSize, nil);

  try
    SQLCaller := TSQLCaller.Create;
    try
      SQLCaller.ConnectionString := ConnectionStr;

      if (CompanyCode <> '') then
        QueryStr := StringReplace('[COMPANY].[isp_PartialUnPostHistory]', '[COMPANY]', '[' + CompanyCode + ']', [rfReplaceAll])
      else
        QueryStr := '[COMPANY].[isp_PartialUnPostHistory]';

      with SQLCaller.StoredProcedure do
      begin
        ProcedureName := QueryStr;
        with Parameters.AddParameter do
        begin
          Direction := pdReturnValue;
          Name := 'ReturnCode';
          DataType := ftInteger;
        end;
        with Parameters.AddParameter do
        begin
          Direction := pdInput;
          Name := 'NType';
          DataType := ftFixedChar;
          Size := 1;
          Value := NType;
        end;
        with Parameters.AddParameter do
        begin
          Direction := pdInput;
          Name := 'NCode';
          DataType := ftString;
          NCodeStr := NCode;
          Value := NCodeStr;
        end;
        with Parameters.AddParameter do
        begin
          Direction := pdInput;
          Name := 'PCr';
          DataType := ftSmallInt;
          Value := PCr;
        end;
        with Parameters.AddParameter do
        begin
          Direction := pdInput;
          Name := 'PYr';
          DataType := ftSmallInt;
          Value := PYr;
        end;
        with Parameters.AddParameter do
        begin
          Direction := pdInput;
          Name := 'PPr';
          DataType := ftSmallInt;
          Value := PPr;
        end;
        with Parameters.AddParameter do
        begin
          Direction := pdInput;
          Name := 'PPr2';
          DataType := ftSmallInt;
          Value := PPr2;
        end;
        with Parameters.AddParameter do
        begin
          Direction := pdInput;
          Name := 'Range';
          DataType := ftSmallInt;
          Value := Ord(Range);
        end;
        with Parameters.AddParameter do
        begin
          Direction := pdInput;
          Name := 'SetACHist';
          DataType := ftSmallInt;
          Value := Ord(SetACHist);
        end;
        with Parameters.AddParameter do
        begin
          Direction := pdOutput;
          Name := 'ov_Purch';
          DataType := ftFloat;
        end;
        with Parameters.AddParameter do
        begin
          Direction := pdOutput;
          Name := 'ov_PSales';
          DataType := ftFloat;
        end;
        with Parameters.AddParameter do
        begin
          Direction := pdOutput;
          Name := 'ov_PCleared';
          DataType := ftFloat;
        end;
        with Parameters.AddParameter do
        begin
          Direction := pdOutput;
          Name := 'ov_PBudget';
          DataType := ftFloat;
        end;
      end;

      if (not SQLCaller.Connection.Connected) then
        SQLCaller.Connection.Open;

      SQLCaller.StoredProcedure.ExecProc;
      FuncRes := SQLCaller.StoredProcedure.Parameters.ParamValues['ReturnCode'];
      FLastSQLError := SQLCaller.ErrorMsg;
      if (LastSQLError = '') and (FuncRes = 0) then
      begin
        Result := 0;
        if not VarIsNull(SQLCaller.StoredProcedure.Parameters.ParamByName('ov_Purch').Value) then
        begin
          Purch := SQLCaller.StoredProcedure.Parameters.ParamByName('ov_Purch').Value;
          PSales := SQLCaller.StoredProcedure.Parameters.ParamByName('ov_PSales').Value;
          PCleared := SQLCaller.StoredProcedure.Parameters.ParamByName('ov_PCleared').Value;
          PBudget := SQLCaller.StoredProcedure.Parameters.ParamByName('ov_PBudget').Value;
        end;
      end
      else
        Result := -1;
    finally
      SQLCaller.Free;
    end;
  finally
    StrDispose(ConnectionStr);
  end;
end;

// -----------------------------------------------------------------------------

function CheckExchRnd: Integer; stdcall;
var
  ConnectionStr: PChar;
  BufferSize: Integer;
  SQLCaller: TSQLCaller;
  QueryStr: string;
begin
  { Prepare a buffer to hold the returned connection string }
  BufferSize := 256;
  ConnectionStr := StrAlloc(BufferSize);
  try
    GetCommonConnectionString(ConnectionStr, BufferSize, nil);
    SQLCaller := TSQLCaller.Create;
    try
      SQLCaller.ConnectionString := ConnectionStr;

      QueryStr := 'EXECUTE [common].[isp_CheckExchRnd]';
      Result := SQLCaller.ExecSQL(QueryStr, '');

      FLastSQLError := SQLCaller.ErrorMsg;
    finally
      SQLCaller.Free;
    end;
  finally
    StrDispose(ConnectionStr);
  end;
end;

// -----------------------------------------------------------------------------

function ExecSQL(QueryStr: PChar; CompanyPath: PChar): Integer;
var
  CompanyCode: string;
  ConnectionStr: PChar;
  BufferSize: Integer;
  SQLCaller: TSQLCaller;
begin

  CompanyCode := FindCompanyCode(CompanyPath);
  { Prepare a buffer to hold the returned connection string }

  BufferSize := 256;
  ConnectionStr := StrAlloc(BufferSize);

//  GetConnectionString(PChar(CompanyCode), False, ConnectionStr, BufferSize, nil);
  GetCommonConnectionString(ConnectionStr, BufferSize, nil);

  try
    SQLCaller := TSQLCaller.Create;
    try
      SQLCaller.ConnectionString := ConnectionStr;
      Result := SQLCaller.ExecSQL(QueryStr, CompanyCode);
      FLastSQLError := SQLCaller.ErrorMsg;
    finally
      SQLCaller.Free;
    end;
  finally
    StrDispose(ConnectionStr);
  end;
end;

// -----------------------------------------------------------------------------

function SQLFetch(const QueryStr, Field, CompanyPath: PChar; var Value: Variant): Integer;
var
  CompanyCode: string;
  ConnectionStr,
  lPassword: PChar;
  BufferSize: Integer;
  SQLCaller: TSQLCaller;
begin
  Result := 0;

  { Prepare a buffer to hold the returned connection string }
  BufferSize := 256;
  ConnectionStr := StrAlloc(BufferSize);
  //SS:20/02/2018:2018-R1:ABSEXCH-19788:System User Login:Total Unpost: Getting error : 'Login failed for 'ADM1038MAIN01808'
  lPassword := StrAlloc(BufferSize);
  if (CompanyPath <> '') then
  begin
    CompanyCode := FindCompanyCode(CompanyPath);
    //SS:09/02/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
    GetConnectionStringWOPass(PChar(CompanyCode), False, ConnectionStr, BufferSize, lPassword, nil);
  end
  else
  begin
    CompanyCode := '';
    GetCommonConnectionStringWOPass(ConnectionStr, BufferSize, lPassword, nil);
  end;

  try
    SQLCaller := TSQLCaller.Create;
    try
      SQLCaller.ConnectionString := ConnectionStr;
      SQLCaller.Connection.Password := lPassword;
      SQLCaller.Select(QueryStr, CompanyCode);
      try
        if (SQLCaller.ErrorMsg = '') then
          Value := SQLCaller.Records.FieldByName(Field).AsVariant
        else
          Result := 10;
        FLastSQLError := SQLCaller.ErrorMsg;
      finally
        SQLCaller.Close;
      end;
    finally
      SQLCaller.Free;
    end;
  finally
    StrDispose(ConnectionStr);
    //SS:20/02/2018:2018-R1:ABSEXCH-19788:System User Login:Total Unpost: Getting error : 'Login failed for 'ADM1038MAIN01808'
    StrDispose(lPassword);
  end;
end;

// -----------------------------------------------------------------------------

function LastSQLError: ShortString;
begin
  Result := FLastSQLError;
end;

// -----------------------------------------------------------------------------

function UpdateCompanyCache(CompanyCode, CompanyPath: PChar): Integer;
begin
  Result := CompanyTable.UpdateCache(CompanyCode, CompanyPath);
end;

// -----------------------------------------------------------------------------

procedure EnteringModule(ModuleName: PChar);
begin
  Log('Entering module : ' + ModuleName);
end;

// -----------------------------------------------------------------------------


procedure LeavingModule(ModuleName: PChar);
begin
  Log('Leaving module : ' + ModuleName);
end;

// -----------------------------------------------------------------------------

// =============================================================================
// Internal DLL functions (for accessing the Btrieve or iCore DLLs)
// =============================================================================

function Load_DLL(Path: PChar): Boolean;
var
  ErrMsg: string;
  ErrNo: Integer;
  DLLSpec: AnsiString;
  DBType: string;
  Dir: ShortString;
begin

//Log('Load_DLL: ' + Path);

  Result := False;
  ErrMsg := '';

  DBType := SysUtils.GetEnvironmentVariable('EXCHEQUERDBTYPE');

Log('LoadDLL: DBType: ' + DBType);

  if (DBType = '0') then
    IsSql := False
  else if (DBType = '1') then
    IsSql := True;

  { Determine whether we are running Btrieve or SQL, and load the appropriate
    DLL. }
  DLLPath := '';
  if (Trim(Path) = '') then
  begin
    GetOleServerPath(Dir);
    DLLPath := Trim(Dir);
  end
  else
  begin
    DLLPath := Path;
    DLLPath := Trim(DLLPath);
  end;
  if (DLLPath <> '') then
    DLLPath := IncludeTrailingPathDelimiter(DLLPath);

  if IsSQL then
    DLLSpec := DLLPath + 'icorebtrv.dll'
  else
    DLLSpec := 'WBTRV32.DLL';
//    DLLSpec := DLLPath + 'WBTRV32.DLL';

Log('LoadDLL: ' + DLLSpec);

  DLLHandle := LoadLibrary(PChar(DLLSpec));

  { Try to get the function addresses from the DLL. }
  if DLLHandle <> 0 then
  begin
    BTRCallProtector.BeginWrite;
    try
      @BTRCallFn            := GetProcAddress(DLLHandle, 'BTRCALL');
      @BTRCallIDFn          := GetProcAddress(DLLHandle, 'BTRCALLID');
      @WBTRVInitFn          := GetProcAddress(DLLHandle, 'WBTRVINIT');
      @WBTRVStopFn          := GetProcAddress(DLLHandle, 'WBTRVSTOP');
      if not Assigned(BTRCallFn) then
        ErrMsg := 'BTRCALL'
      else if not Assigned(BTRCallIDFn) then
        ErrMsg := 'BTRCALLID'
      else if not Assigned(WBTRVInitFn) then
        ErrMsg := 'WBTRVINIT'
      else if not Assigned(WBTRVStopFn) then
        ErrMsg := 'WBTRVSTOP';
      if (ErrMsg = '') and IsSQL then
      begin
        @CreateDatabaseFn       := GetProcAddress(DLLHandle, 'CreateDatabase');
        @CreateCompanyFn        := GetProcAddress(DLLHandle, 'CreateCompany');
        @DeleteCompanyFn        := GetProcAddress(DLLHandle, 'DeleteCompany');
        @OpenCompanyFn          := GetProcAddress(DLLHandle, 'OpenCompany');
        @TableExistsFn          := GetProcAddress(DLLHandle, 'TableExists');
        @DeleteTableFn          := GetProcAddress(DLLHandle, 'DeleteTable');
        @AttachCompanyFn        := GetProcAddress(DLLHandle, 'AttachCompany');
        @DetachCompanyFn        := GetProcAddress(DLLHandle, 'DetachCompany');
        @ConnectionStringFn     := GetProcAddress(DLLHandle, 'GetConnectionString');
        @ConnectionStringWOPassFn := GetProcAddress(DLLHandle, 'GetConnectionStringWOPass');   //VA:26/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
        @ExportDatasetFn        := GetProcAddress(DLLHandle, 'ExportDataset');
        @ImportDatasetFn        := GetProcAddress(DLLHandle, 'ImportDataset');
        @GetSQLErrorInfoFn      := GetProcAddress(DLLHandle, 'GetErrorInformation');
        @HasExclusiveAccessFn   := GetProcAddress(DLLHandle, 'HasExclusiveAccess');
        @CopyTableFn            := GetProcAddress(DLLHandle, 'CopyTable');
        @UpdateTableFn          := GetProcAddress(DLLHandle, 'UpdateTable');
        @GetDBColumnNameFn      := GetProcAddress(DLLHandle, 'GetDbColumnNameFromSchemaName');
        @GetDBTableNameFn       := GetProcAddress(DLLHandle, 'GetTableNameFromBtrieveFileName');
        @CloseClientIdSessionFn := GetProcAddress(DLLHandle, 'CloseClientIdSession');
        @SetCacheSizeFn         := GetProcAddress(DLLHandle, 'SetCacheSize');
        @DeleteRowsFn           := GetProcAddress(DLLHandle, 'DeleteRows');
        @CreateCustomPrefillCacheEmulatorFn := GetProcAddress(DLLHandle, 'CreateCustomPrefillCacheEmulator');
        @UseCustomPrefillCacheEmulatorFn := GetProcAddress(DLLHandle, 'UseCustomPrefillCacheEmulator');
        @DropCustomPrefillCacheEmulatorFn := GetProcAddress(DLLHandle, 'DropCustomPrefillCacheEmulator');
        @PostToHistoryFn        := GetProcAddress(DLLHandle, 'PostToHistory');
        @PostToYearDateFn       := GetProcAddress(DLLHandle, 'PostToYearDate');
        @UseVariantForNextCallFn := GetProcAddress(DLLHandle, 'UseVariantForNextCall');
        @CommonConnectionStringFn := GetProcAddress(DLLHandle, 'GetCommonConnectionString');
        @CommonConnectionStringWOPassFn := GetProcAddress(DLLHandle, 'GetCommonConnectionStringWOPass');    //SS:26/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
        @FillBudgetFn           := GetProcAddress(DLLHandle, 'FillBudget');
        @StockFreezeFn          := GetProcAddress(DLLHandle, 'StockFreeze');
        @CheckAllStockFn        := GetProcAddress(DLLHandle, 'CheckAllStock');
        @GetLineNumberAccountsFn:= GetProcAddress(DLLHandle, 'GetLineNumberAccounts');
        @GetLineNumberStockFn   := GetProcAddress(DLLHandle, 'GetLineNumberStock');
        @ResetViewHistoryFn     := GetProcAddress(DLLHandle, 'ResetViewHistory');
        @ResetAuditHistoryFn    := GetProcAddress(DLLHandle, 'ResetAuditHistory');
        @StockLocationFilterFn  := GetProcAddress(DLLHandle, 'StockLocationFilter');
        @StockAddCustAnalFn     := GetProcAddress(DLLHandle, 'StockAddCustAnal');
        @TotalProfitToDateRangeFn := GetProcAddress(DLLHandle, 'TotalProfitToDateRange');
        @RemoveLastCommitFn     := GetProcAddress(DLLHandle, 'RemovedLastCommit');
        @DiscardCachedDataFn    := GetProcAddress(DLLHandle, 'DiscardCachedData');
        if not Assigned(CreateDatabaseFn) then
          ErrMsg := 'CreateDatabase'
        else if not Assigned(CreateCompanyFn) then
          ErrMsg := 'CreateCompany'
        else if not Assigned(DeleteCompanyFn) then
          ErrMsg := 'DeleteCompany'
        else if not Assigned(OpenCompanyFn) then
          ErrMsg := 'OpenCompany'
        else if not Assigned(TableExistsFn) then
          ErrMsg := 'TableExists'
        else if not Assigned(DeleteTableFn) then
          ErrMsg := 'DeleteTable'
        else if not Assigned(AttachCompanyFn) then
          ErrMsg := 'AttachCompany'
        else if not Assigned(DetachCompanyFn) then
          ErrMsg := 'DetachCompany'
        else if not Assigned(ConnectionStringFn) then
          ErrMsg := 'GetConnectionString'
        else if not Assigned(ConnectionStringWOPassFn) then   //VA:26/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
          ErrMsg := 'GetConnectionStringWOPass'
        else if not Assigned(ExportDatasetFn) then
          ErrMsg := 'ExportDataset'
        else if not Assigned(ImportDatasetFn) then
          ErrMsg := 'ImportDataset'
        else if not Assigned(HasExclusiveAccessFn) then
          ErrMsg := 'HasExclusiveAccess'
        else if not Assigned(GetSQLErrorInfoFn) then
          ErrMsg := 'GetErrorInformation'
        else if not Assigned(CopyTableFn) then
          ErrMsg := 'CopyTable'
        else if not Assigned(UpdateTableFn) then
          ErrMsg := 'UpdateTable'
        else if not Assigned(GetDBColumnNameFn) then
          ErrMsg := 'GetDbColumnNameFromSchemaName'
        else if not Assigned(GetDBTableNameFn) then
          ErrMsg := 'GetTableNameFromBtrieveFilename'
        else if not Assigned(CloseClientIDSessionFn) then
          ErrMsg := 'CloseClientIdSession'
        else if not Assigned(SetCacheSizeFn) then
          ErrMsg := 'SetCacheSize'
        else if not Assigned(CreateCustomPrefillCacheEmulatorFn) then
          ErrMsg := 'CreateCustomPrefillCacheEmulator'
        else if not Assigned(UseCustomPrefillCacheEmulatorFn) then
          ErrMsg := 'UseCustomPrefillCacheEmulator'
        else if not Assigned(DropCustomPrefillCacheEmulatorFn) then
          ErrMsg := 'DropCustomPrefillCacheEmulator'
        else if not Assigned(PostToHistoryFn) then
          ErrMsg := 'PostToHistory'
        else if not Assigned(PostToYearDateFn) then
          ErrMsg := 'PostToYearDate'
        else if not Assigned(UseVariantForNextCallFn) then
          ErrMsg := 'UseVariantForNextCall'
        else if not Assigned(CommonConnectionStringFn) then
          ErrMsg := 'CommonConnectionString'
        else if not Assigned(CommonConnectionStringWOPassFn) then   //SS:26/01/2018:2018-R1:ABSEXCH-19243:Enhancement to remove the ability to extract SQL admin passwords
          ErrMsg := 'CommonConnectionStringWOPass'
        else if not Assigned(FillBudgetFn) then
          ErrMsg := 'FillBudget'
        else if not Assigned(StockFreezeFn) then
          ErrMsg := 'StockFreeze'
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
        else if not Assigned(StockAddCustAnalFn) then
          ErrMsg := 'StockAddCustAnal'
        else if not Assigned(TotalProfitToDateRangeFn) then
          ErrMsg := 'TotalProfitToDateRange'
        else if not Assigned(RemoveLastCommitFn) then
          ErrMsg := 'RemoveLastCommit'
        else if not Assigned(DiscardCachedDataFn) then
          ErrMsg := 'DiscardCachedData'
      end;
    finally
      BTRCallProtector.EndWrite;
    end;
    if ErrMsg <> '' then
      ErrMsg := Format(NOT_FOUND_MSG, [ErrMsg])
    else
      { If we reach here, we have successfully loaded the DLL and
        obtained the addresses of all the required functions. }
      Result := True;
  end
  else
  begin
    ErrNo := GetLastError;
    ErrMsg := 'Unable to load database connection DLL (LoadLibrary() failed): ' + DLLSpec + ', error #' + IntToStr(ErrNo);
  end;

  if not Result then
  begin
    ShowMessage(ErrMsg + ' Please contact your Technical Support');
    Result := False;
  end
  else
  begin

if IsSQL then
  Log('Load_DLL: using SQL Server')
else
  Log('Load_DLL: using Btrieve');

{
    if IsSQL then
      ShowMessage('SQL-aware BTRVU2 unit active, using SQL Server')
    else
      ShowMessage('SQL-aware BTRVU2 unit active, using Btrieve');
}
  end;

end;

// -----------------------------------------------------------------------------

function Unload_DLL: Boolean;
begin

//Log('Unload_DLL: ' + IntToStr(DLLHandle));

  if DLLHandle <> 0 then
    Result := FreeLibrary(DLLHandle)
  else
    Result := True;
end;

// -----------------------------------------------------------------------------

function OverrideUsingSQL(Value: Boolean): Integer; stdcall;
var
  NewPath: AnsiString;
begin
  IsSQL := Value;
  Unload_DLL;

//Log('OverrideUsingSQL');

  NewPath := Copy(DLLPath, 1, Length(DLLPath));
  if not Load_DLL(PChar(NewPath)) then
    Result := -1
  else
    Result := 0;
end;

// -----------------------------------------------------------------------------

function SetCacheSize(var PosBlock; Size: Integer; var OldSize: Integer; ClientID: Pointer): Integer;
begin
Log('SetCacheSize: clientid=' + IntToStr(Integer(ClientID)) +
    ', posblk ' + IntToStr(Integer(Pointer(@PosBlock))) +
    ', size ' + IntToStr(Size));
  Result := SetCacheSizeFn('WMIT_SC', PChar(ClientID), PosBlock, Size, OldSize);
//  Result := SetCacheSizeFn(Dummy, Dummy, Dummy, 10, OldSize);
end;

// -----------------------------------------------------------------------------

// CJS 2011-10-19: ABSEXCH-11513 - added call to discard cached data (as
//                 DeleteRows() will have rendered the cache invalid, but
//                 the Emulator will not be aware of this). Also added a new
//                 ClientID parameter to DeleteRows(), as DiscardCachedData()
//                 requires one.
function DeleteRows(CompanyCode, Filename, WhereClause: PChar; ClientID: Pointer): Integer; stdcall;
begin
  Result := DeleteRowsFn('WMIT_DR', CompanyCode, FileName, WhereClause);
  if (Result = 0) then
    Result := DiscardCachedData(FileName, ClientID);
end;

// -----------------------------------------------------------------------------

{$IFDEF SQLDEBUG}

{ TSQLFiles }

procedure TSQLFiles.Add(PosBlock: Integer; FileSpec: string);
var
  NewFile: TSQLFile;
begin
  if not IsRecorded(PosBlock) then
  begin
    NewFile := TSQLFile.Create;
    NewFile.PosBlock := PosBlock;
    NewFile.FileSpec := ExtractFileName(FileSpec);
    FList.Add(NewFile);
  end;
end;

// -----------------------------------------------------------------------------

constructor TSQLFiles.Create;
begin
  inherited Create;
  FList := TObjectList.Create;
  FList.OwnsObjects := True;
end;

// -----------------------------------------------------------------------------

destructor TSQLFiles.Destroy;
begin
  FreeAndNil(FList);
  inherited;
end;

// -----------------------------------------------------------------------------

function TSQLFiles.FileSpec(PosBlock: Integer): string;
var
  i: Integer;
begin
  i := IndexOf(PosBlock);
  if (i <> -1) then
    Result := TSQLFile(FList[i]).FileSpec
  else
    Result := 'FILE NOT OPEN';
end;

// -----------------------------------------------------------------------------

function TSQLFiles.IndexOf(PosBlock: Integer): Integer;
var
  i: Integer;
begin
  Result := -1;
  for i := 0 to FList.Count - 1 do
  begin
    if (TSQLFile(FList[i]).PosBlock = PosBlock) then
    begin
      Result := i;
      break;
    end;
  end;
end;

// -----------------------------------------------------------------------------

function TSQLFiles.IsRecorded(PosBlock: Integer): Boolean;
begin
  Result := (IndexOf(PosBlock) <> -1);
end;

// -----------------------------------------------------------------------------

{$ENDIF}

initialization

  IsMultiThread := True;

// ShowMessage(IntToStr(SizeOf(TAllocWizardSessionRec)));

  {$IFDEF SQLDEBUG}
  SQLFiles := TSQLFiles.Create;
  {$ENDIF}

  if not (Lowercase(ExtractFileName(ParamStr(0))) = 'delphi32.exe') then
  begin
    ClientIDs := TClientIDs.Create;
    if not InitLicence('') then
    begin
      ShowMessage('Failed to initialise licence');
      Halt;
    end;
  end;
//  Coinitialize(nil);

finalization

  {$IFDEF SQLDEBUG}
  FreeAndNil(SQLFiles);
  {$ENDIF}

  Finalize_SQLVariantsU;
  Finalize_SQLRedirectorU;
  Finalize_SQLLockU;
  Finalize_SQLCache;

  Unload_DLL;

  BTRCallProtector.Free;

  ClientIDs.Free;
  ClientIDs := nil;

end.

