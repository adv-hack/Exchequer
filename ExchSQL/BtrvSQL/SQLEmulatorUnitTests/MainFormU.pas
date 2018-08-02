unit MainFormU;
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

  TMainForm = class(TForm)
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
    Label5: TLabel;
    SelectAllBtn: TButton;
    SelectNoneBtn: TButton;
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
    ClearBtn: TButton;
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
    procedure ClearBtnClick(Sender: TObject);
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
    procedure Test_OpenCompany;
    procedure Test_OpenCompanyByCode;
    procedure Test_ValidSystem;
    procedure Test_ValidCompany;
    procedure Test_CompanyExists;
    procedure Test_TableExists;
    procedure Test_FindRec;
    procedure Test_FindCompanyCode;
    procedure Test_HasExclusiveAccess;
    procedure Test_GetDBColumnName;
    procedure Test_OpenFile;
    procedure Test_StepFirst;
    procedure Test_Presrv_BTPos;
    procedure Test_DeleteRec;
    procedure Test_MultiLock;
    procedure Test_EndOfFile;
    procedure Test_FindOnClosed;
    procedure Test_CreateDatabase;
    procedure Test_CreateCompany;
    procedure Test_DetachCompany;
    procedure Test_AttachCompany;
    procedure Test_DeleteCompany;
    procedure Test_ExportFullDataset;
    procedure Test_ExportCommonDataset;
    procedure Test_ExportCompanyDataset;
    procedure Test_CopyTable;
    procedure Test_ImportDataset;
    procedure Test_Sentimail_TimeField;
    procedure Test_PutRec;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$WARN UNIT_PLATFORM OFF}

uses SQLUtils, SQLCompany, BtrvU2, Inifiles, FileCtrl, VarConst;

const
  OK     = True;
  FAILED = False;

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  AddAllTests;
  ReadSettings;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  WriteSettings;
  ClearAllTests;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.TestListDrawItem(Control: TWinControl; Index: Integer;
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

procedure TMainForm.CloseBtnClick(Sender: TObject);
begin
  Close;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.RunBtnClick(Sender: TObject);
begin
  RunAllTests;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.SelectAllBtnClick(Sender: TObject);
begin
  SelectAllTests;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.SelectNoneBtnClick(Sender: TObject);
begin
  UnselectAllTests;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.SelectPathBtnClick(Sender: TObject);
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

procedure TMainForm.SelectTestPathClick(Sender: TObject);
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

procedure TMainForm.SelectDataZipBtnClick(Sender: TObject);
begin
  OpenDialog.Filter := 'ZIP files|*.zip|All files|*.*';
  OpenDialog.FileName := SourceZIPFileNameTxt.Text;
  if OpenDialog.Execute then
    SourceZIPFileNameTxt.Text := OpenDialog.FileName;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.SelectImportExportFileBtnClick(Sender: TObject);
begin
  OpenDialog.Filter := 'ZIP files|*.zip|All files|*.*';
  OpenDialog.FileName := ImportExportZIPFileNameTxt.Text;
  if OpenDialog.Execute then
    ImportExportZIPFileNameTxt.Text := OpenDialog.FileName;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.ClearBtnClick(Sender: TObject);
begin
  ClearAllTests;
  AddAllTests;
end;

// -----------------------------------------------------------------------------

// =============================================================================
// Unit test support routines
// =============================================================================
procedure TMainForm.AddTest(Test: TTestProcedure; Title: string);
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

procedure TMainForm.AddAllTests;
begin
  AddTest(Test_GetBtrvVer,          'GetBtrvVer');
  AddTest(Test_GetConnectionString, 'GetConnectionString');
  AddTest(Test_OpenCompany,         'OpenCompany');
  AddTest(Test_OpenCompanyByCode,   'OpenCompanyByCode');
  AddTest(Test_ValidSystem,         'ValidSystem');
  AddTest(Test_ValidCompany,        'ValidCompany');
  AddTest(Test_TableExists,         'TableExists');
  AddTest(Test_FindRec,             'Find_Rec');
  AddTest(Test_MultiLock,           'Find_Rec with Multi-Lock');
  AddTest(Test_FindCompanyCode,     'FindCompanyCode');
  AddTest(Test_CompanyExists,       'CompanyExists');
  AddTest(Test_HasExclusiveAccess,  'HasExclusiveAccess');
  AddTest(Test_GetDBColumnName,     'GetDBColumnName');
  AddTest(Test_OpenFile,            'Open_File');
  AddTest(Test_StepFirst,           'Find_Rec(B_StepFirst)');
  AddTest(Test_Presrv_BTPos,        'Presrv_BTPos');
  AddTest(Test_EndOfFile,           'GetNext / End of File');
  AddTest(Test_FindOnClosed,        'FindOnClosed');
  AddTest(Test_CreateDatabase,      'CreateDatabase');
  AddTest(Test_CreateCompany,       'CreateCompany');
  AddTest(Test_DetachCompany,       'DetachCompany');
  AddTest(Test_AttachCompany,       'AttachCompany');
  AddTest(Test_ExportFullDataset,   'Export full dataset');
  AddTest(Test_ExportCommonDataset, 'Export common dataset');
  AddTest(Test_ExportCompanyDataset,'Export company dataset');
  AddTest(Test_ImportDataset,       'ImportDataset');
  AddTest(Test_CopyTable,           'CopyTable');
  AddTest(Test_DeleteRec,           'Delete_Rec');
  AddTest(Test_DeleteCompany,       'DeleteCompany');
  AddTest(Test_Sentimail_TimeField, 'Sentimail Time field');
  AddTest(Test_PutRec,              'Put_Rec');
  SelectAllTests;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.ClearAllTests;
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

procedure TMainForm.SelectAllTests;
var
  i: Integer;
begin
  for i := 0 to TestList.Items.Count - 1 do
    TestList.Checked[i] := True;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.UnselectAllTests;
var
  i: Integer;
begin
  for i := 0 to TestList.Items.Count - 1 do
    TestList.Checked[i] := False;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.Check(Expression: Boolean; FailMsg: string);
begin
  if not Expression then
    raise Exception.Create(FailMsg)
end;

// -----------------------------------------------------------------------------

procedure TMainForm.Check(Expression: Boolean; FailCode: Integer);
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

procedure TMainForm.Report(Msg: string; Success: Boolean);
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

procedure TMainForm.RunAllTests;
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

procedure TMainForm.RunTest(Idx: Integer; Test: TTestProcedure; Title: string);
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

procedure TMainForm.SetUp;
begin

end;

// -----------------------------------------------------------------------------

procedure TMainForm.TearDown;
begin

end;

// -----------------------------------------------------------------------------

procedure TMainForm.ReadSettings;
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

procedure TMainForm.WriteSettings;
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

procedure TMainForm.Test_GetBtrvVer;
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

procedure TMainForm.Test_GetConnectionString;
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

procedure TMainForm.Test_OpenCompany;
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

procedure TMainForm.Test_OpenCompanyByCode;
var
  Code: string;
  FuncRes: Integer;
begin
  Code := CompanyCodeTxt.Text;
  FuncRes := OpenCompanyByCode(Code);
  Check(FuncRes = 0, FuncRes);
end;

// -----------------------------------------------------------------------------

procedure TMainForm.Test_ValidSystem;
var
  Path: string;
begin
  Path := CompanyPathTxt.Text;
  Check(SQLUtils.ValidSystem(Path), 'failed');
end;

// -----------------------------------------------------------------------------

procedure TMainForm.Test_ValidCompany;
var
  Path: string;
begin
  Path := CompanyPathTxt.Text;
  Check(SQLUtils.ValidCompany(Path), 'failed');
end;

// -----------------------------------------------------------------------------

procedure TMainForm.Test_CompanyExists;
var
  Code: string;
begin
  Code := CompanyCodeTxt.Text;
  Check(SQLUtils.CompanyExists(Code) = 0, 'failed');
  Code := 'XXXXXX';
  Check(not (SQLUtils.CompanyExists(Code) = 0), 'Found non-existant company');
end;

// -----------------------------------------------------------------------------

procedure TMainForm.Test_TableExists;
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
end;

// -----------------------------------------------------------------------------

procedure TMainForm.Test_FindRec;
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

procedure TMainForm.Test_FindCompanyCode;
var
  Code: string;
begin
  Code := FindCompanyCode(CompanyPathTxt.Text);
  Check(Code <> '', 'failed');
end;

// -----------------------------------------------------------------------------

procedure TMainForm.Test_HasExclusiveAccess;
begin
  Check(SQLUtils.ExclusiveAccess(''), 'failed');
end;

// -----------------------------------------------------------------------------

procedure TMainForm.Test_GetDBColumnName;
var
  DBField: string;
begin
  DBField := SQLUtils.GetDBColumnName('DOCUMENT.DAT', 'f_run_no', '');
  Check(DBField = 'thRunNo', 'expected thRunNo, got ' + DBField);
end;

// -----------------------------------------------------------------------------

procedure TMainForm.Test_OpenFile;
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

procedure TMainForm.Test_StepFirst;
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

procedure TMainForm.Test_Presrv_BTPos;
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

procedure TMainForm.Test_CreateDatabase;
var
  Server, Database, UserName, Password: string;
  FuncRes: Integer;
begin
  Server := ServerTxt.Text;
  Database := TestDatabaseTxt.Text;
  UserName := 'xcheckdbo';
  Password := 'password123';
  FuncRes := CreateDatabase(Server, Database, UserName, Password);
  Check(FuncRes = 0, FuncRes);
end;

// -----------------------------------------------------------------------------

procedure TMainForm.Test_CreateCompany;
var
  CompanyCode, CompanyName, CompanyPath: ShortString;
  ROUserName: string;
  FuncRes: Integer;
begin
{
  CompanyCode := TestCompany1CodeTxt.Text;
  CompanyName := TestCompanyNameTxt.Text;
  CompanyPath := TestCompanyPathTxt.Text;
  ROUserName  := 'ReadOnly' + FormatDateTime('HHMMSS', Now);
  FuncRes := CreateCompany(CompanyCode, CompanyName, CompanyPath, SourceZIPFileNameTxt.Text, ROUserName, 'test', nil);
  Check(FuncRes = 0, FuncRes);
}
  CompanyCode := TestCompany2CodeTxt.Text;
  CompanyName := TestCompanyNameTxt.Text;
  CompanyPath := TestCompanyPathTxt.Text;
  ROUserName  := 'ReadOnly' + FormatDateTime('HHMMSS', Now);
  FuncRes := CreateCompany(CompanyCode, CompanyName, CompanyPath, SourceZIPFileNameTxt.Text, ROUserName, 'test', nil);
  Check(FuncRes = 0, FuncRes);
end;

// -----------------------------------------------------------------------------

procedure TMainForm.Test_DetachCompany;
var
  Code: string;
  FuncRes: Integer;
begin
  Code := TestCompany2CodeTxt.Text;
  FuncRes := DetachCompany(Code, nil);
  Check(FuncRes = 0, FuncRes);
end;

// -----------------------------------------------------------------------------

procedure TMainForm.Test_AttachCompany;
var
  Code: string;
  FuncRes: Integer;
begin
  Code := TestCompany2CodeTxt.Text;
  FuncRes := AttachCompany(Code, nil);
  Check(FuncRes = 0, FuncRes);
end;

// -----------------------------------------------------------------------------

procedure TMainForm.Test_ExportCommonDataset;
var
  FuncRes: Integer;
begin
  FuncRes := SQLUtils.ExportSQLDataset(TestCompany1CodeTxt.Text, ImportExportZIPFileNameTxt.Text, EXPORT_COMMON);
  Check(FuncRes = 0, FuncRes);
end;

// -----------------------------------------------------------------------------

procedure TMainForm.Test_ExportCompanyDataset;
var
  FuncRes: Integer;
begin
  FuncRes := SQLUtils.ExportSQLDataset(TestCompany1CodeTxt.Text, ImportExportZIPFileNameTxt.Text, EXPORT_COMPANY);
  Check(FuncRes = 0, FuncRes);
end;

// -----------------------------------------------------------------------------

procedure TMainForm.Test_ExportFullDataset;
var
  FuncRes: Integer;
begin
  FuncRes := SQLUtils.ExportSQLDataset(TestCompany1CodeTxt.Text, ImportExportZIPFileNameTxt.Text, EXPORT_ALL);
  Check(FuncRes = 0, FuncRes);
end;

// -----------------------------------------------------------------------------

procedure TMainForm.Test_ImportDataset;
const
  FNum = 21;  // COMPANY
var
  Key    : string[255];
  FuncRes: Smallint;
  SystemPath: string;
  Buffer: array[1..1536] of Char;
begin
  SystemPath := ExtractFilePath(Application.ExeName);

  FuncRes := Open_File(F[FNum], SystemPath + 'COMPANY.DAT', 0);
  Check(FuncRes = 0, 'Could not open file, error #' + IntToStr(FuncRes));

  FuncRes := SQLUtils.ImportSQLDataset(TestCompany2CodeTxt.Text, ImportExportZIPFileNameTxt.Text);
  Check(FuncRes = 0, FuncRes);

  FuncRes := Close_File(F[FNum]);
  Check(FuncRes <> 3, 'Company table has been closed');
end;

// -----------------------------------------------------------------------------

procedure TMainForm.Test_CopyTable;
var
  FuncRes: Integer;
begin
  FuncRes := SQLUtils.CopyTable(TestCompany1CodeTxt.Text, TestCompany2CodeTxt.Text, 'CUSTSUPP.DAT', '(acCode = ' + QuotedStr('CASH01') + ')');
  Check(FuncRes = 0, FuncRes);

//  FuncRes := SQLUtils.CopyTable(TestCompany1CodeTxt.Text, TestCompany2CodeTxt.Text, 'CUSTSUPP.DAT', ' acCustSupp = ' + QuotedStr('C'));
  FuncRes := SQLUtils.CopyTable(TestCompany1CodeTxt.Text, TestCompany2CodeTxt.Text, 'CUSTSUPP.DAT', '1=1');
  if (FuncRes = 10) then
    Check(False, FuncRes)
  else
    Check(FuncRes = 0, 'Failed to copy table with no WHERE clause: ' + IntToStr(FuncRes));
end;

// -----------------------------------------------------------------------------

procedure TMainForm.Test_DeleteRec;
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

procedure TMainForm.Test_DeleteCompany;
var
  FuncRes: Integer;
begin
  FuncRes := SQLUtils.DeleteCompany(TestCompany2CodeTxt.Text);
  Check(FuncRes = 0, FuncRes);
end;

// -----------------------------------------------------------------------------

procedure TMainForm.Test_FindOnClosed;
const
  FNum = 21;  // COMPANY
var
  Key    : string[255];
  FuncRes: Smallint;
  SystemPath: string;
  Buffer: array[1..1536] of Char;
begin
  SystemPath := ExtractFilePath(Application.ExeName);

  FileRecLen[FNum] := SizeOf(Buffer);

  FuncRes := Open_File(F[FNum], SystemPath + 'COMPANY.DAT', 0);
  Check(FuncRes = 0, 'Could not open file, error #' + IntToStr(FuncRes));

  Key := '';
  FuncRes := Find_Rec(B_GetFirst, F[FNum], FNum, Buffer[1], 0, Key);
  Check(FuncRes = 0, FuncRes);

  FuncRes := Close_File(F[FNum]);
  Check(FuncRes <> 3, 'Company table has been closed');

  FuncRes := Find_Rec(B_GetFirst, F[FNum], FNum, Buffer[1], 0, Key);
  Check(FuncRes = 3, 'Find_Rec on closed table returned #' + IntToStr(FuncRes));
end;

// -----------------------------------------------------------------------------

procedure TMainForm.Test_MultiLock;
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

procedure TMainForm.Test_Sentimail_TimeField;
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

procedure TMainForm.Test_PutRec;
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

procedure TMainForm.Test_EndOfFile;
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

initialization

  SystemPath := 'C:\EXCHSQL\';

finalization

end.

