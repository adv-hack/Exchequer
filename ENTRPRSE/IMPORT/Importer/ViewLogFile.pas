unit ViewLogFile;

{******************************************************************************}
{      Displays the log file passed as the parameter to the Show method.       }
{ Also displays a list of all the log files in the log folder, each of which   }
{ can be selected for viewing. Double-clicking an error line of a displayed    }
{ log file will open the imported file positioned at the line which generated  }
{ the error (if the error line begins with a row number).                      }
{******************************************************************************}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, uMultiList, Menus;

type
  TfrmViewLogFile = class(TForm)
    GroupBox3: TGroupBox;
    Panel1: TPanel;
    mlLogFiles: TMultiList;
    Splitter1: TSplitter;
    Panel2: TPanel;
    btnClose: TButton;
    mlLogFile: TMultiList;
    PopupMenu1: TPopupMenu;
    mniProperties1: TMenuItem;
    mniSaveCoordinates1: TMenuItem;
    PopupMenu2: TPopupMenu;
    mniProperties2: TMenuItem;
    mniSaveCoordinates2: TMenuItem;
    btnRefresh: TButton;
    procedure mlLogFileRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mlLogFilesRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure mniSaveCoordinates1Click(Sender: TObject);
    procedure mniSaveCoordinates2Click(Sender: TObject);
    procedure mniProperties1Click(Sender: TObject);
    procedure mniProperties2Click(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
  protected
    constructor create(AOwner: TComponent); override;
  private
{* Internal Fields *}
    FHelping: boolean;
    FLogFileName: string;
    FLogFolder: string;
    FSaveCoordinates: boolean;
{* Property Fields *}
{* Procedural Methods *}
    procedure ChangeCaption;
    function  ErrorFile(ARowIndex: integer): string;
    function  ErrorRow(AErrorLine: string): integer;
    procedure LoadAllLogFiles;
    procedure LoadLogFile(ALogFileName: string);
{* Message Handlers *}
    procedure WMMoving(var msg: TMessage); message WM_MOVING;
  public
    class procedure Show(ALogFileName: string);
  end;

implementation

uses FileViewer, utils, GlobalConsts, TIniClass;

const
  COL_LOGFILENAME  = 0;
  COL_LOGFILELINES = 0;

var
  frmViewLogFile: TfrmViewLogFile;

{$R *.dfm}

class procedure TfrmViewLogFile.Show(ALogFileName: string);
begin
  if not assigned(frmViewLogFile) then
    frmViewLogFile := TfrmViewLogFile.Create(nil);

  if ALogFileName <> '' then
    frmViewLogFile.LoadLogFile(ALogFileName);

//inherited Show
  frmViewLogFile.Visible := true;
  frmViewLogFile.BringToFront;
end;

constructor TfrmViewLogFile.create(AOwner: TComponent);
begin
  inherited create(AOwner);

  if not SchedulerMode then
    FormStyle := fsMDIChild;

  FormLoadSettings(Self, nil);
  MLLoadSettings(mlLogFiles, Self);
  MLLoadSettings(mlLogFile, Self);

//  SetConstraints(Constraints, height, width);

  LoadAllLogFiles;
end;

{* Procedural Methods *}

procedure TfrmViewLogFile.ChangeCaption;
begin
  mlLogFile.DesignColumns[COL_LOGFILELINES].Caption := FLogFileName + format(' - [%d lines]', [mlLogFile.DesignColumns[COL_LOGFILELINES].Items.count]);
end;

function TfrmViewLogFile.ErrorFile(ARowIndex: integer): string;
// starting from the given row, work backwards through the log file to find
// the data file to which the row's log entry refers.
var
  i: integer;
  LogLine: string;
  PosColon: integer;
begin
  for i := ARowIndex downto 0 do begin
    LogLine := mlLogFile.DesignColumns[COL_LOGFILELINES].Items[i];
    if copy(LogLine, 1, length(LOG_PROCFILE)) = LOG_PROCFILE then begin
      PosColon := pos(':', LogLine);
      result := copy(LogLine, PosColon + 2, 255);
    end;
  end;
end;

function TfrmViewLogFile.ErrorRow(AErrorLine: string): integer;
// if the row from the log file starts with a numeric record number then
// return it
var
  code:  integer;
  Value: integer;
begin
  result := 0;
  if length(AErrorLine) < LEN_REC_NO then exit;

  val(Copy(AErrorLine, 1, LEN_REC_NO), Value, Code);
  if Code = 0 then
    result := Value;
end;

procedure TfrmViewLogFile.LoadAllLogFiles;
var
  rc: integer;
  sr: TSearchRec;
begin
  mlLogFiles.ClearItems;
  FLogFolder := IncludeTrailingPathDelimiter(IniFile.ReadString(SYSTEM_SETTINGS, 'Log File Folder', ''));
  rc := FindFirst(FLogFolder + '*.log', faAnyFile, sr);
  while rc = 0 do begin
    mlLogFiles.DesignColumns[COL_LOGFILENAME].Items.Add(sr.Name);
    rc := FindNext(sr);
  end;
  FindClose(sr);
  rc := FindFirst(FLogFolder + '*.txt', faAnyFile, sr);
  while rc = 0 do begin
    mlLogFiles.DesignColumns[COL_LOGFILENAME].Items.Add(sr.Name);
    rc := FindNext(sr);
  end;
  FindClose(sr);
  application.ProcessMessages; // make sure ML.ItemsCount gets updated
  MLSelectLast(mlLogFiles);
end;

procedure TfrmViewLogFile.LoadLogFile(ALogFileName: string);
// TStrings.LoadFromFile in classes.pas opens the file as fmShareDenyWrite which
// causes problems if jobs are still running in the background, particularly
// when viewing the main Importer.log.
// So instead we create our own stream and load from that instead.
// If we display a very long log file, scroll to the end and then display a much shorter one, TMultilist
// goes blank as its still positioned on rows which aren't there. So we select
// the first row each time which cures it.
begin
  ALogFileName := ExtractFileName(ALogFileName);
  if LoadFromStream(FLogFolder + ALogFileName,
                mlLogFile.DesignColumns[COL_LOGFILELINES].Items) = 0 then begin
      FLogFileName := ALogFileName;
      ChangeCaption;
      MLSelectFirst(mlLogFile);
      if SameText(ALogFileName, APPLOGFILE) then
        MLSelectLast(mlLogFile); // position on the most recent entry in the main log
    end;
end;

{* Event Procedures *}

procedure TfrmViewLogFile.mlLogFileRowDblClick(Sender: TObject; RowIndex: Integer);
begin
  TfrmFileViewer.Show(ErrorFile(RowIndex), ErrorRow(mlLogFile.DesignColumns[COL_LOGFILELINES].Items[RowIndex]));
end;

procedure TfrmViewLogFile.btnCloseClick(Sender: TObject);
begin
  close;
end;

procedure TfrmViewLogFile.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FSaveCoordinates then
    FormSaveSettings(Self, nil);
  action         := caFree;
  frmViewLogFile := nil;
end;

procedure TfrmViewLogFile.mlLogFilesRowDblClick(Sender: TObject; RowIndex: Integer);
begin
  LoadLogFile(mlLogFiles.DesignColumns[COL_LOGFILENAME].Items[mlLogFiles.Selected]);
end;

{* Message Handlers *}

procedure TfrmViewLogFile.WMMoving(var msg: TMessage);
begin
  WindowMoving(msg, height, width);
end;

procedure TfrmViewLogFile.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if key = VK_ESCAPE then close;
end;

procedure TfrmViewLogFile.mniSaveCoordinates1Click(Sender: TObject);
begin
  mniSaveCoordinates1.Checked := not mniSaveCoordinates1.Checked;
  mniSaveCoordinates2.Checked := mniSaveCoordinates1.Checked;
  FSaveCoordinates            := mniSaveCoordinates1.Checked;
end;

procedure TfrmViewLogFile.mniSaveCoordinates2Click(Sender: TObject);
begin
  mniSaveCoordinates2.Checked := not mniSaveCoordinates2.Checked;
  mniSaveCoordinates1.Checked := mniSaveCoordinates2.Checked;
  FSaveCoordinates            := mniSaveCoordinates2.Checked;
end;

procedure TfrmViewLogFile.mniProperties1Click(Sender: TObject);
begin
  MLEditProperties(mlLogFiles, Self, nil);
end;

procedure TfrmViewLogFile.mniProperties2Click(Sender: TObject);
begin
  MLEditProperties(mlLogFile, Self, nil);
end;

procedure TfrmViewLogFile.btnRefreshClick(Sender: TObject);
begin
  LoadAllLogFiles;
end;

initialization
  frmViewLogFile := nil;
end.
