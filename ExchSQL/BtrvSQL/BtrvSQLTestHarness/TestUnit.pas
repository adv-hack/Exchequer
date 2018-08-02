unit TestUnit;

interface

uses SysUtils, Forms, TestFramework;

const
  TEST_COMPANY_CODE = 'ZZZZ01';
  TEST_COMPANY_PATH = 'C:\EXCH64';
  TEST_COMPANY_NAME = 'Test Company';

type
  TTestCompany = record
    Code: string;
    Name: string;
    Path: string;
  end;
  TTestSettings = record
    MainCompany: TTestCompany;
    SecondCompany: TTestCompany;
    ServerName: string;
    TestDatabaseName: string;
  end;
  TTestBtrvSQL = class(TTestCase)
  private
    Settings: TTestSettings;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    { Miscellaneous tests }
    procedure Test_Sentimail_TimeField;
    procedure Test_SetCacheSize;
    procedure Test_DeleteRows;
    procedure Test_StringToHex;
    procedure Test_ResetCustomSettings;
    procedure Test_RebuildCompanyCache;
  end;

  TTestBtrvSQLBasicConnectivity = class(TTestCase)
  private
    Settings: TTestSettings;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    { Basic connectivity and access }
    procedure Test_GetBtrvVer;
    procedure Test_GetConnectionString;
    procedure Test_GetCommonConnectionString;
    procedure Test_GetErrorInformation;
    procedure Test_OpenCompany;
    procedure Test_OpenCompanyByCode;
    procedure Test_ValidSystem;
    procedure Test_ValidCompany;
    procedure Test_CompanyExists;
    procedure Test_TableExists;
    procedure Test_HasExclusiveAccess;
    procedure Test_GetDBColumnName;
    procedure Test_GetComputedColumnName;
    procedure Test_GetDBTableName;
    procedure Test_CreateTable;
    procedure Test_DeleteTable;
  end;

  TTestBtrvSQLNavigation = class(TTestCase)
  private
    Settings: TTestSettings;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    { Navigation }
    procedure Test_FindRec;
    procedure Test_FindStock;
    procedure Test_FindCompanyCode;
    procedure Test_OpenFile;
    procedure Test_StepFirst;
    procedure Test_Presrv_BTPos;
    procedure Test_DeleteRec;
    procedure Test_GetPosAfterDelete;
    procedure Test_MultiLock;
    procedure Test_EndOfFile;
    procedure Test_PutRec;
  end;

  TTestBtrvSQLDirect = class(TTestCase)
  private
    Settings: TTestSettings;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    { Direct SQL Access }
    procedure Test_ExecSQL;
    procedure Test_SQLFetch;
  end;

  TTestBtrvSQLStoredProcedures = class(TTestCase)
  private
    Settings: TTestSettings;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    { Stored Procedures }
    procedure Test_StockFreeze;
    procedure Test_CheckAllStock;
    procedure Test_TotalProfitToDateRange;
    procedure Test_FillBudget;
    procedure Test_StockAddCustAnal;
    procedure Test_UserCount;
    procedure Test_RemoveLastCommit;
  end;

  TTestBtrvSQLPrefillCache = class(TTestCase)
  private
    Settings: TTestSettings;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    { Prefill Cache }
    procedure Test_CustomPrefillCache;
    procedure Test_CustomPrefillCacheWithEXCHQCHK;
    procedure Test_CustomPrefillCacheWithJOBDET;
    procedure Test_CustomPrefillCacheWithGetPos;
  end;

  TTestBtrvSQLLockKeeper = class(TTestCase)
  private
    Settings: TTestSettings;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    { TLockKeeper tests }
    procedure Test_LockKeeper;
    procedure Test_LockType;
    procedure Test_AddLock;
    procedure Test_FindLock;
  end;

  TTestBtrvSQLVariantFiles = class(TTestCase)
  private
    Settings: TTestSettings;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    { Variant file handling }
    procedure Test_UseVariantForNextCall;
    procedure Test_Variant;
    procedure Test_IsVariant;
    procedure Test_AddVariant;
    procedure Test_VariantRecorded;
    procedure Test_RemoveVariant;
  end;

  TTestBtrvSQLRedirection = class(TTestCase)
  private
    Settings: TTestSettings;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    { Redirected tables }
    procedure Test_GetRedirector;
    procedure Test_ImportKeyBuffer;
    procedure Test_ExportKeyBuffer;
    procedure Test_WindowSettings;
  end;

  TTestBtrvSQLFieldNames = class(TTestCase)
  private
    Settings: TTestSettings;
  protected
    procedure SetUp; override;
    procedure TearDown; override;
  published
    { SQL Field Names (in SQLFields.pas) }
    procedure Test_HookSecurityFields;
    procedure Test_DetailsFields;
    procedure Test_VATRecFields;
    procedure Test_BACSDbRecFields;
  end;

implementation

uses SQLUtils, SQLFuncs, SQLCompany, SQLLockU, BtrvU2, Inifiles, FileCtrl,
  VarConst, CompanyU, TemporaryTablesU, GlobVar, SQLVariantsU, ClientIDU,
  SQLRedirectorU, BtKeys1U, SQLFields;

const
  OK     = True;
  FAILED = False;

{ TTestBtrvSQL }

procedure TTestBtrvSQL.SetUp;
begin
  inherited;
  SQLUtils.Load_DLL;
  Settings.MainCompany.Code := TEST_COMPANY_CODE;
  Settings.MainCompany.Path := TEST_COMPANY_PATH;
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQL.TearDown;
begin
  try
    SQLUtils.Unload_DLL;
  except
  end;
  inherited;
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQL.Test_RebuildCompanyCache;
var
  FuncRes: Integer;
begin
  FuncRes := SQLUtils.RebuildCompanyCache;
  Check(FuncRes = 0, 'RebuildCompanyCache failed');
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQL.Test_Sentimail_TimeField;
const
  FNum = 21;
var
  SystemPath: string;
  FuncRes: Integer;
  Buffer: array[1..1634] of Char;
  Key: string[255];
begin
  { Open the Sentimail file }
  SystemPath := ExtractFilePath(Application.ExeName);
  FuncRes    := Open_File(F[FNum], SystemPath + 'SENT.DAT', 0);

  FillChar(Buffer, SizeOf(Buffer), 0);
  try
    Check(FuncRes = 0, 'Open_File failed, error #' + IntToStr(FuncRes));

    { Search for the first record }
    Key := 'MANAGER                                 ';
    FileRecLen[FNum] := SizeOf(Buffer);
    FuncRes := Find_Rec(B_GetGEq, F[FNum], FNum, Buffer[1], 0, Key);
    Check(FuncRes = 0, 'Find_Rec failed');

  finally
    Close_File(F[FNum]);
  end;
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQL.Test_SetCacheSize;
const
  FNum = 15;
var
  SystemPath: string;
  FuncRes: Integer;
  CacheSize, OldCacheSize: LongInt;
  PosBlock: FileVar;
begin
  FillChar(PosBlock,Sizeof(PosBlock),0);
  { Open the ExchqSS file }
  SystemPath := ExtractFilePath(Application.ExeName);
  FuncRes    := Open_File(PosBlock, SystemPath + 'EXCHQSS.DAT', 0);
  Check(FuncRes = 0, 'Failed to open EXCHQSS, error #' + IntToStr(FuncRes));
  try
    OldCacheSize := 0;
    CacheSize := 10;
    FuncRes := SetCacheSize(PosBlock, CacheSize, OldCacheSize);
    Check(FuncRes = 0, 'SetCacheSize failed');
  finally
    Close_File(PosBlock);
  end;
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQL.Test_DeleteRows;
var
  FuncRes: Integer;
  WhereClause: string;
  BinaryCode: string;
  CodeField: string;
  CompanyCode: string;
begin
  WhereClause := 'RecMFix=''%s'' and SubType=''%s'' and SUBSTRING(%s, 2, 10) = %s';
  { Get the correct column name, based on the fixed fieldname in the XML Schema }
  CodeField := SQLUtils.GetDBColumnName('EXSTKCHK.DAT', 'exstchk_var2', '');
  { Convert the user name to the binary equivalent }
  BinaryCode := StringToHex('MANAGER', 10);
  { Insert the values into the Where clause }
  WhereClause := Format(WhereClause, ['U', 'C', CodeField, BinaryCode]);
  { Get the current Company Code }
  CompanyCode := SQLUtils.GetCompanyCode(Settings.MainCompany.Path);
  { Delete the records }
  FuncRes := SQLUtils.DeleteRows(CompanyCode, 'EXSTKCHK.DAT', WhereClause);

  Check(FuncRes = 0, 'DeleteRows failed');

end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQL.Test_StringToHex;
var
  TestStr: string;
begin
  TestStr := StringToHex('MANAGER', 10);
  Check(TestStr = '0x4D414E41474552202020',
        'Expected "0x4D414E41474552202020" ' +
        'but returned "' + TestStr + '"');
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQL.Test_ResetCustomSettings;
var
  FuncRes: Integer;
begin
  FuncRes := SQLFuncs.ResetCustomSettings(Settings.MainCompany.Path, 'MANAGER');
  Check(FuncRes = 0, 'ResetCustomSettings failed');
end;

// -----------------------------------------------------------------------------

{ TTestBtrvSQLBasicConnectivity }

procedure TTestBtrvSQLBasicConnectivity.SetUp;
begin
  inherited;
  SQLUtils.Load_DLL;
  Settings.MainCompany.Code := TEST_COMPANY_CODE;
  Settings.MainCompany.Path := TEST_COMPANY_PATH;
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLBasicConnectivity.TearDown;
begin
  try
    SQLUtils.Unload_DLL;
  except
  end;
  inherited;
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLBasicConnectivity.Test_CompanyExists;
var
  Code: string;
begin
  Code := Settings.MainCompany.Code;
  Check(SQLUtils.CompanyExists(Code) = 0, 'failed');
  Code := 'XXXXXX';
  Check(not (SQLUtils.CompanyExists(Code) = 0), 'Found non-existant company');
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLBasicConnectivity.Test_CreateTable;
var
  Fnum: Integer;
  FuncRes: Integer;
  SystemPath: string;
  Key: Str255;
begin
  SystemPath := ExtractFilePath(Application.ExeName);

  Fnum := ReportF;

  FileNames[Fnum] := 'SWAP\REP1.DAT';

  FuncRes := Make_File(F[Fnum], SystemPath + FileNames[Fnum], FileSpecOfs[Fnum]^, FileSpecLen[Fnum]);
  Check(FuncRes = 0, 'Make_File failed');
  Check(TableExists(SystemPath + FileNames[Fnum]), 'Failed to find new table');

  FuncRes := Open_File(F[FNum], SystemPath + FileNames[Fnum], 0);
  Check(FuncRes = 0, 'Failed to open new file: error #' + IntToStr(FuncRes));

  FuncRes := Add_Rec(F[FNum], FNum, RepFile, 0);
  Check(FuncRes = 0, 'Failed to add record: error #' + IntToStr(FuncRes));

  FuncRes := Find_Rec(B_GetFirst, F[FNum], FNum, RepFile, 0, Key);
  Check(FuncRes = 0, 'Failed to find record: error #' + IntToStr(FuncRes));
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLBasicConnectivity.Test_DeleteTable;
var
  Fnum: Integer;
  FuncRes: Integer;
  SystemPath: string;
  Key: Str255;
begin
  SystemPath := ExtractFilePath(Application.ExeName);

  Fnum := ReportF;

  FileNames[Fnum] := 'REP1.DAT';

  FuncRes := Make_File(F[Fnum], FileNames[Fnum], FileSpecOfs[Fnum]^, FileSpecLen[Fnum]);
  Check(TableExists(FileNames[Fnum]), 'Failed to create new table');

  FuncRes := DeleteTable(FileNames[Fnum]);
  Check(FuncRes = 0, 'DeleteTable failed');
  Check(not TableExists(FileNames[Fnum]), 'Failed to delete table');
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLBasicConnectivity.Test_GetBtrvVer;
var
  Ver     :  Integer;
  Rev     :  Integer;
  Typ     :  Char;
  DumBlock:  FileVar;
begin
  FillChar(DumBlock,Sizeof(DumBlock),0);
  if GetBtrvVer(DumBlock,Ver,Rev,Typ,1) then
    Check((Ver = 9) and (Rev = 5),
          'Wrong Btrieve version returned. Expected 9.5, got ' +
          IntToStr(Ver) + '.' + IntToStr(Rev))
  else
    Check(FAILED, 'Failed');
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLBasicConnectivity.Test_GetCommonConnectionString;
var
  FuncRes: Integer;
  Str: AnsiString;
begin
  FuncRes := GetCommonConnectionString(Str, nil);
  Check(FuncRes = 0, 'GetCommonConnectionString failed');
  Str := Trim(Str);
  Check(Str <> '', 'No connection string returned');
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLBasicConnectivity.Test_GetErrorInformation;
const
  FNum = 1;
var
  FuncRes: Integer;
  ErrorMsg: string;
  SystemPath: string;
begin
  SystemPath := ExtractFilePath(Application.ExeName);
  FuncRes := Open_File(F[FNum], SystemPath + 'CUST\CUSTSUPPWRONG.DAT', 0);
  Check(FuncRes <> 0, 'Opened non-existent CUSTSUPPWRONG.DAT');
  ErrorMsg := SQLUtils.GetSQLErrorInformation(FuncRes);
  Check(ErrorMsg <> '', 'No error message returned');
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLBasicConnectivity.Test_GetComputedColumnName;
var
  DBField: string;
begin
  DBField := SQLUtils.GetComputedColumnName('DETAILS.DAT', 'f_stock_code', '');
  Check(DBField = 'tlStockCodeComputed', 'expected tlStockCodeComputed, got ' + DBField);
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLBasicConnectivity.Test_GetConnectionString;
var
  FuncRes: Integer;
  Str: AnsiString;
begin
  FuncRes := GetConnectionString(Settings.MainCompany.Code, False, Str, nil);
  Check(FuncRes = 0, 'GetConnectionString failed');
  Str := Trim(Str);
  Check(Str <> '', 'No connection string returned');
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLBasicConnectivity.Test_GetDBColumnName;
var
  DBField: string;
begin
  DBField := SQLUtils.GetDBColumnName('DOCUMENT.DAT', 'f_run_no', '');
  Check(DBField = 'thRunNo', 'expected thRunNo, got ' + DBField);
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLBasicConnectivity.Test_GetDBTableName;
var
  TableName: string;
begin
  TableName := SQLUtils.GetDBTableName(Settings.MainCompany.Path + '\DOCUMENT.DAT');
  Check(TableName = '[ZZZZ01].[DOCUMENT]', 'expected [ZZZZ01].[DOCUMENT], got ' + TableName);
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLBasicConnectivity.Test_HasExclusiveAccess;
begin
  Check(SQLUtils.ExclusiveAccess(Settings.MainCompany.Path), 'failed');
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLBasicConnectivity.Test_OpenCompany;
const
  FNum = 15;  // EXCHQSS
var
  SystemPath: string;
  Path: string;
  FuncRes: Integer;
  Buffer: array[1..1787] of Char;
  Key: string[255];
begin
  Path := Settings.MainCompany.Path;
  FuncRes := OpenCompany(Path, nil);
  Check(FuncRes = 0, 'OpenCompany failed');

  SystemPath := ExtractFilePath(Application.ExeName);
  FuncRes    := Open_File(F[FNum], SystemPath + 'EXCHQSS.DAT', 0);
  Check(FuncRes = 0, 'Failed to open ' + SystemPath + 'EXCHQSS.DAT in ' + Settings.MainCompany.Code + ', error #' + IntToStr(FuncRes));

  Key := 'SYS';
  FileRecLen[FNum] := SizeOf(Buffer);
  FuncRes := Find_Rec(B_GetEq, F[FNum], FNum, Buffer[1], 0, Key);
  Check(FuncRes = 0, 'Failed to find SYS record in ' + SystemPath + 'EXCHQSS.DAT, error #' + IntToStr(FuncRes));

  Close_File(F[FNum]);

  Path := Settings.SecondCompany.Path;
  FuncRes := OpenCompany(Path, nil);
  Check(FuncRes = 0, 'Failed to open company for path ' + Path + ', error #' + IntToStr(FuncRes));

  SystemPath := ExtractFilePath(Application.ExeName);
  FuncRes    := Open_File(F[FNum], SystemPath + 'EXCHQSS.DAT', 0);
  Check(FuncRes = 0, 'Failed to open ' + SystemPath + 'EXCHQSS.DAT in ' + Settings.SecondCompany.Code + ', error #' + IntToStr(FuncRes));

end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLBasicConnectivity.Test_OpenCompanyByCode;
var
  Code: string;
  FuncRes: Integer;
begin
  Code := Settings.MainCompany.Code;
  FuncRes := OpenCompanyByCode(Code);
  Check(FuncRes = 0, 'OpenCompanyByCode failed');
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLBasicConnectivity.Test_TableExists;
var
  SystemPath: string;
  FuncRes: Boolean;
begin
  SystemPath := ExtractFilePath(Application.ExeName);
  FuncRes := TableExists(SystemPath + 'Dictnary.dat');
  Check(FuncRes, 'failed for DICTNARY.DAT');
  if (FuncRes) then
  begin
    FuncRes := TableExists(SystemPath + 'CUST\CUSTSUPP.DAT');
    Check(FuncRes, 'failed for CUST\CUSTSUPP.DAT');
  end;
  if (FuncRes) then
  begin
    FuncRes := TableExists(SystemPath + 'COMPANY.DAT');
    Check(FuncRes, 'failed for COMPANY.DAT');
  end;
  if (FuncRes) then
  begin
    FuncRes := TableExists(SystemPath + 'MC\COMPANY.DAT');
    Check(not FuncRes, 'COMPANY.DAT reported for sub-company');
  end;
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLBasicConnectivity.Test_ValidCompany;
var
  Path: string;
begin
  Path := Settings.MainCompany.Path;
  Check(SQLUtils.ValidCompany(Path), 'failed');
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLBasicConnectivity.Test_ValidSystem;
var
  Path: string;
begin
  Path := Settings.MainCompany.Path;
  Check(SQLUtils.ValidSystem(Path), 'failed');
end;

// -----------------------------------------------------------------------------

{ TTestBtrvSQLNavigation }

procedure TTestBtrvSQLNavigation.SetUp;
begin
  inherited;
  SQLUtils.Load_DLL;
  Settings.MainCompany.Code := TEST_COMPANY_CODE;
  Settings.MainCompany.Path := TEST_COMPANY_PATH;
end;

procedure TTestBtrvSQLNavigation.TearDown;
begin
  try
    SQLUtils.Unload_DLL;
  except
  end;
  inherited;
end;

procedure TTestBtrvSQLNavigation.Test_FindRec;
const
  FNum = 21;  // COMPANY
var
  SystemPath: string;
  FuncRes: Integer;
  Buffer: array[1..1536] of Char;
  Key: string[255];
begin
  SystemPath := ExtractFilePath(Application.ExeName);
  FuncRes    := Open_File(F[FNum], SystemPath + 'COMPANY.DAT', 0);

  FillChar(Buffer, SizeOf(Buffer), 0);
  try
    Check(FuncRes = 0, 'Open_File failed, error #' + IntToStr(FuncRes));

    Key := 'CZZZZ01';
    FileRecLen[FNum] := SizeOf(Buffer);
    FuncRes := Find_Rec(B_GetEq, F[FNum], FNum, Buffer[1], 0, Key);
    Check(FuncRes = 0, 'FindRec failed');
  finally
    Close_File(F[FNum]);
  end;
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLNavigation.Test_FindStock;
const
  FNum = 5;  // STOCK
var
  SystemPath: string;
  FuncRes: Integer;
  Buffer: array[1..1841] of Char;
  Key: string[255];
begin
  SystemPath := ExtractFilePath(Application.ExeName);
  FuncRes    := Open_File(F[FNum], SystemPath + 'STOCK\STOCK.DAT', 0);

  FillChar(Buffer, SizeOf(Buffer), 0);
  try
    Check(FuncRes = 0, 'Open_File failed, error #' + IntToStr(FuncRes));

    Key := 'BAT-1.5AAA-ALK  ';
    FileRecLen[FNum] := SizeOf(Buffer);
    FuncRes := Find_Rec(B_GetGEq, F[FNum], FNum, Buffer[1], 0, Key);
    Check(FuncRes = 0, 'Find_Rec failed');
    Check(Key = 'BAT-1.5AAA-ALK  ', 'Expected "BAT-1.5AAA-ALK  ", found "' + Key + '"');
  finally
    Close_File(F[FNum]);
  end;
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLNavigation.Test_FindCompanyCode;
var
  Code: string;
begin
  Code := FindCompanyCode(Settings.MainCompany.Path);
  Check(Code <> '', 'failed');
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLNavigation.Test_OpenFile;
const
  FNum = 1; // CUST
var
  SystemPath: string;
  FuncRes: Integer;
begin
  SystemPath := ExtractFilePath(Application.ExeName);
  try
    FuncRes := Open_File(F[FNum], SystemPath + 'CUST\CUSTSUPP.DAT', 0);
    Check(FuncRes = 0, 'Open_File failed');
  finally
    Close_File(F[FNum]);
  end;
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLNavigation.Test_StepFirst;
const
  FNum = 21;  // COMPANY
var
  SystemPath: string;
  FuncRes: Integer;
  Buffer: array[1..1536] of Char;
  Key: string[255];
begin
  SystemPath := ExtractFilePath(Application.ExeName);
  FuncRes    := Open_File(F[FNum], SystemPath + 'COMPANY.DAT', 0);

  FillChar(Buffer, SizeOf(Buffer), 0);
  try
    Check(FuncRes = 0, 'Open_File failed, error #' + IntToStr(FuncRes));

    Key := '';
    FileRecLen[FNum] := SizeOf(Buffer);
    FuncRes := Find_Rec(B_StepFirst, F[FNum], FNum, Buffer[1], 0, Key);
    Check(FuncRes = 0, 'Find_Rec failed');
  finally
    Close_File(F[FNum]);
  end;
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLNavigation.Test_Presrv_BTPos;
const
  FNum = 21;  // COMPANY
var
  Key       : string[255];
  FuncRes   : Smallint;
  FKeyPath  : Integer;
  TmpRecAddr: LongInt;
  Buffer: array[1..1536] of Char;
  SystemPath: string;
begin
  SystemPath := ExtractFilePath(Application.ExeName);
  FuncRes := Open_File(F[FNum], SystemPath + 'COMPANY.DAT', 0);
  Check(FuncRes = 0, 'Could not open file, error #' + IntToStr(FuncRes));
  try
    { Go to the first record (so we have a valid record position) }
    Key := '';
    FileRecLen[FNum] := SizeOf(Buffer);
    FuncRes := Find_Rec(B_GetFirst, F[FNum], FNum, Buffer[1], 0, Key);
    Check(FuncRes = 0, 'Could not get first record, error #' + IntToStr(FuncRes));

    { Save the record position }
    FKeyPath := GetPosKey;
    FuncRes := Presrv_BTPos(FNum, FKeyPath, F[FNum], TmpRecAddr, False, False);
    Check(FuncRes = 0, 'failed, error #' + IntToStr(FuncRes));

    { Locate the first physical record in the file }
    FuncRes := Find_Rec(B_StepFirst, F[FNum], FNum, Buffer[1], 0, Key);
    Check(FuncRes = 0, 'Find_Rec(B_StepFirst) failed, error #' + IntToStr(FuncRes));

    { Restore the record position }
    RecPtr[FNum] := @Buffer;
    FuncRes := Presrv_BTPos(FNum, FKeyPath, F[FNum], TmpRecAddr, True, True);
    Check(FuncRes = 0, 'Failed to restore record position, error #' + IntToStr(FuncRes));

    { Re-read the record at the restored position }
    Move(TmpRecAddr, Buffer[1], Sizeof(TmpRecAddr));
    FuncRes := GetDirect(F[FNum], FNum, Buffer[1], FKeyPath, 0);
    Check(FuncRes = 0, 'GetDirect failed, error #' + IntToStr(FuncRes));
  finally
    Close_File(F[FNum]);
  end;
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLNavigation.Test_DeleteRec;
const
  FNum = 3; // DETAILS
var
  FuncRes: Integer;
  Buffer: array[1..1536] of Char;
  Key: string[255];
  SystemPath: string;
  RecAddr: LongInt;
  KeyPath: Integer;
  Code: Integer;
begin
  SystemPath := ExtractFilePath(Application.ExeName);

  FuncRes := Open_File(F[FNum], SystemPath + 'DETAILS.DAT', 0);
  Check(FuncRes = 0, 'Could not open file, error #' + IntToStr(FuncRes));

  try
    { Find the record for deletion }
    Code := 4110;
    Move(Code, Key[1], Sizeof(Code));

    FileRecLen[FNum] := SizeOf(Buffer);
    FuncRes := Find_Rec(B_GetEq, F[FNum], FNum, Buffer[1], 0, Key);
    Check(FuncRes = 0, 'Failed to find record: ' + IntToStr(FuncRes));

    { Establish the record position }
    KeyPath := GetPosKey;
    FuncRes := Presrv_BTPos(FNum, KeyPath, F[FNum], RecAddr, False, False);
    Check(FuncRes = 0, 'failed, error #' + IntToStr(FuncRes));

    { Re-read and lock the record at the current position }
    Move(RecAddr, Buffer[1], Sizeof(RecAddr));
    FuncRes := GetDirect(F[Fnum], Fnum, Buffer[1], 0, B_MultLock);
    Check(FuncRes = 0, 'Failed to lock record: ' + IntToStr(FuncRes));

    { Delete the record }
    FuncRes := Delete_Rec(F[Fnum], Fnum, 0);
    Check(FuncRes = 0, 'Delete_Rec failed');

    { Attempt to find the record again, to make sure it has actually been
      deleted }
    FuncRes := Find_Rec(B_GetGEq, F[FNum], FNum, Buffer[1], 0, Key);
    Check(FuncRes = 4, 'Record still exists');

  finally
    Close_File(F[FNum]);
  end;
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLNavigation.Test_GetPosAfterDelete;
type
  TFormSettingsRec = record
    fsRecType : char;
    fsLookup : String[120];
    fsDummyChar : char;
    fssTop : LongInt;
    fssLeft : LongInt;
    fssHeight : LongInt;
    fssWidth : LongInt;
    fssSaveCoordinates : boolean;
  end;
var
  Buffer: TFormSettingsRec;
  SystemPath: string;
  FuncRes: Integer;
  Key: Str255;
  KeyPath: Integer;
  RecAddr: Integer;
const
  FNum = 21;
begin
  FileRecLen[FNum] := SizeOf(Buffer);

  SystemPath := ExtractFilePath(Application.ExeName);
  try
    // Open the Settings file
    FuncRes := Open_File(F[FNum], SystemPath + 'SETTINGS.DAT', 0);
    Check(FuncRes = 0, 'Failed to open SETTINGS, error #' + IntToStr(FuncRes));

    // Add a couple of dummy records
    Buffer.fsRecType := Char(70);
    Buffer.fsLookUp  := 'Emulator - Test 1';
    FuncRes := Add_Rec(F[FNum], FNum, Buffer, 0);
    Check(FuncRes = 0, 'Failed to save record 1, error #' + IntToStr(FuncRes));

    Buffer.fsRecType := Char(70);
    Buffer.fsLookUp  := 'Emulator - Test 2';
    FuncRes := Add_Rec(F[FNum], FNum, Buffer, 0);
    Check(FuncRes = 0, 'Failed to save record 1, error #' + IntToStr(FuncRes));

    // Delete all the records
    SQLUtils.DeleteRows(Settings.MainCompany.Code, 'SETTINGS.DAT', '1=1');
    FuncRes := Used_Recs(F[FNum], FNum);
    Check(FuncRes = 0, 'Not all records were deleted');

    // Try to get the record address
    KeyPath := GetPosKey;
    FuncRes := Presrv_BTPos(FNum, KeyPath, F[FNum], RecAddr, False, False);
    Check(RecAddr = 0, 'Presrv_BTPos: Record Position for empty dataset reported as ' + IntToStr(RecAddr));

  finally
    Close_File(F[FNum]);
  end;
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLNavigation.Test_MultiLock;
const
  FNum = 3; // DETAILS
var
  FuncRes: Integer;
  Buffer: array[1..1536] of Char;
  Key: string[255];
  SystemPath: string;
begin
  SystemPath := ExtractFilePath(Application.ExeName);

  FuncRes := Open_File(F[FNum], SystemPath + 'TRANS\DETAILS.DAT', 0);
  Check(FuncRes = 0, 'Could not open file ' + SystemPath + 'TRANS\DETAILS.DAT, error #' + IntToStr(FuncRes));

  try
    { Find the record and lock it. }
    Key := '';

    FileRecLen[FNum] := SizeOf(Buffer);
    FuncRes := Find_Rec(B_GetFirst + B_MultLock, F[FNum], FNum, Buffer[1], 0, Key);
    Check(FuncRes = 0, 'Failed to find and lock record: ' + IntToStr(FuncRes));

  finally
    Close_File(F[FNum]);
  end;
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLNavigation.Test_EndOfFile;
const
  FNum = 21;  // COMPANY
var
  SystemPath: string;
  FuncRes: Integer;
  Buffer: array[1..1536] of Char;
  LastKey, Key: string[255];
begin
  SystemPath := ExtractFilePath(Application.ExeName);
  FuncRes    := Open_File(F[FNum], SystemPath + 'COMPANY.DAT', 0);

  FillChar(Buffer, SizeOf(Buffer), 0);
  try
    Check(FuncRes = 0, 'Open_File failed, error #' + IntToStr(FuncRes));

    Key := '';
    FileRecLen[FNum] := SizeOf(Buffer);
    FuncRes := Find_Rec(B_GetFirst, F[FNum], FNum, Buffer[1], 0, Key);
    while (FuncRes <> 9) do
    begin
      LastKey := Key;
      FuncRes := Find_Rec(B_GetNext, F[FNum], FNum, Buffer[1], 0, Key);
      Check(not ((FuncRes = 0) and (LastKey = Key)), 'Failed to move to next record on GetNext');
    end;
    Check(FuncRes = 9, 'Find_Rec reached end of file');
  finally
    Close_File(F[FNum]);
  end;
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLNavigation.Test_PutRec;
const
  FNum = 15;
//  NewSecurityCode = 'W3GDQSTQ37';
  NewSecurityCode = 'XYZABCDE12';
var
  SystemPath: string;
  FuncRes: Integer;
  Buffer: array[1..1634] of Char;
  Key: string[255];
begin
  { Open the ExchqSS file }
  SystemPath := ExtractFilePath(Application.ExeName);
  FuncRes    := Open_File(F[FNum], SystemPath + 'EXCHQSS.DAT', 0);

  FillChar(Buffer, SizeOf(Buffer), 0);
  try
    Check(FuncRes = 0, 'Open_File failed, error #' + IntToStr(FuncRes));

    { Search for the system record }
    Key := 'SYS';
    FileRecLen[FNum] := SizeOf(Buffer);
    FuncRes := Find_Rec(B_GetGEq, F[FNum], FNum, Syss, 0, Key);
    Check(FuncRes = 0, 'Find_Rec failed');

    SQLUtils.OpenCompanyByCode('ZZZZ02');

    FuncRes := Open_File(F[FNum], SystemPath + 'EXCHQSS.DAT', 0);
    Check(FuncRes = 0, 'Open_File in different company failed, error #' + IntToStr(FuncRes));

    Key := 'SYS';
    FileRecLen[FNum] := SizeOf(Buffer);
    FuncRes := Find_Rec(B_GetGEq, F[FNum], FNum, Syss, 0, Key);
    Check(FuncRes = 0, 'Find_Rec failed');

    Syss.ExSecurity := NewSecurityCode;
    FuncRes := Put_Rec(F[FNum], FNum, Syss, 0);
    Check(FuncRes = 0, 'Put_Rec failed');

    Key := 'SYS';
    FileRecLen[FNum] := SizeOf(Buffer);
    FuncRes := Find_Rec(B_GetGEq, F[FNum], FNum, Syss, 0, Key);
    Check(Syss.ExSecurity = NewSecurityCode, 'Failed to update ExSecurity to "' + NewSecurityCode + '"');

  finally
    Close_File(F[FNum]);
  end;
end;

// -----------------------------------------------------------------------------

{ TTestBtrvSQLDirect }

procedure TTestBtrvSQLDirect.SetUp;
begin
  inherited;
  SQLUtils.Load_DLL;
  Settings.MainCompany.Code := TEST_COMPANY_CODE;
  Settings.MainCompany.Path := TEST_COMPANY_PATH;
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLDirect.TearDown;
begin
  try
    SQLUtils.Unload_DLL;
  except
  end;
  inherited;
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLDirect.Test_ExecSQL;
var
  Qry: string;
  Count: Integer;
begin
  SetDrive := ExtractFilePath(Application.ExeName);
  Qry := 'UPDATE ' + Settings.MainCompany.Code + '.CUSTSUPP ' +
         'SET acZIPAttachments = 0';
  Count := ExecSQL(Qry, SetDrive);
//  Check(Count > -1, 'SQL UPDATE Query failed ' + SQLFuncs.SQLCaller.ErrorMsg);
  Check(Count > -1, 'SQL UPDATE Query failed.');
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLDirect.Test_SQLFetch;
var
  Qry: string;
  Count: Variant;
  Balance: Variant;
  FuncRes: Integer;
begin
  SetDrive := ExtractFilePath(Application.ExeName);
  Qry := 'SELECT TOP 10 COUNT(acCode) AS countcust FROM ' + Settings.MainCompany.Code + '.CUSTSUPP';
  FuncRes := SQLFetch(Qry, 'countcust', SetDrive, Count);
  Check(FuncRes = 0, LastSQLError);
  Check(Count <> 0, 'No count returned');
  Qry := 'SELECT SUM(acBalance) AS balance FROM [COMPANY].CUSTSUPP';
  FuncRes := SQLFetch(Qry, 'balance', SetDrive, Balance);
  Check(FuncRes = 0, LastSQLError);
  Check(Balance <> 0, 'No balance returned');
end;

// -----------------------------------------------------------------------------

{ TTestBtrvSQLStoredProcedures }

procedure TTestBtrvSQLStoredProcedures.SetUp;
begin
  inherited;
  SQLUtils.Load_DLL;
  Settings.MainCompany.Code := TEST_COMPANY_CODE;
  Settings.MainCompany.Path := TEST_COMPANY_PATH;
end;

procedure TTestBtrvSQLStoredProcedures.TearDown;
begin
  try
    SQLUtils.Unload_DLL;
  except
  end;
  inherited;
end;

procedure TTestBtrvSQLStoredProcedures.Test_StockFreeze;
var
  FuncRes: Integer;
begin
  SetDrive := ExtractFilePath(Application.ExeName);
  FuncRes := SQLUtils.StockFreeze(SetDrive, 'AAA', True, 107, 11);
  Check(FuncRes >= 0, 'StockFreeze failed');
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLStoredProcedures.Test_UserCount;
begin
  SetDrive := ExtractFilePath(Application.ExeName);
//  Check(SQLFuncs.LoggedInUsers > 0, 'Failed to find any logged-in users');
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLStoredProcedures.Test_RemoveLastCommit;
var
  FuncRes: Integer;
begin
  SetDrive := ExtractFilePath(Application.ExeName);
  FuncRes := SQLUtils.RemoveLastCommit(SetDrive);
  Check(FuncRes >= 0, 'Error #' + IntToStr(FuncRes) + ' ' + SQLUtils.LastSQLError);
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLStoredProcedures.Test_CheckAllStock;
var
  FuncRes: Integer;
begin
  SetDrive := ExtractFilePath(Application.ExeName);
  FuncRes := CheckAllStock(SetDrive, 'ALARMSYS-DOM-1  ', 'M', 313);
  Check(FuncRes >= 0, 'CheckAllStock failed');
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLStoredProcedures.Test_TotalProfitToDateRange;
var
  Purch, PSales, Balance, PCleared, PBudget, PRBudget, BValue1, BValue2: double;
  FuncRes: Integer;
begin
  SetDrive := ExtractFilePath(Application.ExeName);
  FuncRes := SQLUtils.TotalProfitToDateRange(SetDrive, 'U', 'AFEL01', 0, 106, 253, 0, true, false,
    Purch, PSales, Balance, PCleared, PBudget, PRBudget, BValue1, BValue2);
  Check(FuncRes = 0, 'TotalProfitToDateRange failed');
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLStoredProcedures.Test_StockAddCustAnal;
var
  FuncRes: Integer;
begin
//  CustCode, StockCode, PDate, FolioRef, AbsLineNo, Currency, IdDocHed, LineType, LineTotal, Mode
// EXEC @ReturnValue = [!ActiveSchema!].[isp_StockAddCustAnal] 'ABAP01','BAT-9PP3-ALK    ','20080711', -2147478510, 2, 1, 8, 'O', 3.83, 0
  SetDrive := ExtractFilePath(Application.ExeName);
  FuncRes := SQLUtils.StockAddCustAnal(SetDrive, 'ABAP01','BAT-9PP3-ALK    ','20080711', -2147478510, 2, 1, 8, 'O', 3.83, 0);
  Check(FuncRes >= 0, 'StockAddCustAnal failed');
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLStoredProcedures.Test_FillBudget;
var
  FuncRes: Integer;
  NType: Integer;
  Code: string;
  Currency: Integer;
  Year: Integer;
  Period: Integer;
  PeriodInYear: Integer;
  CalcPurgeOB: Boolean;
  Range: Boolean;
  PPr2: Integer;
begin
  SetDrive := ExtractFilePath(Application.ExeName);
  NType := 56;
  Code := Char(56) + Char(1) + Char(1) + Char(4) + Char(0) + Char(0) + Char(0) + Char(48) + Char(48) + Char(49) + Char(52) + Char(32) + Char(32) + Char(32) + Char(32) + Char(32) + Char(32) + Char(32) + Char(32) + Char(32) + Char(32); // + Char(0);// + Char(105) + Char(1);
//  Code := '0x380101040000003030313420202020202020202020'; //SQLFuncs.StringToHex(Code);
  Currency := 0;
  Year := 103;
  Period := 1;
  PeriodInYear := 12;
  CalcPurgeOB := False;
  Range := True;
  PPr2 := 0;
  FuncRes := SQLUtils.FillBudget(SetDrive, NType, Code, Currency, Year, Period,
                                 PeriodInYear, CalcPurgeOB, Range, PPr2);
  Check(FuncRes = 0, 'Error #' + IntToStr(FuncRes) + ' : ' + SQLUtils.LastSQLError);
end;

// -----------------------------------------------------------------------------

{ TTestBtrvSQLPrefillCache }

procedure TTestBtrvSQLPrefillCache.SetUp;
begin
  inherited;
  SQLUtils.Load_DLL;
  Settings.MainCompany.Code := TEST_COMPANY_CODE;
  Settings.MainCompany.Path := TEST_COMPANY_PATH;
end;

procedure TTestBtrvSQLPrefillCache.TearDown;
begin
  try
    SQLUtils.Unload_DLL;
  except
  end;
  inherited;
end;

procedure TTestBtrvSQLPrefillCache.Test_CustomPrefillCache;
const
  FNum = 1; // CUST
  FNum2 = CompF; // COMPANY
var
  SystemPath: string;
  FuncRes, FindRes: Integer;
  ID: Integer;
  Buffer: array[1..2119] of Char;
  CompanyBuffer: CompRec;
  Key: string[255];
begin
  SystemPath := ExtractFilePath(Application.ExeName);

  FuncRes := Open_File(F[FNum], SystemPath + 'CUST\CUSTSUPP.DAT', 0);
  Check(FuncRes = 0, 'Failed to open CUSTSUPP, error #' + IntToStr(FuncRes));

  FuncRes := Open_File(F[FNum2], SystemPath + 'COMPANY.DAT', 0);
  Check(FuncRes = 0, 'Failed to open COMPANY, error #' + IntToStr(FuncRes));

  try
    FileRecLen[FNum2] := SizeOf(CompanyBuffer);
    FindRes := Find_Rec(B_GetFirst, F[FNum2], FNum2, CompanyBuffer, 0, Key);
    Check(FindRes = 0, 'Failed to find any Company records, error #' + IntToStr(FindRes));

    FuncRes := CreateCustomPrefillCache(SystemPath + 'CUST\CUSTSUPP.DAT', 'acCustSupp = ''C''', 'acCode, acCustSupp', ID);
    Check(FuncRes = 0, 'Failed to create cache, error #' + IntToStr(FuncRes));
    Check(ID > 0, 'Failed to assign cache ID');

    FuncRes := UseCustomPrefillCache(ID);
    Check(FuncRes = 0,  'Failed to use cache, error #' + IntToStr(FuncRes));

    FileRecLen[FNum] := SizeOf(Buffer);
    FindRes := Find_Rec(B_GetFirst, F[FNum], FNum, Buffer[1], 0, Key);
    Check(FindRes = 0, 'Failed to find any records, error #' + IntToStr(FuncRes));
    Check(Buffer[1] <> #0, 'Failed to fill record structure');

    while (FuncRes = 0) and (FindRes = 0) do
    begin
      FuncRes := UseCustomPrefillCache(ID);
      Check(FuncRes = 0,  'Failed to use cache, error #' + IntToStr(FuncRes));
      FindRes := Find_Rec(B_GetNext, F[FNum], FNum, Buffer[1], 0, Key);
    end;

    FuncRes := DropCustomPrefillCache(ID);
    Check(FuncRes = 0, 'Failed to drop cache, error #' + IntToStr(FuncRes));

    FindRes := Find_Rec(B_GetFirst, F[FNum2], FNum2, CompanyBuffer, 0, Key);
    Check(FindRes = 0, 'Failed to find any Company records after closing Cache, error #' + IntToStr(FindRes));

  finally
    Close_File(F[FNum2]);
    Close_File(F[FNum]);
  end;
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLPrefillCache.Test_CustomPrefillCacheWithEXCHQCHK;
const
  FNum = 8; // EXCHQCHK
var
  SystemPath: string;
  FuncRes, FindRes: Integer;
  ID: Integer;
  Buffer: array[1..283] of Char;
  Key: string[255];
begin
  SystemPath := ExtractFilePath(Application.ExeName);

  FuncRes := Open_File(F[FNum], SystemPath + 'MISC\EXCHQCHK.DAT', 0);
  Check(FuncRes = 0, 'Failed to open EXCHQCHK, error #' + IntToStr(FuncRes));

  try
    FuncRes := CreateCustomPrefillCache(SystemPath + 'MISC\EXCHQCHK.DAT', 'RecPFix = ''C'' AND SubType = 67', '', ID);
    Check(FuncRes = 0, 'Failed to create cache, error #' + IntToStr(FuncRes));

    FuncRes := UseCustomPrefillCache(ID);
    Check(FuncRes = 0,  'Failed to use cache, error #' + IntToStr(FuncRes));

    FileRecLen[FNum] := SizeOf(Buffer);
    FindRes := Find_Rec(B_GetFirst, F[FNum], FNum, Buffer[1], 0, Key);
    Check(FindRes = 0, 'Failed to find any records, error #' + IntToStr(FindRes));

    while (FuncRes = 0) and (FindRes = 0) do
    begin
      FuncRes := UseCustomPrefillCache(ID);
      Check(FuncRes = 0,  'Failed to use cache, error #' + IntToStr(FuncRes));
      FindRes := Find_Rec(B_GetNext, F[FNum], FNum, Buffer[1], 0, Key);
    end;

    FuncRes := DropCustomPrefillCache(ID);
    Check(FuncRes = 0, 'Failed to drop cache, error #' + IntToStr(FuncRes));

  finally
    Close_File(F[FNum]);
  end;
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLPrefillCache.Test_CustomPrefillCacheWithJOBDET;
const
  FNum = 12; // JOBDET
var
  SystemPath: string;
  FuncRes, FindRes, FirstCount, SecondCount: Integer;
  ID: Integer;
  Buffer: array[1..838] of Char;
  Key: string[255];
  RecordAddress: Integer;
begin
  SystemPath := ExtractFilePath(Application.ExeName);

  FuncRes := Open_File(F[FNum], SystemPath + 'MISC\JOBDET.DAT', 0);
  Check(FuncRes = 0, 'Failed to open JOBDET, error #' + IntToStr(FuncRes));

  try
    FuncRes := CreateCustomPrefillCache(SystemPath + 'MISC\JOBDET.DAT', '((RecPFix = ''J'' AND SubType = ''E'') AND (SUBSTRING(varcode1computed, 1, 10) = 0x42415448303120202020) AND (Invoiced = 0) AND (JAType <= 6 OR JAType > 10) AND JAType <= 13)', '', ID);
    Check(FuncRes = 0, 'Failed to create cache, error #' + IntToStr(FuncRes));

    FileRecLen[FNum] := SizeOf(Buffer);

    { First pass. Use Get Next to step through all the records in the cache,
      and count the number of records reached. }
    FirstCount := 0;

    FuncRes := UseCustomPrefillCache(ID);
    FindRes := Find_Rec(B_GetFirst, F[FNum], FNum, Buffer[1], 0, Key);
    Check(FindRes = 0, 'Failed to find any records, error #' + IntToStr(FuncRes));

    while (FuncRes = 0) and (FindRes = 0) do
    begin
      FirstCount := FirstCount + 1;
      FuncRes := UseCustomPrefillCache(ID);
      FindRes := Find_Rec(B_GetNext, F[FNum], FNum, Buffer[1], 0, Key);
    end;

    { Second pass. Use Get Next to step through all the records in the cache,
      but precede each move with Get Pos and Get Direct, which should have no
      effect on the record position. Count the number of records reached. }
    SecondCount := 0;

    FuncRes := UseCustomPrefillCache(ID);
    FindRes := Find_Rec(B_GetFirst, F[FNum], FNum, Buffer[1], 0, Key);
    Check(FindRes = 0, 'Failed to find any records, error #' + IntToStr(FindRes));

    while (FuncRes = 0) and (FindRes = 0) do
    begin
      SecondCount := SecondCount + 1;

      FuncRes := UseCustomPrefillCache(ID);
      FuncRes := GetPos(F[FNum], FNum, RecordAddress);

      Check(FuncRes = 0, 'GetPos failed, error #' + IntToStr(FuncRes));
      Check(RecordAddress <> 0, 'GetPos returned record address of 0');

      FuncRes := UseCustomPrefillCache(ID);
      Move(RecordAddress, Buffer[1], 4);
      FuncRes := GetDirect(F[FNum], FNum, Buffer[1], 0, 0);

      FuncRes := UseCustomPrefillCache(ID);
      FindRes := Find_Rec(B_GetNext, F[FNum], FNum, Buffer[1], 0, Key);
    end;

    Check(FirstCount = SecondCount, 'Without GetPos & GetDirect, found ' + IntToStr(FirstCount) + ' records, with GetPos & GetDirect found ' + IntToStr(SecondCount) + ' records');

    FuncRes := DropCustomPrefillCache(ID);
    Check(FuncRes = 0, 'Failed to drop cache, error #' + IntToStr(FuncRes));

  finally
    Close_File(F[FNum]);
  end;
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLPrefillCache.Test_CustomPrefillCacheWithGetPos;
const
  FNum = 1; // CUST
var
  SystemPath: string;
  FuncRes, FindRes: Integer;
  ID: Integer;
  Buffer: array[1..2119] of Char;
  Key: string[255];
  RecAddr: Integer;
begin
  SystemPath := ExtractFilePath(Application.ExeName);

  FuncRes := Open_File(F[FNum], SystemPath + 'CUST\CUSTSUPP.DAT', 0);
  Check(FuncRes = 0, 'Failed to open CUSTSUPP, error #' + IntToStr(FuncRes));

  try
    FuncRes := CreateCustomPrefillCache(SystemPath + 'CUST\CUSTSUPP.DAT', 'acCustSupp = ''C''', 'acCode, acCustSupp', ID);
    Check(FuncRes = 0, 'Failed to create cache, error #' + IntToStr(FuncRes));
    Check(ID > 0, 'Failed to assign cache ID');

    FuncRes := UseCustomPrefillCache(ID);
    Check(FuncRes = 0,  'Failed to use cache, error #' + IntToStr(FuncRes));

    FileRecLen[FNum] := SizeOf(Buffer);
    FindRes := Find_Rec(B_GetFirst, F[FNum], FNum, Buffer[1], 0, Key);
    Check(FindRes = 0, 'Failed to find any records, error #' + IntToStr(FindRes));
    Check(Buffer[1] <> #0, 'Failed to fill record structure');

    FuncRes := UseCustomPrefillCache(ID);
    FuncRes := GetPos(F[FNum], FNum, RecAddr);
    Check(FuncRes = 0, 'GetPos failed, error #' + IntToStr(FuncRes));
    Check(RecAddr <> 0, 'GetPos returned record address of 0');

    while (FuncRes = 0) and (FindRes = 0) do
    begin
      FuncRes := UseCustomPrefillCache(ID);
      Check(FuncRes = 0,  'Failed to use cache, error #' + IntToStr(FuncRes));
      FindRes := Find_Rec(B_GetNext, F[FNum], FNum, Buffer[1], 0, Key);
    end;

    FuncRes := DropCustomPrefillCache(ID);
    Check(FuncRes = 0, 'Failed to drop cache, error #' + IntToStr(FuncRes));

  finally
    Close_File(F[FNum]);
  end;
end;

// -----------------------------------------------------------------------------

{ TTestBtrvSQLLockKeeper }

procedure TTestBtrvSQLLockKeeper.SetUp;
begin
  inherited;
  SQLUtils.Load_DLL;
  Settings.MainCompany.Code := TEST_COMPANY_CODE;
  Settings.MainCompany.Path := TEST_COMPANY_PATH;
end;

procedure TTestBtrvSQLLockKeeper.TearDown;
begin
  try
    SQLUtils.Unload_DLL;
  except
  end;
  inherited;
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLLockKeeper.Test_LockKeeper;
begin
  Check(LockKeeper <> nil, 'Failed to create/access LockKeeper');
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLLockKeeper.Test_LockType;
var
  Operation: LongInt;
begin
  Operation := 105;
  Check(LockKeeper.LockType(Operation) = ltSingleWait,
        'Failed to identify Single Wait lock on Get Equal');
  Operation := 234;
  Check(LockKeeper.LockType(Operation) = ltSingleNoWait,
        'Failed to identify Single No Wait lock on Step Last');
  Operation := 434;
  Check(LockKeeper.LockType(Operation) = ltMultiNoWait,
        'Failed to identify Multiple No Wait lock on Step Last');
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLLockKeeper.Test_AddLock;
var
  Lock: TLock;
begin
// function TLockKeeper.AddLock(LockType: TLockType; PosBlock: Integer; RecordAddress: Integer; ThreadID: string): TLock;
  Lock := LockKeeper.AddLock(ltSingleNoWait, 1234, 1, '9999');
  Check(Lock <> nil, 'Failed to create/return lock record');
  Check(Lock.ThreadID = '9999', 'Lock has wrong thread id');
  Check(Lock.PosBlock = 1234, 'Lock has wrong position block');
  Check(Lock.LockType = ltSingleNoWait, 'Lock has wrong type');
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLLockKeeper.Test_FindLock;
var
  Lock: TLock;
begin
// function TLockKeeper.AddLock(LockType: TLockType; PosBlock: Integer; RecordAddress: Integer; ThreadID: string): TLock;
  LockKeeper.AddLock(ltSingleNoWait, 1234, 1, '0001');
  LockKeeper.AddLock(ltSingleNoWait, 1235, 1, '0002');
  LockKeeper.AddLock(ltSingleNoWait, 1234, 2, '0003');
  Lock := LockKeeper.FindLock(1234, 1, '0001');
  Check(Lock <> nil, 'Failed to find lock');
  Check(Lock.ThreadID = '0001', 'Found wrong lock');
  Lock := LockKeeper.FindLock(1236, 1, '0001');
  Check(Lock = nil, 'Found non-existent lock');
end;

// -----------------------------------------------------------------------------

{ TTestBtrvSQLVariantFiles }

procedure TTestBtrvSQLVariantFiles.SetUp;
begin
  inherited;
  SQLUtils.Load_DLL;
  Settings.MainCompany.Code := TEST_COMPANY_CODE;
  Settings.MainCompany.Path := TEST_COMPANY_PATH;
end;

procedure TTestBtrvSQLVariantFiles.TearDown;
begin
  try
    SQLUtils.Unload_DLL;
  except
  end;
  inherited;
end;

procedure TTestBtrvSQLVariantFiles.Test_UseVariantForNextCall;
const
  FNum = 14; // MLocF
var
  FuncRes: Integer;
  SystemPath, ErrorMsg: string;
  Key: string[255];
  Buffer: array[1..1302] of Char;
begin
  SystemPath := ExtractFilePath(Application.ExeName);
  FuncRes := Open_File(F[FNum], SystemPath + 'STOCK\MLOCSTK.DAT', 0);
  Check(FuncRes = 0, 'Failed to open MLOCSTK, error #' + IntToStr(FuncRes));

  try
    FuncRes := SQLUtils.UseVariantForNextCall(F[FNum]);
    if (FuncRes <> 0) then
    begin
      ErrorMsg := SQLUtils.GetSQLErrorInformation(FuncRes);
      Check(False, ErrorMsg);
    end;

    Key := 'CC';
    FuncRes := Find_Rec(B_GetGEq, F[FNum], FNum, Buffer[1], 0, Key);

    if (FuncRes <> 0) then
    begin
      ErrorMsg := SQLUtils.GetSQLErrorInformation(FuncRes);
      Check(False, ErrorMsg);
    end;

    while (FuncRes = 0) and
          (Buffer[1] = 'C') and
          (Buffer[2] = 'C') do
    begin
      SQLUtils.UseVariantForNextCall(F[FNum]);
      FuncRes := Find_Rec(B_GetNext, F[FNum], FNum, Buffer[1], 0, Key);
    end;

  finally
    Close_File(F[FNum]);
  end;

end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLVariantFiles.Test_Variant;
begin
  Check(SQLVariants <> nil, 'SQLVariant global singleton not created');
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLVariantFiles.Test_IsVariant;
begin
  Check(SQLVariants.IsVariant('EXCHQCHK.DAT'), '"EXCHQCHK.DAT" not reported as variant');
  Check(not SQLVariants.IsVariant('DETAILS.DAT'), '"DETAILS.DAT" reported as variant');
  Check(SQLVariants.IsVariant('JOBS\JOBCTRL.DAT'), '"JOBS\JOBCTRL.DAT" not reported as variant');
  Check(SQLVariants.IsVariant('JOBS\JobCtrl.DAT'), '"JOBS\JobCtrl.DAT" not reported as variant');
  Check(SQLVariants.IsVariant('JOBS\JOBCTRL.DAT  '), '"JOBS\JOBCTRL.DAT  " not reported as variant');
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLVariantFiles.Test_AddVariant;
var
  FileName: string;
  FakePosBlock: Integer;
  FakeClientID: TClientID;
begin
  SQLVariants.Clear;
  FileName := 'EXCHQCHK.DAT';
  FakePosBlock := 123456789;
  FakeClientID.AppID := 'TT';
  FakeClientID.TaskID := 1;
  SQLVariants.AddFile(FileName, FakePosBlock, @FakeClientID);
  Check(SQLVariants.Count > 0, 'Variant file not added');
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLVariantFiles.Test_VariantRecorded;
var
  FileName: string;
  FakePosBlock: Integer;
  FakeClientID: TClientID;
begin
  SQLVariants.Clear;
  FileName := 'EXCHQCHK.DAT';
  FakePosBlock := 123456789;
  FakeClientID.AppID := 'TT';
  FakeClientID.TaskID := 1;
  SQLVariants.AddFile(FileName, FakePosBlock, @FakeClientID);
  FakePosBlock := 123456799;
  SQLVariants.AddFile(FileName, FakePosBlock, @FakeClientID);

  FakePosBlock := 123456789;
  Check(SQLVariants.AlreadyRecorded(FakePosBlock), 'Variant entry not found');

  FakePosBlock := 123456788;
  Check(not SQLVariants.AlreadyRecorded(FakePosBlock), 'Erroneous variant entry reported');
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLVariantFiles.Test_RemoveVariant;
var
  FileName: string;
  FakePosBlock: Integer;
  FakeClientID: TClientID;
begin
  SQLVariants.Clear;
  FileName := 'EXCHQCHK.DAT';
  FakePosBlock := 123456789;
  FakeClientID.AppID := 'TT';
  FakeClientID.TaskID := 1;
  SQLVariants.AddFile(FileName, FakePosBlock, @FakeClientID);
  FakePosBlock := 123456799;
  SQLVariants.AddFile(FileName, FakePosBlock, @FakeClientID);

  SQLVariants.RemoveEntry(FakePosBlock);
  Check(SQLVariants.Count < 2, 'Entry not removed');

  FakePosBlock := 123456788;
  SQLVariants.RemoveEntry(FakePosBlock);
  Check(SQLVariants.Count > 0, 'Entry erroneously removed');
end;

// -----------------------------------------------------------------------------

{ TTestBtrvSQLRedirection }

procedure TTestBtrvSQLRedirection.SetUp;
begin
  inherited;
  SQLUtils.Load_DLL;
  Settings.MainCompany.Code := TEST_COMPANY_CODE;
  Settings.MainCompany.Path := TEST_COMPANY_PATH;
end;

procedure TTestBtrvSQLRedirection.TearDown;
begin
  try
    SQLUtils.Unload_DLL;
  except
  end;
  inherited;
end;

procedure TTestBtrvSQLRedirection.Test_GetRedirector;
var
  Redirector: TTransactionNotesRedirector;
  DataBuffer: Str255;
  KeyBuffer: Str255;
  PosBlock: array[1..128] of char;
begin
  DataBuffer := 'EXCHQCHK.DAT';
  KeyBuffer := 'ND' + FullNomKey(100) + '  D' + FullNomKey(1);
  Redirector := RedirectorFactory.GetRedirector(0, PosBlock, DataBuffer, KeyBuffer[1]) as TTransactionNotesRedirector;
  Check(Redirector <> nil, 'Redirector not created');
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLRedirection.Test_ImportKeyBuffer;
var
  Redirector: TTransactionNotesRedirector;
  DataBuffer: Str255;
  KeyBuffer: Str255;
  PosBlock: array[1..128] of char;
begin
  DataBuffer := 'EXCHQCHK.DAT';
  KeyBuffer := 'ND' + FullNomKey(100) + '  D' + FullNomKey(1);
  Redirector := RedirectorFactory.GetRedirector(0, PosBlock, DataBuffer, KeyBuffer[1]) as TTransactionNotesRedirector;
  Check(Redirector <> nil, 'Redirector not created');
  Redirector.ImportKeyBuffer(KeyBuffer[1], 255);
  Check(Redirector.KeyRec.Folio = 100, 'Folio imported as ' + IntToStr(Redirector.KeyRec.Folio) + ' instead of 100');
  Check(Redirector.KeyRec.NType = 'D', 'NType imported as ' + Redirector.KeyRec.NType+ ' instead of "D"');
  Check(Redirector.KeyRec.LineNo = 1, 'LineNo imported as ' + IntToStr(Redirector.KeyRec.LineNo) + ' instead of 1');
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLRedirection.Test_ExportKeyBuffer;
var
  Redirector: TTransactionNotesRedirector;
  DataBuffer: Str255;
  KeyBuffer: Str255;
  PosBlock: array[1..128] of char;
  IntBuffer: string[4];
begin
  DataBuffer := 'EXCHQCHK.DAT';
  KeyBuffer := 'ND' + FullNomKey(100) + '  D' + FullNomKey(1);
  Redirector := RedirectorFactory.GetRedirector(0, PosBlock, DataBuffer, KeyBuffer[1]) as TTransactionNotesRedirector;
  Check(Redirector <> nil, 'Redirector not created');
  Redirector.DataRec.NoteFolio := 42;
  Redirector.DataRec.NType := 'X';
  Redirector.DataRec.LineNo := 9;
  Redirector.ExportKeyBuffer(KeyBuffer[1], 255);
  Check(Copy(KeyBuffer, 1, 2) = 'ND', 'Prefix/Subtype exported as ' + Copy(KeyBuffer, 1, 2) + ' instead of "ND"');
  IntBuffer := Copy(KeyBuffer, 3, 4);
  Check(UnfullNomKey(IntBuffer) = 42, 'Folio exported as ' + IntToStr(UnfullNomKey(IntBuffer)) + ' instead of 42');
  Check(Copy(KeyBuffer, 7, 1) = 'X', 'NType exported as ' + Copy(KeyBuffer, 7, 1) + ' instead of "X"');
  IntBuffer := Copy(KeyBuffer, 8, 4);
  Check(UnfullNomKey(IntBuffer) = 9, 'LineNo exported as ' + IntToStr(UnfullNomKey(IntBuffer)) + ' instead of 9');
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLRedirection.Test_WindowSettings;
const
  FNum = 9; // MiscF
var
  FuncRes: Integer;
  SystemPath, ErrorMsg: string;
  Key: string[255];
  Buffer: array[1..523] of Char;
begin
  SystemPath := ExtractFilePath(Application.ExeName);
  FuncRes := Open_File(F[FNum], SystemPath + 'MISC\EXSTKCHK.DAT', 0);
  Check(FuncRes = 0, 'Failed to open EXSTKCHK, error #' + IntToStr(FuncRes));

  Key := 'UCSBSPanel14MANAGER   ';
  FuncRes := Find_Rec(B_GetEq, F[FNum], FNum, Buffer[1], 0, Key);
  Check(FuncRes = 0, 'Failed to find "UCSBSPanel14MANAGER   "');

  Key := 'UCSSysFrmDet          ';
  FuncRes := Find_Rec(B_GetEq, F[FNum], FNum, Buffer[1], 0, Key);
  Check(FuncRes = 0, 'Failed to find "UCSSysFrmDet          "');

  Close_File(F[FNum]);
end;

// -----------------------------------------------------------------------------

{ TTestBtrvSQLFieldNames }

procedure TTestBtrvSQLFieldNames.SetUp;
begin
  inherited;
  SQLUtils.Load_DLL;
  Settings.MainCompany.Code := TEST_COMPANY_CODE;
  Settings.MainCompany.Path := TEST_COMPANY_PATH;
end;

procedure TTestBtrvSQLFieldNames.TearDown;
begin
  try
    SQLUtils.Unload_DLL;
  except
  end;
  inherited;
end;

procedure TTestBtrvSQLFieldNames.Test_HookSecurityFields;
var
  Fields: string;
begin
  Fields := GetAllHookSecurityRecTypeFields;
  Check(Pos('hkVersion', Fields) <> 0, '"hkVersion" not found in SQLFields');
  Check(Pos('hkEncryptedCode', Fields) <> 0, '"hkEncryptedCode" not found in SQLFields');
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLFieldNames.Test_DetailsFields;
var
  Fields: string;
begin
  Fields := GetAllDetailsFields;
  Check(Pos('tlDiscount2', Fields) <> 0, '"tlDiscount2" not found in SQLFields');
  Check(Pos('tlDiscount2Chr', Fields) <> 0, '"tlDiscount2Chr" not found in SQLFields');
  Check(Pos('tlDiscount3', Fields) <> 0, '"tlDiscount3" not found in SQLFields');
  Check(Pos('tlDiscount3Chr', Fields) <> 0, '"tlDiscount3Chr" not found in SQLFields');
  Check(Pos('tlDiscount3Type', Fields) <> 0, '"tlDiscount3Type" not found in SQLFields');
  Check(Pos('tlECService', Fields) <> 0, '"tlECService" not found in SQLFields');
  Check(Pos('tlServiceStartDate', Fields) <> 0, '"tlServiceStartDate" not found in SQLFields');
  Check(Pos('tlServiceEndDate', Fields) <> 0, '"tlServiceEndDate" not found in SQLFields');
  Check(Pos('tlECSalesTaxReported', Fields) <> 0, '"tlECSalesTaxReported" not found in SQLFields');
  Check(Pos('tlPurchaseServiceTax', Fields) <> 0, '"tlPurchaseServiceTax" not found in SQLFields');
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLFieldNames.Test_VATRecFields;
var
  Fields: string;
begin
  Fields := GetAllVATRecFields;
  Check(Pos('EnableECServices', Fields) <> 0, '"EnableECServices" not found in SQLFields');
  Check(Pos('ECSalesThreshold', Fields) <> 0, '"ECSalesThreshold" not found in SQLFields');
end;

// -----------------------------------------------------------------------------

procedure TTestBtrvSQLFieldNames.Test_BACSDbRecFields;
var
  Fields: string;
begin
  Fields := GetAllBACSDbRecFields;
  Check(Pos('BrSortCodeEx', Fields) <> 0, '"BrSortCodeEx" not found in SQLFields');
  Check(Pos('BrAccountCodeEx', Fields) <> 0, '"BrAccountCodeEx" not found in SQLFields');
end;

// -----------------------------------------------------------------------------

initialization

  RegisterTest('Basic connectivity', TTestBtrvSQLBasicConnectivity.Suite);
  RegisterTest('Navigation', TTestBtrvSQLNavigation.Suite);
  RegisterTest('Direct SQL access', TTestBtrvSQLDirect.Suite);
  RegisterTest('Stored Procedures', TTestBtrvSQLStoredProcedures.Suite);
  RegisterTest('Prefill Cache', TTestBtrvSQLPrefillCache.Suite);
  RegisterTest('Lockkeeper', TTestBtrvSQLLockKeeper.Suite);
  RegisterTest('Variant files', TTestBtrvSQLVariantFiles.Suite);
  RegisterTest('Redirection', TTestBtrvSQLRedirection.Suite);
  RegisterTest('SQL Field Names', TTestBtrvSQLFieldNames.Suite);
  RegisterTest('Miscellaneous tests', TTestBtrvSQL.Suite);

finalization

end.
