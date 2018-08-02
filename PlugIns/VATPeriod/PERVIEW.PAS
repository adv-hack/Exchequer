unit PerView;

{ nfrewer440 15:19 19/11/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, Enterprise01_TLB,
  ComCtrls, StdCtrls, Grids, AutoFill, ExtCtrls, Menus, ActnList, PerSet, CTKUtil, APIUtil;

type

  TfrmPeriodList = class(TForm)
    lvwPeriods: TListView;
    mnuMain: TMainMenu;
    mniFile: TMenuItem;
    sbrLastDate: TStatusBar;
    mniExit: TMenuItem;
    N1: TMenuItem;
    mniSave: TMenuItem;
    mniReload: TMenuItem;
    mniEdit: TMenuItem;
    mniAutoFill: TMenuItem;
    mniInsertItem: TMenuItem;
    mniEditItem: TMenuItem;
    mniDeleteItem: TMenuItem;
    mnuPopup: TPopupMenu;
    mniPopupAutoFill: TMenuItem;
    mniPopUpInsert: TMenuItem;
    mniPopupEdit: TMenuItem;
    mniPopUpDelete: TMenuItem;
    aclActions: TActionList;
    actAutoFill: TAction;
    actInsert: TAction;
    actEdit: TAction;
    actDelete: TAction;
    actEditLastDate: TAction;
    mniPopupEditLastDate: TMenuItem;
    mniEditLastDate: TMenuItem;
    actUndoAutoFill: TAction;
    N2: TMenuItem;
    UndoAutoFill1: TMenuItem;
    N3: TMenuItem;
    UndoAutoFill2: TMenuItem;
    N4: TMenuItem;
    mniExport: TMenuItem;
    mniHelp: TMenuItem;
    mniAbout: TMenuItem;
    cmbCompany: TComboBox;
    Label1: TLabel;
    btnInsert: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    btnSave: TButton;
    btnClose: TButton;
    lMaxPeriods: TLabel;
    cbUsePlugIn: TCheckBox;
    Bevel1: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure mniExitClick(Sender: TObject);
    procedure mniSaveClick(Sender: TObject);
    procedure mniReloadClick(Sender: TObject);
    procedure actAutoFillExecute(Sender: TObject);
    procedure actInsertExecute(Sender: TObject);
    procedure actEditExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actEditLastDateExecute(Sender: TObject);
    procedure actUndoAutoFillExecute(Sender: TObject);
    procedure mniExportClick(Sender: TObject);
    procedure lvwPeriodsKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure mniAboutClick(Sender: TObject);
    procedure lvwPeriodsChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure cmbCompanyChange(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure cbUsePlugInClick(Sender: TObject);
  private
    fDataChanged : boolean;         // Whether the data has been edited
    fLastDate: TDateTime;           // The last date
    iMaxNoPeriods, PrevItemIndex, fLastAutoFillItem, fFirstAutoFillItem : integer;
    procedure SetLastDate(const Value: TDateTime);
    procedure SetInteger(Index, Value : integer);
    procedure SetDataChanged(const Value: boolean);
    procedure FillCompanyList(cmbComp : TComboBox);
    procedure GetMaxPeriods;
  protected
    function  ValidatePeriods : boolean;
    procedure WriteToINIFile;
    procedure ReadFromINIFile;
    function  EditPeriodValues(var ItemPeriod, ItemYear : integer;
      var ItemStartDate : TDateTime; ProcessMode : TProcessMode = prcEdit) : boolean;
    function  AddPeriod(Period, Year : integer; StartDate : TDateTime;
                Position : integer = -1) : integer;
    procedure AutoFillList(StartDate, EndDate : TDateTime;
                Year, FirstPeriod, PeriodLength : integer; PeriodType : TPeriodType);
   public
    class function ErrorDesc(ErrorCode : integer) : string;
    property LastDate : TDateTime read fLastDate write SetLastDate;
    property DataChanged : boolean read fDataChanged write SetDataChanged;
    property FirstAutoFillItem : integer index 1 read fFirstAutoFillItem write SetInteger;
    property LastAutoFillItem : integer index 2 read fLastAutoFillItem write SetInteger;
  end;


var
  frmPeriodList: TfrmPeriodList;

implementation

{$R *.DFM}



//------------------------------------------------------------------------------------

procedure TfrmPeriodList.SetInteger(Index, Value : integer);
begin
  case Index of
    1: begin
         fFirstAutoFillItem := Value;
         actUndoAutoFill.Enabled := Value <> -1;
       end;
    2: fLastAutoFillItem := Value;
  end;
end; // TfrmPeriodList.SetInteger

//------------------------------------------------------------------------------------

procedure TfrmPeriodList.SetDataChanged(const Value: boolean);
begin
  fDataChanged := Value;
  if Value then
  begin
    // Editing the data invalidates AutoFill Undo
    FirstAutoFillItem := -1;
    LastAutoFillItem := -1;
  end;
end;

//------------------------------------------------------------------------------------

function TfrmPeriodList.EditPeriodValues(var ItemPeriod, ItemYear : integer;
  var ItemStartDate : TDateTime; ProcessMode : TProcessMode = prcEdit) : boolean;
begin
  with TfrmPeriodSet.Create(self) do
  try
    Period := ItemPeriod;
    Year := ItemYear;
    SelDate := ItemStartDate;
    Result := ShowModal = mrOK;
    if Result then
    begin
      ItemPeriod := Period;
      ItemYear := Year;
      ItemStartDate := SelDate;
    end;
  finally
    Release;
  end;
end; // TfrmPeriodList.EditPeriodValues

//------------------------------------------------------------------------------------

class function TfrmPeriodList.ErrorDesc(ErrorCode : integer) : string;
begin
  case ErrorCode of
    2: Result := 'File not found';
    3: Result := 'Path not found';
    4: Result := 'Too many open files';
    5: Result := 'File access denied';
  end;
end;

//------------------------------------------------------------------------------------

procedure TfrmPeriodList.SetLastDate(const Value: TDateTime);
begin
  fLastDate := Value;
  sbrLastDate.Panels[1].Text := DateToStr(Value);
end;

//------------------------------------------------------------------------------------

procedure TfrmPeriodList.WriteToINIFile;
begin
end; // TfrmPeriodList.WriteToINIFile

//------------------------------------------------------------------------------------

procedure TfrmPeriodList.ReadFromINIFile;
begin
end; // TfrmPeriodList.ReadFromINIFile

//------------------------------------------------------------------------------------

procedure TfrmPeriodList.FormCreate(Sender: TObject);
begin
  FirstAutoFillItem := -1;
  LastAutoFillItem := -1;
end;

//------------------------------------------------------------------------------------

procedure TfrmPeriodList.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if DataChanged then
    CanClose := MessageDlg('None of the changes you have made will be saved.' + #13#10 +
                  'Is this OK?', mtConfirmation, [mbYes, mbNo], 0) = mrYes;
end;

//------------------------------------------------------------------------------------

function TfrmPeriodList.AddPeriod(Period, Year : integer; StartDate : TDateTime;
           Position : integer = -1) : integer;
// Action : Adds a line to the list view
// Post   : Returns the index of the item added to the list view
var
  ListItem : TListItem;
begin
  if Period <= iMaxNoPeriods then
    begin
      with lvwPeriods do
      begin
        if Position = -1 then
          ListItem := lvwPeriods.Items.Add
        else
          ListItem := lvwPeriods.Items.Insert(Position);
        ListItem.Caption := IntToStr(Period);
        ListItem.SubItems.Add(IntToStr(Year));
        ListItem.SubItems.Add(DateToStr(StartDate));
        Result := ListItem.Index
      end;
    end
  else begin
    MsgBox('You cannot add any more periods, because the maximum number of periods will then be exceeded.' +
    #13#13 + 'To change the number of periods, you must open Exchequer and Run the Menu Option : Utilities - System Setup - General Setttings'
    ,mtInformation,[mbOK],mbOK,'Maximum Periods : ' + IntTostr(iMaxNoPeriods));
    Result := -1;
  end;{if}
end; // TfrmPeriodList.AddPeriod

//------------------------------------------------------------------------------------

procedure TfrmPeriodList.AutoFillList(StartDate, EndDate : TDateTime;
            Year, FirstPeriod, PeriodLength : integer; PeriodType : TPeriodType);
// Pre : StartDate is the date of the first period
//       EndDate is the date that the periods should run up to
const
  DAYS_PER_WEEK = 7;
var
  PeriodStartDate : TDateTime;
  Period,
  CurItem : integer;
begin
  DataChanged := true;
  PeriodStartDate := StartDate;
  Period := FirstPeriod;
  FirstAutoFillItem := -1;
  CurItem := -1;

  case PeriodType of
    perWeeks   : PeriodLength := PeriodLength * DAYS_PER_WEEK;
    perPeriods : PeriodLength := Trunc((Round(EndDate - StartDate +1)) / PeriodLength);
  end;

  while (PeriodStartDate < EndDate) and (Period < 100) do
  begin
    CurItem := AddPeriod(Period, Year, PeriodStartDate);
    if CurItem = -1 then Break;
    if FirstAutoFillItem = -1 then
      FirstAutoFillItem := CurItem;
    if PeriodType = perMonths then
      PeriodStartDate := IncMonth(PeriodStartDate, PeriodLength) // PeriodLength = months
    else
      PeriodStartDate := PeriodStartDate + PeriodLength; // PeriodLength = days
    inc(Period);
  end;
  fLastAutoFillItem := CurItem;
  if EndDate > LastDate then
    LastDate := EndDate;
end; // TfrmPeriodList.AutoFillList

//------------------------------------------------------------------------------------

procedure TfrmPeriodList.mniExitClick(Sender: TObject);
begin
  Close;
end;

//------------------------------------------------------------------------------------

procedure TfrmPeriodList.mniSaveClick(Sender: TObject);
begin
  if MessageDlg('About to save the changes.' + #13#10 +
                'Is this OK?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    if ValidatePeriods then
    begin
      WriteToIniFile;
      DataChanged := false;
    end;
  end;
end;

//------------------------------------------------------------------------------------

procedure TfrmPeriodList.mniReloadClick(Sender: TObject);
begin
  if MessageDlg('About to re-load the saved periods.' + #13#10 +
                'Is this OK?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    lvwPeriods.Items.Clear;
    ReadFromINIFile;
  end;
end; // TfrmPeriodList.mniReloadClick

//------------------------------------------------------------------------------------

procedure TfrmPeriodList.actAutoFillExecute(Sender: TObject);
begin
  with TfrmAutoFill.Create(self) do
    try
      if ShowModal = mrOK then
        AutoFillList(StartDate, EndDate, Year, PeriodStart, PeriodLength, PeriodType);
    finally
      Release;
    end;
end; // TfrmPeriodList.actAutoFillExecute(Sender: TObject);

//------------------------------------------------------------------------------------

procedure TfrmPeriodList.actInsertExecute(Sender: TObject);
var
  CurDay, CurMonth, CurYear : word;
  LineNum,
  Period,
  Year    : integer;
  StartDate : TDateTime;
begin
  if Assigned(lvwPeriods.Selected) then
    with lvwPeriods.Selected do
    begin // A list view line is selected, but we're adding
      LineNum := lvwPeriods.Selected.Index;
      // Give default values from the selected line
      Period := StrToInt(Caption);
      Year := StrToInt(SubItems[0]);
      StartDate := StrToDate(SubItems[1]);
    end
  else
  begin  // No list view lines are selected
    LineNum := -1;
    if lvwPeriods.Items.Count > 0 then
      with lvwPeriods.Items[lvwPeriods.Items.Count -1] do
      begin // Give default values from the last line
        Period := StrToInt(Caption) +1;
        Year := StrToInt(SubItems[0]);
        StartDate := StrToDate(SubItems[1]);
      end
    else
    begin // Give sensible defaults
      Period := 1;
      StartDate := Now;
      DecodeDate(StartDate, CurYear, CurMonth, CurDay);
      Year := CurYear;
    end;
  end;
  
  if EditPeriodValues(Period, Year, StartDate) then
  begin
    DataChanged := true;
    AddPeriod(Period, Year, StartDate, LineNum);
  end;
end; // TfrmPeriodList.actInsertExecute

//------------------------------------------------------------------------------------

procedure TfrmPeriodList.actEditExecute(Sender: TObject);
var
  Period,
  Year    : integer;
  StartDate : TDateTime;
begin
  if Assigned(lvwPeriods.Selected) then
    with lvwPeriods.Selected do
    begin
      Period := StrToInt(Caption);
      Year := StrToInt(SubItems[0]);
      StartDate := StrToDate(SubItems[1]);
      if EditPeriodValues(Period, Year, StartDate) then
      begin
        DataChanged := true;
        Caption := IntToStr(Period);
        SubItems[0] := IntToStr(Year);
        SubItems[1] := DateToStr(StartDate);
      end;
    end; // with
end; // TfrmPeriodList.actEditExecute

//------------------------------------------------------------------------------------

procedure TfrmPeriodList.actDeleteExecute(Sender: TObject);
var
  Line : integer;
begin
  with lvwPeriods do begin
    if Assigned(Selected) then begin
      if MessageDlg('Are you sure you want to delete this period ?',mtConfirmation,[mbYes,mbNo],0) = mrYes then begin
        Line := Selected.Index;
        Items.Delete(Line);
        if Line < Items.Count then Items[Line].Selected := true;
        DataChanged := true;
      end;{if}
    end;{if}
  end;{with}
end; // TfrmPeriodList.actDeleteExecute

//------------------------------------------------------------------------------------

procedure TfrmPeriodList.actEditLastDateExecute(Sender: TObject);
begin
  with TfrmPeriodSet.Create(self) do
  try
    try
      SelDate := StrToDate(sbrLastDate.Panels[1].Text);
    except
      on EConvertError do
        SelDate := Now;
    end;
    EditMode := edmLastDate;
    if ShowModal = mrOK then
    begin
      LastDate := SelDate;
      DataChanged := true;
    end;
  finally
    Release;
  end;
end; // TfrmPeriodList.actEditLastDateExecute

//------------------------------------------------------------------------------------

procedure TfrmPeriodList.actUndoAutoFillExecute(Sender: TObject);
var
  i : integer;
begin
  if (FirstAutoFillItem <> -1) and (LastAutoFillItem <> -1) then
  begin
    lvwPeriods.Items.BeginUpdate;
    for i := 0 to (LastAutoFillItem - FirstAutoFillItem) do
      lvwPeriods.Items.Delete(FirstAutoFillItem);
    lvwPeriods.Items.EndUpdate;
    FirstAutoFillItem := -1;
    LastAutoFillItem := -1;
  end;
end; // TfrmPeriodList.actUndoAutoFillExecute

//------------------------------------------------------------------------------------

procedure TfrmPeriodList.mniExportClick(Sender: TObject);
// Action : Outputs the list to a simple text file
//          Period, Year, Start Date, End Date 
//          A blank line is output between the financial years
const
  EXPORT_NAME = 'Periods.Txt';
  CRLF = #13#10;
var
  CurYear : integer;
  OutputLine : string;
  i : integer;
  WriteBlankLine : boolean;
  TotalLines : integer;
begin
  with TFileStream.Create(EXPORT_NAME, fmCreate or fmShareDenyWrite) do
  try
    try
      CurYear := 0;
      WriteBlankLine := false;
      TotalLines := lvwPeriods.Items.Count;
      for i := 0 to TotalLines -1 do
        with lvwPeriods.Items[i] do
        begin
          if StrToInt(SubItems[0]) <> CurYear then
          begin
            if CurYear <> 0 then
              WriteBlankLine := true;
            CurYear := StrToInt(SubItems[0]);
          end;
          OutputLine := '';
          if WriteBlankLine then
          begin
            OutputLine := CRLF;
            WriteBlankLine := false;
          end;
          OutputLine := OutputLine +
            Format('%2d  %d  %s', [StrToInt(Caption), CurYear, SubItems[1]]);
          if (i <= TotalLines -2) then
            OutputLine := Format('%s %s%s', [OutputLine,
              DateToStr(StrToDate(lvwPeriods.Items[i+1].SubItems[1]) - 1), CRLF])
          else
            OutputLine := Format('%s %s%s', [OutputLine, DateToStr(LastDate), CRLF]);
          Write(OutputLine[1], length(OutputLine));
        end;
    except
      MessageDlg(Format('Error writing %s', [EXPORT_NAME]), mtError, [mbOK], 0);
    end;
  finally
    Free;
  end;
  // Attempts to open the text file in the default text file
  // viewing application, probably Notepad
  if ShellExecute(Self.Handle, 'open', EXPORT_NAME, '', '', SW_SHOWNORMAL) <= 32 then
    MessageDlg(Format('Could not open file %s with default text file viewer', [EXPORT_NAME])
      ,mtError, [mbOK], 0);
end; // TfrmPeriodList.mniExportClick

//------------------------------------------------------------------------------------

function TfrmPeriodList.ValidatePeriods;
var
  Line,
  CurPeriod,
  CurYear   : integer;
  CurDate : TDateTime;
  PeriodOK, YearOK, DateOK : boolean;
  Msg : string;
begin
  Result := true;

  with lvwPeriods do begin
    if Items.Count > 0 then begin
      if LastDate < StrToDate(Items[Items.Count-1].SubItems[1]) then begin
        Result := false;
        MessageDlg('The Last Date is within the range defined by the periods', mtError,
          [mbOK], 0);
      end;{if}
    end;{if}

    if (Items.Count > 1) and Result then begin
      CurPeriod := StrToInt(Items[0].Caption);
      CurYear := StrToInt(Items[0].SubItems[0]);
      CurDate := StrToDate(Items[0].SubItems[1]);
      Line := 0;
      PeriodOK := true;
      DateOK := true;
      YearOK := true;
      while (Line < Items.Count) and PeriodOK and DateOK and YearOK do begin
        with Items[Line] do begin
          PeriodOK := (StrToInt(Caption) = CurPeriod +1) or ((Line = 0) and (StrToInt(Caption) = 1));
          if not PeriodOK then begin
            PeriodOK := (StrToInt(SubItems[0]) > CurYear) and (StrToInt(Caption) = 1);
            if not PeriodOK then begin
              if Line = 0 then Msg := 'The first period is missing'
              else begin
                if StrToInt(Caption) = CurPeriod then Msg := 'There is a duplicate period number'
                else begin
                  if StrToInt(Caption) > CurPeriod + 1 then Msg := 'There is a missing period number'
                  else begin
                    if StrToInt(Caption) < CurPeriod then Msg := 'There is a period number out of sequence'
                    else Msg := 'Unspecified Period Error'
                  end;{if}
                end;{if}
              end;{if}
            end;{if}
          end;{if}

          DateOK := (StrToDate(SubItems[1]) > CurDate) or (Line = 0);
          YearOK := (StrToInt(SubItems[0]) = CurYear)
          or ((StrToInt(SubItems[0]) > CurYear) and (StrToInt(Caption) = 1));

          CurPeriod := StrToInt(Caption);
          CurYear := StrToInt(SubItems[0]);
          CurDate := StrToDate(SubItems[1]);
          inc(Line);
        end;{with}
      end;{while}

      Result := PeriodOK and DateOK and YearOK;

      if not DateOK then Msg := 'The specified date is out of sequence'
      else begin
        if not YearOK then Msg := 'The specified year is out of sequence';
      end;{if}

      if not Result then begin
        MessageDlg(Format('%s at Line: %d', [Msg, Line]), mtError, [mbOK], 0);
        Items[Line-1].Selected := true;
        ItemFocused := Items[Line-1];
        ActiveControl := lvwPeriods;
      end; {if}
    end; // if More than 1 item in the list view
  end; // with
end; // TfrmPeriodList.ValidatePeriods

//------------------------------------------------------------------------------------

procedure TfrmPeriodList.lvwPeriodsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_DELETE : actDeleteExecute(self);
    VK_RETURN : actEditExecute(self);
    VK_INSERT : actInsertExecute(self);
  end;
end;

//------------------------------------------------------------------------------------

procedure TfrmPeriodList.mniAboutClick(Sender: TObject);
begin
  with TAboutBox.Create(self) do
  try
    ShowModal;
  finally
    Release;
  end;
end;

procedure TfrmPeriodList.lvwPeriodsChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  {size last column to accomodate the scroll bar}
  if lvwPeriods.Items.Count > 16 then lvwPeriods.Columns[2].Width := 105
  else lvwPeriods.Columns[2].Width := 121;
end;

procedure TfrmPeriodList.FillCompanyList(cmbComp : TComboBox);
var
  CompDir : array[0..255] of char;
  CompArray : PCompanies;
  iArrayItems, iPos : longint;
  iStatus : smallint;
  CompanyInfo : TCompanyInfo;
begin
  new(CompArray);
  StrPCopy(CompDir, ExtractFilePath(Application.ExeName));
  iArrayItems := SizeOf(CompArray^);
  iStatus := EX_GETCOMPANY(CompDir, CompArray, iArrayItems);
  if iStatus = 0 then
    begin
      for iPos := 1 to iArrayItems do begin
        with CompArray^[iPos] do begin

          CompanyInfo := TCompanyInfo.Create;
          with CompanyInfo do begin
            Name := CompName;
            Code := CompCode;
            Path := CompPath;
          end;{with}
          cmbComp.Items.AddObject(CompName, CompanyInfo);
        end;{with}
      end;{for}

      if cmbComp.Items.Count <> 0 then begin
        cmbComp.ItemIndex := 0;
        cmbComp.Enabled := cmbComp.Items.Count > 1;
        PrevItemIndex := 0;
      end;{if}
    end
  else ShowMessage('Error ' + IntToStr(iStatus) + ' occured whilst reading the company list');
  dispose(CompArray);
end;

procedure TfrmPeriodList.cmbCompanyChange(Sender: TObject);
begin
  if DataChanged and (MessageDlg('Would you like to save the changes that you have made ?'
  , mtConfirmation, [mbYes, mbNo], 0) = mrYes) then begin
    if ValidatePeriods then
    begin
      WriteToIniFile;
      DataChanged := false;
    end;
  end;{if}

  lvwPeriods.Items.Clear;
  GetMaxPeriods;
  ReadFromINIFile;
  PrevItemIndex := cmbCompany.ItemIndex;
end;

procedure TfrmPeriodList.btnCloseClick(Sender: TObject);
begin
  close;
end;

procedure TfrmPeriodList.GetMaxPeriods;
var
  oToolkit : IToolkit;


begin
  oToolkit := OpenToolkit(IncludeTrailingBackslash(Trim(TCompanyInfo(cmbCompany.Items.Objects[cmbCompany.ItemIndex]).Path))
  , TRUE);

  if Assigned(oToolkit) then
    begin
      iMaxNoPeriods := oToolkit.SystemSetup.ssPeriodsInYear;
      lMaxPeriods.Caption := 'Maximum No. of Periods : ' + IntToStr(iMaxNoPeriods);
      oToolkit := nil;
    end
  else lMaxPeriods.Caption := 'Maximum No. of Periods : ' + 'COM Toolkit Unavailable';

end;

procedure TfrmPeriodList.cbUsePlugInClick(Sender: TObject);
begin
  DataChanged := true;
  lvwPeriods.Enabled := cbUsePlugIn.Checked;
  btnInsert.Enabled := cbUsePlugIn.Checked;
  btnEdit.Enabled := cbUsePlugIn.Checked;
  btnDelete.Enabled := cbUsePlugIn.Checked;
end;

end.


