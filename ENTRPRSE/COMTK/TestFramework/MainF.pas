unit MainF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SQLCallerU, StdCtrls, DB, Grids, DBGrids, CompareIntf, ComCtrls, TestList,
  Enterprise04_TLB, TestConst, Menus, ExtCtrls;


type
  TfrmMain = class(TForm)
    lvTests: TListView;
    lblTestCo: TLabel;
    lblRefCo: TLabel;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    New1: TMenuItem;
    Open1: TMenuItem;
    Save1: TMenuItem;
    SaveAs1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    est1: TMenuItem;
    Add1: TMenuItem;
    Edit1: TMenuItem;
    Delete1: TMenuItem;
    Run1: TMenuItem;
    ools1: TMenuItem;
    CompareDatabases1: TMenuItem;
    RunTests1: TMenuItem;
    LoadResults1: TMenuItem;
    N2: TMenuItem;
    CheckTests1: TMenuItem;
    StatusBar1: TStatusBar;
    Panel1: TPanel;
    btnCompare: TButton;
    btnRunAll: TButton;
    btnLoadResults: TButton;
    btnAdd: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    btnRun: TButton;
    btnLoadTests: TButton;
    btnSave: TButton;
    btnSaveAs: TButton;
    btnClose: TButton;
    Label1: TLabel;
    Label3: TLabel;
    cbTestDb: TComboBox;
    cbTestCo: TComboBox;
    cbRefCo: TComboBox;
    cbRefDb: TComboBox;
    Label2: TLabel;
    Label5: TLabel;
    edtResultsFolder: TEdit;
    chkCompareAtEnd: TCheckBox;
    Label4: TLabel;
    hELP1: TMenuItem;
    About1: TMenuItem;
    N3: TMenuItem;
    SetupDatabase1: TMenuItem;
    PopupMenu1: TPopupMenu;
    Add2: TMenuItem;
    Edit2: TMenuItem;
    Delete2: TMenuItem;
    Run2: TMenuItem;
    btnCheckAll: TButton;
    procedure FormDestroy(Sender: TObject);
    procedure btnLoadResultsClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbTestDbChange(Sender: TObject);
    procedure cbRefDbChange(Sender: TObject);
    procedure btnCompareClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure lvTestsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure btnRunAllClick(Sender: TObject);
    procedure btnRunClick(Sender: TObject);
    procedure cbTestCoChange(Sender: TObject);
    procedure cbRefCoChange(Sender: TObject);
    procedure btnLoadTestsClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnSaveAsClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure New1Click(Sender: TObject);
    procedure CheckTests1Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure lvTestsInfoTip(Sender: TObject; Item: TListItem;
      var InfoTip: String);
    procedure About1Click(Sender: TObject);
    procedure SetupDatabase1Click(Sender: TObject);
    procedure btnCheckAllClick(Sender: TObject);
  private
    { Private declarations }
    SQLCaller : TSQLCaller;
    oCompare : ICompareTables;
    oCompareDB : ICompareDatabases;
    FTestFilename : string;
    FAnyChanges : Boolean;
    FTestRunner : TTestList;
    FToolkit : IToolkit;
    FCurrentTest : Integer;
    FCurrentResult : Integer;
    FListLoaded : Boolean;
    procedure LoadSQLDataBaseLists;
    procedure LoadSQLCompanyList(const AList : TComboBox; const sDb : string);
    procedure DoProgress(const sMessage : string);
    procedure LoadTestList(const sName : string = '');
    procedure SaveTestList(const sName : string);
    function CompareDatabases(const TestName : string) : Boolean;
    function GetTestCoPath : string;
    procedure TestToListItem(const ATest : TTest; const Item : TListItem);
    procedure ListItemToTest(const Item : TListItem; const ATest : TTest);
    function CompareResults(const ATest : TTest; Index : Integer) : Boolean;
    procedure AddStatusMessage(ErrorCode : Word);
    function GetStatusDesc(ErrorCode : Word) : string;
    function GetCompanyName(const dbName, coCode : string) : string;
    procedure SetCaption;
    function CheckChanges : Boolean;
    function CheckApps(ShowOKMessage : Boolean = False) : Boolean;
    function ResultsFolderIsEmpty : Boolean;
    procedure DBsToSettings;
    procedure SettingsToDBs;
  public
    { Public declarations }
    procedure WMTestProgress(Var Message  :  TMessage); Message WM_TESTPROGRESS;

  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}
uses
  SQLUtils, CompareSQLU, CompareSQLDb, FrameworkUtils, ResultF,
  TestItemF, ApiUtil, CTKUtil04, StrUtils, FrameworkIni, SetupDB;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  if Assigned(SQLCaller) then
    FreeAndNil(SQLCaller);
  if Assigned(FTestRunner) then
    FreeAndNil(FTestRunner);
  FToolkit := nil;
  DbsToSettings;
  oIniFile.Items[RESULTS_FOLDER] := edtResultsFolder.Text;
end;

procedure TfrmMain.btnLoadResultsClick(Sender: TObject);
begin
  with TfrmShowResult.Create(nil) do
  Try
    ResultDir := IncludeTrailingBackslash(edtResultsFolder.Text);
    ShowModal;
  Finally
    Free;
  End;
end;

procedure TfrmMain.LoadSQLDataBaseLists;
var
  sQuery : AnsiString;
begin
  sQuery := 'SELECT * FROM master.dbo.sysdatabases WHERE dbid > 6';
  SQLCaller.Select(sQuery);
  Try
    SQLCaller.Records.First;

    while not SQLCaller.Records.EOF do
    begin
      cbTestDb.Items.Add(SQLCaller.Records.FieldByName('name').AsString);
      cbRefDb.Items.Add(SQLCaller.Records.FieldByName('name').AsString);

      SQLCaller.Records.Next;
    end;
    cbTestDb.ItemIndex := 0;
    cbRefDb.ItemIndex := 0;
  Finally
    SQLCaller.Records.Close;
{    cbRefDbChange(nil);
    cbTestDbChange(nil);}
  End;
end;

procedure TfrmMain.LoadSQLCompanyList(const AList : TComboBox; const sDb : string);
var
  sQuery : AnsiString;
begin
  sQuery := 'Select DISTINCT TABLE_SCHEMA FROM ' + sDb + '.INFORMATION_SCHEMA.TABLES';
  sQuery := sQuery + ' WHERE TABLE_SCHEMA <> ''common''';

  SQLCaller.Select(sQuery);
  Try
    AList.Items.Clear;
    SQLCaller.Records.First;

    while not SQLCaller.Records.EOF do
    begin
      AList.Items.Add(SQLCaller.Records.FieldByName('TABLE_SCHEMA').AsString);

      SQLCaller.Records.Next;
    end;
    AList.ItemIndex := 0;
  Finally
    SQLCaller.Records.Close;
  End;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FToolkit := CreateToolkitWithBackdoor;
  SetupIniFile;
  FListLoaded := False;
  SQLCaller := TSQLCaller.Create;
  FTestRunner := TTestList.Create;
  SetupSQLConnection(SQLCaller.Connection);
  LoadSQLDatabaseLists;
  SettingsToDBs;
  FTestRunner.MessageHandle := Handle;
  FAnyChanges := False;
  LoadTestList;
  if oIniFile.Items[RESULTS_FOLDER] <> '' then
    edtResultsFolder.Text := oIniFile.Items[RESULTS_FOLDER];
  ActiveControl := cbTestDb;
end;

procedure TfrmMain.cbTestDbChange(Sender: TObject);
begin
  LoadSQLCompanyList(cbTestCo,cbTestDb.Items[cbTestDb.ItemIndex]);
  cbTestCoChange(cbTestCo);
end;

procedure TfrmMain.cbRefDbChange(Sender: TObject);
begin
  LoadSQLCompanyList(cbRefCo,cbRefDb.Items[cbRefDb.ItemIndex]);
  cbRefCoChange(cbRefCo);
end;

procedure TfrmMain.btnCompareClick(Sender: TObject);
begin
  if CompareDatabases('Test') then
    ShowMessage('No differences found')
  else
    ShowMessage('There were differences');
end;

procedure TfrmMain.DoProgress(const sMessage: string);
begin
  StatusBar1.SimpleText := sMessage;
  StatusBar1.Refresh;
  Application.ProcessMessages;
end;

procedure TfrmMain.WMTestProgress(var Message: TMessage);
begin
  FCurrentResult := Message.lParam;
  if Message.wParam >= E_SUCCESS then
    AddStatusMessage(Message.wParam);
  Inc(FCurrentTest);
end;

procedure TfrmMain.LoadTestList(const sName: string = '');
var
  i, j : integer;
begin
  FListLoaded := False;
  lvTests.Clear;
  if Trim(sName) <> '' then
    FTestRunner.ListName := sName;
  FTestRunner.Load;
  for i := 0 to FTestRunner.Count - 1 do
    TestToListItem(FTestRunner.Test[i], lvTests.Items.Add);
  SetCaption;
  FAnyChanges := False;
  FListLoaded := True;
end;

procedure TfrmMain.btnCloseClick(Sender: TObject);
begin
  SendMessage(Handle, WM_TESTPROGRESS, 0, 0);
  Close;
end;

procedure TfrmMain.SaveTestList(const sName: string);
begin
  if Trim(sName) <> '' then
    FTestRunner.ListName := sName;
  FTestRunner.Save;
end;

procedure TfrmMain.btnAddClick(Sender: TObject);
var
  AnItem : TListItem;
begin
  FListLoaded := False;
  with TfrmTestItem.Create(nil) do
  Try
    ShowModal;
    if ModalResult = mrOK then
    begin
      AnItem := lvTests.Items.Add;
      with AnItem do
      begin
        Caption := edtTestName.Text;
        SubItems.Add(edtApp.Text);
        SubItems.Add(BoolToYN(chkCompareRes.Checked));
        SubItems.Add(edtResult.Text);
        SubItems.Add(BoolToYN(chkCompareDB.Checked));
        SubItems.Add(edtExtra.Text);
        Checked := chkRun.Checked;
      end;
      FAnyChanges := True;
      ListItemToTest(AnItem, FTestRunner.Add);
    end;
  Finally
    Free;
    FListLoaded := True;
  End;
end;

procedure TfrmMain.btnEditClick(Sender: TObject);
begin
  FListLoaded := False;
  if Assigned(lvTests.Selected) then
  with TfrmTestItem.Create(nil) do
  Try
    edtTestName.Text := lvTests.Selected.Caption;
    edtApp.Text := lvTests.Selected.SubItems[0];
    chkRun.Checked := lvTests.Selected.Checked;
    chkCompareRes.Checked := lvTests.Selected.SubItems[1] = 'Y';
    edtResult.Text := lvTests.Selected.SubItems[2];
    chkCompareDB.Checked := lvTests.Selected.SubItems[3] = 'Y';
    edtExtra.Text := lvTests.Selected.SubItems[4];
    ShowModal;
    if ModalResult = mrOK then
    begin
      lvTests.Selected.Caption := edtTestName.Text;
      lvTests.Selected.SubItems[0] := edtApp.Text;
      lvTests.Selected.SubItems[1] := BoolToYN(chkCompareRes.Checked);
      lvTests.Selected.SubItems[2] := edtResult.Text;
      lvTests.Selected.SubItems[3] := BoolToYN(chkCompareDB.Checked);
      lvTests.Selected.SubItems[4] := edtExtra.Text;
      lvTests.Selected.Checked := chkRun.Checked;
      FAnyChanges := True;
      ListItemToTest(lvTests.Selected, FTestRunner.Test[lvTests.ItemIndex]);
    end;
  Finally
    Free;
    FListLoaded := True;
  End;
end;

procedure TfrmMain.btnDeleteClick(Sender: TObject);
begin
  if Assigned(lvTests.Selected) then
  begin
    FTestRunner.Delete(lvTests.Selected.Index);
    lvTests.DeleteSelected;
  end;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := CheckChanges;
end;

procedure TfrmMain.lvTestsChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  if FListLoaded and (Change = ctState) and Assigned(FTestRunner) then
  begin
    if FTestRunner.Count > Item.Index then
    begin
      if FTestRunner.Test[Item.Index].WantToRun <> Item.Checked then
      begin
        FTestRunner.Test[Item.Index].WantToRun := Item.Checked;
        FAnyChanges := True;
      end;
    end;
  end;;
end;

function TfrmMain.CompareDatabases(const TestName : string): Boolean;
begin
  oCompareDB := GetCompareSQLDatabases;
  oCompareDB.cdPath1 := cbTestDb.Items[cbTestDb.ItemIndex] + '.' +
                        cbTestCo.Items[cbTestCo.ItemIndex];

  oCompareDB.cdPath2 := cbRefDb.Items[cbRefDb.ItemIndex] + '.' +
                        cbRefCo.Items[cbRefCo.ItemIndex];

  oCompareDB.cdResultsFolder := IncludeTrailingBackslash(edtResultsFolder.Text);
  oCompareDB.cdTestName := TestName;
  oCompareDB.OnProgress := DoProgress;

  Result := oCompareDB.Execute;
end;

procedure TfrmMain.btnRunAllClick(Sender: TObject);
var
  i : integer;
  ResOK, AllResOK, DBOK : Boolean;
begin
  if not ResultsFolderIsEmpty then
    EXIT;
{$B+}
  if CheckApps then
  begin

    //Clear results
    for i := 0 to FTestRunner.Count - 1 do
    begin
      lvTests.ItemIndex := i;

      FCurrentTest := i;
      FCurrentResult := 0;

      AddStatusMessage(E_BLANK);
    end;

    DBOk := True;
    AllResOK := True;
    FTestRunner.DataPath := GetTestCoPath;
    for i := 0 to FTestRunner.Count - 1 do
    begin

      lvTests.ItemIndex := i;
      FCurrentTest := i;

      if Assigned(lvTests.Items[i]) then
        lvTests.Items[i].MakeVisible(False);

      FCurrentResult := 0;

      if FTestRunner.Test[i].WantToRun then
      begin
        AddStatusMessage(E_RUNNING);
        DoProgress(FTestRunner.Test[i].TestName);
        FTestRunner.RunTest(i);

        //Wait until the test has finished - on closing it will send
        //a message which will increment FCurrentTest and set FCurrentResult to
        //the value of the test result.
        while FCurrentTest = i do
        begin
          Wait(1000);
        end;

        //If we're comparing results and it fails then there's no point comparing the DBs
        if FTestRunner.Test[i].CompareResult then
          ResOK := CompareResults(FTestRunner.Test[i], i)
        else
          ResOK := True;

        AllResOK := AllResOK and ResOK; //Keep track of any fails, so we don't bother comparing DBs at end

        if ResOK and FTestRunner.Test[i].CompareDB and not chkCompareAtEnd.Checked then
          dbOK := dbOK and CompareDatabases(FTestRunner.Test[i].TestName);

      end;

    end; //for i

    if chkCompareAtEnd.Checked and AllResOK then
      dbOK := CompareDatabases('All');

    DoProgress('Finished');

    if not AllResOK then
      ShowMessage('There were differences in the results')
    else
    if not dbOK then
      ShowMessage('There were differences in the databases');

  end; //if check apps
  {$B-}
end;

function TfrmMain.GetTestCoPath: string;
begin
  Result := Trim(CompanyPathFromCode(FToolkit, cbTestCo.Items[cbTestCo.ItemIndex]));
end;

procedure TfrmMain.ListItemToTest(const Item: TListItem;
  const ATest: TTest);
begin
  ATest.WantToRun := Item.Checked;
  ATest.TestName := Item.Caption;
  ATest.AppName := Item.SubItems[0];
  ATest.CompareResult := Item.SubItems[1] = 'Y';
  ATest.ExpectedResult := StrToIntDef(Item.SubItems[2], 0);
  ATest.CompareDB := Item.SubItems[3] = 'Y';
  ATest.ExtraParam := Item.SubItems[4];
end;

procedure TfrmMain.TestToListItem(const ATest: TTest;
  const Item: TListItem);
begin
  Item.Checked := ATest.WantToRun;
  Item.Caption := ATest.TestName;
  if Item.SubItems.Count = 0 then
  begin
    Item.SubItems.Add(ATest.AppName);
    Item.SubItems.Add(BoolToYN(ATest.CompareResult));
    Item.SubItems.Add(IntToStr(ATest.ExpectedResult));
    Item.SubItems.Add(BoolToYN(ATest.CompareDB));
    Item.SubItems.Add(ATest.ExtraParam);
  end
  else
  begin
    Item.SubItems[0] := ATest.AppName;
    Item.SubItems[1] := BoolToYN(ATest.CompareResult);
    Item.SubItems[2] := IntToStr(ATest.ExpectedResult);
    Item.SubItems[3] := BoolToYN(ATest.CompareDB);
    Item.SubItems[4] := ATest.ExtraParam;
  end;
end;

procedure TfrmMain.btnRunClick(Sender: TObject);
var
  i : integer;
  ResOK : Boolean;
begin
  i := lvTests.ItemIndex;
  if i >= 0 then
  begin
    if not ResultsFolderIsEmpty then
      EXIT;

    FCurrentTest := i;
    FCurrentResult := 0;

    AddStatusMessage(E_BLANK);

    FTestRunner.DataPath := GetTestCoPath;
    FTestRunner.RunTest(i);

    while FCurrentTest = i do
    begin
      Wait(1000);
    end;

    if FTestRunner.Test[i].CompareResult then
      ResOK := CompareResults(FTestRunner.Test[i], i)
    else
      ResOK := True;


    if ResOK and FTestRunner.Test[i].CompareDB then
      CompareDatabases(FTestRunner.Test[i].TestName);


  end;
end;

function TfrmMain.CompareResults(const ATest: TTest; Index : Integer) : Boolean;

  function MakeSafeFileName(const s : string) : string;
  const
    BadChars = ['\','/',':','?','*','>','<','"','|'];
  var
    i : integer;
  begin
    Result := s;
    for i := 1 to Length(Result) do
      if Result[i] in BadChars then
        Result[i] := ' ';
  end;
begin
  Result := ATest.ExpectedResult = FCurrentResult;
  if not Result then
  with TStringList.Create do
  Try
    Add('Test: ' + ATest.TestName);
    Add('Expected Result: ' + IntToStr(ATest.ExpectedResult));
    Add('Actual Result: ' + IntToStr(FCurrentResult));
  Finally
    SaveToFile(IncludeTrailingBackslash(edtResultsFolder.Text) + MakeSafeFilename(ATest.TestName) + '_Results.txt');
    Free;
    lvTests.Items[Index].SubItems[STATUS_COL] := '* ' + lvTests.Items[Index].SubItems[STATUS_COL];
  End;
end;

procedure TfrmMain.AddStatusMessage(ErrorCode: Word);
begin
  with lvTests.Items[FCurrentTest] do
  begin
    if SubItems.Count = STATUS_COL then
      SubItems.Add(' ');

    SubItems[STATUS_COL] := GetStatusDesc(ErrorCode);
  end;

end;

function TfrmMain.GetStatusDesc(ErrorCode: Word): string;
begin
  Case ErrorCode of
    E_BLANK          : Result := '';
    E_RUNNING        : Result := 'Running...';
    E_SUCCESS        : Result := 'Test complete';
    E_INVALID_PARAMS : Result := 'Invalid number of parameters';
    E_OPEN_TOOLKIT   : Result := 'Unable to open toolkit (' + IntToStr(FCurrentResult) + ')';
    E_FILE_NOT_FOUND : Result := 'The filename passed as a parameter was not found';
  end;
  if ErrorCode > E_RUNNING then
    Result := '* ' + Result + ' *';
end;

procedure TfrmMain.cbTestCoChange(Sender: TObject);
begin
  lblTestCo.Caption := GetCompanyName(cbTestDb.Items[cbTestDb.ItemIndex], cbTestCo.Items[cbTestCo.ItemIndex]);
end;

function TfrmMain.GetCompanyName(const dbName, coCode: string): string;
var
  sQuery : AnsiString;
begin
  sQuery := 'SELECT Company_code2 FROM ' + dbName + '.Common.Company WHERE RecPFix = ''C'' ' +
            'AND Cast(SubString(CompanyCode1, 2, 6) as VarChar) = ' + QuotedStr(coCode);
  SQLCaller.Select(sQuery);
  Try
    SQLCaller.Records.First;

    if not SQLCaller.Records.EOF then
      Result := Trim(SQLCaller.Records.FieldByName('Company_code2').AsString)
    else
      Result := '';
  Finally
    SQLCaller.Records.Close;
  End;
end;

procedure TfrmMain.cbRefCoChange(Sender: TObject);
begin
  lblRefCo.Caption := GetCompanyName(cbRefdb.Items[cbRefdb.ItemIndex], cbRefCo.Items[cbRefCo.ItemIndex]);
end;

procedure TfrmMain.btnLoadTestsClick(Sender: TObject);
begin
  if CheckChanges then
  begin
    OpenDialog1.Filename := ExtractFilepath(Application.ExeName) + '*.csv';
    if OpenDialog1.Execute then
    begin
      LoadTestList(OpenDialog1.Filename);
      FAnyChanges := False;
    end;
  end;
end;

procedure TfrmMain.btnSaveClick(Sender: TObject);
begin
  if FTestRunner.ListName = S_UNTITLED then
    btnSaveAsClick(nil)
  else
  begin
    SaveTestList('');
    FAnyChanges := False;
  end;
end;

procedure TfrmMain.btnSaveAsClick(Sender: TObject);
begin
  if SaveDialog1.Execute then
  begin
    SaveTestList(SaveDialog1.Filename);
    SetCaption;
    FAnyChanges := False;
  end;
end;

procedure TfrmMain.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.New1Click(Sender: TObject);
begin
  if CheckChanges then
  begin
    FTestRunner.Clear;
    lvTests.Clear;
    SetCaption;
    FAnyChanges := False;
  end;
end;

procedure TfrmMain.SetCaption;
begin
  Caption := S_APP_TITLE + ' - ' + FTestRunner.ListName + ' - ' + FToolkit.Version;
end;

function TfrmMain.CheckChanges: Boolean;
var
  Res : Integer;
begin
  if FAnyChanges then
  begin
    Res := msgBox('Do you want to save your changes?', mtConfirmation, mbYesNoCancel, mbYes, 'Confirm');
    if Res = mrYes then
      btnSaveClick(nil);

  end
  else
    Res := mrNo;

  Result := Res in [mrYes, mrNo];  //If Cancel then return false so caller can block action.
end;

procedure TfrmMain.CheckTests1Click(Sender: TObject);
begin
  CheckApps(True);
end;

function TfrmMain.CheckApps(ShowOKMessage: Boolean): Boolean;
begin
  Result := FTestRunner.CheckList;
  if Result then
  begin
    if ShowOKMessage then
      ShowMessage('All test applications found');
  end
  else
    ShowMessage('The following test applications were not found:'#10#10 +
                  AnsiReplaceStr(FTestRunner.InvalidList.CommaText, ',', #10));
end;

procedure TfrmMain.FormResize(Sender: TObject);
begin
  lvTests.Width := ClientWidth - lvTests.Left - Panel1.Width;
  lvTests.Height := ClientHeight - 143;
  Panel1.top := 0;
  Panel1.Height := ClientHeight - StatusBar1.Height;
  Panel1.Left := ClientWidth - Panel1.Width;
end;

function TfrmMain.ResultsFolderIsEmpty: Boolean;
const
  Exts : Array[1..2] of string[5] = ('*.xml','*.txt');
var
  SRec : TSearchRec;
  Res : Integer;
  i : integer;
begin
  Result := True;
  i := 1;

  while Result and (i <=2) do
  begin
    Res := FindFirst(IncludeTrailingBackslash(edtResultsFolder.text) + Exts[i], faAnyFile, SRec);
    Try
      Result := Res <> 0;
      inc(i);
    Finally
      FindClose(SRec);
    End;
  end;

  if not Result then
  begin
    if msgBox('There are some files in the results folder. Do you wish to continue anyway?',
              mtConfirmation, [mbYes,mbNo], mbNo, 'Confirm') = mrYes then
        Result := True;
  end;
end;

procedure TfrmMain.DBsToSettings;
begin
  with oIniFile do
  begin
    Items[TEST_DB] := Trim(cbTestDB.Items[cbTestDB.ItemIndex]);
    Items[TEST_CO] := Trim(cbTestCo.Items[cbTestCo.ItemIndex]);
    Items[REF_DB]  := Trim(cbRefDb.Items[cbRefDb.ItemIndex]);
    Items[REF_CO]  := Trim(cbRefCo.Items[cbRefCo.ItemIndex]);
  end;
end;

procedure TfrmMain.SettingsToDBs;

  procedure SetComboBox(const ACombo : TComboBox; const Value : string);
  begin
    if Trim(Value) <> '' then
      ACombo.ItemIndex := ACombo.Items.IndexOf(Trim(Value))
    else
      ACombo.ItemIndex := 0;
  end;

begin
  with oIniFile do
  begin
    SetComboBox(cbTestDB, Items[TEST_DB]);
    SetComboBox(cbRefDB, Items[REF_DB]);

    cbRefDbChange(nil);
    cbTestDbChange(nil);

    SetComboBox(cbTestCo, Items[TEST_CO]);
    SetComboBox(cbRefCo, Items[REF_CO]);
  end;
end;

procedure TfrmMain.lvTestsInfoTip(Sender: TObject; Item: TListItem;
  var InfoTip: String);
begin
  if Item.SubItems.Count > STATUS_COL then
    InfoTip := Trim(Item.SubItems[STATUS_COL]);
end;

procedure TfrmMain.About1Click(Sender: TObject);
begin
  ShowMessage(S_APP_TITLE + ' ' + S_FRAMEWORK_VERSION);
end;

procedure TfrmMain.SetupDatabase1Click(Sender: TObject);
var
  sDb : string;
begin
  FToolkit.Configuration.DataDirectory := GetTestCoPath;
  FToolkit.OpenToolkit;
  Try
    sDb := cbTestDb.Items[cbTestDb.ItemIndex] + '.' + cbTestCo.Items[cbTestCo.ItemIndex];
    AddExtraStockItems(FToolkit, DoProgress);
//    CloseJob(SQLCaller, sDb);
    SetBOMKittingOptions(SQLCaller, sDb);
  Finally
    FToolkit.CloseToolkit;
    DoProgress('Done');
  End;
end;

procedure TfrmMain.btnCheckAllClick(Sender: TObject);
var
  i :  integer;
  Tick : Boolean;
begin
  FAnyChanges := True;
  if btnCheckAll.Tag = 0 then
  begin
    btnCheckAll.Tag := 1;
    Tick := True;
    btnCheckAll.Caption := 'Untick All';
  end
  else
  begin
    btnCheckAll.Tag := 0;
    Tick := False;
    btnCheckAll.Caption := 'Tick All';
  end;

  for i := 0 to lvTests.Items.Count - 1 do
    lvTests.Items[i].Checked := Tick;
end;

end.
