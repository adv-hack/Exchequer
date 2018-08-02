unit uTest;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, uDBMultiList, ExtCtrls, StdCtrls, ComCtrls, DB,
  ADODB, Menus, uScrollBar, ImgList, uDBMColumns, Spin, uMultiList,
  pvtables, btvtables, DBAccess, MSAccess, MemDS, uExDatasets, sqldataset,
  pvsqltables, uSQLDatasets, Buttons, uBTRecords, uBtrieveDataset;

type
  TfrmTest = class(TForm)
    PopupMenu1: TPopupMenu;
    hi1: TMenuItem;
    Panel1: TPanel;
    bnColVisible: TButton;
    GroupBox1: TGroupBox;
    bnAddCol: TButton;
    bnDeleteCol: TButton;
    bnInsertCol: TButton;
    bnClearCol: TButton;
    GroupBox2: TGroupBox;
    edText: TEdit;
    bnTextAll: TButton;
    bnTextRuntime: TButton;
    bnTextDesign: TButton;
    there1: TMenuItem;
    cbBoldSelect: TCheckBox;
    cbRandomText: TCheckBox;
    seLines: TSpinEdit;
    Label1: TLabel;
    bnCnfg1: TButton;
    bnCnfg2: TButton;
    bnCnfg3: TButton;
    bnCnfg4: TButton;
    bnCnfg5: TButton;
    bnSelect: TButton;
    edFilter: TEdit;
    bnFilter: TButton;
    edSort: TEdit;
    Button1: TButton;
    edSearch: TEdit;
    bnSearch: TButton;
    cbFlicker: TCheckBox;
    bnRefresh: TButton;
    DBMultiList1: TDBMultiList;
    DBMultiList2: TDBMultiList;
    DBMultiList3: TDBMultiList;
    Button2: TButton;
    cbRefresh: TCheckBox;
    cbReturnAll: TCheckBox;
    Button3: TButton;
    Button4: TButton;
    BitBtn1: TBitBtn;
    SpeedButton1: TSpeedButton;
    MultiList1: TMultiList;
    DBMultiList4: TDBMultiList;
    Button5: TButton;
    Button6: TButton;
    bnResetCols: TButton;
    BtrieveDataset2: TBtrieveDataset;
    ImageList2: TImageList;
    SQLDatasets1: TSQLDatasets;
    Timer1: TTimer;
    procedure bnAddColClick(Sender: TObject);
    procedure bnDeleteColClick(Sender: TObject);
    procedure bnTextAllClick(Sender: TObject);
    procedure MultiList1ScrollClick(ScrollType: TScrollType; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure bnTextRuntimeClick(Sender: TObject);
    procedure bnColVisibleClick(Sender: TObject);
    procedure bnInsertColClick(Sender: TObject);
    procedure bnClearColClick(Sender: TObject);
    procedure bnTextDesignClick(Sender: TObject);
    procedure cbBoldSelectClick(Sender: TObject);
    procedure bnCnfg1Click(Sender: TObject);
    procedure bnCnfg2Click(Sender: TObject);
    procedure bnCnfg3Click(Sender: TObject);
    procedure bnCnfg4Click(Sender: TObject);
    procedure bnSelectClick(Sender: TObject);
    procedure bnCnfg5Click(Sender: TObject);
    procedure bnFilterClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure bnSearchClick(Sender: TObject);
    procedure cbFlickerClick(Sender: TObject);
    procedure edTextKeyPress(Sender: TObject; var Key: Char);
    procedure bnRefreshClick(Sender: TObject);
    procedure DBMultiList1Navigate(Sender: TObject; var Allow: Boolean;
      NewSelected: Integer);
    procedure DBMultiList1SearchColumn(ColIndex: Integer;
      SearchStr: String);
    procedure DBMultiList1CellPaint(Sender: TObject; ColumnIndex,
      RowIndex: Integer; var OwnerText: String; var TextFont: TFont;
      var TextAlign: TAlignment);
    procedure Button2Click(Sender: TObject);
    procedure cbRefreshClick(Sender: TObject);
    procedure cbReturnAllClick(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure DBMultiList2CellPaint(Sender: TObject; ColumnIndex,
      RowIndex: Integer; var OwnerText: String; var TextFont: TFont;
      var TextBrush: TBrush; var TextAlign: TAlignment);
    procedure MultiList1CellPaint(Sender: TObject; ColumnIndex,
      RowIndex: Integer; var OwnerText: String; var TextFont: TFont;
      var TextBrush: TBrush; var TextAlign: TAlignment);
    procedure FormCreate(Sender: TObject);
    procedure BtrieveDataset2GetFieldValue(Sender: TObject; PData: Pointer;
      FieldName: String; var FieldValue: String);
    procedure BtrieveDataset2FilterRecord(Sender: TObject; PData: Pointer;
      var Include: Boolean);
    procedure DBMultiList4SortColumn(Sender: TObject; ColIndex: Integer; SortAsc: Boolean);
    procedure SpeedButton1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure bnResetColsClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  end;

var
  frmTest: TfrmTest;

implementation

{$R *.dfm}

procedure TfrmTest.bnAddColClick(Sender: TObject);
begin
  with MultiList1, Columns do
  begin
    Add;
    if Count mod 2 > 0 then Columns[Count - 1].Color:= clMoneyGreen;
  end;
end;

procedure TfrmTest.bnInsertColClick(Sender: TObject);
begin
  with MultiList1, Columns do
  begin
    if Count < 1 then Exit;
    Insert(1);
  end;
end;

procedure TfrmTest.bnDeleteColClick(Sender: TObject);
begin
  with MultiList1, Columns do
  begin
    if Count < 1 then Exit;
    Delete(Count - 1);
  end;
end;

procedure TfrmTest.bnClearColClick(Sender: TObject);
begin
  MultiList1.Columns.Clear;
end;

procedure TfrmTest.bnTextAllClick(Sender: TObject);
var
ColIndex, ItemIndex: integer;
begin
  if cbRandomText.Checked then Randomize;

  with MultiList1 do
  begin
    BeginUpdate;
    try

      for ItemIndex:= 1 to seLines.Value do for ColIndex:= 0 to Columns.Count - 1 do
      begin
        if cbRandomText.Checked then Columns[ColIndex].Items.Add(IntToStr(Random(99999)) + ' ' + IntToStr(Random(99999)))
        else Columns[ColIndex].Items.Add(edText.Text);
      end;

    finally
      EndUpdate;
    end;
  end;
end;

procedure TfrmTest.bnTextRuntimeClick(Sender: TObject);
begin
  if MultiList1.Columns.Count < 2 then Exit;

  if cbRandomText.Checked then
  begin
    Randomize;
    MultiList1.Columns[1].Items.Add(IntToStr(Random(99999)) + ' ' + IntToStr(Random(99999)))
  end
  else MultiList1.Columns[1].Items.Add(edText.Text);
end;

procedure TfrmTest.bnTextDesignClick(Sender: TObject);
var
DBMColumn: TDBMColumn;
begin
  DBMColumn:= MultiList1.DesignColumns[1];   //Alternatively .Items.Add(edText.Text); without checking for assignment;
  if Assigned(DBMColumn) then with DBMColumn do
  begin
    if cbRandomText.Checked then
    begin
      Randomize;
      Items.Add(IntToStr(Random(99999)) + ' ' + IntToStr(Random(99999)))
    end
    else Items.Add(edText.Text);
  end;
end;

procedure TfrmTest.MultiList1ScrollClick(ScrollType: TScrollType; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  case ScrollType of
    stFirst: Caption:= 'First Clicked';
    stPageUp: Caption:= 'Page Up Clicked';
    stLineUp: Caption:= 'Line Up Clicked';
    stLineDown: Caption:= 'Line Down Clicked';
    stPageDown: Caption:= 'Page Down Clicked';
    stLast: Caption:= 'Last Clicked';
  end;
end;

procedure TfrmTest.bnColVisibleClick(Sender: TObject);
begin
  with MultiList1 do
  begin
    if Columns.Count < 1 then Exit;
    if DesignColumns[0].Visible then DesignColumns[0].Visible:= false else DesignColumns[0].Visible:= true;
  end;
end;

procedure TfrmTest.bnSelectClick(Sender: TObject);
begin
  MultiList1.Selected:= 2;
end;

procedure TfrmTest.cbBoldSelectClick(Sender: TObject);
begin
  MultiList1.Invalidate;
end;

procedure TfrmTest.bnCnfg1Click(Sender: TObject);
var
ColIndex: integer;
begin
  with MultiList1 do
  begin
    Selected:= -1;
    Columns.Clear;
    for ColIndex:= 0 to 5 do
    begin
      Columns.Add;
      Columns[ColIndex].Color:= clSkyBlue;
      Columns[ColIndex].Alignment:= taRightJustify;
    end;
    Colours.Frame:= clSilver;
    Colours.Splitter:= clSilver;
    Colours.Scrollbar:= clSilver;
    Colours.Buttons:= clSkyBlue;
    Borders.Scrollbar:= bsSingle;
    Borders.Inner:= bsSingle;
    Bevels.Frame:= bvRaised;
    Dimensions.ScrollbarWidth:= 22;
    Bevels.ScrollBar:= bvNone;
    Borders.Outer:= bsNone;
    Dimensions.SpacerWidth:= 5;
    Font.Name:= 'MS Sans Serif';
    Bevels.Inner:= bvNone;
    Bevels.Outer:= bvNone;
    Bevels.Width:= 1;
    Dimensions.SplitterWidth:= 6;
    Colours.SelectionText:= clHighlightText;
    Colours.Selection:= clHighlight;
    Font.Color:= clBlack;
  end;
end;

procedure TfrmTest.bnCnfg2Click(Sender: TObject);
var
ColIndex: integer;
begin
  with MultiList1 do
  begin
    Selected:= -1;
    Columns.Clear;
    for ColIndex:= 0 to 3 do
    begin
      Columns.Add;
      Columns[ColIndex].Color:= clWhite;
      Columns[ColIndex].Alignment:= taCenter;
      Columns[ColIndex].Width:= 150;
    end;
    Colours.Frame:= $005CA372;
    Colours.Splitter:= $005CA372;
    Colours.Scrollbar:= clBtnFace;
    Colours.Buttons:= clSilver;
    Borders.Scrollbar:= bsSingle;
    Borders.Inner:= bsSingle;
    Bevels.Frame:= bvRaised;
    Dimensions.ScrollbarWidth:= 22;
    Bevels.ScrollBar:= bvNone;
    Borders.Outer:= bsNone;
    Dimensions.SpacerWidth:= 50;
    Font.Name:= 'Arial';
    Bevels.Inner:= bvNone;
    Bevels.Outer:= bvNone;
    Bevels.Width:= 1;
    Dimensions.SplitterWidth:= 6;
    Colours.SelectionText:= clMoneyGreen;
    Colours.Selection:= clMaroon;
    Font.Color:= clNavy;
  end;
end;

procedure TfrmTest.bnCnfg3Click(Sender: TObject);
var
ColIndex: integer;
begin
  with MultiList1 do
  begin
    Selected:= -1;
    Columns.Clear;
    for ColIndex:= 0 to 10 do
    begin
      Columns.Add;
      Columns[ColIndex].Color:= clWhite;
      Columns[ColIndex].Alignment:= taCenter;
      Columns[ColIndex].Width:= 100;
    end;
    Colours.Frame:= clBtnFace;
    Colours.Splitter:= clBtnFace;
    Colours.Scrollbar:= clBtnFace;
    Colours.Buttons:= clBtnFace;
    Borders.Scrollbar:= bsNone;
    Borders.Inner:= bsNone;
    Bevels.Frame:= bvLowered;
    Dimensions.ScrollbarWidth:= 18;
    Bevels.ScrollBar:= bvNone;
    Borders.Outer:= bsNone;
    Dimensions.SpacerWidth:= 5;
    Font.Name:= 'Arial';
    Bevels.Inner:= bvNone;
    Bevels.Outer:= bvNone;
    Bevels.Width:= 1;
    Dimensions.SplitterWidth:= 6;
    Colours.SelectionText:= clYellow;
    Colours.Selection:= clBlue;
    Font.Color:= clMaroon;
  end;
end;

procedure TfrmTest.bnCnfg4Click(Sender: TObject);
var
ColIndex: integer;
begin
  with MultiList1 do
  begin
    Selected:= -1;
    Columns.Clear;
    for ColIndex:= 0 to 3 do
    begin
      Columns.Add;
      Columns[ColIndex].Color:= clMoneyGreen;
      Columns[ColIndex].Alignment:= taCenter;
      Columns[ColIndex].Width:= (ColIndex + 1) * 100;
    end;
    Colours.Frame:= clBtnFace;
    Colours.Splitter:= clBtnFace;
    Colours.Scrollbar:= clBtnFace;
    Colours.Buttons:= clBtnFace;
    Borders.Scrollbar:= bsNone;
    Borders.Inner:= bsNone;
    Bevels.Frame:= bvNone;
    Dimensions.ScrollbarWidth:= 18;
    Bevels.ScrollBar:= bvNone;
    Borders.Outer:= bsNone;
    Dimensions.SpacerWidth:= 0;
    Font.Name:= 'Times New Roman';
    Bevels.Inner:= bvNone;
    Bevels.Outer:= bvNone;
    Bevels.Width:= 1;
    Dimensions.SplitterWidth:= 6;
    Colours.SelectionText:= clYellow;
    Colours.Selection:= clRed;
    Font.Color:= clBlack;
  end;
end;

procedure TfrmTest.bnCnfg5Click(Sender: TObject);
var
ColIndex: integer;
begin
  with MultiList1 do
  begin
    Selected:= -1;
    Columns.Clear;
    for ColIndex:= 0 to 6 do
    begin
      Columns.Add;
      Columns[ColIndex].Color:= clSilver;
      Columns[ColIndex].Alignment:= taCenter;
    end;
    Colours.Frame:= clMoneyGreen;
    Colours.Splitter:= clMoneyGreen;
    Colours.Scrollbar:= clSilver;
    Colours.Buttons:= clSkyBlue;
    Borders.Scrollbar:= bsNone;
    Borders.Inner:= bsNone;
    Bevels.Frame:= bvRaised;
    Dimensions.ScrollbarWidth:= 20;
    Bevels.ScrollBar:= bvLowered;
    Borders.Outer:= bsSingle;
    Dimensions.SpacerWidth:= 5;
    Font.Name:= 'MS Sans Serif';
    Bevels.Inner:= bvRaised;
    Bevels.Outer:= bvLowered;
    Bevels.Width:= 5;
    Dimensions.SplitterWidth:= 12;
    Colours.SelectionText:= clHighlightText;
    Colours.Selection:= clHighlight;
    Font.Color:= clBlue;
  end;
end;

procedure TfrmTest.bnFilterClick(Sender: TObject);
begin
//  DBMultiList2.DBFilter:= edFilter.Text;
end;

procedure TfrmTest.Button1Click(Sender: TObject);
begin
  DBMultiList1.SortColumn(StrToInt(edSort.Text), true);
end;

procedure TfrmTest.bnSearchClick(Sender: TObject);
begin
  DBMultiList1.SearchColumn(StrToInt(edSort.Text), edSearch.Text);
end;

procedure TfrmTest.cbFlickerClick(Sender: TObject);
begin
 DBMultiList4.FlickerReduction:= cbFlicker.Checked;
end;

procedure TfrmTest.edTextKeyPress(Sender: TObject; var Key: Char);
begin
  application.mainform.caption := key;
end;

procedure TfrmTest.bnRefreshClick(Sender: TObject);
begin
  DBMultiList4.RefreshDB;
end;

procedure TfrmTest.DBMultiList1Navigate(Sender: TObject;
  var Allow: Boolean; NewSelected: Integer);
begin
  //DBMultiList1.RefreshDB;
end;

procedure TfrmTest.DBMultiList1SearchColumn(ColIndex: Integer;  SearchStr: String);
begin
  //lblSearch.Caption:= 'Searching ' + DBMultiList1.Columns[ColIndex].Caption + ' for: ' + SearchStr;
end;

procedure TfrmTest.DBMultiList1CellPaint(Sender: TObject; ColumnIndex,
  RowIndex: Integer; var OwnerText: String; var TextFont: TFont;
  var TextAlign: TAlignment);
begin
  if OwnerText = 'Mike' then OwnerText:= 'Hallelujah';
end;

procedure TfrmTest.Button2Click(Sender: TObject);
begin
  //DBMultiList3.DBFilter:= edFilter.Text;
end;

procedure TfrmTest.cbRefreshClick(Sender: TObject);
begin
  DBMultiList3.Dataset.KeepConnection:= cbRefresh.Checked;
end;

procedure TfrmTest.cbReturnAllClick(Sender: TObject);
begin
  TSQLDatasets(DBMultiList3.Dataset).ReturnAllFields:= cbReturnAll.Checked;
end;

procedure TfrmTest.Button3Click(Sender: TObject);
var
Ctly: TControlSelectType;
ControlIndex: integer;
begin
  Ctly:= dbmultilist4.GetControlSelected;
  for ControlIndex:= low(Ctly) to high(Ctly) do
  begin
    showmessage(Ctly[ControlIndex]);
  end;
end;

procedure TfrmTest.Button4Click(Sender: TObject);
var
Shifty: TShiftSelectType;
ShiftIndex: integer;
begin
  Shifty:= dbmultilist4.GetShiftSelected;
  for shiftindex:= low(shifty) to high(shifty) do
  begin
    showmessage('Low: ' + shifty[shiftindex].RangeLow + ' High: ' + shifty[shiftindex].RangeHigh);
  end;
end;

procedure TfrmTest.DBMultiList2CellPaint(Sender: TObject; ColumnIndex,
  RowIndex: Integer; var OwnerText: String; var TextFont: TFont;
  var TextBrush: TBrush; var TextAlign: TAlignment);
{var
TestCol: TDBMColumn;}
begin
  if RowIndex <> DBMultiList2.Selected then TextFont.Color := RGB(RowIndex * 10, RowIndex * 10, RowIndex * 10);
  if RowIndex <> DBMultiList2.Selected then TextBrush.Color := RGB(255 - RowIndex * 10, 255 - RowIndex * 10, 255 - RowIndex * 10);
   
  {TestCol:= DBMultiList2.GetDesignCol(1);
  with DBMultiList2, TestCol do
  begin
    if (Items[RowIndex] > 'N') then TextBrush.Color:= clRed;
  end;}
end;

procedure TfrmTest.MultiList1CellPaint(Sender: TObject; ColumnIndex,
  RowIndex: Integer; var OwnerText: String; var TextFont: TFont;
  var TextBrush: TBrush; var TextAlign: TAlignment);
begin
  //Using selected instead of isselected will test the cursor position only, and exclude multiselects;
  if cbBoldSelect.Checked and MultiList1.IsSelected(RowIndex) then TextFont.Style:= [fsBold];

  if Length(OwnerText) >= 12 then with MultiList1 do
  begin
    if Selected <> RowIndex then TextFont.Color:= clRed;   //Leave the selected text as SelTextColour;
    TextAlign:= taRightJustify;
    OwnerText:= 'This text was overwritten!';
  end;
end;

procedure TfrmTest.FormCreate(Sender: TObject);
begin
  //Multilist1.RecordSize:= SizeOf(TCustRec);
end;

procedure TfrmTest.BtrieveDataset2GetFieldValue(Sender: TObject; PData: Pointer; FieldName: String; var FieldValue: String);
var
CustRec: TCustRec;
//MiscRec: TMLocRec;
begin
  CustRec:= TCustRec(PData^);

  case StrToIntDef(FieldName, -1) of
    0: FieldValue:= CustRec.CustCode;
    1: FieldValue:= CustRec.Company;
    2: FieldValue:= CustRec.CustSupp;
    3: FieldValue:= Trim(CustRec.CustCode2);
  end;

  {MiscRec:= TMLocRec(PData^);

  case StrToIntDef(FieldName, -1) of
    0: FieldValue:= MiscRec.MStkLoc.lsStkCode;
    1: FieldValue:= MiscRec.MStkLoc.lsLocCode;
    2: FieldValue:= MiscRec.RecPfix + MiscRec.SubType;
  end;}
end;

procedure TfrmTest.BtrieveDataset2FilterRecord(Sender: TObject; PData: Pointer; var Include: Boolean);
var
CustRec: TCustRec;
begin
  CustRec:= TCustRec(PData^);
  Include:= true;
end;

procedure TfrmTest.SpeedButton1Click(Sender: TObject);
begin
  dbMultilist4.options.MultiSelection := true;
  if dbmultilist4.options.multiselection then showmessage('dbmulti on') else showmessage('dbmulti off');
end;

procedure TfrmTest.BitBtn1Click(Sender: TObject);
begin
  multilist1.options.multiselection:= true;
  if multilist1.options.multiselection then showmessage('multi on') else showmessage('multi off');
end;

procedure TfrmTest.Button5Click(Sender: TObject);
begin
  with DBMultilist4, Custom do
  begin
    if UserName = 'Mike' then UserName:= 'Nick' else UserName:= 'Mike';
    InitialiseUser;
  end;
end;

procedure TfrmTest.Button6Click(Sender: TObject);
var
Positions, Widths: TSettings;
begin
  SetLength(Positions, 4);                
  SetLength(Widths, 4);

  {If you try to position a non-existent column in a position it won't happen;
   If you move columns to non-existent positions it won't happen;}

  Positions[0]:= 3;
  Positions[1]:= 2;
  Positions[2]:= 0;
  Positions[3]:= 15;
  Widths[0]:= 25;
  Widths[1]:= 50;
  Widths[2]:= 75;
  Widths[3]:= 100;

  DBMultiList4.ApplySettings(Positions, Widths);
end;

procedure TfrmTest.bnResetColsClick(Sender: TObject);
begin
  DBMultilist4.ResetColumns;
end;

procedure TfrmTest.Timer1Timer(Sender: TObject);
var
NewLoc, OldLoc: integer;
begin
  Randomize;
  OldLoc:= Random(4);
  NewLoc:= Random(4);
  while NewLoc = OldLoc do NewLoc:= Random(4);
  DBMultilist4.MoveColumn(OldLoc, NewLoc);
end;

procedure TfrmTest.DBMultiList4SortColumn(Sender: TObject; ColIndex: Integer; SortAsc: Boolean);
begin
  with DBMultilist4, TBtrieveDataset(Dataset) do
  begin
    case DesignIndexes[ColIndex] of
      0: SearchIndex:= 5;
      1: SearchIndex:= 6;
      3: SearchIndex:= 7;
    end;
  end;
end;

end.

