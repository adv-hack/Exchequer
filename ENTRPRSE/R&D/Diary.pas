unit Diary;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, StrUtils,
  GlobVar,
  VarRec2U,
  Saltxl1U,
  Saltxl2u,
  SalTxl3U,
  Tranl1u,
  uMultiList,
  SQLCallerU,

  // CJS 2011-07-20: ABSEXCH-11620 - Use global SQL connection
  ADOConnect,
  StrUtil, //PS 11/05/2016 2016-R2 ABSEXCH-17364: Added to Make use of String related functions
  DiaryNote, Menus;

type
  TDiarySource = class(TObject)
  private
    Owner: TComponent;
    DispCust: TFCustDisplay;
    DispDoc: TFInvDisplay;
    {$IFDEF STK}
    DispStk: TFStkDisplay;
    {$ENDIF}
    {$IFDEF JC}
    DispJob: TFJobDisplay;
    DispEmp: TFJobDisplay;
    {$ENDIF}
    function CanViewCustomer: Boolean;
    procedure DisplayCustomerRecord;
    function CanViewTransaction: Boolean;
    procedure DisplayTransactionRecord;
    {$IFDEF STK}
    function CanViewStock: Boolean;
    procedure DisplayStockRecord;
    {$ENDIF}
    {$IFDEF JC}
    function CanViewJob: Boolean;
    procedure DisplayJobRecord;
    function CanViewEmployee: Boolean;
    procedure DisplayEmployeeRecord;
    {$ENDIF}
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure Display(SubType: Char; LinkCode: Str10);
  end;

  TDiaryFrm = class(TForm)
    StatusBar: TStatusBar;
    PopupMenu: TPopupMenu;
    Add1: TMenuItem;
    Edit1: TMenuItem;
    Clear1: TMenuItem;
    ShowCleared1: TMenuItem;
    Delete1: TMenuItem;
    ViewSource1: TMenuItem;
    N1: TMenuItem;
    Properties1: TMenuItem;
    N2: TMenuItem;
    SaveCoordinates1: TMenuItem;
    MultiList: TMultiList;
    CloseBtn: TButton;
    AddBtn: TButton;
    EditBtn: TButton;
    ClearBtn: TButton;
    SwitchBtn: TButton;
    DeleteBtn: TButton;
    ViewBtn: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CloseBtnClick(Sender: TObject);
    procedure AddBtnClick(Sender: TObject);
    procedure DeleteBtnClick(Sender: TObject);
    procedure EditBtnClick(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
    procedure ViewBtnClick(Sender: TObject);
    procedure SwitchBtnClick(Sender: TObject);
    procedure MultiListRowClick(Sender: TObject; RowIndex: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure MultiListRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure MultiListChangeSelection(Sender: TObject);
    procedure PopupMenuPopup(Sender: TObject);
    procedure Properties1Click(Sender: TObject);
    procedure MultiListCellPaint(Sender: TObject; ColumnIndex,
      RowIndex: Integer; var OwnerText: String; var TextFont: TFont;
      var TextBrush: TBrush; var TextAlign: TAlignment);
    procedure FormResize(Sender: TObject);
  private
    DoneRestore: Boolean;
    SQLCall: TSQLCaller;
    SQLCurrent: TSQLCaller;
    Prefix: Char;
    SubType: Char;
    DiaryEntryTillToday: Boolean;   // //PS 11/05/2016 2016-R2 ABSEXCH-17364: used for showing Workflow Diary entries till current date
    // CJS 2016-01-28 - ABSEXCH-17149 - Workflow Diary - issues with clearing and viewing source
    // CJS 2015-04-23 - ABSEXCH-15945 - Workflow Diary - copied changes from v7.0.11
    // CJS 2015-03-05 - ABSEXCH-15877 - Workflow Diary corruption
    PositionID: LongInt;

    CurrentRec: NotesType;
    ShowCleared: Boolean;
    DiarySource: TDiarySource;
    // Converts a number to the Base36 equivalent. Used for storing the line
    // number in the index field (EXCHQCHKCode1).
    function Dec2Base36(Value: Integer): ShortString;
    // Returns the next line number to use for manual notes
    function NextLineNumber: Integer;
    // Prepares the SQL Caller connections.
    procedure OpenCall;
    // Retrieves the data via the SQLCall object and populates the multilist
    // with the returned data.
    procedure PopulateList(TargetSubType: Char = #0; TargetNoteNo: string = '');
    // Clears the CurrentRec record structure, and fills in default values.
    procedure ResetRecord;
    // Synchronises the database with the currently selected record -- on
    // return, SQLCurrent will hold the details of the current record.
    procedure SynchroniseRecord;
    // Displays the Diary view/edit note dialog, in either Add or Edit mode.
    procedure ShowDiaryNote(Mode: TDiaryNoteMode);
    // Enables/disables controls as appropriate. If FullCheck is True, the
    // state of the list as a whole is used, otherwise it only checks the
    // currently selected record.
    procedure UpdateDisplayState(FullCheck: Boolean = True);
    // Reads the current record from the SQL Caller into the CurrentRec
    // structure.
    procedure ReadRecord(Caller: TSQLCaller);
    // Allows the user to set the colours and positions of the form.
    procedure SetProperties (const Mode: Byte);
    // Returns a correctly formatted date, or an empty string if the supplied
    // date is not valid.
    function FormatCellDate(DateValue: string): string;
  public
    constructor Create(AOwner: TComponent; const ShowAlarmTillToday: boolean);overload;  //overloaded constructor for the form
  end;

function HasExpiredNotes(ForDate: LongDate): Boolean;

var
  DiaryFrm: TDiaryFrm;

implementation

{$R *.dfm}

uses Btrvu2, BtKeys1U, VarConst, ETDateU, ETMiscU, NoteSupU, SQLUtils,
     BTSupU1, uSettings, PWarnU, DateUtils, uDBMColumns, Base36;

const
  // MH 15/06/2017 2017-R2 ABSEXCH-17612: Rewrote to integrate the Source column into the query
  // Select transaction notes from normalised TransactionNote table

  // Common base query used by list query (see sqlSelectTransactionList) and the SynchroniseRecord
  // routine to refresh the details.
  sqlBaseSelectTransaction = 'SELECT ''N'' AS RecPFix, ' +
                                    'ASCII(''D'') AS SubType, ' +
                                    'NoteFolio, ' +
                                    ''''' AS NoteNo, ' +
                                    'NoteDate, ' +
                                    'NoteAlarm, ' +
                                    'NoteType, ' +
                                    'LineNumber, ' +
                                    '(NoteLine Collate SQL_Latin1_General_CP1_CI_AS) As NoteLine, ' +   //SSK 12/02/2018 2018 R1 ABSEXCH-19711: this will fix the Collating issue for Noteline field
                                    'NoteUser, ' +
                                    'ShowDate, ' +
                                    'RepeatNo, ' +
                                    'NoteFor, ' +
                                    'TN.PositionId';

  // Query for loading transaction notes for the list
  sqlSelectTransactionList = sqlBaseSelectTransaction + ', ' +
                                    'TH.thOurRef As Source ' +
                               'FROM [COMPANY].TransactionNote TN ' +
                               'JOIN [COMPANY].Document TH ON TN.NoteFolio = TH.thFolioNum ';

  // Query for refreshing a transaction notes record in SynchroniseRecord
  sqlSelectSyncRecord      = sqlBaseSelectTransaction + ' ' +
                               'FROM [COMPANY].TransactionNote TN ';


  // Select misc non-normalised note from ExchqChk
  sqlSelectExchqChkNote = 'SELECT EX.RecPFix, ' +
                                 'EX.SubType, ' +
                                 'CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(CONVERT(VARBINARY(4), NoteFolio),2,4))) AS INTEGER) AS NoteFolio, ' +
                                 'CAST(SUBSTRING(EXCHQCHKcode1, 2, 11) AS VARCHAR(11)) AS NoteNo, ' +
                                 'CAST(SUBSTRING(EXCHQCHKCode2, 2, 8) AS VARCHAR(8)) AS NoteDate, ' +
                                 'CAST(SUBSTRING(EXCHQCHKCode3, 2, 8) AS VARCHAR(8)) AS NoteAlarm, ' +
                                 'NType AS NoteType, ' +
                                 'LineNumber, ' +
                                 'NoteLine, ' +
                                 'NoteUser, ' +
                                 'ShowDate, ' +
                                 'RepeatNo, ' +
                                 'NoteFor, ' +
                                 'EX.PositionId';
                                 // Add Custom Source Column here per Note Type
  sqlFromExchqChkNote =    'FROM [COMPANY].EXCHQCHK EX ';

  SQL_SELECT_LAST_LINE_NUMBER =
    'SELECT TOP 1 LineNumber FROM [COMPANY].[EXCHQCHK] ' +
    'WHERE RecPfix = ''N'' AND SubType = 2 ' +
    'ORDER BY LineNumber DESC';


function HasExpiredNotes(ForDate: LongDate): Boolean;
var
  CompanyCode: AnsiString;
  Qry: string;
  User: string;
  SQLCaller: TSQLCaller;
  ConnectionString: AnsiString;
begin
// CJS 2011-07-20: ABSEXCH-11620 - Use global SQL connection
  SQLCaller := TSQLCaller.Create(GlobalADOConnection);
//  CompanyCode := GetCompanyCode(SetDrive);
//  if (GetConnectionString(CompanyCode, False, ConnectionString) = 0) Then
//    SQLCaller.ConnectionString := ConnectionString;
  Result := False;

  User := EntryRec^.Login;

  //GS: 29/02/2012 ABSEXCH-11785 : added formatting checks to certain string arguments
  //(to check for quote chars that could break SQLs interpretation)
  User := SQLCaller.CompatibilityFormat(User); //a username can potentially contain a ['] character..
  Qry :=
    'SELECT NoteFor FROM [COMPANY].TransactionNote ' +
    'WHERE (NoteAlarm <= ' + QuotedStr(ForDate) + ') AND ' +
    '      ((NoteFor = ''' + User + ''') OR (NoteFor = '''')) AND ' +
    '      (NoteAlarm <> '''') '+ //HV 17/05/2016 2016-R2 ABSEXCH-17357: Added condition to display diary having Alarm date less then today
    'UNION ' +
    'SELECT NoteFor FROM EXCHQCHK ' +
    'WHERE (RecPfix = ''N'') AND ' +
    '      (CAST(SUBSTRING(EXCHQCHKCode3, 2, 8) AS VARCHAR(8)) > 0x0000000000000000) AND ' +
    '      (CAST(SUBSTRING(EXCHQCHKCode3, 2, 8) AS VARCHAR(8)) <= ''' + DateToStr8(Today) + ''') AND ' + //HV 17/05/2016 2016-R2 ABSEXCH-17357: Added condition to display diary having Alarm date less then today
    '      ((NoteFor = ''' + User + ''') OR (NoteFor = '''')) ';
  CompanyCode := GetCompanyCode(SetDrive);
  SQLCaller.Select(Qry, CompanyCode);
  try
    if (SQLCaller.ErrorMsg = '') Then
      if (SQLCaller.Records.RecordCount > 0) then
        Result := True;
  finally
    SQLCaller.Close;
    FreeAndNil(SQLCaller);
  end;
end;

function CustomDateSort(List: TStringList; Index1, Index2: Integer): Integer;
var
  Date1, Date2: TDateTime;
begin
  Date1 := StrToDateDef(List[Index1], 0);
  Date2 := StrToDateDef(List[Index2], 0);
  if (Date1 < Date2) then
    Result := -1
  else if (Date1 > Date2) then
    Result := 1
  else
    Result := 0;
end;

// =============================================================================
// TDiaryFrm
// =============================================================================

procedure TDiaryFrm.AddBtnClick(Sender: TObject);
begin
  ShowDiaryNote(dnAdd);
end;

// -----------------------------------------------------------------------------

procedure TDiaryFrm.ClearBtnClick(Sender: TObject);
var
  CompanyCode: AnsiString;
  RemoveLine: Boolean;
  Qry: string;
begin
  if (MultiList.Selected <> -1) then
  begin
    OpenCall;
    SynchroniseRecord;
    if (CurrentRec.RepeatNo <> 0) then
    begin
      CurrentRec.NoteAlarm := CalcDueDate(CurrentRec.NoteAlarm, CurrentRec.RepeatNo);
      RemoveLine := False;
    end
    else
    begin
      CurrentRec.NoteAlarm := '';
      CurrentRec.NoteUser  := '';
      CurrentRec.NoteFor   := '';
      RemoveLine := True;
    end;
    { For EXCHQCHK, Prefix + SubType + NoteNo identifies the record. For the
      TransactionNote table Folio + LineNumber identifies the record. }
    if (SubType = 'D') then
      Qry := 'UPDATE [COMPANY].TransactionNote ' +
             'SET NoteAlarm = ''' + CurrentRec.NoteAlarm + ''', ' +
             'NoteUser = ''' + CurrentRec.NoteUser + ''', ' +
             'NoteFor = ' + QuotedStr(CurrentRec.NoteFor) + ' ' +
              // CJS 2016-01-28 - ABSEXCH-17149 - Workflow Diary - issues with clearing and viewing source
              // CJS 2015-04-23 - ABSEXCH-15945 - Workflow Diary - copied changes from v7.0.11
              // CJS 2015-03-05 - ABSEXCH-15877 - Workflow Diary corruption
              'WHERE PositionId = ' + IntToStr(PositionID)
    else
      Qry := 'UPDATE [COMPANY].EXCHQCHK ' +
             'SET EXCHQCHKcode3 = ' + StringToHex(CurrentRec.NoteAlarm, 11, True, '00') + ', ' +
             'NoteUser = ''' + CurrentRec.NoteUser + ''', ' +
             'NoteFor = ' + QuotedStr(CurrentRec.NoteFor) + ' ' +
              // CJS 2016-01-28 - ABSEXCH-17149 - Workflow Diary - issues with clearing and viewing source
              // CJS 2015-04-23 - ABSEXCH-15945 - Workflow Diary - copied changes from v7.0.11
              // CJS 2015-03-05 - ABSEXCH-15877 - Workflow Diary corruption
              'WHERE PositionId = ' + IntToStr(PositionId);
    CompanyCode := GetCompanyCode(SetDrive);
    SQLCurrent.Close;
    SQLCurrent.ExecSQL(Qry, CompanyCode);

    //GS: 10/05/11 ABSEXCH-11181 UpdateDisplayState reads the current records CurrentRec.NoteAlarm property to
    //determine if the clear button should be enabled or not; causes a problem when the current record has just been
    //cleared and its NoteAlarm property destroyed in the process. insread it needs to check the NoteAlarm property
    //of the record that is selected after a clear proces has been performed.

    if (SQLCurrent.ErrorMsg <> '') Then
      raise Exception.Create('Failed to clear note: ' + SQLCurrent.ErrorMsg)
    else if RemoveLine and not ShowCleared then
    begin
      MultiList.DeleteRow(MultiList.Selected);
      //repaint the multi list, so the next item in the list is selected after we have used the clear function
      MultiList.ForceRepaint;
      //run a sync on the selected record, giving access to all its information
      SynchroniseRecord;
    end
    else
    begin
      MultiList.DesignColumns[1].Items[MultiList.Selected] := FormatCellDate(CurrentRec.NoteAlarm);
      MultiList.ForceRepaint;
    end;

    //update the states of all the buttons, if the selected record in the list has a NoteAlarm value, the 'cleared' button will be enabled,
    //if the record does not then it is a 'grayed out' record, and the clear button should be disabled.
    UpdateDisplayState;
  end;
end;

// -----------------------------------------------------------------------------

procedure TDiaryFrm.CloseBtnClick(Sender: TObject);
begin
  Close;
end;

// -----------------------------------------------------------------------------
//PS 11/05/2016 2016-R2 ABSEXCH-17364: Overloaded constructor to initialise variable to check if call is made to see all diary entry or till today
constructor TDiaryFrm.Create(AOwner: TComponent;
  const ShowAlarmTillToday: boolean);
begin
  DiaryEntryTillToday := ShowAlarmTillToday;
  Inherited Create(AOwner);
end;

function TDiaryFrm.Dec2Base36(Value: Integer): ShortString;
begin
  Encode36(Value, Result);
end;

// -----------------------------------------------------------------------------

procedure TDiaryFrm.DeleteBtnClick(Sender: TObject);
var
  CompanyCode: AnsiString;
  Prefix, SubType: Char;
  NoteNo: string;
  Qry: string;
  Selected: Integer;
begin
  if (MultiList.Selected <> -1) then
  begin
    OpenCall;
    { Prefix + SubType + NoteNo identifies the record. }
    Prefix     := MultiList.DesignColumns[6].Items[MultiList.Selected][1];
    SubType    := MultiList.DesignColumns[7].Items[MultiList.Selected][1];
    NoteNo     := MultiList.DesignColumns[8].Items[MultiList.Selected];
    Qry := 'DELETE [COMPANY].EXCHQCHK ' +
           // CJS 2016-01-28 - ABSEXCH-17149 - Workflow Diary - issues with clearing and viewing source
           // CJS 2015-04-23 - ABSEXCH-15945 - Workflow Diary - copied changes from v7.0.11
           // CJS 2015-03-05 - ABSEXCH-15877 - Workflow Diary corruption
           'WHERE PositionId = ' + IntToStr(PositionId);
    CompanyCode := GetCompanyCode(SetDrive);
    SQLCall.Close;
    SQLCall.ExecSQL(Qry, CompanyCode);
    if (SQLCall.ErrorMsg <> '') Then
      raise Exception.Create('Failed to delete note: ' + SQLCall.ErrorMsg)
    else
    begin
      Selected := MultiList.Selected;
      MultiList.DeleteRow(MultiList.Selected);
      if (Selected > MultiList.DesignColumns[0].Items.Count - 1) then
        Selected := Selected - 1;
      MultiList.Selected := Selected;
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TDiaryFrm.EditBtnClick(Sender: TObject);
begin
  ShowDiaryNote(dnEdit);
end;

// -----------------------------------------------------------------------------

function TDiaryFrm.FormatCellDate(DateValue: string): string;
begin
  Result := POutDate(DateValue);
  if Copy(Result, 1, 1) = 'd' then
    Result := '';
end;

// -----------------------------------------------------------------------------

procedure TDiaryFrm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Save colours/positions/sizes/etc.
  SetProperties(1);
  Action := caFree;
  SendMessage((Owner as TForm).Handle, WM_FormCloseMsg, 213,  0);
end;

// -----------------------------------------------------------------------------

procedure TDiaryFrm.FormCreate(Sender: TObject);
begin
  ClientHeight := 410;
  ClientWidth  := 730;
  self.WindowState := wsMinimized;
  MultiList.DesignColumns[0].CustomSortHandler := CustomDateSort;
  MultiList.DesignColumns[1].CustomSortHandler := CustomDateSort;
  DiarySource := TDiarySource.Create(self);
  ShowCleared := False;
  // Load colours/positions/sizes/etc.
  DoneRestore := False;
  SetProperties(0);
  MultiList.SortColumn(1, False);
  PopulateList;
end;

// -----------------------------------------------------------------------------

procedure TDiaryFrm.FormDestroy(Sender: TObject);
begin
  if (SQLCall <> nil) then
  begin
    SQLCall.Close;
    FreeAndNil(SQLCall);
  end;
  if (SQLCurrent <> nil) then
  begin
    SQLCurrent.Close;
    FreeAndNil(SQLCurrent);
  end;
  FreeAndNil(DiarySource);
end;

// -----------------------------------------------------------------------------

procedure TDiaryFrm.FormResize(Sender: TObject);
begin
  // Align properties don't work properly on this window - probably due to the minimise call in FormCreate
  CloseBtn.Left := ClientWidth - CloseBtn.Width - 5;
  AddBtn.Left := CloseBtn.Left;
  EditBtn.Left := CloseBtn.Left;
  ClearBtn.Left := CloseBtn.Left;
  SwitchBtn.Left := CloseBtn.Left;
  DeleteBtn.Left := CloseBtn.Left;
  ViewBtn.Left := CloseBtn.Left;

  MultiList.Top := 5;
  MultiList.Height := StatusBar.Top - 7;      // closed gap at bottom as looks better with status bar

  MultiList.Left := 5;
  MultiList.Width := CloseBtn.Left - 10;
end;

//-------------------------------------------------------------------------

procedure TDiaryFrm.MultiListCellPaint(Sender: TObject; ColumnIndex,
  RowIndex: Integer; var OwnerText: String; var TextFont: TFont;
  var TextBrush: TBrush; var TextAlign: TAlignment);
begin
  if ShowCleared and (MultiList.DesignColumns[1].Items[RowIndex] = '') then
    TextFont.Color := clGrayText;
end;

// -----------------------------------------------------------------------------

procedure TDiaryFrm.MultiListChangeSelection(Sender: TObject);
begin
  MultiListRowClick(Sender, MultiList.Selected);
end;

// -----------------------------------------------------------------------------

procedure TDiaryFrm.MultiListRowClick(Sender: TObject; RowIndex: Integer);
begin
  SynchroniseRecord;
  UpdateDisplayState(False);
end;

// -----------------------------------------------------------------------------

procedure TDiaryFrm.MultiListRowDblClick(Sender: TObject;
  RowIndex: Integer);
begin
  ShowDiaryNote(dnEdit);
end;

// -----------------------------------------------------------------------------

function TDiaryFrm.NextLineNumber: Integer;
var
  CompanyCode: AnsiString;
  Qry: string;
  User: string;
  Source: string;
begin
  Result := 0;
  OpenCall;
  Qry := SQL_SELECT_LAST_LINE_NUMBER;
  CompanyCode := GetCompanyCode(SetDrive);
  SQLCall.Select(Qry, CompanyCode);
  try
    if (SQLCall.ErrorMsg = '') Then
    begin
      if (SQLCall.Records.RecordCount > 0) then
      begin
        SQLCall.Records.First;
        if (not SQLCall.Records.EOF) then
          Result := SQLCall.Records.FieldByName('LineNumber').AsInteger + 1;
      end;
    end;
  finally
    SQLCall.Close;
    UpdateDisplayState;
  end;
end;

// -----------------------------------------------------------------------------

procedure TDiaryFrm.OpenCall;
var
  CompanyCode: AnsiString;
  ConnectionString: AnsiString;
begin
  if (SQLCall = nil) then
  begin
    // CJS 2011-07-20: ABSEXCH-11620 - Use global SQL connection
    SQLCall := TSQLCaller.Create(GlobalADOConnection);
//    CompanyCode := GetCompanyCode(SetDrive);
//    if (GetConnectionString(CompanyCode, False, ConnectionString) = 0) Then
//      SQLCall.ConnectionString := ConnectionString;
  end;
  if (SQLCurrent = nil) then
  begin
    // CJS 2011-07-20: ABSEXCH-11620 - Use global SQL connection
    SQLCurrent := TSQLCaller.Create(GlobalADOConnection);
//    CompanyCode := GetCompanyCode(SetDrive);
//    if (GetConnectionString(CompanyCode, False, ConnectionString) = 0) Then
//      SQLCurrent.ConnectionString := ConnectionString;
  end;
end;

// -----------------------------------------------------------------------------

procedure TDiaryFrm.PopulateList(TargetSubType: Char; TargetNoteNo: string);
var
  CompanyCode: AnsiString;
  Qry: string;
  User: string;
  Source: string;
  TargetLine: Integer;
  SortColumn: Integer;
  SortAscending: Boolean;

  //-----------------------------------

  Function BuildExchqChkWhere (Const SubType : Byte; Const CustomClause : String = '') : String;
  Begin // BuildExchqChkWhere
    Result :=          'WHERE (Ex.RecPfix = ''N'') ' +
                         // Filter on SubType to control the type of notes we are pulling back
                         'AND (Ex.SubType = ' + IntToStr(SubType) + ') ' +
                         // Only show notes where the date is set
                         'AND (CAST(SUBSTRING(Ex.EXCHQCHKCode3, 2, 8) AS VARCHAR(8)) <> 0x0000000000000000) ' +
                         // Filter by the user - suppress notes for other users
                         'AND ((Ex.NoteFor = ''' + User + ''') OR (Ex.NoteFor = '''')) ';

    If DiaryEntryTillToday Then
                         // Don't show future notes
      Result := Result + 'AND CAST(SUBSTRING(Ex.EXCHQCHKCode3, 2, 8) AS VARCHAR(8)) <= ''' + DateToStr8(Today) + ''' ';

    If (CustomClause <> '') Then
      Result := Result + 'AND ' + CustomClause + ' ';
  End; // BuildExchqChkWhere

  //-----------------------------------

begin
  TargetLine := -1;
  OpenCall;
  User := EntryRec^.Login;

  // MH 15/06/2017 2017-R2 ABSEXCH-17612: Rewrote to integrate the Source column into the query, this requires
  // each type of note to be broken out into their own Select clause so they can JOIN to the related data to
  // calculate the Source correctly, eg. Trader Notes load the Customer/Supplier, Job Notes load the Job, etc...

  // Transaction Notes -------------------------------------------
  Qry := sqlSelectTransactionList +
         'WHERE (NoteAlarm <> '''') ' + IfThen (DiaryEntryTillToday, 'AND (NoteAlarm <= ''' + DateToStr8(Today) + ''') ', '') +
           'AND ((NoteFor = ''' + User + ''') OR (NoteFor = '''')) ';

  // Trader Notes ------------------------------------------------
  Qry := Qry + 'UNION ' +
               sqlSelectExchqChkNote + ', ' +
               // Define custom Source column
               'RTRIM(AC.acCode) + '', '' + RTRIM(AC.acCompany) As Source ' +
               sqlFromExchqChkNote +
               // Define custom JOIN to populate the Source column
               'JOIN [COMPANY].CustSupp AC ON (Ex.Exchqchkcode1Trans7 = AC.acCode) ' +
               BuildExchqChkWhere (65);

  // Employee Notes ----------------------------------------------
  Qry := Qry + 'UNION ' +
               sqlSelectExchqChkNote + ', ' +
               // Define custom Source column
               'RTRIM(Em.EmployeeCode) + '', '' + RTRIM(Em.EmployeeName Collate SQL_Latin1_General_CP1_CI_AS) As Source ' +
               sqlFromExchqChkNote +
               // Define custom JOIN to populate the Source column
               'JOIN [COMPANY].evw_Employee EM ON (CAST(SUBSTRING(Ex.EXCHQCHKcode1, 2, 6) AS VARCHAR(6)) = EM.EmployeeCode) ' +
               BuildExchqChkWhere (69);

  // Job Notes ---------------------------------------------------
  Qry := Qry + 'UNION ' +
               sqlSelectExchqChkNote + ', ' +
               // Define custom Source column
               'RTRIM(JH.JobCode) + '', '' + RTRIM(JH.JobDesc) As Source ' +
               sqlFromExchqChkNote +
               // Define custom JOIN to populate the Source column
               'JOIN [COMPANY].JOBHEAD JH ON (CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(CONVERT(VARBINARY(4), Ex.NoteFolio),2,4))) AS INTEGER) = JH.JobFolio) ' +
               BuildExchqChkWhere (74);

  // Location Notes ----------------------------------------------
  Qry := Qry + 'UNION ' +
               sqlSelectExchqChkNote + ', ' +
               // Define custom Source column
               'RTRIM(LO.LoCode) + '', '' + RTRIM(LO.loName) As Source ' +
               sqlFromExchqChkNote +
               // Define custom JOIN to populate the Source column
               'JOIN [COMPANY].Location LO ON (CAST(SUBSTRING(EX.EXCHQCHKcode1, 2, 3) AS VARCHAR(3)) = LO.loCode) ' +
               BuildExchqChkWhere (76, '(CAST(SUBSTRING(EX.EXCHQCHKcode1, 5, 3) AS VARCHAR(3)) = ''   '')');

  // Stock-Location Notes ----------------------------------------
  Qry := Qry + 'UNION ' +
               sqlSelectExchqChkNote + ', ' +
               // Define custom Source column - Stk-Loc Notes don't contain enough info to link to Stock or Notes!
               ''''' As Source ' +
               sqlFromExchqChkNote +
               // No JOIN
               BuildExchqChkWhere (76, '(CAST(SUBSTRING(EX.EXCHQCHKcode1, 5, 3) AS VARCHAR(3)) <> ''   '')');

  // Department Notes --------------------------------------------
  Qry := Qry + 'UNION ' +
               sqlSelectExchqChkNote + ', ' +
               // Define custom Source column
               'RTRIM(DE.DepartmentCode) + '', '' + RTRIM(DE.DepartmentName) As Source ' +
               sqlFromExchqChkNote +
               // Define custom JOIN to populate the Source column
               'JOIN [COMPANY].evw_Department DE ON (CAST(SUBSTRING(EX.EXCHQCHKcode1, 2, 3) AS VARCHAR(3)) = DE.DepartmentCode) ' +
               BuildExchqChkWhere (80);

  // Stock Notes -------------------------------------------------
  Qry := Qry + 'UNION ' +
               sqlSelectExchqChkNote + ', ' +
               // Define custom Source column
               'RTRIM(ST.stCode) + '', '' + RTRIM(ST.stDescLine1) As Source ' +
               sqlFromExchqChkNote +
               // Define custom JOIN to populate the Source column
               'JOIN [COMPANY].Stock ST ON (CAST(CONVERT(VARBINARY(4), REVERSE(SUBSTRING(CONVERT(VARBINARY(4), EX.NoteFolio),2,4))) AS INTEGER) = ST.stFolioNum) ' +
               BuildExchqChkWhere (83);

  // Cost Centre Notes -------------------------------------------
  Qry := Qry + 'UNION ' +
               sqlSelectExchqChkNote + ', ' +
               // Define custom Source column
               'RTRIM(CC.CostCentreCode) + '', '' + RTRIM(CC.CostCentreName) As Source ' +
               sqlFromExchqChkNote +
               // Define custom JOIN to populate the Source column
               'JOIN [COMPANY].evw_CostCentre CC ON (CAST(SUBSTRING(EX.EXCHQCHKcode1, 2, 3) AS VARCHAR(3)) = CC.CostCentreCode) ' +
               BuildExchqChkWhere (84);

  // Everything Else ---------------------------------------------
  Qry := Qry + 'UNION ' +
               sqlSelectExchqChkNote + ', ' +
               // Define custom Source column
               '(' +
		   'CASE ' +
                     'WHEN SubType=2 THEN '''' ' +                          // Workflow Diary - #2
                     'WHEN SubType=66 THEN ''Stock Alternative Code'' ' +   // -- Alt Stock Code - 'B'
                     'WHEN SubType=82 THEN ''Serial No. Record'' ' +        // -- Serial Batch - 'R'
                     'ELSE ''''' +
                   'END' +
               ') As Source ' +
               sqlFromExchqChkNote +
               'WHERE (Ex.RecPfix = ''N'') ' +
                      // Filter on SubType to exlude the notes included above
                      'AND Not (Ex.SubType In (65, 69, 74, 76, 80, 83, 84)) ' +
                      // Only show notes where the date is set
                      'AND (' +
                            '(CAST(SUBSTRING(Ex.EXCHQCHKCode3, 2, 8) AS VARCHAR(8)) <> 0x0000000000000000) ';

  If ShowCleared Then       // Show Cleared Workflow Diary notes
    Qry := Qry +            'OR ' +
                            '(SubType=2)';
  Qry := Qry +            ') ' +
                      // Filter by the user - suppress notes for other users
                      'AND ((Ex.NoteFor = ''' + User + ''') OR (Ex.NoteFor = '''')) ';
  If DiaryEntryTillToday Then  // Don't show future notes
      Qry := Qry +    'AND (CAST(SUBSTRING(Ex.EXCHQCHKCode3, 2, 8) AS VARCHAR(8)) <= ''' + DateToStr8(Today) + ''') ';

  //PS 11/05/2016 2016-R2 ABSEXCH-17364 : added Order by clause which will be added to sql query
  Qry := Qry + 'ORDER BY NoteAlarm DESC';

  CompanyCode := GetCompanyCode(SetDrive);
  SQLCall.Select(Qry, CompanyCode);

  MultiList.BeginUpdate;
  { Store the current sort order, if any. }
  SortColumn := MultiList.SortedIndex;
  SortAscending := MultiList.SortedAsc;
  try
    if (SQLCall.ErrorMsg = '') Then
    begin
      MultiList.ClearItems;
      if (SQLCall.Records.RecordCount > 0) then
      begin
        SQLCall.Records.First;
        while (not SQLCall.Records.EOF) do
        begin
          ReadRecord(SQLCall);
          MultiList.DesignColumns[0].Items.Add(FormatCellDate(CurrentRec.NoteDate));
          MultiList.DesignColumns[1].Items.Add(FormatCellDate(CurrentRec.NoteAlarm));
          MultiList.DesignColumns[2].Items.Add(CurrentRec.NoteLine);
          MultiList.DesignColumns[3].Items.Add(CurrentRec.NoteUser);
          // MH 15/06/2017 2017-R2 ABSEXCH-17612: Rewrote to integrate the Source column into the query
          MultiList.DesignColumns[4].Items.Add(SQLCall.Records.FieldByName('Source').AsString);
          MultiList.DesignColumns[5].Items.Add(CurrentRec.NoteFor);

          { Store the Prefix, SubType, NoteNo, NoteFolio, LineNumber, and
            NoteAlarm fields as hidden columns. }
          MultiList.DesignColumns[6].Items.Add(Prefix);
          MultiList.DesignColumns[7].Items.Add(SubType);
          MultiList.DesignColumns[8].Items.Add(CurrentRec.NoteNo);
          if (TargetSubType <> #0) then
            if (Ord(TargetSubType) = SQLCall.Records.FieldByName('SubType').AsInteger) and
               (CurrentRec.NoteNo = TargetNoteNo) then
            begin
              TargetLine := MultiList.DesignColumns[0].Items.Count - 1;
            end;
          MultiList.DesignColumns[9].Items.Add(CurrentRec.NoteFolio);
          MultiList.DesignColumns[10].Items.Add(IntToStr(CurrentRec.LineNo));
          MultiList.DesignColumns[11].Items.Add(IntToStr(CurrentRec.RepeatNo));

          // CJS 2016-01-28 - ABSEXCH-17149 - Workflow Diary - issues with clearing and viewing source
          // CJS 2015-04-23 - ABSEXCH-15945 - Workflow Diary - copied changes from v7.0.11
          // CJS 2015-03-05 - ABSEXCH-15877 - Workflow Diary corruption
          MultiList.DesignColumns[12].Items.Add(IntToStr(PositionID));

          SQLCall.Records.Next;
        end;
        if (TargetLine <> -1) then
          MultiList.Selected := TargetLine
        else
          MultiList.Selected := 0;
        SynchroniseRecord;
      end;
    end;
  finally
    SQLCall.Close;
    if (SortColumn <> -1) then
    begin
      { Reapply the sort order. }
      MultiList.SortColumn(SortColumn, SortAscending);
    end;
    if (TargetSubType <> #0) then
    begin
      { Restore the record selection. }
      for TargetLine := 0 to MultiList.DesignColumns[0].Items.Count - 1 do
      begin
        if (MultiList.DesignColumns[6].Items[TargetLine] = TargetSubType) and
           (MultiList.DesignColumns[7].Items[TargetLine] = TargetNoteNo) then
        begin
          MultiList.Selected := TargetLine;
          break;
        end;
      end;
      SynchroniseRecord;
    end;
    UpdateDisplayState;
    MultiList.EndUpdate;
  end;
end;

// -----------------------------------------------------------------------------

procedure TDiaryFrm.PopupMenuPopup(Sender: TObject);
begin
  Edit1.Enabled := EditBtn.Enabled;
  Clear1.Enabled := ClearBtn.Enabled;
  Delete1.Enabled := DeleteBtn.Enabled;
  ViewSource1.Enabled := ViewBtn.Enabled;
end;

// -----------------------------------------------------------------------------

procedure TDiaryFrm.Properties1Click(Sender: TObject);
begin
  // Call the colours dialog
  if oSettings.Edit(MultiList, self.Name, nil) = mrRestoreDefaults then
    SetProperties(2);
end;

// -----------------------------------------------------------------------------

procedure TDiaryFrm.ReadRecord(Caller: TSQLCaller);
begin
  Prefix                := Caller.Records.FieldByName('RecPFix').AsString[1];
  SubType               := Chr(Caller.Records.FieldByName('SubType').AsInteger);

  // CJS 2016-01-28 - ABSEXCH-17149 - Workflow Diary - issues with clearing and viewing source
  // CJS 2015-04-23 - ABSEXCH-15945 - Workflow Diary - copied changes from v7.0.11
  // CJS 2015-03-05 - ABSEXCH-15877 - Workflow Diary corruption
  PositionID            := Caller.Records.FieldByName('PositionId').AsInteger;

  CurrentRec.NoteNo     := Caller.Records.FieldByName('NoteNo').AsString;
  CurrentRec.NoteFolio  := FullNomKey(Caller.Records.FieldByName('NoteFolio').AsInteger);
  CurrentRec.LineNo     := Caller.Records.FieldByName('LineNumber').AsInteger;
  CurrentRec.NoteDate   := Caller.Records.FieldByName('NoteDate').AsString;
  CurrentRec.NoteAlarm  := Caller.Records.FieldByName('NoteAlarm').AsString;
  CurrentRec.NoteUser   := Caller.Records.FieldByName('NoteUser').AsString;
  CurrentRec.NoteFor    := Caller.Records.FieldByName('NoteFor').AsString;
  CurrentRec.NoteLine   := Caller.Records.FieldByName('NoteLine').AsString;
  CurrentRec.RepeatNo   := Caller.Records.FieldByName('RepeatNo').AsInteger;
  CurrentRec.ShowDate   := Caller.Records.FieldByName('ShowDate').AsBoolean;
end;

// -----------------------------------------------------------------------------

procedure TDiaryFrm.ResetRecord;
begin
  CurrentRec.NoteNo := '';
  CurrentRec.NoteDate := ETDateU.Today;
  CurrentRec.NoteAlarm := ETDateU.Today;
  CurrentRec.NoteFolio := '';
  CurrentRec.NType := '2';
  CurrentRec.LineNo := 0;
  CurrentRec.NoteLine := '';
  CurrentRec.NoteUser := EntryRec^.Login;
  CurrentRec.TmpImpCode := '';
  CurrentRec.ShowDate := True;
  CurrentRec.RepeatNo := 0;
  CurrentRec.NoteFor := '';
end;

// -----------------------------------------------------------------------------

procedure TDiaryFrm.SetProperties(const Mode: Byte);
var
  WantAutoSave : Boolean;
begin
  case Mode of
    0 : begin
          oSettings.LoadForm (self, WantAutoSave);
          SaveCoordinates1.Checked := WantAutoSave;
          oSettings.LoadList (MultiList, Self.Name);
        end;
    1 : if (Not DoneRestore) Then
        begin
          // Only save the details if the user didn't select Restore Defaults
          oSettings.SaveForm (self, SaveCoordinates1.Checked);
          oSettings.SaveList (MultiList, Self.Name);
        end;
    2 : begin
          DoneRestore := True;
          oSettings.RestoreFormDefaults (self.Name);
          oSettings.RestoreListDefaults (MultiList, self.Name);
          SaveCoordinates1.Checked := False;
        end;
  else
    raise Exception.Create ('TDiaryFrm.SetProperties - Unknown Mode (' + IntToStr(Ord(Mode)) + ')');
  end;
end;

// -----------------------------------------------------------------------------

procedure TDiaryFrm.ShowDiaryNote(Mode: TDiaryNoteMode);
var
  NoteDlg: TDiaryNoteFrm;
  CompanyCode: AnsiString;
  Qry: string;
begin
  NoteDlg := TDiaryNoteFrm.Create(self);
  try
    if (Mode = dnEdit) then
      SynchroniseRecord
    else
      ResetRecord;
    NoteDlg.Initialise(CurrentRec);
    NoteDlg.Mode := Mode;
    if NoteDlg.ShowModal = mrOk then
    begin
      NoteDlg.WriteRecord(CurrentRec);
      if (Mode = dnEdit) then
      begin
        if (SubType = 'D') then
          Qry := 'UPDATE [COMPANY].TransactionNote SET ' +
                 'NoteDate = ''' + CurrentRec.NoteDate + ''', ' +
                 'NoteLine = ' + QuotedStr(CurrentRec.NoteLine) + ', ' +
                 'NoteFor = ' + QuotedStr(CurrentRec.NoteFor) + ', ' +
                 'NoteAlarm = ''' + CurrentRec.NoteAlarm + ''', ' +
                 'RepeatNo = ' + IntToStr(CurrentRec.RepeatNo) + ', ' +
                 'ShowDate = ' + IntToStr(Ord(CurrentRec.ShowDate)) + ' ' +
                 // CJS 2016-01-28 - ABSEXCH-17149 - Workflow Diary - issues with clearing and viewing source
                 // CJS 2015-04-23 - ABSEXCH-15945 - Workflow Diary - copied changes from v7.0.11
                 // CJS 2015-03-05 - ABSEXCH-15877 - Workflow Diary corruption
                 'WHERE PositionId = ' + IntToStr(PositionId)
        else
          Qry := 'UPDATE [COMPANY].EXCHQCHK SET ' +
                 'EXCHQCHKcode2 = ' + StringToHex(CurrentRec.NoteDate, 9, True, '00') + ', ' +
                 'EXCHQCHKcode3 = ' + StringToHex(CurrentRec.NoteAlarm, 11, True, '00') + ', ' +
                 'NoteLine = ' + QuotedStr(CurrentRec.NoteLine) + ', ' +
                 'NoteFor = ' + QuotedStr(CurrentRec.NoteFor) + ', ' +
                 'RepeatNo = ' + IntToStr(CurrentRec.RepeatNo) + ', ' +
                 'ShowDate = ' + IntToStr(Ord(CurrentRec.ShowDate)) + ' ' +
                 // CJS 2016-01-28 - ABSEXCH-17149 - Workflow Diary - issues with clearing and viewing source
                 // CJS 2015-04-23 - ABSEXCH-15945 - Workflow Diary - copied changes from v7.0.11
                 // CJS 2015-03-05 - ABSEXCH-15877 - Workflow Diary corruption
                 'WHERE PositionId = ' + IntToStr(PositionId);
      end
      else if (Mode = dnAdd) then
      begin
        Prefix := 'N';
        SubType := #2;
        CurrentRec.LineNo := NextLineNumber;
        Qry := 'INSERT [COMPANY].EXCHQCHK(' +
               'RecPFix, SubType, EXCHQCHKCode1, EXCHQCHKCode2, ' +
               'EXCHQCHKCode3, NoteFolio, NType, Spare1, LineNumber, NoteLine, NoteUser, TmpImpCode, ' +
               'ShowDate, RepeatNo, NoteFor) VALUES (' +
               '''' + Prefix + ''', ' +
               IntToStr(Ord(SubType)) + ', ' +
               StringToHex(FullNCode(NoteTCode) + '2' + Dec2Base36(CurrentRec.LineNo), 12, True, '00') + ', ' +
               StringToHex(CurrentRec.NoteDate, 9, True, '00') + ', ' +
               StringToHex(CurrentRec.NoteAlarm, 11, True, '00') + ', ' +
               StringToHex(NoteTCode, 10, True, '00') + ', ' +
               CurrentRec.NType + ', ' +
               '0x0000, ' +
               IntToStr(CurrentRec.LineNo) + ', ' +
               QuotedStr(CurrentRec.NoteLine) + ', ' +
               QuotedStr(CurrentRec.NoteUser) + ', ' +
               QuotedStr(CurrentRec.TmpImpCode) + ', ' +
               IntToStr(Ord(CurrentRec.ShowDate)) + ', ' +
               IntToStr(CurrentRec.RepeatNo) + ', ' +
               QuotedStr(CurrentRec.NoteFor) + ')';
      end;
      CompanyCode := GetCompanyCode(SetDrive);
      SQLCurrent.Close;
      SQLCurrent.ExecSQL(Qry, CompanyCode);
      if (SQLCurrent.ErrorMsg <> '') Then
        raise Exception.Create('Failed to read records: ' + SQLCurrent.ErrorMsg)
      else if (Mode = dnAdd) then
        PopulateList(#2, FullNCode(NoteTCode) + '2' + Dec2Base36(CurrentRec.LineNo))
      else if (Mode = dnEdit) then
      begin
        if (CurrentRec.NoteAlarm = '') and not ShowCleared then
        begin
          ClearBtnClick(nil);
        end
        else
        begin
          MultiList.DesignColumns[0].Items[MultiList.Selected] := FormatCellDate(CurrentRec.NoteDate);
          MultiList.DesignColumns[1].Items[MultiList.Selected] := FormatCellDate(CurrentRec.NoteAlarm);
          MultiList.DesignColumns[2].Items[MultiList.Selected] := CurrentRec.NoteLine;
          MultiList.DesignColumns[11].Items[MultiList.Selected] := IntToStr(CurrentRec.RepeatNo);

          // CJS 2016-01-28 - ABSEXCH-17149 - Workflow Diary - issues with clearing and viewing source
          // CJS 2015-04-23 - ABSEXCH-15945 - Workflow Diary - copied changes from v7.0.11
          // CJS 2015-03-05 - ABSEXCH-15877 - Workflow Diary corruption
          MultiList.DesignColumns[12].Items[MultiList.Selected] := IntToStr(PositionID);

          PopulateList(#2);
        end;
      end;
      UpdateDisplayState(False);
    end;
  finally
    NoteDlg.Free;
  end;
end;

// -----------------------------------------------------------------------------

procedure TDiaryFrm.SwitchBtnClick(Sender: TObject);
var
  SelectedSubType: Char;
  SelectedNoteNo: string;
begin
  ShowCleared := not ShowCleared;
  {
  if (MultiList.Selected <> -1) then
  begin
    SelectedSubType := MultiList.DesignColumns[6].Items[MultiList.Selected][1];
    SelectedNoteNo  := MultiList.DesignColumns[7].Items[MultiList.Selected];
    PopulateList(SelectedSubType, SelectedNoteNo);
  end
  else
  }
  PopulateList;
  if ShowCleared then
    SwitchBtn.Caption := '&Hide Cleared'
  else
    SwitchBtn.Caption := '&Show Cleared';
end;

// -----------------------------------------------------------------------------

procedure TDiaryFrm.SynchroniseRecord;
var
  Key: Str255;
  CompanyCode: AnsiString;
  FuncRes: Integer;
  Prefix, SubType: Char;
  NoteNo: string;
  NoteFolio: string;
  LineNumber: string;
  Qry: string;
begin
  if (MultiList.Selected <> -1) then
  begin
    OpenCall;
    { For EXCHQCHK, Prefix + SubType + NoteNo identifies the record. For the
      TransactionNote table Folio + LineNumber identifies the record. }
    Prefix     := MultiList.DesignColumns[6].Items[MultiList.Selected][1];
    SubType    := MultiList.DesignColumns[7].Items[MultiList.Selected][1];
    NoteNo     := MultiList.DesignColumns[8].Items[MultiList.Selected];
    NoteFolio  := MultiList.DesignColumns[9].Items[MultiList.Selected];
    LineNumber := MultiList.DesignColumns[10].Items[MultiList.Selected];
    // CJS 2016-01-28 - ABSEXCH-17149 - Workflow Diary - issues with clearing and viewing source
    // CJS 2015-04-23 - ABSEXCH-15945 - Workflow Diary - copied changes from v7.0.11
    // CJS 2015-03-05 - ABSEXCH-15877 - Workflow Diary corruption
    PositionID := StrToInt(MultiList.DesignColumns[12].Items[MultiList.Selected]);
    if (SubType = 'D') then
      // MH 15/06/2017 2017-R2 ABSEXCH-17612: Rewrote to integrate the Source column into the query
      Qry := sqlSelectSyncRecord +
             // CJS 2016-01-28 - ABSEXCH-17149 - Workflow Diary - issues with clearing and viewing source
             // CJS 2015-04-23 - ABSEXCH-15945 - Workflow Diary - copied changes from v7.0.11
             // CJS 2015-03-05 - ABSEXCH-15877 - Workflow Diary corruption
             'WHERE TN.PositionId = ' + IntToStr(PositionID)
    else
      // MH 15/06/2017 2017-R2 ABSEXCH-17612: Rewrote to integrate the Source column into the query
      Qry := sqlSelectExchqChkNote + ' ' +
             sqlFromExchqChkNote +
             // CJS 2016-01-28 - ABSEXCH-17149 - Workflow Diary - issues with clearing and viewing source
             // CJS 2015-04-23 - ABSEXCH-15945 - Workflow Diary - copied changes from v7.0.11
             // CJS 2015-03-05 - ABSEXCH-15877 - Workflow Diary corruption
             'WHERE PositionId = ' + IntToStr(PositionID) + ' ' +
             'ORDER BY NoteAlarm';
    CompanyCode := GetCompanyCode(SetDrive);
    SQLCurrent.Close;
    SQLCurrent.Select(Qry, CompanyCode);
    if (SQLCurrent.ErrorMsg = '') then
    begin
      if (SQLCurrent.Records.RecordCount = 0) then
        StatusBar.Panels[0].Text := 'Record not found'
      else if (SQLCurrent.Records.RecordCount = 1) then
      begin
        SQLCurrent.Records.First;
        ReadRecord(SQLCurrent);
        StatusBar.Panels[0].Text := MultiList.DesignColumns[4].Items[MultiList.Selected];
        StatusBar.Panels[1].Text := CurrentRec.NoteLine;
      end
      else
      begin
        SQLCurrent.Records.First;
        ReadRecord(SQLCurrent);
        // CJS 2016-01-28 - ABSEXCH-17149 - Workflow Diary - issues with clearing and viewing source
        // CJS 2015-04-23 - ABSEXCH-15945 - Workflow Diary - copied changes from v7.0.11
        // CJS 2014-12-16 - ABSEXCH-15877 - Patch for ASAP to fix 'file not open' error
        StatusBar.Panels[0].Text := MultiList.DesignColumns[4].Items[MultiList.Selected];
        StatusBar.Panels[1].Text := CurrentRec.NoteLine;
      end;
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TDiaryFrm.UpdateDisplayState(FullCheck: Boolean);
begin
  if FullCheck then
  begin
    if (MultiList.DesignColumns[0].Items.Count = 0) then
    begin
      EditBtn.Enabled := False;
      ClearBtn.Enabled := False;
      DeleteBtn.Enabled := False;
      ViewBtn.Enabled := False;
    end
    else
    begin
      EditBtn.Enabled := True;
      ClearBtn.Enabled := True;
      DeleteBtn.Enabled := True;
      ViewBtn.Enabled := True;
    end;
  end;
  if (MultiList.Selected <> -1) then
  begin
    DeleteBtn.Enabled := (SubType = #2);
    ClearBtn.Enabled  := (Trim(CurrentRec.NoteAlarm) <> '');
    ViewBtn.Enabled := (SubType in [NoteCCode, NoteDCode, NoteSCode, NoteJCode, NoteECode]);
  end;
end;

// -----------------------------------------------------------------------------

procedure TDiaryFrm.ViewBtnClick(Sender: TObject);
begin
  SynchroniseRecord;
  if (SubType = 'D') then
    DiarySource.Display(SubType, CurrentRec.NoteFolio)
  else
    DiarySource.Display(SubType, ExtNoteKey(CurrentRec.NoteNo));
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TDiarySource
// =============================================================================

function TDiarySource.CanViewCustomer: Boolean;
begin
  Result := Allowed_In(IsACust(Cust.CustSupp), 34) or
            Allowed_In(not IsACust(Cust.CustSupp), 44)
end;

// -----------------------------------------------------------------------------

{$IFDEF JC}
function TDiarySource.CanViewEmployee: Boolean;
begin
  Result := Allowed_In(JBCostOn,206);
end;

// -----------------------------------------------------------------------------

function TDiarySource.CanViewJob: Boolean;
begin
  Result := Allowed_In(JBCostOn, 206);
end;
{$ENDIF}

// -----------------------------------------------------------------------------

{$IFDEF STK}
function TDiarySource.CanViewStock: Boolean;
begin
  Result := Allowed_In(BOn, 469);
end;
{$ENDIF}

// -----------------------------------------------------------------------------

function TDiarySource.CanViewTransaction: Boolean;
begin
  with Inv do
    Result := Allowed_In(InvDocHed In (SalesSplit-OrderSet), 05) or
              Allowed_In(InvDocHed In (PurchSplit-OrderSet), 14) or
              Allowed_In(InvDocHed In NomSplit, 26) or
              Allowed_In(InvDocHed In (OrderSet-PurchSplit), 158) or
              Allowed_In(InvDocHed In (OrderSet-SalesSplit), 168) or
              Allowed_In(InvDocHed In (TSTSplit), 217) or
              Allowed_In(InvDocHed In (WOPSplit), 378) or
              Allowed_In(InvDocHed In (JAPSalesSplit), 446) or
              Allowed_In(InvDocHed In (JAPPurchSplit), 437) or
              Allowed_In(InvDocHed In (StkAdjSplit), 118);
end;

// -----------------------------------------------------------------------------

constructor TDiarySource.Create(AOwner: TComponent);
begin
  inherited Create;
  Owner := AOwner;
end;

// -----------------------------------------------------------------------------

destructor TDiarySource.Destroy;
begin

  inherited;
end;

// -----------------------------------------------------------------------------

procedure TDiarySource.Display(SubType: Char; LinkCode:  Str10);
begin
  if (SubType in [NoteCCode, NoteDCode, NoteSCode, NoteJCode, NoteECode]) then
  begin
    LinkFNote(SubType, LinkCode);
    case SubType of
      NoteCCode: if CanViewCustomer then DisplayCustomerRecord;
      NoteDCode: if CanViewTransaction then DisplayTransactionRecord;
      {$IFDEF STK}
      NoteSCode: if CanViewStock then DisplayStockRecord;
      {$ENDIF}
      {$IFDEF JC}
      NoteJCode: if CanViewJob then DisplayJobRecord;
      NoteECode: if CanViewEmployee then DisplayEmployeeRecord;
      {$ENDIF}
    end;
  end
  else
    { Unsupported type }
  ;
end;

// -----------------------------------------------------------------------------

procedure TDiarySource.DisplayCustomerRecord;
begin
  if (DispCust = nil) then
    DispCust := TFCustDisplay.Create(Owner);
  try
    //SSK 12/02/2018 2018 R1 ABSEXCH-19711: this will display Trader Record (linked to 19696)
    DispCust.Display_Trader(IsACust(Cust.CustSupp),0,Inv);
  except
    FreeAndNil(DispCust);
  end;
end;

// -----------------------------------------------------------------------------

{$IFDEF JC}
procedure TDiarySource.DisplayEmployeeRecord;
begin
  if (DispEmp = nil) then
    DispEmp := TFJobDisplay.Create(Owner);
  try
    DispEmp.Display_Employee(2,BOn);
  except
    FreeAndNil(DispEmp);
  end;
end;

// -----------------------------------------------------------------------------

procedure TDiarySource.DisplayJobRecord;
begin
  if (DispJob = nil) then
    DispJob := TFJobDisplay.Create(Owner);
  try
    DispJob.Display_Account(0, JobRec^.JobCode, '', 0, 0, BOff, nil);
  except
    FreeAndNil(DispJob);
  end;
end;
{$ENDIF}

// -----------------------------------------------------------------------------

{$IFDEF STK}
procedure TDiarySource.DisplayStockRecord;
begin
  if (DispStk = nil) then
    DispStk := TFStkDisplay.Create(Owner);
  try
    DispStk.Display_Account(0);
  except
    FreeAndNil(DispStk);
  end;
end;
{$ENDIF}

// -----------------------------------------------------------------------------

procedure TDiarySource.DisplayTransactionRecord;
begin
  if (DispDoc = nil) then
    DispDoc := TFInvDisplay.Create(Owner);
  try
    DispDoc.LastDocHed := Inv.InvDocHed;
    DispDoc.Display_Trans(0, Inv.FolioNum, BOff, BOff);
  except
    FreeAndNil(DispDoc);
  end;
end;

// -----------------------------------------------------------------------------

end.
