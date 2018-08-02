unit MainFormU;
{
  Unit Tests for the BtrvSQL.DLL. Note that tests for the Emulator itself are
  in a different project (SQLEmulatorTests).
}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, ComCtrls,
  ClientIdU, ExtCtrls;

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
    Panel1: TPanel;
    TestList: TCheckListBox;
    Panel2: TPanel;
    RunningLbl: TLabel;
    RunningAnim: TAnimate;
    ButtonPnl: TPanel;
    RunBtn: TButton;
    SelectAllBtn: TButton;
    SelectNoneBtn: TButton;
    CloseBtn: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SelectAllBtnClick(Sender: TObject);
    procedure SelectNoneBtnClick(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure RunBtnClick(Sender: TObject);
    procedure TestListDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
  private
    ClientIDs: TClientIDs;
    { Unit test support routines }
    procedure AddTest(Test: TTestProcedure; Title: string);
    procedure AddAllTests;
    procedure ClearAllTests;
    procedure SelectAllTests;
    procedure UnselectAllTests;
    procedure SetUp;
    procedure TearDown;
    procedure Fail(FailMsg: string);
    procedure Check(Expression: Boolean; FailMsg: string); overload;
    procedure Check(Expression: Boolean; FailCode: Integer); overload;
    procedure Report(Msg: string; Success: Boolean);
    procedure RunTest(Idx: Integer; Test: TTestProcedure; Title: string);
    procedure RunAllTests;
    procedure ReadSettings;
    procedure WriteSettings;
    { Client ID tests }
    procedure Test_ClientIDs;
    procedure Test_MainThreadRecord;
    procedure Test_AddClientIDLink;
    procedure Test_FindClientIDLink;
    procedure Test_ChangePath;
    procedure Test_RemoveClientIDLink;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$WARN UNIT_PLATFORM OFF}

uses SQLUtils, Inifiles, FileCtrl;

const
  OK     = True;
  FAILED = False;

{$R *.dfm}

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

// =============================================================================
// MainForm
// =============================================================================

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
  AddTest(Test_ClientIDs,          'ClientIDs object');
  AddTest(Test_MainThreadRecord,   'Main thread record');
  AddTest(Test_AddClientIDLink,    'Add Client ID link record');
  AddTest(Test_FindClientIDLink,   'Find Client ID link record');
  AddTest(Test_ChangePath,         'Change path');
  AddTest(Test_RemoveClientIDLink, 'Remove Client ID link record');
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

procedure TMainForm.Fail(FailMsg: string);
begin
  raise Exception.Create(FailMsg);
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
      try
        SetUp;
      except
        on E:Exception do
        begin
          Report('Setup failed - ' + E.Message, FAILED);
          Exit;
        end;
      end;
      Test;
      TestList.Items[Idx] := Title;
      Report('Ok', OK);
    finally
      try
        TearDown;
      except
        on E:Exception do
        begin
          Report('Tear-down failed - ' + E.Message, FAILED);
        end;
      end;
    end;
  except
    on E:Exception do
      Report(E.Message, FAILED);
  end;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.SetUp;
begin
  ClientIDs := TClientIDs.Create;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.TearDown;
begin
  ClientIDs.Free;
end;

// -----------------------------------------------------------------------------

procedure TMainForm.ReadSettings;
var
  Inifile: TInifile;
  i: Integer;
begin
  Inifile := TInifile.Create('BtrvSQLUnitTests.Ini');
  try

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
  Inifile := TInifile.Create('BtrvSQLUnitTests.Ini');
  try
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
// Test routines
// =============================================================================

procedure TMainForm.Test_ClientIDs;
begin
  Check(ClientIds <> nil, 'TClientIDs instance not created');
end;

// -----------------------------------------------------------------------------

procedure TMainForm.Test_MainThreadRecord;
var
  LinkRecord: PClientIDLink;
begin
  LinkRecord := ClientIds.ID(nil);
  Check(LinkRecord <> nil, 'Main thread record not round');
  Check(LinkRecord.IsMainSession, 'Wrong client ID link record returned');
end;

// -----------------------------------------------------------------------------

procedure TMainForm.Test_AddClientIDLink;
var
  ClientID: TClientID;
  LinkRecord: PClientIDLink;
begin
  ClientID.AppId  := 'AA';
  ClientID.TaskId := 1;
  LinkRecord := ClientIDs.AddID(@ClientID, 'C:\TEST\');

  Check(LinkRecord <> nil, 'Record not returned from AddID');
  Check(LinkRecord.Path = 'C:\TEST\', 'Wrong record returned from AddID');
end;

// -----------------------------------------------------------------------------

procedure TMainForm.Test_FindClientIDLink;
var
  LinkRecord: PClientIDLink;
  ClientID: TClientID;
begin
  { Add several records. }
  ClientID.AppId  := 'AA';
  ClientID.TaskId := 1;
  ClientIDs.AddID(@ClientID, 'C:\TEST_ONE\');

  ClientID.AppId  := 'AA';
  ClientID.TaskId := 2;
  ClientIDs.AddID(@ClientID, 'C:\TEST_TWO\');

  ClientID.AppId  := 'AB';
  ClientID.TaskId := 1;
  ClientIDs.AddID(@ClientID, 'C:\TEST_THREE\');

  { Find the second record. }
  ClientID.AppId := 'AA';
  ClientID.TaskId := 2;
  LinkRecord := ClientIDs.ID(@ClientID);

  Check(LinkRecord <> nil, 'Link record not found');
  Check(LinkRecord.Path = 'C:\TEST_TWO\', 'Wrong link record found. Found: ' +
                          'App ID "' + LinkRecord.AppID + '", ' +
                          'Path "'   + LinkRecord.Path + '"');

  { Look for a non-existent record. }
  ClientID.AppId := 'AX';
  ClientID.TaskId := 1;
  LinkRecord := ClientIDs.ID(@ClientID);

  if (LinkRecord <> nil) then
    Fail('Found unexpected record: ' +
         'App ID "' + LinkRecord.AppID + '", ' +
         'Path "'   + LinkRecord.Path + '"');

end;

// -----------------------------------------------------------------------------

procedure TMainForm.Test_ChangePath;
var
  LinkRecord: PClientIDLink;
  ClientID: TClientID;
begin
  { Add several records. }
  ClientID.AppId  := 'AA';
  ClientID.TaskId := 1;
  ClientIDs.AddID(@ClientID, 'C:\TEST_ONE\');

  ClientID.AppId  := 'AA';
  ClientID.TaskId := 2;
  ClientIDs.AddID(@ClientID, 'C:\TEST_TWO\');

  ClientID.AppId  := 'AB';
  ClientID.TaskId := 1;
  ClientIDs.AddID(@ClientID, 'C:\TEST_THREE\');

  { Find the second record, and change the path. }
  ClientID.AppId := 'AA';
  ClientID.TaskId := 2;
  LinkRecord := ClientIDs.ID(@ClientID);
  LinkRecord.Path := 'C:\NEWPATH\';
  LinkRecord := nil;

  { Add another couple of records. }
  ClientID.AppId  := 'ZZ';
  ClientID.TaskId := 1;
  ClientIDs.AddID(@ClientID, 'C:\TEST_FOUR\');

  ClientID.AppId  := 'AC';
  ClientID.TaskId := 4;
  ClientIDs.AddID(@ClientID, 'C:\TEST_FIVE\');

  { Find the record again, and check that it holds the changed path. }
  ClientID.AppId  := 'AA';
  ClientID.TaskId := 2;
  LinkRecord := ClientIDs.ID(@ClientID);
  Check(LinkRecord.Path = 'C:\NEWPATH\', 'Path not changed correctly. Path found is "' + LinkRecord.Path + '"');
end;

// -----------------------------------------------------------------------------

procedure TMainForm.Test_RemoveClientIDLink;
var
  LinkRecord: PClientIDLink;
  ClientID: TClientID;
begin
  { Add several records. }
  ClientID.AppId  := 'AA';
  ClientID.TaskId := 1;
  ClientIDs.AddID(@ClientID, 'C:\TEST_ONE\');

  ClientID.AppId  := 'AA';
  ClientID.TaskId := 2;
  ClientIDs.AddID(@ClientID, 'C:\TEST_TWO\');

  ClientID.AppId  := 'AB';
  ClientID.TaskId := 1;
  ClientIDs.AddID(@ClientID, 'C:\TEST_THREE\');

  { Remove the second record. }
  ClientID.AppId := 'AA';
  ClientID.TaskId := 2;
  ClientIDs.RemoveID(@ClientID);

  { Check that the record no longer exists. }
  LinkRecord := ClientIDs.ID(@ClientID);
  Check(LinkRecord = nil, 'Record still exists.');

end;

// -----------------------------------------------------------------------------

end.
