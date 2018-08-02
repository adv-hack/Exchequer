unit frmVRWSizeU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, BorBtns, Mask, TEditVal, DesignerTypes,
  ComCtrls, RPDefine;

type
  TControlSizing = (csWidthNoChange, csWidthShrink, csWidthGrow, csWidth,
                    csHeightNoChange, csHeightShrink, csHeightGrow, csHeight);
  TfrmVRWSize = class(TForm)
    btnOk: TButton;
    btnCancel: TButton;
    WidthGrp: TGroupBox;
    chkWidthNoChange: TBorRadio;
    chkWidthShrink: TBorRadio;
    chkWidthGrow: TBorRadio;
    chkWidth: TBorRadio;
    HeightGrp: TGroupBox;
    chkHeightNoChange: TBorRadio;
    chkHeightShrink: TBorRadio;
    chkHeightGrow: TBorRadio;
    chkHeight: TBorRadio;
    edtWidth: TEdit;
    spinWidth: TUpDown;
    spinHeight: TUpDown;
    edtHeight: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure edtHeightChange(Sender: TObject);
    procedure edtWidthChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure OnCheckClick(Sender: TObject);
  private
    { Private declarations }
    FHeightSizing: TControlSizing;
    FWidthSizing: TControlSizing;
    FRegionManager: IRegionManager;
    FUpdatingDisplay: Boolean;
    procedure SetHeightSizing(const Value: TControlSizing);
    procedure SetWidthSizing(const Value: TControlSizing);
    procedure SetRegionManager(const Value: IRegionManager);
    property UpdatingDisplay: Boolean
      read FUpdatingDisplay
      write FUpdatingDisplay;
  public
    { Public declarations }
    property WidthSizing: TControlSizing
      read FWidthSizing
      write SetWidthSizing;
    property HeightSizing: TControlSizing
      read FHeightSizing
      write SetHeightSizing;
    property RegionManager: IRegionManager
      read FRegionManager
      write SetRegionManager;
  end;

var
  frmVRWSize: TfrmVRWSize;

implementation

{$R *.dfm}

{ TfrmVRWSize }

procedure TfrmVRWSize.edtHeightChange(Sender: TObject);
begin
  if not UpdatingDisplay then
    HeightSizing := csHeight;
end;

procedure TfrmVRWSize.edtWidthChange(Sender: TObject);
begin
  if not UpdatingDisplay then
    WidthSizing := csWidth;
end;

procedure TfrmVRWSize.FormShow(Sender: TObject);
begin
  WidthSizing := csWidthNoChange;
  HeightSizing := csHeightNoChange;
end;

procedure TfrmVRWSize.OnCheckClick(Sender: TObject);
begin
  if (Sender is TBorRadio) then
    with (Sender as TBorRadio) do
      case Tag of
         1: FWidthSizing  := csWidthNoChange;
         2: FWidthSizing  := csWidthShrink;
         3: FWidthSizing  := csWidthGrow;
         4: FWidthSizing  := csWidth;
         5: FHeightSizing := csHeightNoChange;
         6: FHeightSizing := csHeightShrink;
         7: FHeightSizing := csHeightGrow;
         8: FHeightSizing := csHeight;
      end;
end;

procedure TfrmVRWSize.SetHeightSizing(const Value: TControlSizing);
begin
  if (FHeightSizing <> Value) then
  begin
    FHeightSizing := Value;
    case HeightSizing of
      csHeightNoChange: chkHeightNoChange.Checked := True;
      csHeightShrink:   chkHeightShrink.Checked   := True;
      csHeightGrow:     chkHeightGrow.Checked     := True;
      csHeight:         chkHeight.Checked         := True;
    end;
  end;
end;

procedure TfrmVRWSize.SetRegionManager(const Value: IRegionManager);
begin
  FRegionManager := Value;
  if (FRegionManager <> nil) then
  begin
    UpdatingDisplay := True;
    spinWidth.Min  := RegionManager.rmMinControlWidth;
    spinWidth.Max  := RegionManager.rmPaperWidth;
    spinHeight.Min := RegionManager.rmMinControlHeight;
    if (RegionManager.rmPaperOrientation = poLandscape) then
      spinHeight.Max := RegionManager.rmPaperSizeWidth
    else
      spinHeight.Max := RegionManager.rmPaperSizeHeight;
    UpdatingDisplay := False;
  end;
end;

procedure TfrmVRWSize.SetWidthSizing(const Value: TControlSizing);
begin
  if (FWidthSizing <> Value) then
  begin
    FWidthSizing := Value;
    case WidthSizing of
      csWidthNoChange:  chkWidthNoChange.Checked  := True;
      csWidthShrink:    chkWidthShrink.Checked    := True;
      csWidthGrow:      chkWidthGrow.Checked      := True;
      csWidth:          chkWidth.Checked          := True;
    end;
  end;
end;

end.
