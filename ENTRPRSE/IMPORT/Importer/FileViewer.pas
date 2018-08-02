unit FileViewer;

{******************************************************************************}
{ Displays the contents of a text file and allows individual lines to be       }
{ edited. Full editing capability has not yet been implemented awaiting a      }
{ decision.                                                                    }
{******************************************************************************}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, uMultiList, Menus;

type
  TfrmFileViewer = class(TForm)
    sb: TStatusBar;
    Panel1: TPanel;
    btnClose: TButton;
    btnEdit: TButton;
    btnSave: TButton;
    Panel2: TPanel;
    mlTextFile: TMultiList;
    btnSaveAs: TButton;
    PopupMenu1: TPopupMenu;
    mniProperties: TMenuItem;
    mniSaveCoordinates: TMenuItem;
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mlTextFileChangeSelection(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure mlTextFileRowDblClick(Sender: TObject; RowIndex: Integer);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure mniPropertiesClick(Sender: TObject);
    procedure mniSaveCoordinatesClick(Sender: TObject);
  private
{* Internal Fields *}
    FFileName: string;
{* Procedural Methods *}
    procedure ChangeCaption;
    procedure LoadFile(AFileName: string; ASelectedRow: integer);
  protected
    constructor createEx;
{* Message Handlers *}
    procedure WMMoving(var msg: TMessage); message WM_MOVING;
  public
    class procedure Show(AFileName: string; ASelectedRow: integer);
  end;

implementation

uses EditRecord, GlobalConsts, Utils, ShellAPI;

const
  COL_FILECONTENTS = 0;

var
  frmFileViewer: TfrmFileViewer;

{$R *.dfm}

{ TfrmFileViewer }

class procedure TfrmFileViewer.Show(AFileName: string; ASelectedRow: integer);
begin
  if not FileExists(AFileName) then exit;

  if frmFileViewer = nil then
    frmFileViewer := TfrmFileViewer.CreateEx;

  frmFileViewer.LoadFile(AFileName, ASelectedRow);

// inherited show
  frmFileViewer.Visible := true;
  frmFileViewer.BringToFront;
  SetConstraints(frmFileViewer.Constraints, 0, 0); // initial size ok, let the window maximize correctly.
end;

constructor TfrmFileViewer.createEx;
begin
  inherited create(nil);
  if not SchedulerMode then begin
    FormStyle := fsMDIChild;
//    top := 50;
  end;
  MLInit(mlTextFile);
  mlTextFile.DesignColumns[0].Width := 2048;

  SetConstraints(Constraints, height, width); // stop sizeable MDIChild from altering its initial size
end;

{* Procedural Methods *}

procedure TfrmFileViewer.ChangeCaption;
begin
  Caption := 'File Viewer - [' + FFileName + ']';
end;

procedure TfrmFileViewer.LoadFile(AFileName: string; ASelectedRow: integer);
begin
  if LoadFromStream(AFileName, mlTextFile.DesignColumns[COL_FILECONTENTS].Items) = 0 then begin
    if (ASelectedRow = 0) or (ASelectedRow > mlTextFile.DesignColumns[COL_FILECONTENTS].Items.Count) then
      ASelectedRow := 1;
    mlTextFile.Selected := ASelectedRow - 1;
    FFileName := AFileName;
    ChangeCaption;
    mlTextFile.Align := alClient; // resizes the MultiList late so that the pre-selected row is in view.
  end;
end;

{* Event Procedures *}

procedure TfrmFileViewer.btnCloseClick(Sender: TObject);
begin
  close;
end;

procedure TfrmFileViewer.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if mniSaveCoordinates.Checked then
    FormSaveSettings(Self, nil);
  action := caFree;
  frmFileViewer  := nil;
end;

procedure TfrmFileViewer.mlTextFileChangeSelection(Sender: TObject);
var
  StatusLine: string;
begin
  StatusLine := format('Row %d / %d', [mlTextFile.selected + 1, mlTextFile.ItemsCount]);
  SB.SimpleText := StatusLine;
end;

procedure TfrmFileViewer.btnEditClick(Sender: TObject);
begin
  TfrmEditRecord.Show(mlTextFile, 0);
end;

procedure TfrmFileViewer.mlTextFileRowDblClick(Sender: TObject; RowIndex: Integer);
// Editing files in Importer has not yet been implemented - instead we try to
// open the file in it's associated application instead.
// We then close this window so that if they edit the file, we aren't then displaying
// out-of-date contents when they close the editing app.
begin
  ShellExecute(handle, 'open', pchar(FFileName), '', '', 0);
//  close; // this makes the next MDI child window the active window instead of the application that we've just executed.
  EXIT;


  TfrmEditRecord.Show(mlTextFile, 0); // original idea was to allow them to edit the record,
                                      // replace it in the ML and let them save the contents of the
                                      // ML. At the moment, the editing buttons are not visible.
end;

procedure TfrmFileViewer.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if key = VK_ESCAPE then close;
end;

{* Message Handlers *}

procedure TfrmFileViewer.WMMoving(var msg: TMessage);
begin
  WindowMoving(msg, height, width);
end;

procedure TfrmFileViewer.mniPropertiesClick(Sender: TObject);
begin
  MLEditProperties(mlTextFile, Self, nil);
end;

procedure TfrmFileViewer.mniSaveCoordinatesClick(Sender: TObject);
begin
  mniSaveCoordinates.Checked := not mniSaveCoordinates.Checked;
end;

initialization
  frmFileViewer := nil;
end.
