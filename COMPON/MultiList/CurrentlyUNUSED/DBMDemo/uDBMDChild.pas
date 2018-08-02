unit uDBMDChild;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uExDatasets, uBtrieveDataset, ExtCtrls, uMultiList, uDBMultiList,
  Menus, StdCtrls, Spin, ComCtrls;

type
  String20 = string[20];

  TTableType = (ttCustomers, ttDetails, ttJobs, ttSuppliers, ttMisc);
  TDragInfo = record
    DragBegun: boolean;
    ColDragged: integer;
    StartX: integer;
    StartY: integer;
  end;

  TfrmDBMChild = class(TForm)
    BtrieveDataset: TBtrieveDataset;
    timerConfigs: TTimer;
    pnlHeader: TPanel;
    Panel2: TPanel;
    pcDBM: TPageControl;
    tsColumns: TTabSheet;
    tsInteraction: TTabSheet;
    tsDisplay: TTabSheet;
    tsTimers: TTabSheet;
    se1: TSpinEdit;
    se2: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    bnAddCol: TButton;
    bnRemoveCol: TButton;
    bnHideCol: TButton;
    bnInsertCol: TButton;
    bnClearCols: TButton;
    bnSelectRow: TButton;
    bnRandDisplay: TButton;
    bnDisplays: TButton;
    bnMovingCols: TButton;
    edInterval: TEdit;
    lblInterval: TLabel;
    timerMovingCols: TTimer;
    bnMoveCol: TButton;
    bnRandGradients: TButton;
    cbCellGradients: TCheckBox;
    bnSortCol: TButton;
    bnSearchCol: TButton;
    edSearchCol: TEdit;
    lblSearchCol: TLabel;
    timerGradients: TTimer;
    tsMultiSelection: TTabSheet;
    lbMultiselect: TListBox;
    bnMSAddresses: TButton;
    cbIntegrity: TCheckBox;
    cbMultiSelect: TCheckBox;
    cbChangeText: TCheckBox;
    DBM: TDBMultiList;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtrieveDatasetGetFieldValue(Sender: TObject; PData: Pointer; FieldName: String; var FieldValue: String);
    procedure DBMSortColumn(Sender: TObject; ColIndex: Integer; SortAsc: Boolean);
    procedure bnSelectRowClick(Sender: TObject);
    procedure timerConfigsTimer(Sender: TObject);
    procedure bnAddColClick(Sender: TObject);
    procedure bnRemoveColClick(Sender: TObject);
    procedure bnInsertColClick(Sender: TObject);
    procedure bnHideColClick(Sender: TObject);
    procedure bnClearColsClick(Sender: TObject);
    procedure bnDisplaysClick(Sender: TObject);
    procedure bnRandDisplayClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure timerMovingColsTimer(Sender: TObject);
    procedure bnMovingColsClick(Sender: TObject);
    procedure bnMoveColClick(Sender: TObject);
    procedure DBMCellPaint(Sender: TObject; ColumnIndex, RowIndex: Integer; var OwnerText: String; var TextFont: TFont; var TextBrush: TBrush; var TextAlign: TAlignment);
    procedure cbCellGradientsClick(Sender: TObject);
    procedure bnSortColClick(Sender: TObject);
    procedure bnSearchColClick(Sender: TObject);
    procedure timerGradientsTimer(Sender: TObject);
    procedure bnRandGradientsClick(Sender: TObject);
    procedure cbIntegrityClick(Sender: TObject);
    procedure bnMSAddressesClick(Sender: TObject);
    procedure cbMultiSelectClick(Sender: TObject);
    procedure DBMAfterLoad(Sender: TObject);
    procedure cbBoldSelectionClick(Sender: TObject);
    procedure BtrieveDatasetFilterRecord(Sender: TObject; PData: Pointer; var Include: Boolean);
  private
    fLoaded: boolean;
    fTableType: TTableType;
    fRed: byte;
    fBlue: byte;
    fGreen: byte;
    function FullNomKey(ncode: Integer): string20;
  public
    DragInfo: TDragInfo;
    procedure AddColumns(ColCount: integer);
    property TableType: TTableType read fTableType write fTableType;
  end;

var
  frmDBMChild: TfrmDBMChild;

implementation

uses uBTRecords;

{$R *.dfm}

//******************************************************************************

procedure TfrmDBMChild.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:= caFree;
end;

procedure TfrmDBMChild.AddColumns(ColCount: integer);
var
ColIndex: integer;
begin
  for ColIndex:= 0 to Pred(ColCount) do
  begin
    with DBM, Columns.Add do
    begin
      Field:= IntToStr(Pred(Columns.Count));

      case fTableType of
        ttCustomers:
        begin
          case DBMCol of
            0:
            begin
              Caption:= 'Customer Code';
              Searchable:= true;
              Sortable:= true;
            end;
            1:
            begin
              Caption:= 'Company Name';
              Searchable:= true;
              Sortable:= true;
            end;
            2: Caption:= 'Customer Flag';
            3:
            begin
              Caption:= 'Alternate Code';
              Searchable:= true;
              Sortable:= true;
            end;
          end;
        end;
        ttDetails:
        begin
          case DBMCol of
            0: Caption:= 'Doc';
            1: Caption:= 'Period';
            2: Caption:= 'A/C';
            3: Caption:= 'Description';
            4: Caption:= 'Amount';
            5: Caption:= 'Status';
            6: Caption:= 'Date';
          end;
        end;
      end;
    end;
  end;

  DBM.RefreshDB;
end;

//******************************************************************************

procedure TfrmDBMChild.BtrieveDatasetGetFieldValue(Sender: TObject; PData: Pointer; FieldName: String; var FieldValue: String);
begin
  case fTableType of
    ttCustomers: with TCustRec(PData^) do
    begin
      case StrToIntDef(FieldName, -1) of
        0: FieldValue:= CustCode;
        1: FieldValue:= Company;
        2: FieldValue:= CustSupp;
        3: FieldValue:= Trim(CustCode2);
      end;
    end;
  end;
end;

procedure TfrmDBMChild.DBMSortColumn(Sender: TObject; ColIndex: Integer; SortAsc: Boolean);
begin
  case TableType of
    ttCustomers: with DBM, TBtrieveDataset(Dataset) do
    begin
      case DesignIndexes[ColIndex] of
        0: SearchIndex:= 5;
        1: SearchIndex:= 6;
        3: SearchIndex:= 7;
      end;
    end;
  end;
end;

procedure TfrmDBMChild.bnSelectRowClick(Sender: TObject);
begin
  DBM.Selected:= se1.Value;
end;

procedure TfrmDBMChild.timerConfigsTimer(Sender: TObject);
begin
  bnRandDisplayClick(Self);
end;

procedure TfrmDBMChild.bnAddColClick(Sender: TObject);
begin
  AddColumns(1);
end;

procedure TfrmDBMChild.bnRemoveColClick(Sender: TObject);
begin
  with DBM.Columns do
  begin
    if Count <= 0 then Exit;
    if se1.Value < Count then Delete(se1.Value)
    else Delete(Pred(Count));
  end;
end;

procedure TfrmDBMChild.bnInsertColClick(Sender: TObject);
begin
  with DBM.Columns do
  begin
    if se1.Value < Count then Insert(se1.Value)
    else Insert(Pred(Count));
  end;
end;

procedure TfrmDBMChild.bnHideColClick(Sender: TObject);
begin
  with DBM, Columns do
  begin
    if se1.Value < Count then Columns[se1.Value].Visible:= not Columns[se1.Value].Visible
    else Columns[Pred(Count)].Visible:= not Columns[Pred(Count)].Visible;
  end;
end;

procedure TfrmDBMChild.bnClearColsClick(Sender: TObject);
begin
  DBM.Columns.Clear;
end;

procedure TfrmDBMChild.bnDisplaysClick(Sender: TObject);
begin
  with timerConfigs do
  begin
    Interval:= StrToIntDef(edInterval.Text, 1000);
    Enabled:= not Enabled;
  end;
end;

procedure TfrmDBMChild.bnRandDisplayClick(Sender: TObject);
var
ColIndex: integer;
ColColour: TColor;
begin
  with DBM do
  begin
    with Bevels do
    begin
      Frame:= TBevelCut(Random(Ord(bvRaised)));
      Inner:= TBevelCut(Random(Ord(bvRaised)));
      Outer:= TBevelCut(Random(Ord(bvRaised)));
    end;

    if timerConfigs.Interval >= 1000 then with Borders do
    begin
      Inner:= TBorderStyle(Random(Ord(bsSingle)));
      Outer:= TBorderStyle(Random(Ord(bsSingle)));
      Scrollbar:= TBorderStyle(Random(Ord(bsSingle)));
    end;

    with Colours do
    begin
      ActiveColumn:= RGB(Random(255), Random(255), Random(255));
      Buttons:= RGB(Random(255), Random(255), Random(255));
      Frame:= RGB(Random(255), Random(255), Random(255));
      ColColour:= RGB(Random(255), Random(255), Random(255));
      for ColIndex:= 0 to Pred(Columns.Count) do Columns[ColIndex].Color:= ColColour;
      MultiSelection:= RGB(Random(255), Random(255), Random(255));
      Scrollbar:= RGB(Random(255), Random(255), Random(255));
      Selection:= RGB(Random(255), Random(255), Random(255));
      SelectionText:= RGB(Random(255), Random(255), Random(255));
      SortableTriangle:= RGB(Random(255), Random(255), Random(255));
      SortedTriangle:= RGB(Random(255), Random(255), Random(255));
      Spacer:= RGB(Random(255), Random(255), Random(255));
      Splitter:= RGB(Random(255), Random(255), Random(255));
    end;

    with Dimensions do
    begin
      HeaderHeight:= Random(40) + 15;
      SpacerWidth:= Random(50);
      SplitterWidth:= Random(15);
      if Borders.Scrollbar = bsSingle then ScrollBarWidth:= 22 else ScrollBarWidth:= 18;
    end; 
  end;
end;

procedure TfrmDBMChild.FormCreate(Sender: TObject);
begin
  pcDBM.ActivePage:= tsColumns;
end;

procedure TfrmDBMChild.timerMovingColsTimer(Sender: TObject);
var
NewLoc, OldLoc: integer;
begin
  with DBM, Columns do
  begin
    if Count < 2 then Exit;

    OldLoc:= Random(Count);
    NewLoc:= Random(Count);
    while NewLoc = OldLoc do NewLoc:= Random(Count);
    MoveColumn(OldLoc, NewLoc);
  end;
end;

procedure TfrmDBMChild.bnMovingColsClick(Sender: TObject);
begin
  with timerMovingCols do
  begin
    Interval:= StrToIntDef(edInterval.Text, 1000);
    Enabled:= not Enabled;
  end;
end;

procedure TfrmDBMChild.bnMoveColClick(Sender: TObject);
begin
  if se1.Value <> se2.Value then DBM.MoveColumn(se1.Value, se2.Value);
end;

procedure TfrmDBMChild.cbCellGradientsClick(Sender: TObject);
begin
  fRed:= Random(2);
  fBlue:= Random(2);
  fGreen:= Random(2);
  DBM.Invalidate;
end;

procedure TfrmDBMChild.bnSortColClick(Sender: TObject);
begin
  with DBM, Columns do
  begin
    if se1.Value >= Count then Exit;

    if (se1.Value = SortedIndex) then SortColumn(se1.Value, not SortedAsc)
    else SortColumn(se1.Value, true);
  end;
end;

procedure TfrmDBMChild.bnSearchColClick(Sender: TObject);
begin
  DBM.SortColumn(se1.Value, true);
  DBM.SearchColumn(se1.Value, edSearchCol.Text);
end;

procedure TfrmDBMChild.timerGradientsTimer(Sender: TObject);
begin
  fRed:= Random(2);
  fBlue:= Random(2);
  fGreen:= Random(2);
  DBM.Invalidate;
end;

procedure TfrmDBMChild.bnRandGradientsClick(Sender: TObject);
begin
  with timerGradients do
  begin
    Interval:= StrToIntDef(edInterval.Text, 1000);
    Enabled:= not Enabled;
  end;
end;

procedure TfrmDBMChild.cbIntegrityClick(Sender: TObject);
begin
  DBM.Options.MultiSelectIntegrity:= cbIntegrity.Checked;
end;

procedure TfrmDBMChild.bnMSAddressesClick(Sender: TObject);
var
ControlSelects: TControlSelectType;
ShiftSelects: TShiftSelectType;
SelectIndex: integer;
begin
  ControlSelects:= DBM.GetControlSelected;
  ShiftSelects:= DBM.GetShiftSelected;

  with lbMultiselect do
  begin
    Clear;
    for SelectIndex:= Low(ControlSelects) to High(ControlSelects) do Items.Add(ControlSelects[SelectIndex]);
    for SelectIndex:= Low(ShiftSelects) to High(ShiftSelects) do
    begin
      Items.Add('Low:  ' + ShiftSelects[SelectIndex].RangeLow);
      Items.Add('High: ' + ShiftSelects[SelectIndex].RangeHigh);
    end;
  end;
end;

procedure TfrmDBMChild.cbMultiSelectClick(Sender: TObject);
begin
  DBM.Options.MultiSelection:= cbMultiSelect.Checked;
end;

procedure TfrmDBMChild.DBMAfterLoad(Sender: TObject);
begin
  if not fLoaded then
  begin
    fLoaded:= true;
    DBM.SortColumn(0, true);
  end;
end;

procedure TfrmDBMChild.cbBoldSelectionClick(Sender: TObject);
begin
  DBM.Invalidate;
end;

procedure TfrmDBMChild.DBMCellPaint(Sender: TObject; ColumnIndex, RowIndex: Integer; var OwnerText: String; var TextFont: TFont; var TextBrush: TBrush; var TextAlign: TAlignment);
var
CurrentVal: integer;
begin
  if cbCellGradients.Checked then
  begin
    CurrentVal:= RowIndex * 10;
    if RowIndex <> DBM.Selected then TextFont.Color:= RGB(CurrentVal * fRed, CurrentVal * fGreen, CurrentVal * fBlue);
    if RowIndex <> DBM.Selected then TextBrush.Color:= RGB(255 - (fRed * CurrentVal), 255 - (fGreen * CurrentVal), 255 - (fBlue * CurrentVal));
  end;

  if cbChangeText.Checked then
  begin
    case fTableType of
      ttCustomers: if DBM.DesignIndexes[ColumnIndex] = 2 then
      begin
        if UpperCase(OwnerText) = 'C' then OwnerText:= 'Customer';
      end;
    end;
  end;
end;

procedure TfrmDBMChild.BtrieveDatasetFilterRecord(Sender: TObject; PData: Pointer; var Include: Boolean);
begin
  case fTableType of
    ttCustomers: Include:= TCustRec(PData^).CustCode > 'M';
  end;
end;

function TfrmDBMChild.FullNomKey(ncode: Longint): string20;
var
TmpStr: string20;
begin
  FillChar(TmpStr, Sizeof(TmpStr), 0);
  Move(ncode, TmpStr[1], SizeOf(ncode));
  TmpStr[0]:= Chr(SizeOf(ncode));
  FullNomKey:= TmpStr;
end;

initialization
Randomize;

end.
