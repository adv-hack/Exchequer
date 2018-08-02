unit RecordSizes;

{******************************************************************************}
{ Displays a window detailing the lengths of the standard Exchequer records.   }
{ It currently only displays the records which are of interest to the Importer }
{ project.                                                                     }               
{******************************************************************************}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmRecordSizes = class(TForm)
    lbRecordSizes: TListBox;
    btnClose: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  protected
    constructor create(AOwner: TComponent); override;
  private
    procedure Startup;
{* Message Handlers *}
    procedure WMMoving(var msg: TMessage); message WM_MOVING;
  public
    class procedure Show;
  end;

implementation

uses GlobalTypes, Utils;

var
  frmRecordSizes: TfrmRecordSizes;

{$R *.dfm}

{ TfrmRecordSizes }

class procedure TfrmRecordSizes.Show;
begin
  if not assigned(frmRecordSizes) then
    frmRecordSizes := TfrmRecordSizes.Create(application);

// inherited Show
  frmRecordSizes.visible := true;
  frmRecordSizes.BringToFront;
end;

constructor TfrmRecordSizes.create(AOwner: TComponent);
begin
  inherited;

  Startup;
end;

procedure TfrmRecordSizes.Startup;
begin
//  LBInit(lbRecordSizes);
end;

{* Event Procedures *}

procedure TfrmRecordSizes.btnCloseClick(Sender: TObject);
begin
  close;
end;

procedure TfrmRecordSizes.FormCreate(Sender: TObject);
var
  ExchRec: TExchequerRec;
begin
  left := 683;

  lbRecordSizes.Items.Add(format('%-19s: %.4d', ['TBatchCURec',        SizeOf(ExchRec.BatchCURec)]));
  lbRecordSizes.Items.Add(format('%-19s: %.4d', ['TBatchTHRec',        SizeOf(ExchRec.BatchTHRec)]));
  lbRecordSizes.Items.Add(format('%-19s: %.4d', ['TBatchTLRec',        SizeOf(ExchRec.BatchTLRec)]));
  lbRecordSizes.Items.Add(format('%-19s: %.4d', ['TBatchSKRec',        SizeOf(ExchRec.BatchSKRec)]));
  lbRecordSizes.Items.Add(format('%-19s: %.4d', ['TBatchNomRec',       SizeOf(ExchRec.BatchNomRec)]));
  lbRecordSizes.Items.Add(format('%-19s: %.4d', ['TBatchMatchRec',     SizeOf(ExchRec.BatchMatchRec)]));
  lbRecordSizes.Items.Add(format('%-19s: %.4d', ['TBatchNotesRec',     SizeOf(ExchRec.BatchNotesRec)]));
  lbRecordSizes.Items.Add(format('%-19s: %.4d', ['TBatchJHRec',        SizeOf(ExchRec.BatchJHRec)]));
  lbRecordSizes.Items.Add(format('%-19s: %.4d', ['TBatchMLocRec',      SizeOf(ExchRec.BatchMLocRec)]));
  lbRecordSizes.Items.Add(format('%-19s: %.4d', ['TBatchBOMImportRec', SizeOf(ExchRec.BatchBOMImportRec)]));
  lbRecordSizes.Items.Add(format('%-19s: %.4d', ['TBatchSLRec',        SizeOf(ExchRec.BatchSLRec)]));
  lbRecordSizes.Items.Add(format('%-19s: %.4d', ['TBatchAutoBankRec',  SizeOf(ExchRec.BatchAutoBankRec)]));
  lbRecordSizes.Items.Add(format('%-19s: %.4d', ['TBatchEmplRec',      SizeOf(ExchRec.BatchEmplRec)]));
  lbRecordSizes.Items.Add(format('%-19s: %.4d', ['TBatchJobAnalRec',   SizeOf(ExchRec.BatchJobAnalRec)]));
  lbRecordSizes.Items.Add(format('%-19s: %.4d', ['TBatchJobRateRec',   SizeOf(ExchRec.BatchJobRateRec)]));
  lbRecordSizes.Items.Add(format('%-19s: %.4d', ['TBatchSKAltRec',     SizeOf(ExchRec.BatchSKAltRec)]));
  lbRecordSizes.Items.Add(format('%-19s: %.4d', ['TBatchSerialRec',    SizeOf(ExchRec.BatchSerialRec)]));
  lbRecordSizes.Items.Add(format('%-19s: %.4d', ['TBatchBinRec',       SizeOf(ExchRec.BatchBinRec)]));
  lbRecordSizes.Items.Add(format('%-19s: %.4d', ['TBatchDiscRec',      SizeOf(ExchRec.BatchDiscRec)]));
  lbRecordSizes.Items.Add(format('%-19s: %.4d', ['TBatchCCDepRec',     SizeOf(ExchRec.BatchCCDepRec)]));

  lbRecordSizes.Sorted := true;

  SetConstraints(Constraints, height, width);
end;

procedure TfrmRecordSizes.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action := caFree;
  frmRecordSizes := nil;
end;

{* Message Handlers *}

procedure TfrmRecordSizes.WMMoving(var msg: TMessage);
begin
  WindowMoving(msg, height, width);
end;

procedure TfrmRecordSizes.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_ESCAPE then close;
end;

initialization
  frmRecordSizes := nil;
  
end.
