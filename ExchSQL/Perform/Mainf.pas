unit Mainf;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TCustom, ComCtrls, ExtCtrls, TestObj;

const
  S_PT_VERSION = 'v5.71.002';
  I_COL_POS : Array[False..True] of Integer = (0, 1);


type
  TfrmMain = class(TForm)
    Panel1: TPanel;
    lvTests: TListView;
    pnlStatus: TPanel;
    btnGo: TSBSButton;
    btnSave: TSBSButton;
    btnClose: TSBSButton;
    SaveDialog1: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure btnGoClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure lvTestsInfoTip(Sender: TObject; Item: TListItem;
      var InfoTip: String);
  private
    { Private declarations }
    FCurrentTest : Integer;
    procedure DoProgress(Sender : TObject; const sMessage : string;
                               FileNo : Integer; StatusPanel : Boolean);
    procedure LoadIniFile;
    procedure RunTest(ThisItem : Integer);
    procedure SaveToCSVFile(const FName : string);
  public
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

{ TfrmMain }


procedure TfrmMain.LoadIniFile;
var
  i : integer;
  F : TextFile;
  s : string;
begin
  AssignFile(F, ChangeFileExt(Application.ExeName, '.ini'));
  Reset(F);
  Try
    while not EOF(F) do
    begin
      ReadLn(F, s);
      with lvTests.Items.Add do
      begin
        Caption := s;
        SubItems.Add('');
        SubItems.Add('');
        SubItems.Add('');
        Checked := True;
      end;
    end;
  Finally
    CloseFile(F);
  End;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Caption := Application.Title + ' ' + S_PT_VERSION;
  LoadIniFile;
  TestObject.OnProgress := DoProgress;
end;

procedure TfrmMain.RunTest(ThisItem: Integer);
var
  Col : Integer;
begin
  FCurrentTest := ThisItem;
  Try
    TestObject.RunTest(ThisItem);
    lvTests.Items[ThisItem].SubItems[I_COL_POS[TestObject.ClientIDOn]] :=
                                          IntToStr(TestObject.TimeTaken) + 'ms';
    if TestObject.TotalRecs > 0 then
      lvTests.Items[ThisItem].SubItems[2] := IntToStr(TestObject.TotalRecs);
  Except
    on E:Exception do
      lvTests.Items[ThisItem].SubItems[I_COL_POS[TestObject.ClientIDOn]] :=
                                          E.Message;
  End;

  lvTests.Refresh;
  Application.ProcessMessages;
end;

procedure TfrmMain.btnGoClick(Sender: TObject);
var
  i : Integer;
  ClientIDOn : Boolean;
begin
  for ClientIDOn := False To True do
  begin
    TestObject.ClientIDOn := ClientIDOn;
    for i := 0 to lvTests.Items.Count - 1 do
    begin
      if lvTests.Items[i].Checked then
        RunTest(i);
      if i = 0 then //After open/close, or if open/close not run, we need to open files for later tests
      begin
        TestObject.OnProgress := nil;
        TestObject.OpenAllFiles;
        TestObject.OnProgress := DoProgress;
      end;
      pnlStatus.Caption := '';
      pnlStatus.Refresh;
      Application.ProcessMessages;
    end; // for i
    TestObject.CloseAllFiles;
  end; //for ClientIDOn
  SaveToCSVFile(ExtractFilePath(Application.ExeName) + 'SQLTest.log');
  ShowMessage('Tests completed');
end;

procedure TfrmMain.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.DoProgress(Sender: TObject; const sMessage: string;
  FileNo : Integer; StatusPanel : Boolean);
begin
  if not StatusPanel then
  begin
    lvTests.Items[FCurrentTest].SubItems[I_COL_POS[TestObject.ClientIDOn]] := IntToStr(FileNo);
    lvTests.Refresh;
  end
  else
  begin
    pnlStatus.Caption := 'Reading record ' + IntToStr(FileNo);
    pnlStatus.Refresh;
  end;
  Application.ProcessMessages;
end;



procedure TfrmMain.SaveToCSVFile(const FName: string);
var
  i : Integer;
  F : TextFile;

  function RemoveTimeChars(const s : string) : string;
  begin
    Result := s;
    Delete(Result, Length(s) - 1, 2);
  end;
begin
  AssignFile(F, FName);
  Rewrite(F);
  WriteLn(F, 'Test,Standard,Client ID');
  for i := 0 to lvTests.Items.count - 1 do
  begin
    with lvTests.Items[i] do
    if Checked then
      WriteLn(F, Format('%s,%s,%s', [Caption, RemoveTimeChars(SubItems[0]),
                                              RemoveTimeChars(SubItems[1])]));
  end;
  CloseFile(F);
end;

procedure TfrmMain.btnSaveClick(Sender: TObject);
begin
  if SaveDialog1.Execute then
    SaveToCSVFile(SaveDialog1.FileName);
end;

procedure TfrmMain.lvTestsInfoTip(Sender: TObject; Item: TListItem;
  var InfoTip: String);
//Show full text of error messages written to the listview
begin
  if Pos('Error', Item.SubItems[0]) <> 0 then
    InfoTip := Item.SubItems[0]
  else
  if Pos('Error', Item.SubItems[1]) <> 0 then
    InfoTip := Item.SubItems[1]
  else
    InfoTip := '';
end;

end.
