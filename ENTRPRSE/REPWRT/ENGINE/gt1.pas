unit gt1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GuiEng, StdCtrls, Globtype;

type
  TfrmGuiTest = class(TForm)
    Button1: TButton;
    ListBox1: TListBox;
    Label1: TLabel;
    Edit1: TEdit;
    Button2: TButton;
    Edit2: TEdit;
    Button3: TButton;
    edtSampleCount: TEdit;
    Label2: TLabel;
    chkTestMode: TCheckBox;
    lblFP: TLabel;
    lblLP: TLabel;
    chkRefreshFirst: TCheckBox;
    chkRefreshLast: TCheckBox;
    Label3: TLabel;
    Button4: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
    Engine : TReportWriterEngine;
    tc : longint;
    bAbort : Boolean;
    FP, LP : longint;
    procedure GotRecs(Sender : TObject);
    procedure CheckRecord(Count, Total : Integer; var Abort : Boolean);
    function GetCustomValue(const ValueIdentifier, ValueName : string; var ErrCode : SmallInt;
                              var ErrorString : ShortString;
                              var ErrorWord : ShortString) : ResultValueType;
  public
    { Public declarations }
  end;

var
  frmGuiTest: TfrmGuiTest;

implementation

{$R *.dfm}

procedure TfrmGuiTest.GotRecs(Sender : TObject);
var
  i : integer;
  s : string;
  Res : Boolean;
  CP : Double;

  ErrCode : SmallInt;
begin
  i := GetTickCount - tc;
//  ShowMessage('Done: ' + IntToStr(i div 1000) + ' seconds');
  Res := Engine.GetFirst;

  while Res do
  begin
    s := '';
    for i := 0 to Engine.FieldCount - 1 do
      if Engine.Fields[i].Print then
        s := s + Engine.Fields[i].Value + ' '
      else
        s := s + ' * Not Printed * ';

{     if ListBox1.Items.Count < 4 then
      for i := 0 to Engine.FieldCount - 1 do
      begin
        if Assigned(Engine.Fields[i].DrillDownInfo) then
          with Engine.Fields[i].DrillDownInfo do
            ShowMessage('FileNo: ' + IntToStr(FileNo) + #10 +
                        'IndexNo: ' + IntToStr(IndexNo) + #10 +
                        'KeyString: ' + KeyString);
      end;
   CP := Engine.CustomParse('Blah[123]', ['Blah'], GetCustomValue, ErrCode);

    s := s + '  ' + FloatToStr(CP); }

    ListBox1.Items.Add(s);


    Res := Engine.GetNext;
  end;

  Res := Engine.GetPrevious;

  while Res do
  begin
    s := '';
    for i := 0 to Engine.FieldCount - 1 do
      if Engine.Fields[i].Print then
        s := s + Engine.Fields[i].Value + ' '
      else
        s := s + ' * Not Printed * ';

{    if ListBox1.Items.Count < 4 then
      for i := 0 to Engine.FieldCount - 1 do
      begin
        if Assigned(Engine.Fields[i].DrillDownInfo) then
          with Engine.Fields[i].DrillDownInfo do
            ShowMessage('FileNo: ' + IntToStr(FileNo) + #10 +
                        'IndexNo: ' + IntToStr(IndexNo) + #10 +
                        'KeyString: ' + KeyString);
      end;}
{    CP := Engine.CustomParse('Blah[123]', ['Blah'], GetCustomValue, ErrCode);

    s := s + '  ' + FloatToStr(CP); }

    ListBox1.Items.Add(s);


    Res := Engine.GetPrevious;
  end;

  ShowMessage(IntToStr(Engine.RecordCount));
end;

procedure TfrmGuiTest.Button1Click(Sender: TObject);
begin
  Engine.FirstPos := FP;
  Engine.LastPos := LP;
  ListBox1.Items.Clear;
  //Set file number & index
  Engine.FileNo := 1; //transacitons
  Engine.IndexNo := 0; //no index - step through

  Engine.ClearFields;

  with Engine.AddField do
  begin
    VarName := 'ACCOMP';
    SortOrder := '1A';
{    PrintFilter := Edit1.Text;}
  end;

  with Engine.AddField do
  begin
    CalcField := True;
    Calculation := Edit1.Text;
  end;

{  with Engine.AddField do
  begin
    VarName := 'ACPRBAL';
    DecPlaces := 2;
    Period := '5';
    Year := '2000';
  end;}

{  with Engine.AddField do
  begin
    VarName := 'SYSTODAY';
  end;

  with Engine.AddField do
  begin
    VarName := 'THDATEDU';
  end;

 }

(*  with Engine.AddField do
  begin
    CalcField := True;
    DecPlaces := 2;
{//    Calculation := 'IF(DBF[ACACC] = "CASH01", DBF[ACACC], DBF[ACCOMP])';
    Calculation := 'SUBSTRING(DBF[ACCOMP], 2, 7)';
//    Calculation := 'TRUNC[DBF[ACPRBAL]]';
    Period := 'YTD';
    Year := '2003';}
    Calculation := Edit2.Text;
//    Calculation := 'R1[1,2]';
  end;

  with Engine.AddField do
  begin
    VarName := 'THOSBASE';
//    SortOrder := '1A';
    PrintFilter := #10 + Edit1.Text;
  end;

{  with Engine.AddField do
  begin
    VarName := 'ACACC';
    Name := 'Account';
    SortOrder := '1A';
//    Filter := 'FML[TruncBalTimes2Plus10] < 11';
  end;}
         *)
{  with Engine.AddField do
  begin
    VarName := 'ACCOMP';
    Name := 'Name';
  end;}

{  with Engine.AddField do
  begin
    VarName := 'ACPRBAL';
    DecPlaces := 2;
    Period := 'YTD';
    Year := '';
    Name := 'Balance';
    PeriodField := True;
  end;}

{  with Engine.AddField do
  begin
    CalcField := True;
    DecPlaces := 2;
    Calculation := 'TRUNC[DBF[ACPRBAL]]';
    Name := 'TruncBal';
    Period := 'YTD';
    Year := '';
    PeriodField := True;
  end;}

{  with Engine.AddField do
  begin
    CalcField := True;
    DecPlaces := 2;
    Calculation := 'IF[DBF[ACACTYPE] = "C",DBF[ACPRBAL],0]';
    Name := 'TruncBalTimes2';
    Period := 'YTD';
    Year := '';
    PeriodField := True;
  end;

  with Engine.AddField do
  begin
    CalcField := True;
    DecPlaces := 2;
    Calculation := 'FML[TruncBalTimes2] + 10';
    Name := 'TruncBalTimes2Plus10';
  end;}

{  with Engine.AddField do
  begin
    CalcField := True;
    DecPlaces := 2;
    Calculation := 'FML[TruncBalTimes2Plus10] - FML[TruncBal]';
    Name := 'TruncBalTimes2MinusTruncBal';
  end;}

(*  with Engine.AddField do
  begin
    VarName := 'THOURREF';
//    SortOrder := '1A';
//    Filter := Edit1.Text;
  end;

  with Engine.AddField do
  begin
    VarName := 'THDATE';
//    SortOrder := '1A';
//    Filter := Edit1.Text;
  end;

  with Engine.AddField do
  begin
    CalcField := True;
    Calculation := 'DateToNumber(DBF[THDATE])';
    DecPlaces := 0;
  end;

{  with Engine.AddField do
  begin
    CalcField := True;
    Calculation := Edit2.Text;
    DecPlaces := 0;
  end;}

  with Engine.AddField do
  begin
    CalcField := True;
    Calculation := Edit2.Text;
    DecPlaces := 0;
  end; *)


  Engine.TestMode := chkTestMode.Checked;
  Engine.SampleCount := StrToIntDef(edtSampleCount.Text, 0);

  tc := GetTickCount;
  Engine.Execute;
  lblFP.Caption := IntToStr(Engine.FirstPos);
  lblLP.Caption := IntToStr(Engine.LastPos);
  FP := Engine.FirstPos;
  LP := Engine.LastPos;
  GotRecs(Self);
//  Label3.Caption := IntToStr(ListBox1.Items.Count);
//  ShowMessage(Engine.Fields[0].Filter);
end;

procedure TfrmGuiTest.CheckRecord(Count, Total : Integer; var Abort : Boolean);
begin
   Label1.Caption := IntToStr(Count) + '/' + IntToStr(Total);
   Label1.Refresh;
   Application.ProcessMessages;
   Abort := bAbort;
end;

procedure TfrmGuiTest.FormCreate(Sender: TObject);
begin
  //Create RW Engine
  Engine := TReportWriterEngine.Create;
  Engine.OnCheckRecord := CheckRecord;
  bAbort := False;
end;

procedure TfrmGuiTest.FormDestroy(Sender: TObject);
begin
  Engine.Free;
end;

procedure TfrmGuiTest.Button2Click(Sender: TObject);
var
  Res : Integer;
begin
//  Engine.FileNo := 1;
  Res := Engine.ValidateFilter(Edit1.text);

  if Res = 0 then
    ShowMessage('OK')
  else
    ShowMessage('Eek: ' + IntToStr(Res) + #10#10 + Engine.ValidationErrorString + #10 +
      Engine.ValidationErrorWord);
end;

procedure TfrmGuiTest.Button3Click(Sender: TObject);
var
  Res : Integer;
begin
  Engine.FileNo := 1;
  Res := Engine.ValidateCalculation(Edit2.text);

  if Res = 0 then
    ShowMessage('OK')
  else
    ShowMessage('Eek: ' + IntToStr(Res) + #10#10 + Engine.ValidationErrorString);
end;

function TfrmGuiTest.GetCustomValue(const ValueIdentifier,
  ValueName: string; var ErrCode : SmallInt; var ErrorString : ShortString;
                              var ErrorWord : ShortString): ResultValueType;
var
  TmpDouble : Double;
  Code : integer;
begin
  ErrCode := 1;
  if ValueIdentifier = 'BLAH' then
    Result.DblResult  := 12
  else
  if ValueIdentifier = 'EEK' then
    Result.DblResult := 17.5
  else
  if ValueIdentifier = 'WOO' then
  begin
    Val(ValueName, TmpDouble, Code);
    if Code = 0 then
      Result.DblResult := TmpDouble
    else
      Result.DblResult := 0;
  end;
end;

procedure TfrmGuiTest.Button4Click(Sender: TObject);
var
  Res : ResultValueType;
  Err : SmallInt;
begin
  Res := Engine.CustomParse(Edit1.Text, ['Blah', 'Eek', 'Woo'], GetCustomValue, Err);

  if Err = 0 then
    ShowMessage(Format('%8.2f', [Res.DblResult]))
  else
    ShowMessage('Error ' + IntToStr(Err) + #10 +
                  Engine.ValidationErrorString);
end;

end.
