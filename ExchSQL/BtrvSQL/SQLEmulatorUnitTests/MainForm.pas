unit MainForm;
{
  SQL Emulator unit tests
}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, CheckLst, ComCtrls, Buttons;

type
  TTestStatus = (tsNotRun, tsFailed, tsOk);

  TTestProcedure = procedure of object;

  TTestInfo = class(TObject)
  private
    FTitle: string;
    FTestProc: TTestProcedure;
    FStatus: TTestStatus;
    procedure SetStatus(const Value: TTestStatus);
    procedure SetTestProc(const Value: TTestProcedure);
    procedure SetTitle(const Value: string);
  public
    property TestProc: TTestProcedure read FTestProc write SetTestProc;
    property Title: string read FTitle write SetTitle;
    property Status: TTestStatus read FStatus write SetStatus;
  end;

  TMainFrm = class(TForm)
    CompanyCodeTxt: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    ServerTxt: TEdit;
    Label3: TLabel;
    TestDatabaseTxt: TEdit;
    Label4: TLabel;
    TestCompanyNameTxt: TEdit;
    TestCompanyPathTxt: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    SourceZIPFileNameTxt: TEdit;
    RunBtn: TButton;
    CloseBtn: TButton;
    TestList: TCheckListBox;
    RunningAnim: TAnimate;
    RunningLbl: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    TestCompany1CodeTxt: TEdit;
    Shape1: TShape;
    Label12: TLabel;
    CompanyPathTxt: TEdit;
    Label13: TLabel;
    ImportExportZIPFileNameTxt: TEdit;
    Bevel1: TBevel;
    Label14: TLabel;
    Label15: TLabel;
    DatabaseTxt: TEdit;
    SelectPathBtn: TSpeedButton;
    SelectTestPath: TSpeedButton;
    SelectDataZipBtn: TSpeedButton;
    SelectImportExportFileBtn: TSpeedButton;
    OpenDialog: TOpenDialog;
    TestCompany2CodeTxt: TEdit;
    Panel1: TPanel;
    Label5: TLabel;
    SelectAllBtn: TButton;
    SelectNoneBtn: TButton;
    procedure RunBtnClick(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure TestListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SelectAllBtnClick(Sender: TObject);
    procedure SelectNoneBtnClick(Sender: TObject);
    procedure SelectPathBtnClick(Sender: TObject);
    procedure SelectTestPathClick(Sender: TObject);
    procedure SelectDataZipBtnClick(Sender: TObject);
    procedure SelectImportExportFileBtnClick(Sender: TObject);
  private
    { Unit test support routines }
    procedure AddTest(Test: TTestProcedure; Title: string);
    procedure AddAllTests;
    procedure ClearAllTests;
    procedure SelectAllTests;
    procedure UnselectAllTests;
    procedure SetUp;
    procedure TearDown;
    procedure Check(Expression: Boolean; FailMsg: string); overload;
    procedure Check(Expression: Boolean; FailCode: Integer); overload;
    procedure Report(Msg: string; Success: Boolean);
    procedure RunTest(Idx: Integer; Test: TTestProcedure; Title: string);
    procedure RunAllTests;
    procedure ReadSettings;
    procedure WriteSettings;
    { Unit test procedures }
    procedure Test_GetBtrvVer;
    procedure Test_GetConnectionString;
    procedure Test_GetCommonConnectionString;
    // procedure Test_CheckExchRnd; {Obsolete}
    procedure Test_OpenCompany;
    procedure Test_OpenCompanyByCode;
    procedure Test_ValidSystem;
    procedure Test_ValidCompany;
    procedure Test_CompanyExists;
    procedure Test_TableExists;
    procedure Test_FindRec;
    procedure Test_FindStock;
    procedure Test_FindCompanyCode;
    procedure Test_HasExclusiveAccess;
    procedure Test_GetDBColumnName;
    procedure Test_GetComputedColumnName;
    procedure Test_GetDBTableName;
    procedure Test_CreateTable;
    procedure Test_DeleteTable;
    { Navigation and Record-Handling }
    procedure Test_OpenFile;
    procedure Test_StepFirst;
    procedure Test_Presrv_BTPos;
    procedure Test_DeleteRec;
    procedure Test_GetPosAfterDelete;
    procedure Test_MultiLock;
    procedure Test_EndOfFile;
    procedure Test_ExecSQL;
    procedure Test_SQLFetch;
    procedure Test_PutRec;
    { Stored Procedures }
    procedure Test_StockFreeze;
    procedure Test_CheckAllStock;
    procedure Test_TotalProfitToDateRange;
    procedure Test_FillBudget;
    procedure Test_StockAddCustAnal;
    procedure Test_UserCount;
    procedure Test_RemoveLastCommit;
    { Creation routines }
    procedure Test_CreateDatabase;
    procedure Test_CreateCompany;
    procedure Test_DetachCompany;
    procedure Test_AttachCompany;
    procedure Test_DeleteCompany;
    procedure Test_RebuildCompanyCache;
    procedure Test_ExportDataset;
    procedure Test_CopyTable;
    procedure Test_ImportDataset;
    { Prefill Cache routines }
    procedure Test_CustomPrefillCache;
    procedure Test_CustomPrefillCacheWithEXCHQCHK;
    procedure Test_CustomPrefillCacheWithJOBDET;
    procedure Test_CustomPrefillCacheWithGetPos;
    procedure Test_GetErrorInformation;
    procedure Test_UseVariantForNextCall;
    { TLockKeeper tests }
    procedure Test_LockKeeper;
    procedure Test_LockType;
    procedure Test_AddLock;
    procedure Test_FindLock;
    { Memory test }
    procedure Test_SetMemCallback;
    { Variant file handling }
    procedure Test_Variant;
    procedure Test_IsVariant;
    procedure Test_AddVariant;
    procedure Test_VariantRecorded;
    procedure Test_RemoveVariant;
    { Redirected tables }
    procedure Test_GetRedirector;
    procedure Test_ImportKeyBuffer;
    procedure Test_ExportKeyBuffer;
    procedure Test_WindowSettings;
    { Miscellaneous other tests }
    procedure Test_Sentimail_TimeField;
    procedure Test_SetCacheSize;
    procedure Test_DeleteRows;
    procedure Test_StringToHex;
    procedure Test_ResetCustomSettings;
    { SQL Field Names (in SQLFields.pas) }
    procedure Test_HookSecurityFields;
    procedure Test_DetailsFields;
    procedure Test_VATRecFields;
    procedure Test_BACSDbRecFields;
  public
    { Public declarations }
  end;

var
  MainFrm: TMainFrm;

implementation

{$WARN UNIT_PLATFORM OFF}

uses SQLUtils, SQLFuncs, SQLCompany, SQLLockU, BtrvU2, Inifiles, FileCtrl,
  VarConst, CompanyU, TemporaryTablesU, GlobVar, SQLVariantsU, ClientIDU,
  SQLRedirectorU, BtKeys1U, SQLFields;

const
  OK     = True;
  FAILED = False;

{$R *.dfm}

procedure MemCallback(Msg: ShortString);
begin
  if (Msg = '') then
    raise Exception.Create('No message returned')
  else
    ShowMessage(Msg);
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.FormCreate(Sender: TObject);
begin
  AddAllTests;
  ReadSettings;
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.FormDestroy(Sender: TObject);
begin
  WriteSettings;
  ClearAllTests;
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.TestListDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
	Offset: Integer;
  Status: TTestStatus;
begin
	with (Control as TCheckListBox).Canvas do
	begin
    if ((Control as TCheckListBox).Items.Objects[Index] <> nil) and
       ((Control as TCheckListBox).Items.Objects[Index] is TTestInfo) then
      Status := ((Control as TCheckListBox).Items.Objects[Index] as TTestInfo).Status
    else
      Status := tsNotRun;

    if (Status = tsFailed) then
    begin
      Brush.Color := clRed;
      Font.Color  := clWhite;
    end
    else if (Status = tsOk) then
    begin
      Brush.Color := clWindow;
      Font.Color  := clGreen;
    end
    else
    begin
      Brush.Color := clWindow;
      Font.Color  := clWindowText;
    end;
    if (Pos('Testing', (Control as TCheckListBox).Items[Index]) <> 0) then
      Font.Style := [fsItalic]
    else
      Font.Style := [];
    FillRect(Rect);
    Offset := 2;
    TextOut(Rect.Left + Offset, Rect.Top + 1, (Control as TCheckListBox).Items[Index])  { display the text }
	end;
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.CloseBtnClick(Sender: TObject);
begin
  Close;
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.RunBtnClick(Sender: TObject);
begin
  RunAllTests;
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.SelectAllBtnClick(Sender: TObject);
begin
  SelectAllTests;
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.SelectNoneBtnClick(Sender: TObject);
begin
  UnselectAllTests;
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.SelectPathBtnClick(Sender: TObject);
var
  Dir: string;
begin
  if DirectoryExists(CompanyPathTxt.Text) then
    Dir := CompanyPathTxt.Text
  else
    Dir := '';
  if SelectDirectory(Dir, [], 0) then
    CompanyPathTxt.Text := IncludeTrailingPathDelimiter(Dir);
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.SelectTestPathClick(Sender: TObject);
var
  Dir: string;
begin
  if DirectoryExists(TestCompanyPathTxt.Text) then
    Dir := TestCompanyPathTxt.Text
  else
    Dir := '';
  if SelectDirectory(Dir, [], 0) then
    TestCompanyPathTxt.Text := IncludeTrailingPathDelimiter(Dir);
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.SelectDataZipBtnClick(Sender: TObject);
begin
  OpenDialog.Filter := 'ZIP files|*.zip|All files|*.*';
  OpenDialog.FileName := SourceZIPFileNameTxt.Text;
  if OpenDialog.Execute then
    SourceZIPFileNameTxt.Text := OpenDialog.FileName;
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.SelectImportExportFileBtnClick(Sender: TObject);
begin
  OpenDialog.Filter := 'ZIP files|*.zip|All files|*.*';
  OpenDialog.FileName := ImportExportZIPFileNameTxt.Text;
  if OpenDialog.Execute then
    ImportExportZIPFileNameTxt.Text := OpenDialog.FileName;
end;

// -----------------------------------------------------------------------------

// =============================================================================
// Unit test support routines
// =============================================================================
procedure TMainFrm.AddTest(Test: TTestProcedure; Title: string);
var
  TestInfo: TTestInfo;
begin
  TestInfo := TTestInfo.Create;
  TestInfo.TestProc := Test;
  TestInfo.Title    := Title;
  TestInfo.Status   := tsNotRun;
  TestList.Items.AddObject(Title, TestInfo);
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.AddAllTests;
begin
  AddTest(Test_GetPosAfterDelete,   'Get Position after Delete');
  AddTest(Test_GetBtrvVer,          'GetBtrvVer');
  AddTest(Test_GetConnectionString, 'GetConnectionString');
  AddTest(Test_GetCommonConnectionString, 'GetCommonConnectionString');
  AddTest(Test_GetErrorInformation, 'GetErrorInformation');
  // AddTest(Test_CheckExchRnd,        'CheckExchRnd'); {Obsolete}
  AddTest(Test_OpenCompany,         'OpenCompany');
  AddTest(Test_OpenCompanyByCode,   'OpenCompanyByCode');
  AddTest(Test_ValidSystem,         'ValidSystem');
  AddTest(Test_ValidCompany,        'ValidCompany');
  AddTest(Test_TableExists,         'TableExists');
  AddTest(Test_FindRec,             'Find_Rec');
  AddTest(Test_FindStock,           'Find Stock');
  AddTest(Test_MultiLock,           'Find_Rec with Multi-Lock');
  AddTest(Test_FindCompanyCode,     'FindCompanyCode');
  AddTest(Test_CompanyExists,       'CompanyExists');
  AddTest(Test_HasExclusiveAccess,  'HasExclusiveAccess');
  AddTest(Test_GetDBColumnName,     'GetDBColumnName');
  AddTest(Test_GetComputedColumnName, 'GetComputedColumnName');
  AddTest(Test_GetDBTableName,      'GetDBTableName');
  AddTest(Test_CreateTable,         'CreateTable');
  AddTest(Test_DeleteTable,         'DeleteTable');
  AddTest(Test_OpenFile,            'Open_File');
  AddTest(Test_StepFirst,           'Find_Rec(B_StepFirst)');
  AddTest(Test_Presrv_BTPos,        'Presrv_BTPos');
  AddTest(Test_EndOfFile,           'GetNext / End of File');
  AddTest(Test_ExecSQL,             'ExecSQL');
  AddTest(Test_SQLFetch,            'SQLFetch');
  AddTest(Test_UserCount,           'User Count (requires Exchequer to be running)');
  AddTest(Test_StockFreeze,         'StockFreeze');
  AddTest(Test_CheckAllStock,       'CheckAllStock');
  AddTest(Test_StockAddCustAnal,    'StockAddCustAnal');
  AddTest(Test_TotalProfitToDateRange, 'Total Profit To Date Range');
  AddTest(Test_FillBudget,          'FillBudget');
  AddTest(Test_RemoveLastCommit,    'RemoveLastCommit');
  AddTest(Test_SetCacheSize,        'SetCacheSize');
  AddTest(Test_StringToHex,         'StringToHex');
  AddTest(Test_CustomPrefillCache,  'CustomPrefillCache');
  AddTest(Test_CustomPrefillCacheWithEXCHQCHK, 'CustomPrefillCache(EXCHQCHK.DAT)');
  AddTest(Test_CustomPrefillCacheWithJOBDET, 'CustomPrefillCache(JOBDET.DAT)');
  AddTest(Test_CustomPrefillCacheWithGetPos, 'CustomPrefillCache with GetPos');
  AddTest(Test_UseVariantForNextCall, 'UseVariantForNextCall');
  AddTest(Test_CreateDatabase,      'CreateDatabase');
  AddTest(Test_CreateCompany,       'CreateCompany');
  AddTest(Test_DetachCompany,       'DetachCompany');
  AddTest(Test_AttachCompany,       'AttachCompany');
  AddTest(Test_RebuildCompanyCache, 'RebuildCompanyCache');
  AddTest(Test_ExportDataset,       'ExportDataset');
  AddTest(Test_ImportDataset,       'ImportDataset');
  AddTest(Test_CopyTable,           'CopyTable');
  AddTest(Test_DeleteRec,           'Delete_Rec');
  AddTest(Test_DeleteCompany,       'DeleteCompany');
  AddTest(Test_Sentimail_TimeField, 'Sentimail Time field');
  AddTest(Test_PutRec,              'Put_Rec');
  AddTest(Test_DeleteRows,          'DeleteRows');
  AddTest(Test_ResetCustomSettings, 'ResetCustomSettings');
  AddTest(Test_LockKeeper,          'Verify LockKeeper');
  AddTest(Test_LockType,            'LockType');
  AddTest(Test_AddLock,             'AddLock');
  AddTest(Test_FindLock,            'FindLock');
  AddTest(Test_SetMemCallback,      'SetMemCallback');
  AddTest(Test_Variant,             'SQLVariants');
  AddTest(Test_IsVariant,           'SQLVariants.IsVariant');
  AddTest(Test_AddVariant,          'SQLVariants.AddFile');
  AddTest(Test_VariantRecorded,     'SQLVariants.AlreadyRecorded(PosBlock)');
  AddTest(Test_RemoveVariant,       'SQLVariants.RemoveEntry');
  AddTest(Test_GetRedirector,       'GetRedirector');
  AddTest(Test_ImportKeyBuffer,     'ImportKeyBuffer');
  AddTest(Test_ExportKeyBuffer,     'ExportKeyBuffer');
  AddTest(Test_WindowSettings,      'Find WindowSettings');
  AddTest(Test_HookSecurityFields,  'Fields: HookSecurityRecType');
  AddTest(Test_DetailsFields,       'Fields: Details');
  AddTest(Test_VATRecFields,        'Fields: VATRec');
  AddTest(Test_BACSDbRecFields,     'Fields: BACSDbRecFields');
  SelectAllTests;
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.ClearAllTests;
var
  i: Integer;
begin
  for i := 0 to TestList.Items.Count - 1 do
  begin
    if (TestList.Items.Objects[i] <> nil) then
    begin
      TestList.Items.Objects[i].Free;
      TestList.Items.Objects[i] := nil;
    end;
  end;
  TestList.Clear;
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.SelectAllTests;
var
  i: Integer;
begin
  for i := 0 to TestList.Items.Count - 1 do
    TestList.Checked[i] := True;
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.UnselectAllTests;
var
  i: Integer;
begin
  for i := 0 to TestList.Items.Count - 1 do
    TestList.Checked[i] := False;
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Check(Expression: Boolean; FailMsg: string);
begin
  if not Expression then
    raise Exception.Create(FailMsg)
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Check(Expression: Boolean; FailCode: Integer);
var
  FailMsg: string;
begin
  if (FailCode = 10) then
    FailMsg := GetSQLErrorInformation(FailCode)
  else
    FailMsg := 'failed';
  Check(Expression, FailMsg + ', error #' + IntToStr(FailCode));
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Report(Msg: string; Success: Boolean);
var
  Idx: Integer;
  Line: string;
begin
  { Assume that the test being run is the selected one in the list. }
  Idx := TestList.ItemIndex;
  Line := TestList.Items[Idx];
  Line := Line + ' - ' + Msg;
  Line := StringReplace(Line, 'Testing ', '', [rfReplaceAll]);
  if (TestList.Items.Objects[Idx] <> nil) and
     (TestList.Items.Objects[Idx] is TTestInfo) then
  begin
    if Success then
      (TestList.Items.Objects[Idx] as TTestInfo).Status := tsOk
    else
      (TestList.Items.Objects[Idx] as TTestInfo).Status := tsFailed;
  end;
  TestList.Items[Idx] := Line;
  Application.ProcessMessages;
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.RunAllTests;
var
  i: Integer;
  TestProc: TTestProcedure;
  Title: string;
begin
  RunBtn.Enabled := False;
  try
    RunningLbl.Visible  := True;
    RunningAnim.Visible := True;
    RunningAnim.Active  := True;
    Application.ProcessMessages;
    for i := 0 to TestList.Items.Count - 1 do
    begin
      if (TestList.Checked[i]) and
         (TestList.Items.Objects[i] <> nil) and
         (TestList.Items.Objects[i] is TTestInfo) then
      begin
        TestProc := (TestList.Items.Objects[i] as TTestInfo).TestProc;
        Title    := (TestList.Items.Objects[i] as TTestInfo).Title;
        RunTest(i, TestProc, Title);
      end;
    end;
  finally
    RunningLbl.Visible := False;
    RunningAnim.Visible := False;
    RunningAnim.Active := False;
    RunBtn.Enabled := True;
  end;
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.RunTest(Idx: Integer; Test: TTestProcedure; Title: string);
begin
  try
    TestList.Items[Idx] := 'Testing ' + Title;
    TestList.ItemIndex  := Idx;
    try
      SetUp;
      Test;
      TestList.Items[Idx] := Title;
      Report('Ok', OK);
    finally
      TearDown;
    end;
  except
    on E:Exception do
      Report(E.Message, FAILED);
  end;
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.SetUp;
begin
  SQLUtils.Load_DLL;
//  OverrideUsingSQL(True);
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.TearDown;
begin
  SQLUtils.Unload_DLL;
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.ReadSettings;
var
  Inifile: TInifile;
  i: Integer;
begin
  Inifile := TInifile.Create('SQLEmulatorTest.Ini');
  try
    ServerTxt.Text      := Inifile.ReadString('EXISTING DATABASE', 'Server', 'CSDEV\IRISSQL');
    DatabaseTxt.Text    := Inifile.ReadString('EXISTING DATABASE', 'Database', 'EXCHEQUER');
    CompanyCodeTxt.Text := Inifile.ReadString('EXISTING DATABASE', 'Company Code', 'ZZZZ01');
    CompanyPathTxt.Text := Inifile.ReadString('EXISTING DATABASE', 'Company Path', 'C:\EXCHEQR\');

    TestDatabaseTxt.Text    := Inifile.ReadString('TEST DATABASE', 'Database', 'TESTDATABASE');
    TestCompany1CodeTxt.Text := Inifile.ReadString('TEST DATABASE', 'Test Company 1 Code', 'ZZZZ01');
    TestCompany2CodeTxt.Text := Inifile.ReadString('TEST DATABASE', 'Test Company 2 Code', 'ZZZZ02');
    TestCompanyNameTxt.Text := Inifile.ReadString('TEST DATABASE', 'Test Company Name', 'Test Company');
    TestCompanyPathTxt.Text := Inifile.ReadString('TEST DATABASE', 'Test Company Path', 'C:\EXCHEQR\');

    SourceZIPFileNameTxt.Text       := Inifile.ReadString('ZIP FILES', 'Source ZIP File', 'C:\EXCHDATA\BaseMC.zip');
    ImportExportZIPFileNameTxt.Text := Inifile.ReadString('ZIP FILES', 'Import Export ZIP File', 'C:\TEMP\TestData.zip');

    for i := 0 to TestList.Items.Count - 1 do
      TestList.Checked[i] := Inifile.ReadBool('TESTS', TestList.Items[i], False);

  finally
    Inifile.Free;
  end;
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.WriteSettings;
var
  Inifile: TInifile;
  i: Integer;
  Info: TTestInfo;
begin
  Inifile := TInifile.Create('SQLEmulatorTest.Ini');
  try
    Inifile.WriteString('EXISTING DATABASE', 'Server', ServerTxt.Text);
    Inifile.WriteString('EXISTING DATABASE', 'Database', DatabaseTxt.Text);
    Inifile.WriteString('EXISTING DATABASE', 'Company Code', CompanyCodeTxt.Text);
    Inifile.WriteString('EXISTING DATABASE', 'Company Path', CompanyPathTxt.Text);

    Inifile.WriteString('TEST DATABASE', 'Database', TestDatabaseTxt.Text);
    Inifile.WriteString('TEST DATABASE', 'Test Company 1 Code', TestCompany1CodeTxt.Text);
    Inifile.WriteString('TEST DATABASE', 'Test Company 2 Code', TestCompany2CodeTxt.Text);
    Inifile.WriteString('TEST DATABASE', 'Test Company Name', TestCompanyNameTxt.Text);
    Inifile.WriteString('TEST DATABASE', 'Test Company Path', TestCompanyPathTxt.Text);

    Inifile.WriteString('ZIP FILES', 'Source ZIP File', SourceZIPFileNameTxt.Text);
    Inifile.WriteString('ZIP FILES', 'Import Export ZIP File', ImportExportZIPFileNameTxt.Text);

    Inifile.EraseSection('TESTS');
    for i := 0 to TestList.Items.Count - 1 do
    begin
      if (TestList.Items.Objects[i] <> nil) and
         (TestList.Items.Objects[i] is TTestInfo) then
      begin
        Info := TestList.Items.Objects[i] as TTestInfo;
        Inifile.WriteBool('TESTS', Info.Title, TestList.Checked[i]);
      end;
    end;

  finally
    Inifile.Free;
  end;
end;

// -----------------------------------------------------------------------------

// =============================================================================
// Unit Test procedures
// =============================================================================

procedure TMainFrm.Test_GetBtrvVer;
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

procedure TMainFrm.Test_GetConnectionString;
var
  FuncRes: Integer;
  Str: AnsiString;
begin
  FuncRes := GetConnectionString(CompanyCodeTxt.Text, False, Str, nil);
  Check(FuncRes = 0, FuncRes);
  Str := Trim(Str);
  Check(Str <> '', 'No connection string returned');
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_GetCommonConnectionString;
var
  FuncRes: Integer;
  Str: AnsiString;
begin
  FuncRes := GetCommonConnectionString(Str, nil);
  Check(FuncRes = 0, FuncRes);
  Str := Trim(Str);
  Check(Str <> '', 'No connection string returned');
end;

// -----------------------------------------------------------------------------

{ Obsolete }
(*
procedure TMainFrm.Test_CheckExchRnd;
var
  FuncRes: Integer;
begin
  FuncRes := CheckExchRnd;
  Check(FuncRes = 0, FuncRes);
end;
*)

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_OpenCompany;
const
  FNum = 15;  // EXCHQSS
var
  SystemPath: string;
  Path: string;
  FuncRes: Integer;
  Buffer: array[1..1787] of Char;
  Key: string[255];
begin
  Path := CompanyPathTxt.Text;
  FuncRes := OpenCompany(Path, nil);
  Check(FuncRes = 0, FuncRes);

  SystemPath := ExtractFilePath(Application.ExeName);
  FuncRes    := Open_File(F[FNum], SystemPath + 'EXCHQSS.DAT', 0);
  Check(FuncRes = 0, 'Failed to open ' + SystemPath + 'EXCHQSS.DAT in ' + CompanyCodeTxt.Text + ', error #' + IntToStr(FuncRes));

  Key := 'SYS';
  FileRecLen[FNum] := SizeOf(Buffer);
  FuncRes := Find_Rec(B_GetEq, F[FNum], FNum, Buffer[1], 0, Key);
  Check(FuncRes = 0, 'Failed to find SYS record in ' + SystemPath + 'EXCHQSS.DAT, error #' + IntToStr(FuncRes));

  Close_File(F[FNum]);

  Path := TestCompanyPathTxt.Text;
  FuncRes := OpenCompany(Path, nil);
  Check(FuncRes = 0, 'Failed to open company for path ' + Path + ', error #' + IntToStr(FuncRes));

  SystemPath := ExtractFilePath(Application.ExeName);
  FuncRes    := Open_File(F[FNum], SystemPath + 'EXCHQSS.DAT', 0);
  Check(FuncRes = 0, 'Failed to open ' + SystemPath + 'EXCHQSS.DAT in ' + TestCompany2CodeTxt.Text + ', error #' + IntToStr(FuncRes));

end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_OpenCompanyByCode;
var
  Code: string;
  FuncRes: Integer;
begin
  Code := CompanyCodeTxt.Text;
  FuncRes := OpenCompanyByCode(Code);
  Check(FuncRes = 0, FuncRes);
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_ValidSystem;
var
  Path: string;
begin
  Path := CompanyPathTxt.Text;
  Check(SQLUtils.ValidSystem(Path), 'failed');
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_ValidCompany;
var
  Path: string;
begin
  Path := CompanyPathTxt.Text;
  Check(SQLUtils.ValidCompany(Path), 'failed');
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_CompanyExists;
var
  Code: string;
begin
  Code := CompanyCodeTxt.Text;
  Check(SQLUtils.CompanyExists(Code) = 0, 'failed');
  Code := 'XXXXXX';
  Check(not (SQLUtils.CompanyExists(Code) = 0), 'Found non-existant company');
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_TableExists;
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

procedure TMainFrm.Test_FindRec;
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
    Check(FuncRes = 0, FuncRes);
  finally
    Close_File(F[FNum]);
  end;
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_FindStock;
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
    Check(FuncRes = 0, FuncRes);
    Check(Key = 'BAT-1.5AAA-ALK  ', 'Expected "BAT-1.5AAA-ALK  ", found "' + Key + '"');
  finally
    Close_File(F[FNum]);
  end;
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_FindCompanyCode;
var
  Code: string;
begin
  Code := FindCompanyCode(CompanyPathTxt.Text);
  Check(Code <> '', 'failed');
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_HasExclusiveAccess;
begin
  Check(SQLUtils.ExclusiveAccess(CompanyPathTxt.Text), 'failed');
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_GetDBColumnName;
var
  DBField: string;
begin
  DBField := SQLUtils.GetDBColumnName('DOCUMENT.DAT', 'f_run_no', '');
  Check(DBField = 'thRunNo', 'expected thRunNo, got ' + DBField);
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_GetComputedColumnName;
var
  DBField: string;
begin
  DBField := SQLUtils.GetComputedColumnName('DETAILS.DAT', 'f_stock_code', '');
  Check(DBField = 'tlStockCodeComputed', 'expected tlStockCodeComputed, got ' + DBField);
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_GetDBTableName;
var
  TableName: string;
begin
  TableName := SQLUtils.GetDBTableName(CompanyPathTxt.Text + '\DOCUMENT.DAT');
  Check(TableName = '[ZZZZ01].[DOCUMENT]', 'expected [ZZZZ01].[DOCUMENT], got ' + TableName);
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_CreateTable;
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
  Check(FuncRes = 0, FuncRes);
  Check(TableExists(SystemPath + FileNames[Fnum]), 'Failed to find new table');

  FuncRes := Open_File(F[FNum], SystemPath + FileNames[Fnum], 0);
  Check(FuncRes = 0, 'Failed to open new file: error #' + IntToStr(FuncRes));

  FuncRes := Add_Rec(F[FNum], FNum, RepFile, 0);
  Check(FuncRes = 0, 'Failed to add record: error #' + IntToStr(FuncRes));

  FuncRes := Find_Rec(B_GetFirst, F[FNum], FNum, RepFile, 0, Key);
  Check(FuncRes = 0, 'Failed to find record: error #' + IntToStr(FuncRes));

end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_DeleteTable;
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
  Check(FuncRes = 0, FuncRes);
  Check(not TableExists(FileNames[Fnum]), 'Failed to delete table');

end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_OpenFile;
const
  FNum = 1; // CUST
var
  SystemPath: string;
  FuncRes: Integer;
begin
  SystemPath := ExtractFilePath(Application.ExeName);
  try
    FuncRes := Open_File(F[FNum], SystemPath + 'CUST\CUSTSUPP.DAT', 0);
    Check(FuncRes = 0, FuncRes);
  finally
    Close_File(F[FNum]);
  end;
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_StepFirst;
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
    Check(FuncRes = 0, FuncRes);
  finally
    Close_File(F[FNum]);
  end;
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_Presrv_BTPos;
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

procedure TMainFrm.Test_CreateDatabase;
var
  Server, Database, UserName, Password: string;
  FuncRes: Integer;
begin
  Server := ServerTxt.Text;
  Database := TestDatabaseTxt.Text;
  UserName := 'irisdbo';
  Password := 'datateam';
  FuncRes := CreateDatabase(Server, Database, UserName, Password);
  Check(FuncRes = 0, FuncRes);
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_CreateCompany;
var
  CompanyCode, CompanyName, CompanyPath: ShortString;
  ROUserName: string;
  FuncRes: Integer;
begin
  CompanyCode := TestCompany2CodeTxt.Text;
  CompanyName := TestCompanyNameTxt.Text;
  CompanyPath := TestCompanyPathTxt.Text;
  ROUserName  := 'ReadOnly' + FormatDateTime('HHMMSS', Now);
  FuncRes := CreateCompany(CompanyCode, CompanyName, CompanyPath, SourceZIPFileNameTxt.Text, ROUserName, 'test', nil);
//  Check(FuncRes = 0, FuncRes);
  Check(FuncRes = 0, ' Error #' + IntToStr(FuncRes) + ' : ' + SQLUtils.GetSQLErrorInformation(FuncRes));
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_DetachCompany;
var
  Code: string;
  FuncRes: Integer;
begin
  Code := TestCompany2CodeTxt.Text;
  FuncRes := DetachCompany(Code, nil);
  Check(FuncRes = 0, FuncRes);
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_AttachCompany;
var
  Code: string;
  FuncRes: Integer;
begin
  Code := TestCompany2CodeTxt.Text;
  FuncRes := AttachCompany(Code, nil);
  Check(FuncRes = 0, FuncRes);
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_ExportDataset;
var
  FuncRes: Integer;
begin
  FuncRes := SQLUtils.ExportSQLDataset(TestCompany1CodeTxt.Text, ImportExportZIPFileNameTxt.Text);
  Check(FuncRes = 0, FuncRes);
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_ImportDataset;
var
  FuncRes: Integer;
begin
  FuncRes := SQLUtils.ImportSQLDataset(TestCompany2CodeTxt.Text, ImportExportZIPFileNameTxt.Text);
  Check(FuncRes = 0, FuncRes);
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_CopyTable;
var
  FuncRes: Integer;
begin
  FuncRes := SQLUtils.CopyTable(TestCompany1CodeTxt.Text, TestCompany2CodeTxt.Text, 'CUSTSUPP.DAT', '(acCode = ' + QuotedStr('CASH01') + ')');
  Check(FuncRes = 0, FuncRes);

//  FuncRes := SQLUtils.CopyTable(TestCompany1CodeTxt.Text, TestCompany2CodeTxt.Text, 'CUSTSUPP.DAT', ' acCustSupp = ' + QuotedStr('C'));
  FuncRes := SQLUtils.CopyTable(TestCompany1CodeTxt.Text, TestCompany2CodeTxt.Text, 'CUSTSUPP.DAT', '');
  if (FuncRes = 10) then
    Check(False, FuncRes)
  else
    Check(FuncRes = 0, 'Failed to copy table with no WHERE clause: ' + IntToStr(FuncRes));
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_DeleteRec;
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
    Check(FuncRes = 0, FuncRes);

    { Attempt to find the record again, to make sure it has actually been
      deleted }
    FuncRes := Find_Rec(B_GetGEq, F[FNum], FNum, Buffer[1], 0, Key);
    Check(FuncRes = 4, 'Record still exists');

  finally
    Close_File(F[FNum]);
  end;
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_DeleteCompany;
var
  FuncRes: Integer;
begin
  FuncRes := SQLUtils.DeleteCompany(TestCompany2CodeTxt.Text);
  Check(FuncRes = 0, FuncRes);
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_RebuildCompanyCache;
var
  FuncRes: Integer;
begin
  FuncRes := SQLUtils.RebuildCompanyCache;
  Check(FuncRes = 0, FuncRes);
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_MultiLock;
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

procedure TMainFrm.Test_Sentimail_TimeField;
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
    Check(FuncRes = 0, FuncRes);

  finally
    Close_File(F[FNum]);
  end;
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_PutRec;
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
    Check(FuncRes = 0, FuncRes);

    SQLUtils.OpenCompanyByCode('ZZZZ02');

    FuncRes := Open_File(F[FNum], SystemPath + 'EXCHQSS.DAT', 0);
    Check(FuncRes = 0, 'Open_File in different company failed, error #' + IntToStr(FuncRes));

    Key := 'SYS';
    FileRecLen[FNum] := SizeOf(Buffer);
    FuncRes := Find_Rec(B_GetGEq, F[FNum], FNum, Syss, 0, Key);
    Check(FuncRes = 0, FuncRes);

    Syss.ExSecurity := NewSecurityCode;
    FuncRes := Put_Rec(F[FNum], FNum, Syss, 0);
    Check(FuncRes = 0, FuncRes);

    Key := 'SYS';
    FileRecLen[FNum] := SizeOf(Buffer);
    FuncRes := Find_Rec(B_GetGEq, F[FNum], FNum, Syss, 0, Key);
    Check(Syss.ExSecurity = NewSecurityCode, 'Failed to update ExSecurity to "' + NewSecurityCode + '"');

  finally
    Close_File(F[FNum]);
  end;
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_SetCacheSize;
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
    Check(FuncRes = 0, FuncRes);
  finally
    Close_File(PosBlock);
  end;
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_EndOfFile;
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
    Check(FuncRes = 9, FuncRes);
  finally
    Close_File(F[FNum]);
  end;
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_ExecSQL;
var
  Qry: string;
  Count: Integer;
begin
  SetDrive := ExtractFilePath(Application.ExeName);
  Qry := 'UPDATE ' + CompanyCodeTxt.Text + '.CUSTSUPP ' +
         'SET acZIPAttachments = 0';
  Count := ExecSQL(Qry, SetDrive);
//  Check(Count > -1, 'SQL UPDATE Query failed ' + SQLFuncs.SQLCaller.ErrorMsg);
  Check(Count > -1, 'SQL UPDATE Query failed.');
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_SQLFetch;
var
  Qry: string;
  Count: Variant;
  Balance: Variant;
  FuncRes: Integer;
begin
  SetDrive := ExtractFilePath(Application.ExeName);
  Qry := 'SELECT TOP 10 COUNT(acCode) AS countcust FROM ' + CompanyCodeTxt.Text + '.CUSTSUPP';
  FuncRes := SQLFetch(Qry, 'countcust', SetDrive, Count);
  Check(FuncRes = 0, LastSQLError);
  Check(Count <> 0, 'No count returned');
  Qry := 'SELECT SUM(acBalance) AS balance FROM [COMPANY].CUSTSUPP';
  FuncRes := SQLFetch(Qry, 'balance', SetDrive, Balance);
  Check(FuncRes = 0, LastSQLError);
  Check(Balance <> 0, 'No balance returned');
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_StockFreeze;
var
  FuncRes: Integer;
begin
  SetDrive := ExtractFilePath(Application.ExeName);
  FuncRes := SQLUtils.StockFreeze(SetDrive, 'AAA', True, 107, 11);
  Check(FuncRes >= 0, FuncRes);
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_UserCount;
begin
  SetDrive := ExtractFilePath(Application.ExeName);
//  Check(SQLFuncs.LoggedInUsers > 0, 'Failed to find any logged-in users');
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_RemoveLastCommit;
var
  FuncRes: Integer;
begin
  SetDrive := ExtractFilePath(Application.ExeName);
  FuncRes := SQLUtils.RemoveLastCommit(SetDrive);
  Check(FuncRes >= 0, 'Error #' + IntToStr(FuncRes) + ' ' + SQLUtils.LastSQLError);
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_CheckAllStock;
var
  FuncRes: Integer;
begin
  SetDrive := ExtractFilePath(Application.ExeName);
  FuncRes := CheckAllStock(SetDrive, 'ALARMSYS-DOM-1  ', 'M', 313);
  Check(FuncRes >= 0, FuncRes);
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_TotalProfitToDateRange;
var
  Purch, PSales, Balance, PCleared, PBudget, PRBudget, BValue1, BValue2: double;
  FuncRes: Integer;
begin
  SetDrive := ExtractFilePath(Application.ExeName);
  FuncRes := SQLUtils.TotalProfitToDateRange(SetDrive, 'U', 'AFEL01', 0, 106, 253, 0, true, false,
    Purch, PSales, Balance, PCleared, PBudget, PRBudget, BValue1, BValue2);
  Check(FuncRes = 0, FuncRes);
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_StockAddCustAnal;
var
  FuncRes: Integer;
begin
//  CustCode, StockCode, PDate, FolioRef, AbsLineNo, Currency, IdDocHed, LineType, LineTotal, Mode
// EXEC @ReturnValue = [!ActiveSchema!].[isp_StockAddCustAnal] 'ABAP01','BAT-9PP3-ALK    ','20080711', -2147478510, 2, 1, 8, 'O', 3.83, 0
  SetDrive := ExtractFilePath(Application.ExeName);
  FuncRes := SQLUtils.StockAddCustAnal(SetDrive, 'ABAP01','BAT-9PP3-ALK    ','20080711', -2147478510, 2, 1, 8, 'O', 3.83, 0);
  Check(FuncRes >= 0, FuncRes);
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_FillBudget;
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

procedure TMainFrm.Test_DeleteRows;
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
  CompanyCode := SQLUtils.GetCompanyCode(CompanyPathTxt.Text);
  { Delete the records }
  FuncRes := SQLUtils.DeleteRows(CompanyCode, 'EXSTKCHK.DAT', WhereClause);

  Check(FuncRes = 0, FuncRes);

end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_StringToHex;
var
  TestStr: string;
begin
  TestStr := StringToHex('MANAGER', 10);
  Check(TestStr = '0x4D414E41474552202020',
        'Expected "0x4D414E41474552202020" ' +
        'but returned "' + TestStr + '"');
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_ResetCustomSettings;
var
  FuncRes: Integer;
begin
  FuncRes := SQLFuncs.ResetCustomSettings(CompanyPathTxt.Text, 'MANAGER');
  Check(FuncRes = 0, FuncRes);
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_CustomPrefillCache;
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

procedure TMainFrm.Test_CustomPrefillCacheWithEXCHQCHK;
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

procedure TMainFrm.Test_CustomPrefillCacheWithJOBDET;
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

procedure TMainFrm.Test_CustomPrefillCacheWithGetPos;
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

procedure TMainFrm.Test_GetErrorInformation;
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

procedure TMainFrm.Test_UseVariantForNextCall;
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

procedure TMainFrm.Test_LockKeeper;
begin
  Check(LockKeeper <> nil, 'Failed to create/access LockKeeper');
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_LockType;
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

procedure TMainFrm.Test_AddLock;
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

procedure TMainFrm.Test_FindLock;
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

procedure TMainFrm.Test_SetMemCallback;
begin
  SetMemCallback(MemCallback);
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_Variant;
begin
  Check(SQLVariants <> nil, 'SQLVariant global singleton not created');
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_IsVariant;
begin
  Check(SQLVariants.IsVariant('EXCHQCHK.DAT'), '"EXCHQCHK.DAT" not reported as variant');
  Check(not SQLVariants.IsVariant('DETAILS.DAT'), '"DETAILS.DAT" reported as variant');
  Check(SQLVariants.IsVariant('JOBS\JOBCTRL.DAT'), '"JOBS\JOBCTRL.DAT" not reported as variant');
  Check(SQLVariants.IsVariant('JOBS\JobCtrl.DAT'), '"JOBS\JobCtrl.DAT" not reported as variant');
  Check(SQLVariants.IsVariant('JOBS\JOBCTRL.DAT  '), '"JOBS\JOBCTRL.DAT  " not reported as variant');
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_AddVariant;
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

procedure TMainFrm.Test_VariantRecorded;
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

procedure TMainFrm.Test_RemoveVariant;
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

procedure TMainFrm.Test_GetPosAfterDelete;
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
    SQLUtils.DeleteRows(CompanyCodeTxt.Text, 'SETTINGS.DAT', '1=1');
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

procedure TMainFrm.Test_GetRedirector;
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

procedure TMainFrm.Test_ImportKeyBuffer;
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

procedure TMainFrm.Test_ExportKeyBuffer;
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

procedure TMainFrm.Test_WindowSettings;
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

procedure TMainFrm.Test_HookSecurityFields;
var
  Fields: string;
begin
  Fields := GetAllHookSecurityRecTypeFields;
  Check(Pos('hkVersion', Fields) <> 0, '"hkVersion" not found in SQLFields');
  Check(Pos('hkEncryptedCode', Fields) <> 0, '"hkEncryptedCode" not found in SQLFields');
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_DetailsFields;
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

procedure TMainFrm.Test_VATRecFields;
var
  Fields: string;
begin
  Fields := GetAllVATRecFields;
  Check(Pos('EnableECServices', Fields) <> 0, '"EnableECServices" not found in SQLFields');
  Check(Pos('ECSalesThreshold', Fields) <> 0, '"ECSalesThreshold" not found in SQLFields');
end;

// -----------------------------------------------------------------------------

procedure TMainFrm.Test_BACSDbRecFields;
var
  Fields: string;
begin
  Fields := GetAllBACSDbRecFields;
  Check(Pos('BrSortCodeEx', Fields) <> 0, '"BrSortCodeEx" not found in SQLFields');
  Check(Pos('BrAccountCodeEx', Fields) <> 0, '"BrAccountCodeEx" not found in SQLFields');
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TTestInfo
// =============================================================================

procedure TTestInfo.SetStatus(const Value: TTestStatus);
begin
  FStatus := Value;
end;

// -----------------------------------------------------------------------------

procedure TTestInfo.SetTestProc(const Value: TTestProcedure);
begin
  FTestProc := Value;
end;

// -----------------------------------------------------------------------------

procedure TTestInfo.SetTitle(const Value: string);
begin
  FTitle := Value;
end;

// -----------------------------------------------------------------------------

end.

