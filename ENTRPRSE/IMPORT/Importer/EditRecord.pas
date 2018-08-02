unit EditRecord;

// Displays the value of a MultiList cell for editing
// Originally written to allow editing of import files from within Importer.
// This form is not currently used, as editing has been implemented by opening
// the file in it's associated application instead.

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, uMultiList;

type
  TfrmEditRecord = class(TForm)
    edtRecord: TEdit;
    Panel1: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    procedure btnOKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCancelClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  protected
    constructor CreateEx;
  private
{* internal fields *}
    FMultiList: TMultiList;
    FColumn: integer;
{* property fields *}
{* procedural methods *}
{* getters and setters *}
{* Message Handlers *}
    procedure WMMoving(var msg: TMessage); message WM_MOVING;
  public
    class procedure Show(ML: TMultiList; Col: integer);
  end;

implementation

uses GlobalConsts, Utils;

var
  frmEditRecord: TfrmEditRecord;

{$R *.dfm}

{ TfrmEdit }

class procedure TfrmEditRecord.Show(ML: TMultiList; Col: integer);
begin
  if not assigned(frmEditRecord) then
    frmEditRecord := TfrmEditRecord.CreateEx;

  with frmEditRecord do begin
    FMultiList     := ML;
    FColumn        := Col;
    edtRecord.Text := ML.DesignColumns[Col].Items[ML.selected];
    top            := 100;
  end;

// inherited Show
  frmEditRecord.visible := true;
  frmEditRecord.BringToFront;
end;

constructor TfrmEditRecord.createEx;
begin
  inherited create(application);

  if not SchedulerMode then
    FormStyle := fsMDIChild;

//  SetConstraints(Constraints, height, width);
end;

{* Event Procedures *}

procedure TfrmEditRecord.btnOKClick(Sender: TObject);
begin
  FMultiList.DesignColumns[FColumn].Items[FMultiList.selected] := edtRecord.Text;
  close;
end;

procedure TfrmEditRecord.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action := caFree;
  frmEditRecord  := nil;
end;

procedure TfrmEditRecord.btnCancelClick(Sender: TObject);
begin
  close;
end;

{* getters and setters *}

{* Message Handlers *}

procedure TfrmEditRecord.WMMoving(var msg: TMessage);
begin
  WindowMoving(msg, height, width);
end;

procedure TfrmEditRecord.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if key = VK_ESCAPE then close;
end;

initialization
  frmEditRecord := nil;
end.
