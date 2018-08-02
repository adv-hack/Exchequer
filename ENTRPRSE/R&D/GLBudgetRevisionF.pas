unit GLBudgetRevisionF;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TCustom, ExtCtrls, uMultiList, TEditVal, GLBudgetHistoryClass, EntWindowSettings,
  Menus;

type
  TfrmGLBudgetRevisions = class(TForm)
    SaveDialog1: TSaveDialog;
    PopupMenu1: TPopupMenu;
    Properties1: TMenuItem;
    N1: TMenuItem;
    SaveCoordinates1: TMenuItem;
    Panel1: TPanel;
    Label81: Label8;
    cbYear: TComboBox;
    cbView: TComboBox;
    Label1: TLabel;
    mlRevisions: TMultiList;
    btnExport: TSBSButton;
    btnClose: TSBSButton;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbYearChange(Sender: TObject);
    procedure cbViewChange(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure Properties1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    //Keep track of list's distance from right and bottom for resizing.
    BottomMargin : Integer;
    RightMargin  : Integer;

    //GL Code and currency
    FGLCode : Integer;
    FCurrency : Integer;

    FBudgetHist : TGLBudgetHistory;
    RevList : TStringList;
    NoOfPeriods : Integer;
    FSettings :IWindowSettings;

    FPrefix : Char; //PR: 19/07/2012 ABSEXCH-13185

    OriginalBudgetColumn : integer;
    procedure SetupList;
    function BuildKeyString : string;
    function GetYearChar : Char;
    procedure PopulateCell(Col: integer; const BudgetObj : TGLBudgetHistory);
    procedure PopulateNoChangeCell(Col, Row : Integer);
    procedure PopulateListWithDetails;
    function RevisionChangeIndex(const ADate : string; APeriod : Byte) :Integer;
    procedure WriteListToFile(const Filename: string);
    function ColumnsForDate(const ADate : string) : Integer;
    function GetNumberOfPeriods : Integer;
  public
    { Public declarations }
    //PR: 19/07/2012 ABSEXCH-13185 Add prefix param
    procedure InitialiseRevisions(ACode : longint; Currency : integer; const ACaption : string; APrefix : Char);
    function LoadYears : Boolean; //Returns false if no records are found
  end;


implementation

{$R *.dfm}
uses
  GlobVar, BtKeys1U, EtDateU, BtrvU2, VarConst, ComnU2;

procedure TfrmGLBudgetRevisions.FormCreate(Sender: TObject);
begin
  //Keep track of list's distance from right and bottom for resizing.
  BottomMargin := ClientHeight - (mlRevisions.Top + mlRevisions.Height);
  RightMargin := ClientWidth - (mlRevisions.Left + mlRevisions.Width);

  //Create instance of BudgetHistory class
  FBudgetHist := TGLBudgetHistory.Create;

  //Create stringlist to hold revisions
  RevList := TStringList.Create;
  RevList.Sorted := True;
  RevList.Duplicates := dupAccept;

  FSettings := GetWindowSettings(Self.Name);
  if Assigned(FSettings) then
    FSettings.LoadSettings;

  if Assigned(FSettings) and not FSettings.UseDefaults then
    FSettings.SettingsToWindow(Self);

  //PR: 19/07/2012 ABSEXCH-13186 Set default font color to navy.
  mlRevisions.Font.Color := clNavy;

end;

procedure TfrmGLBudgetRevisions.FormResize(Sender: TObject);
begin
  //Resize list
  mlRevisions.Height := ClientHeight - (mlRevisions.Top + BottomMargin);
  mlRevisions.Width := ClientWidth - (mlRevisions.Left + RightMargin);
end;

//PR: 19/07/2012 ABSEXCH-13185 Add prefix param
procedure TfrmGLBudgetRevisions.InitialiseRevisions(ACode,
  Currency: integer; const ACaption : string; APrefix : Char);
begin
  FGLCode := ACode;
  FCurrency := Currency;
  Caption := ACaption;
  FPrefix := APrefix;
end;

procedure TfrmGLBudgetRevisions.SetupList;
var
  i, j, ColsForDate : integer;
  Res : Integer;
  KeyS : Str255;
  KeyChk : Str255;

  Budgets : Array of Double;
  RevisedBudgets : Array of Double;

  LastDate : string;
  Col : integer;
  Row : integer;

  yy : Integer;

  //Pad numbers below 10 with a zero
  function ZeroAtFront(Value : Integer) : string;
  begin
    Result := Format('%.2d', [Value]);
  end;

begin
  //Allocate arrays for original budget/ current revised budget
  NoOfPeriods := GetNumberOfPeriods;
  SetLength(Budgets, NoOfPeriods + 1);
  SetLength(RevisedBudgets, NoOfPeriods + 1);

  mlRevisions.Columns.Clear;
  RevList.Clear;
  //Period column
  mlRevisions.Columns.Add;
  mlRevisions.DesignColumns[0].Caption := 'Period';

  yy := (StrToInt(cbYear.Items[cbYear.ItemIndex]) - 1900);
  for i := 1 to NoOfPeriods do
    mlRevisions.DesignColumns[0].Items.Add(PPR_OutPr(i, yy));

  //Current revised value
  mlRevisions.Columns.Add;
  mlRevisions.DesignColumns[1].Caption := 'Current Revised';
  mlRevisions.DesignColumns[1].Alignment := taRightJustify;

  //Read budgets and revised budgets from history table and store in arrays.
  //PR: 19/07/2012 ABSEXCH-13185 Add prefix to deal as it's different for different types of gl accounts.
  KeyS := FPrefix + FullNomKey(FGLCode) + StringOfChar(' ', 16) + Char(FCurrency) + GetYearChar;
  KeyChk := KeyS;

  Res := Find_Rec(B_GetGEq, F[NHistF], NHistF, RecPtr[NHistF]^, 0, Keys);

  While (Res = 0) and (Copy(KeyS, 1, Length(KeyChk)) = KeyChk) do
  begin
    if (NHist.Pr in [1..NoOfPeriods]) then
    begin
      Budgets[NHist.Pr] := NHist.Budget;
      RevisedBudgets[NHist.Pr] := NHist.RevisedBudget1;
    end;

    Res := Find_Rec(B_GetNext, F[NHistF], NHistF, RecPtr[NHistF]^, 0, Keys);
  end;

  //Put current revised budgets into list
  for i := 1 to NoOfPeriods do
    mlRevisions.DesignColumns[1].Items.Add(Format('%8.2n', [RevisedBudgets[i]]));

  //Find revised budget change records and load into string list
  KeyS := BuildKeyString;
  KeyChk := KeyS;

  Res := FBudgetHist.FindRec(B_GetGEq, KeyS);

  while (Res = 0) and (Copy(KeyS, 1, Length(KeyChk)) = KeyChk) do
  begin
    //PR 7/11/2012 ABSEXCH-13679 Check that user hasn't reduced the number of periods - if they have then don't show anything later than
    //highest current period.
    if FBudgetHist.bhPeriod in [1..NoOfPeriods] then
      RevList.AddObject(FBudgetHist.bhDateChanged + ZeroAtFront(FBudgetHist.bhPeriod) + FBudgetHist.bhTimeChanged, FBudgetHist.Clone);

    Res := FBudgetHist.FindRec(B_GetNext, KeyS);
  end;


  i := RevList.Count - 1;
  LastDate := '';
  Col := 2;

  //Add one column for each distinct date or same date/same period combination
  while (i >= 0) do
  begin
    if (LastDate <> Copy(RevList[i], 1, 8)) then
    begin
      //Find out how many colums we need for this date
      ColsForDate := ColumnsForDate(Copy(RevList[i], 1, 8));
      for j := 1 to ColsForDate do
      begin
        mlRevisions.Columns.Add;
        mlRevisions.DesignColumns[Col].Caption := POutDate(Copy(RevList[i], 1, 8));
        mlRevisions.DesignColumns[Col].Field := Copy(RevList[i], 1, 8); //Store date in yyyymmdd for later reference
        mlRevisions.DesignColumns[Col].Alignment := taRightJustify;

        //Fill column with rows
        for Row := 1 to NoOfPeriods do
          mlRevisions.DesignColumns[Col].Items.Add(' ');
        inc(Col);
      end;
    end;

    LastDate := Copy(RevList[i], 1, 8);
    Dec(i);
  end;

  //Add column of original budgets
  mlRevisions.Columns.Add;
  mlRevisions.DesignColumns[Col].Caption := 'Original Budget';
  mlRevisions.DesignColumns[Col].Alignment := taRightJustify;
  OriginalBudgetColumn := Col;

  for i := 1 to NoOfPeriods do
    mlRevisions.DesignColumns[Col].Items.Add(Format('%8.2n', [Budgets[i]]));

  //Put detais into list
  PopulateListWithDetails;

  //Set list colours, fonts, etc.
  if Assigned(FSettings) and not FSettings.UseDefaults then
    FSettings.SettingsToParent(mlRevisions);

  Finalize(Budgets);
  Finalize(RevisedBudgets);
end;

procedure TfrmGLBudgetRevisions.FormDestroy(Sender: TObject);
begin
  if Assigned(FSettings) then
  begin
    FSettings.WindowToSettings(Self);
    FSettings.ParentToSettings(Panel1, cbYear);
    FSettings.SaveSettings(SaveCoordinates1.Checked);
    FSettings := nil;
  end;

  if Assigned(FBudgetHist) then
    FBudgetHist.Free;

  if Assigned(RevList) then
    RevList.Free;

end;

function TfrmGLBudgetRevisions.BuildKeyString: string;
begin
  Result := FullNomKey(FGLCode) + Char(FCurrency) + GetYearChar;
end;

//function to return year from drop down box as a byte (year - 1900, so 101 = 2001, etc.)
function TfrmGLBudgetRevisions.GetYearChar: Char;
begin
  Result := Char(StrToInt(cbYear.Items[cbYear.ItemIndex]) - 1900);
end;

function TfrmGLBudgetRevisions.LoadYears : Boolean;
var
  KeyS, KeyChk : Str255;
  Res : Integer;
  FirstYear, LastYear : Integer;

  //Function to check if we have any change records in this year
  function HaveRecordForYear(Year : Byte) : Boolean;
  begin
    KeyS := FullNomKey(FGLCode) + Char(FCurrency) + Char(Year);
    Res := FBudgetHist.FindRec(B_GetGEq, KeyS);
    Result := (Res = 0) and (FBudgetHist.bhYear = Year);
  end;

begin
  //Find the first and last years for this gl/currency and load
  //them and intervening years into the years dropdown.
  Result := False;

  //Find first year for this currency
  KeyChk := FullNomKey(FGLCode) + Char(FCurrency);
  KeyS := KeyChk;
  Res := FBudgetHist.FindRec(B_GetGEq, KeyS);

  if (Res = 0) and (Copy(KeyS, 1, Length(KeyChk)) = KeyChk) then
  begin
    Result := True;

    //Find last year for this currency
    FirstYear := FBudgetHist.bhYear;
    KeyS := FullNomKey(FGLCode) + Char(FCurrency + 1);
    Res := FBudgetHist.FindRec(B_GetLessEq, KeyS);

    if (Res = 0) and (Copy(KeyS, 1, Length(KeyChk)) = KeyChk) then
      LastYear := FBudgetHist.bhYear
    else
      LastYear := FirstYear;

    //Load years from first to last into dropdown
    Repeat
      if HaveRecordForYear(FirstYear) then
        cbYear.Items.Add(IntToStr(FirstYear + 1900));
      inc(FirstYear);
    until (FirstYear > LastYear);

    cbYear.ItemIndex := cbYear.Items.Count - 1;

    //Build list
    SetupList;
  end;
end;

procedure TfrmGLBudgetRevisions.PopulateCell(Col : integer; const BudgetObj : TGLBudgetHistory);
var
  ValueStr : string;
begin
  //Fill in a cell which has a change. Take value or change from BudgetObj, depending upon view dropdown
  if cbView.ItemIndex in [0, 1] then
    ValueStr := Format('%8.2n', [BudgetObj.bhValue])
  else
    ValueStr := Format('%8.2n', [BudgetObj.bhChange]);

  mlRevisions.DesignColumns[Col].Items[BudgetObj.bhPeriod - 1] := ValueStr;
end;

procedure TfrmGLBudgetRevisions.PopulateNoChangeCell(Col, Row: Integer);
begin
  //Fill in a cell which has no change. If showing all then take the previous value (i.e. cell to the right); if showing changes/differences only,
  //show 0.
  if cbView.ItemIndex = 0 then
  begin
    mlRevisions.DesignColumns[Col].Items[Row - 1] := mlRevisions.DesignColumns[Col + 1].Items[Row - 1];

  end
  else
    mlRevisions.DesignColumns[Col].Items[Row - 1] := '0.00';
end;

procedure TfrmGLBudgetRevisions.cbYearChange(Sender: TObject);
begin
  SetupList;
end;

procedure TfrmGLBudgetRevisions.cbViewChange(Sender: TObject);
begin
  PopulateListWithDetails;
end;

procedure TfrmGLBudgetRevisions.PopulateListWithDetails;
var
  Col, Row : Integer;
  idx : Integer;
  Revision : Integer;
  FBudgetHist : TGLBudgetHistory;

  function CellIsEmpty(ACol, ARow : Integer) : Boolean;
  begin
    Result := Trim(mlRevisions.DesignColumns[ACol].Items[ARow]) = '';
  end;

  //Searching from right, find the first empty column for this date and period
  function FindCol(ARow : Integer) : Integer;
  begin
    Result := mlRevisions.Columns.Count - 2;
    while (Result >= 0) and
            (  //PR: 30/07/2012 ABSEXCH-12199 Was using Columns property causing crash if columns moved - change to use DesignColumns 
              (mlRevisions.DesignColumns[Result].Field <> FBudgetHist.bhDateChanged) or
              ((mlRevisions.DesignColumns[Result].Field = FBudgetHist.bhDateChanged) and not CellIsEmpty(Result, ARow))
             ) do
                Dec(Result);
  end;


  procedure ClearCell(ACol, ARow : Integer);
  begin
    mlRevisions.DesignColumns[ACol].Items[ARow] := '';
  end;

begin
  //Clear all cells
  for Col := mlRevisions.Columns.Count - 2 downto 2 do
    for Row := 1 to NoOfPeriods do
        ClearCell(Col, Row - 1);

  //iterate through list of objects and put values into correct cells
  For Revision := 0 to RevList.Count - 1 do
  begin
    FBudgetHist := TGLBudgetHistory(RevList.Objects[Revision]);
    Col := FindCol(FBudgetHist.bhPeriod - 1);

    if (Col >= 2) then
      PopulateCell(Col, FBudgetHist)
    else
      raise ERangeError.Create('Column index out of range (' + IntToStr(Col) + ').');
  end;

  //Now fill in any cells which weren't populated
  for Col := mlRevisions.Columns.Count - 2 downto 2 do
    for Row := 1 to NoOfPeriods do
      if CellIsEmpty(Col, Row - 1) then
        PopulateNoChangeCell(Col, Row);

end;

function TfrmGLBudgetRevisions.RevisionChangeIndex(const ADate : string; APeriod : Byte) :Integer;
var
  idx : integer;
  Found : Boolean;
begin
  //Find the index of a revised budget change in the list.
  Result := -1;
  Found := False;
  idx := RevList.IndexOf(ADate);
  if idx >= 0 then
  begin
    while not Found and (idx < RevList.Count) and (ADate = RevList[idx]) do
    begin
      Found := TGLBudgetHistory(RevList.Objects[idx]).bhPeriod = APeriod;

      if Found then
        Result := idx
      else
        inc(idx);
    end;

  end;
end;


procedure TfrmGLBudgetRevisions.btnExportClick(Sender: TObject);
begin
  if SaveDialog1.Execute then
    WriteListToFile(SaveDialog1.Filename);
end;

procedure TfrmGLBudgetRevisions.WriteListToFile(const Filename: string);
var
  Col, Row : Integer;
  s : string;
begin
  with TStringList.Create do
  Try
    s := '';
    for Col := 0 to mlRevisions.Columns.Count -1 do
      s := s + mlRevisions.DesignColumns[Col].Caption + ',';

    System.Delete(s, Length(s), 1);
    Add(s);

    for Row := 0 to NoOfPeriods - 1 do
    begin
      s := '';
      for Col := 0 to mlRevisions.Columns.Count -1 do
        s := s + mlRevisions.DesignColumns[Col].Items[Row] + ',';

      System.Delete(s, Length(s), 1);
      Add(s);
    end;
  Finally
    SaveToFile(Filename);
    Free;
  End;
end;

procedure TfrmGLBudgetRevisions.Properties1Click(Sender: TObject);
begin
  if Assigned(FSettings) then
    FSettings.Edit(mlRevisions, mlRevisions);
end;

procedure TfrmGLBudgetRevisions.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  FSettings.WindowToSettings(Self);
  FSettings.ParentToSettings(mlRevisions, mlRevisions);
  FSettings.SaveSettings(SaveCoordinates1.Checked);
  FSettings := nil;
end;

//Function to calculate the number of colums we need for a given date. This is done by working out which period has most records for this date.
//The RevList strings are formatted date/period/time (yyyymmddpphhnnss) so Copy(1, 8) gives us the date and Copy(9, 2) gives us the period.
function TfrmGLBudgetRevisions.ColumnsForDate(const ADate: string): Integer;
var
  i, iCount : integer;
  CurrentPeriod : Integer;
begin
  Result := 0;
  i := RevList.Count - 1;
  iCount := 0;
  CurrentPeriod := StrToInt(Copy(RevList[i], 9, 2));

  while (i > 0) and (ADate <> Copy(RevList[i], 1, 8)) do
    dec(i);

  while (i >= 0) and (ADate = Copy(RevList[i], 1, 8)) do
  begin
     if StrToInt(Copy(RevList[i], 9, 2)) = CurrentPeriod then
     begin
       inc(iCount);
     end
     else
     begin
       if iCount > Result then
         Result := iCount;
       iCount := 1;
       CurrentPeriod := StrToInt(Copy(RevList[i], 9, 2));
     end;
     dec(i);
  end;
  if iCount > Result then
    Result := iCount;
end;

function TfrmGLBudgetRevisions.GetNumberOfPeriods: Integer;
var
  KeyS : Str255;
  KeyChk : Str255;
  Res :Integer;
begin
  Result := Syss.PrInYr;
  //PR: 19/11/2012 ABSEXCH-13682. Check how many budget records there are in history for this year, in
  //case periods in year has been changed.
  KeyS := FPrefix + FullNomKey(FGLCode) + StringOfChar(' ', 16) + Char(FCurrency) + GetYearChar + 'z';
  KeyChk := Copy(KeyS, 1, Length(KeyS) - 1);

  Res := Find_Rec(B_GetLessEq, F[NHistF], NHistF, RecPtr[NHistF]^, 0, Keys);

  if (Res = 0) and (Copy(KeyS, 1, Length(KeyChk)) = KeyChk) then
    Result:= NHist.Pr;
end;

end.
