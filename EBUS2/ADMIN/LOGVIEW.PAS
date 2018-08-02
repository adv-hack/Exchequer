unit LogView;

{ prutherford440 09:44 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, ExtCtrls, SBSPanel, RPDefine, RPBase, RPCanvas,
  RPrinter, FileSel, BTSupU1, Buttons, EBusUtil, Menus, AdmnUtil;

type
  TLogSearchMode = (smdlogOldest, smdlogNext, smdlogPrev, smdlogNewest);
  TLogSearchResult = (srcNoLogs, srcBegin, srcEnd, srcOK);

  TLogFileInfo = record
    LogFileName : string;     // File name without path
    LogFileDate : TDateTime;  // File time and date
  end;
  PLogFileInfo = ^TLogFileInfo;

  ELogFileViewerError = class(Exception);

  TfrmLogFileViewer = class(TForm)
    RepPrint: TReportPrinter;
    pnlButtons: TPanel;
    btnClose: TButton;
    sbxButtons: TScrollBox;
    btnDelete: TButton;
    btnOldest: TButton;
    btnNext: TButton;
    btnPrevious: TButton;
    btnLatest: TButton;
    btnPrint: TButton;
    edtFileName: TEdit;
    edtLogDisplay: TRichEdit;
    mnuDelete: TPopupMenu;
    mniCurrentLog: TMenuItem;
    mniMultipleLogs: TMenuItem;
    procedure RepPrintPrint(Sender: TObject);
    procedure btnFindLogClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mniMultipleLogsClick(Sender: TObject);
    procedure mniCurrentLogClick(Sender: TObject);
  private
    // Form controlling variables
    InitSize : TPoint;
    GotCoord : boolean;
    PagePoint : array[0..4] of TPoint;

    lstLogFiles : TList;
    fLogFileListPos : integer;
    frmFileSelect : TfrmFileSelect;
    fMode : TEBusProcess;  // Importing or Posting to Enterprise
    fLogFileDir : string;
    fCurLogFileName : string; // When working with one log this is instantiated
    function  ExtractLogFileNumber(FileName : string) : integer;
    function  FindLogFilePos(LogFindMode : TLogSearchMode) : TLogSearchResult;
    procedure DeleteLogRange;
    procedure DeleteSingleLog;
    procedure ShowLogRangeSelect;
    procedure ParseDirectory;
    procedure WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo); message WM_GetMinMaxInfo;
    procedure WMCustGetRec(var Message : TMessage); message WM_CustGetRec;
    procedure WMSysCommand(var Message : TMessage); message WM_SysCommand;
    procedure StoreInitialFormCoords;
    procedure ShowFormSize;
  public
    procedure DisplayALog(const LogName : string; const TransNo : string = '');
    procedure Initialise(Mode : TEBusProcess; const LogFileDir : string; const TransNo : string = '');
    class function TransNoToLogName(const TransNo : string) : string;
  end;

procedure DisplayLogs(Mode: TEBusProcess);
function DisplaySingleLog(const TransNo : string; AOwner : TComponent) : TfrmLogFileViewer;
function GetLogFileDirectory(Mode : TEBusProcess) : string;

var
  frmLogFileViewer: TfrmLogFileViewer;

implementation

{$R *.DFM}

uses
  RPDevice, EBusVar, EBusBtrv, FileCtrl, StrUtil;

var
  PostingLogDisplayed,
  ImportLogDisplayed   : boolean;

//-----------------------------------------------------------------------

class function TfrmLogFileViewer.TransNoToLogName(const TransNo : string) : string;
// Pre  : TransNo = Transaction number in the format SIN123456
// Post : Returns equivalent log name for that transaction
begin
  Result := copy(TransNo,2,length(TransNo)-1) + '.LOG';
end;

//-----------------------------------------------------------------------

procedure TfrmLogFileViewer.RepPrintPrint(Sender: TObject);
var
  i : integer;

  procedure SetMargins;
  begin
    with RepPrint do
    begin
      if Orientation = poPortrait then
      begin
        MarginLeft   := 2 * LeftWaste;
        MarginRight  := 2 * RightWaste;
        MarginTop    := 2 * TopWaste;
        MarginBottom := 2 * BottomWaste;
      end
      else
      begin
        MarginLeft   := 2 * TopWaste;
        MarginRight  := 2 * BottomWaste;
        MarginTop    := 2 * RightWaste;
        MarginBottom := 2 * LeftWaste;
      end;
    end;
  end; // SetMargins

begin  // TfrmLogFileViewer.RepPrintPrint
  SetMargins;
  with RepPrint do
  begin
    FontName := 'Courier New';
    FontSize := 10;

    for i := 0 to edtLogDisplay.Lines.Count -1 do
      PrintLn(edtLogDisplay.Lines[i])
  end; // with
end; // TfrmLogFileViewer.RepPrintPrint

//-----------------------------------------------------------------------

function TfrmLogFileViewer.FindLogFilePos(LogFindMode : TLogSearchMode) : TLogSearchResult;
begin
  if lstLogFiles.Count = 0 then
    Result := srcNoLogs
  else
  begin // Log reports in list
    Result := srcOK;
    case LogFindMode of
      smdlogOldest :
        fLogFileListPos := 0;
      smdlogNext :
        if fLogFileListPos < lstLogFiles.Count - 1 then
          inc(fLogFileListPos)
        else
          Result := srcEnd;
      smdlogPrev :
        if fLogFileListPos > 0 then
          dec(fLogFileListPos)
        else
          Result := srcBegin;
      smdlogNewest :
        fLogFileListPos := lstLogFiles.Count -1;
    end; // case
  end; // Log reports in list
end; // TfrmLogFileViewer.ShowLogFile

//-----------------------------------------------------------------------

procedure TfrmLogFileViewer.DisplayALog(const LogName : string; const TransNo : string = '');
var
  Title, 
  FullLogName : string;
begin
  edtLogDisplay.Lines.Clear;
  FullLogName := fLogFileDir + LogName;
  if FileExists(FullLogName) then
  begin
    edtLogDisplay.Lines.LoadFromFile(FullLogName);
    fCurLogFileName := LogName;
    Title := LogName;
    btnDelete.Enabled := true;
    btnPrint.Enabled := true;
  end
  else
  begin
    Title := Format('No log for transaction %s found', [TransNo]);
    btnDelete.Enabled := false;
    btnPrint.Enabled := false;
  end;
  edtFileName.Text := Title;
  edtLogDisplay.Refresh;
end;

//-----------------------------------------------------------------------

procedure TfrmLogFileViewer.btnFindLogClick(Sender: TObject);
var
  LogSearchMode : TLogSearchMode;
  LogSearchResult : TLogSearchResult;
  LogName : string;
begin
  if Sender = btnOldest then
    LogSearchMode := smdlogOldest;
  if Sender = btnNext then
    LogSearchMode := smdlogNext;
  if Sender = btnPrevious then
    LogSearchMode := smdlogPrev;
  if Sender = btnLatest then
    LogSearchMode := smdlogNewest;

  case FindLogFilePos(LogSearchMode) of
    srcOK :
      DisplayALog(TLogFileInfo(lstLogFiles.Items[fLogFileListPos]^).LogFileName);
    srcNoLogs :
      MessageDlg('There are no logs available to view', mtInformation, [mbOK], 0);
    srcBegin :
      MessageDlg('No older logs available to view', mtInformation, [mbOK], 0);
    srcEnd :
      MessageDlg('No newer logs available to view', mtInformation, [mbOK], 0);
  end; // case
end; // TfrmLogFileViewer.btnFindLogClick

//-----------------------------------------------------------------------

function TfrmLogFileViewer.ExtractLogFileNumber(FileName : string) : integer;
// Pre : A log file name of the form DI0001234.
var
  Posn : integer;
begin
  // Remove the file extension
  FileName := JustFileName(FileName);
  // Find the last alpha character from the left e.g. DI001234
  Posn := length(FileName);
  while (Posn > 1) and (FileName[Posn-1] in ['0'..'9']) do
    dec(Posn);
  Result := StrToInt(copy(FileName, Posn, length(FileName) - Posn +1));
end; // TfrmLogFileViewer.ExtractFileNumber

//-----------------------------------------------------------------------

procedure TfrmLogFileViewer.DeleteLogRange;
var
  i : integer;
  LogDate : TDateTime;

  function SelectedToDelete(FileInfo : TLogFileInfo) : boolean;
  begin
    Result := false;
    with frmFileSelect do
      case SelectMode of
        selDate : Result := (FileInfo.LogFileDate >= FromDate) and
          (FileInfo.LogFileDate <= ToDate);
        selNumber : Result := (ExtractLogFileNumber(FileInfo.LogFileName) >= FromLogNum) and
          (ExtractLogFileNumber(FileInfo.LogFileName) <= ToLogNum);
        selAll : Result := true;
      end;
  end;

begin
  if frmFileSelect.SelectMode = selAll then
    if MessageDlg('Are you sure you wish to delete all log files ?', mtConfirmation,
        [mbYes, mbNo], 0) = mrNo then exit;

  with lstLogFiles do
  begin
    for i := 0 to Count -1 do
    begin
      if SelectedToDelete(TLogFileInfo(lstLogFiles.Items[i]^)) then
      begin // File in correct date range
        if SysUtils.DeleteFile(fLogFileDir + TLogFileInfo(lstLogFiles.Items[i]^).LogFileName) then
        begin // Deleted OK
          dispose(PLogFileInfo(Items[i]));
          Items[i] := nil;
        end;
      end;
    end; // for
    Pack;
  end; // with
  // Reset display etc.
  edtLogDisplay.Lines.Clear;
  edtFileName.Text := '';
  fLogFileListPos := 0;
end; // TfrmLogFileViewer.DeleteLogs

//-----------------------------------------------------------------------

procedure TfrmLogFileViewer.DeleteSingleLog;
begin
  if MessageDlg('Are you sure you wish to delete this log?', mtConfirmation,
        [mbYes, mbNo], 0) = mrYes then
    if SysUtils.DeleteFile(fLogFileDir + fCurLogFileName) then
    begin
      edtLogDisplay.Lines.Clear;
      edtFileName.Text := fCurLogFileName + ' deleted';
    end;
end;

//-----------------------------------------------------------------------

function LogFileNameCompare(Item1, Item2 : Pointer): Integer;
// Post : Returns < 0 if Item1 < Item2
//        Returns 0 if Item1 = Item2
//        Returns > 0 if Item1 > Item2
begin
  Result := AnsiCompareStr(TLogFileInfo(Item1^).LogFileName, TLogFileInfo(Item2^).LogFileName);
end;

//-----------------------------------------------------------------------

procedure TfrmLogFileViewer.ParseDirectory;
var
  FileFound : integer;
  SearchRec : TSearchRec;
  Path : string;
  Attr : integer;
  LogFileInfo : PLogFileInfo;
begin
  Path := fLogFileDir + '*.LOG';

  Attr := faAnyFile;
  FileFound := FindFirst(Path, Attr, SearchRec);
  while FileFound = 0 do
  begin
    new(LogFileInfo);
    LogFileInfo^.LogFileName := SearchRec.Name;
    LogFileInfo^.LogFileDate := FileDateToDateTime(SearchRec.Time);
    lstLogFiles.Add(LogFileInfo);
    FileFound := FindNext(SearchRec);
  end;
  FindClose(SearchRec);
  lstLogFiles.Sort(LogFileNameCompare);
end; // TfrmLogFileViewer.ParseDirectory

//-----------------------------------------------------------------------

procedure TfrmLogFileViewer.FormClose(Sender: TObject; var Action: TCloseAction);
var
  i : integer;
begin
  if Assigned(lstlogFiles) then
    with lstLogFiles do
    begin
      for i := 0 to Count -1 do
        if Assigned(Items[i]) then
        begin
          dispose(PLogFileInfo(Items[i]));
          Items[i] := nil;
        end;
      Free;
    end;
  Action := caFree;
  if Assigned(Owner) then
    SendMessage((Owner as TForm).Handle, WM_CustGetRec, EBUS_FORM_CLOSE, FORM_LOG_VIEW);
  if fMode = ebsImport then  // was dntImport
    ImportLogDisplayed := false
  else
    PostingLogDisplayed := false;
end; // TfrmLogfileViewer.FormClose

//-----------------------------------------------------------------------

procedure TfrmLogFileViewer.FormCreate(Sender: TObject);
begin
  InitSize.X := 549;
  InitSize.Y := 337;
  Self.ClientWidth := InitSize.X;
  Self.ClientHeight := InitSize.Y;
  StoreInitialFormCoords;
end;

//-----------------------------------------------------------------------

procedure TfrmLogFileViewer.btnCloseClick(Sender: TObject);
begin
  Close;
end;

//-----------------------------------------------------------------------

procedure TfrmLogFileViewer.btnPrintClick(Sender: TObject);
begin
  if RpDev.PrinterSetUpDialog then
  begin
    RepPrint.PrinterIndex := RpDev.DeviceIndex;
    RepPrint.Execute;
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmLogFileViewer.btnDeleteClick(Sender: TObject);
var
  Posn : TPoint;
begin
  // Position pop-up menu over button
  Posn := Point(1,1);
  with (Sender as TControl) do
    Posn := ClientToScreen(Posn);
  mnuDelete.PopUp(Posn.X, Posn.Y);
end;

//-----------------------------------------------------------------------

procedure TfrmLogFileViewer.ShowLogRangeSelect;
begin
  if lstLogFiles.Count = 0 then
    MessageDlg('There are no logs to delete', mtInformation, [mbOK], 0)
  else
    if not Assigned(frmFileSelect) then
    begin
      frmFileSelect := TfrmFileSelect.Create(Self);
      with frmFileSelect do
      begin
        SelectMode := selDate;
        FromDate := TLogFileInfo(lstLogFiles.Items[0]^).LogFileDate;
        ToDate := TLogFileInfo(lstLogFiles.Items[lstLogFiles.Count-1]^).LogFileDate;
        FromLogNum := ExtractLogFileNumber(TLogFileInfo(lstLogFiles.Items[0]^).LogFileName);
        ToLogNum := ExtractLogFileNumber(TLogFileInfo(lstLogFiles.Items[lstLogFiles.Count-1]^).LogFileName);
        Show;
      end;
    end;
end; // TfrmLogFileViewer.DeleteLogs

//-----------------------------------------------------------------------

procedure TfrmLogFileViewer.WMCustGetRec(var Message : TMessage);
begin
  if Message.WParam = EBUS_FORM_CLOSE then
  begin
    if Message.LParam = 1 then // OK pressed
      DeleteLogRange;
    // OK or Cancel pressed
    frmFileSelect.Release;
    frmFileSelect := nil;
  end;
end; // TfrmLogFileViewer.WMCustGetRec

//-----------------------------------------------------------------------

procedure TfrmLogFileViewer.WMSysCommand(var Message : TMessage);
// Notes : Prevent the form from maximising when the maximise title bar
//         button is clicked.  Standard Enterprise behaviour for an MDI child.
begin
  with Message do
    case WParam of
      SC_Maximize :
        begin
          Self.ClientHeight := InitSize.Y;
          Self.ClientWidth := InitSize.X;
          WParam := 0;
        end;
    end; // case
  inherited;
end; // TfrmLogFileViewer.WMSysCommand

//-----------------------------------------------------------------------

procedure TfrmLogFileViewer.StoreInitialFormCoords;
begin
  PagePoint[0].X := ClientWidth - pnlButtons.Left;
  PagePoint[0].Y := ClientHeight - pnlButtons.Height;

  PagePoint[1].X := ClientWidth - edtLogDisplay.Width;
  PagePoint[1].Y := ClientHeight - edtLogDisplay.Height;

  PagePoint[3].X := pnlButtons.Height - sbxButtons.Height;
  GotCoord := true;
end;

//-----------------------------------------------------------------------

procedure TfrmLogFileViewer.FormResize(Sender: TObject);
begin
  if GotCoord then
  begin
    pnlButtons.Left := ClientWidth - PagePoint[0].X;
    pnlButtons.Height := ClientHeight - PagePoint[0].Y;

    edtLogDisplay.Width := ClientWidth - PagePoint[1].X;
    edtFileName.Width := edtLogDisplay.Width;
    edtLogDisplay.Height := ClientHeight - PagePoint[1].Y;

    sbxButtons.Height := pnlButtons.Height - PagePoint[3].X;
  end; // GotCoord
  edtLogDisplay.Refresh;
end; // TfrmLogFileViewer.FormResize

//-----------------------------------------------------------------------

procedure TfrmLogFileViewer.WMGetMinMaxInfo(var Message : TWMGetMinMaxInfo);
begin
  with Message.MinMaxInfo^ do
  begin
    ptMinTrackSize.X:=313;
    ptMinTrackSize.Y:=145;
  end;
  Message.Result := 0;
  Inherited;
end; // TfrmLogFileViewer.WMGetMinMaxInfo

//-----------------------------------------------------------------------

procedure TfrmLogFileViewer.Initialise(Mode : TEBusProcess;
  const LogFileDir : string; const TransNo : string = '');
begin
  fMode := Mode;
  fLogFileDir := LogFileDir;
  fCurLogFileName := TfrmLogFileViewer.TransNoToLogName(TransNo);
  if fMode = ebsImport then // was dntImport
    ImportLogDisplayed := true
  else
    PostingLogDisplayed := true;

  if TransNo = '' then
  begin // Normal log file viewing mode
    lstLogFiles := TList.Create;
    ParseDirectory;
    btnFindLogClick(btnLatest);
  end
  else
  begin // Single log file linked to E-Business daybook
    DisplayALog(fCurLogFileName, TransNo);
    btnOldest.Enabled := false;
    btnNext.Enabled := false;
    btnPrevious.Enabled := false;
    btnLatest.Enabled := false;
    mniMultipleLogs.Visible := false;
  end;
end; // TfrmLogFileViewer.Initialise

//-----------------------------------------------------------------------

procedure TfrmLogFileViewer.ShowFormSize;
begin
  if MessageDlg('Client settings', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    ShowMessage(Format('Client Height = %d' + #13#10 + 'Client Width = %d',
      [ClientHeight, ClientWidth]))
  else
    ShowMessage(Format('Height = %d' + #13#10 + 'Width = %d',
      [Height, Width]))
end;

//-----------------------------------------------------------------------

function GetLogFileDirName(Mode : TEBusProcess) : string;
begin
  if Mode = ebsImport then
    Result := 'Import log directory for ' + CurCompSettings.CompanyCode
  else
    Result := 'Posting log directory for ' + CurCompSettings.CompanyCode;
end;

//-----------------------------------------------------------------------

function GetLogFileDirectory(Mode : TEBusProcess) : string;
//var
//  CompParams : PEBusEntCompanyParams;


begin

 (*
  new(CompParams);
  try
    FillChar(CompParams^, SizeOf(CompParams^), 0);
    if ReadNoLockEBusLevel1(CompParams, EBUS_ENTERPRISE, EBUS_COMPANY,
      EBusParams.CurCompCode) = 0 then
      if Mode = ebsImport then
        Result := CompParams^.EntImportLogDir
      else
        Result := CompParams^.EntPostingLogDir
    else
      raise ELogFileViewerError.CreateFmt('The %s could not be read',
        [GetLogFileDirName(Mode)]);

    if Blank(Result) then
      raise ELogFileViewerError.CreateFmt('The %s is not defined.' + CRLF +
        'Setup is via Utilities | General Setup | Companies', [GetLogFileDirName(Mode)]);
    if not DirectoryExists(Result) then
      raise ELogFileViewerError.CreateFmt('The %s does not exist',
        [GetLogFileDirName(Mode)]);
    Result := AddBackSlash(Result);
  finally
    dispose(CompParams);
  end; // try *)

  Result:=IncludeTrailingBackSlash(CurCompSettings.CompanyPath)+IncludeTrailingBackSlash(EBUS_DIR)+IncludeTrailingBackSlash(EBUS_Logs_DIR);

  If (Mode=ebsImport) then
    Result:=Result+IncludeTrailingBackSlash(EBUS_LOGS_IMPORTED_DIR)
  else
    Result:=Result+IncludeTrailingBackSlash(EBUS_XML_POSTED_DIR);


end; // GetLogFileDirectory

//-----------------------------------------------------------------------

procedure CheckForLogs(const Name, Dir : string);
// Pre : Name = Name of log to search for (use * for wildcard)
//       Dir = directory to search in
var
  SearchRec : TSearchRec;
  SearchPath : string;
begin
  SearchPath := Dir + Name;
  try
    if FindFirst(SearchPath, faAnyFile, SearchRec) <> 0 then
      raise ELogFileViewerError.Create('No log file(s) could be found');
  finally
    SysUtils.FindClose(SearchRec);
  end; // try
end; // CheckForLogs

//-----------------------------------------------------------------------

procedure DisplayLogs(Mode: TEBusProcess);
var
  LogFileDir : string;
begin
  // Allow only one instance of each type of log viewer
  if (Mode = ebsImport) and ImportLogDisplayed then exit;
  if (Mode = ebsPost) and PostingLogDisplayed then exit;

  LogFileDir := GetLogFileDirectory(Mode);
  CheckForLogs('*.LOG', LogFileDir);

  with TfrmLogFileViewer.Create(nil) do
  begin
    Initialise(Mode, LogFileDir);
    Show;
  end;
end; // DisplayLogs

//-----------------------------------------------------------------------

function DisplaySingleLog(const TransNo : string; AOwner : TComponent) : TfrmLogFileViewer;
var
  LogFileDir,
  LogFileName : string;
begin
  LogFileDir := GetLogFileDirectory(ebsImport);
//  CheckForLogs(TfrmLogFileViewer.TransNoToLogName(TransNo), LogFileDir);

  Result := TfrmLogFileViewer.Create(AOwner);
  with Result do
  begin
    Initialise(ebsImport, LogFileDir, TransNo);
    Show;
  end;
end;

//-----------------------------------------------------------------------

procedure TfrmLogFileViewer.FormDestroy(Sender: TObject);
begin
  if fMode = ebsImport then
    ImportLogDisplayed := false
  else
    PostingLogDisplayed := false;
end;

//-----------------------------------------------------------------------

procedure TfrmLogFileViewer.mniMultipleLogsClick(Sender: TObject);
begin
  ShowLogRangeSelect;
end;

//-----------------------------------------------------------------------

procedure TfrmLogFileViewer.mniCurrentLogClick(Sender: TObject);
begin
  DeleteSingleLog;
end;

//-----------------------------------------------------------------------

initialization
  PostingLogDisplayed := false;
  ImportLogDisplayed  := false;

end.
