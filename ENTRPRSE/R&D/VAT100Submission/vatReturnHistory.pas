unit vatReturnHistory;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, EnterToTab;

type
  TvatHistoryForm = class(TForm)
    vatReturnList: TListView;
    btnClose: TButton;
    btnView: TButton;
    EnterToTab1: TEnterToTab;
    procedure btnCloseClick(Sender: TObject);
    procedure vatReturnListSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure btnViewClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure vatReturnListColumnClick(Sender: TObject;
      Column: TListColumn);
    procedure vatReturnListCompare(Sender: TObject; Item1,
      Item2: TListItem; Data: Integer; var Compare: Integer);
    procedure vatReturnListCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure vatReturnListCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  vatHistoryForm: TvatHistoryForm;


implementation

uses
  vatUtils,
  vatReturnSummary,
  vatReturnDBManager;

{$R *.dfm}

procedure TvatHistoryForm.btnCloseClick(Sender: TObject);
begin
  close;
end;

procedure TvatHistoryForm.vatReturnListSelectItem(Sender: TObject;
  Item: TListItem; Selected: Boolean);
begin
  btnView.Enabled := Selected and (Item <> nil);
end;

procedure TvatHistoryForm.btnViewClick(Sender: TObject);
var
  selitem : TListItem;
  selRecord : TVATSubmissionRecord;
begin
  selItem := vatReturnList.Selected;
  if (selItem <> nil) then
  begin
    selRecord := selItem.Data;
    // PKR. 09/09/2015. ABSEXCH-16834 Multiple copies of the Submissions window may be opened.
    // The same applies for the summary form
    if not Assigned(vatSummaryForm) then
    begin
      vatSummaryForm := TvatSummaryForm.Create(self);
    end;
    vatSummaryForm.SetVATReturn(selRecord);
    vatSummaryForm.Show;
  end;
end;

procedure TvatHistoryForm.FormShow(Sender: TObject);
var
  newItem   : TListItem;
  DBManager : TVATReturnDBManager;
  index     : integer;
  vatRecord : TVATSubmissionRecord;
begin
  VATReturnList.Clear;

  // Get a list of submissions from the database
  DBManager := NewVAT100DBManager;

  for index := 0 to DBManager.NumberOfRecords-1 do
  begin
    vatRecord := DBManager.GetRecordByIndex(index);
    VATReturnList.AddItem(vatRecord.vatPeriod, vatRecord);
    newItem := VATReturnList.Items[index];

    newItem.SubItems.Add(FormatSubmittedDate(vatRecord.dateSubmitted));

    newItem.SubItems.Add(FormatSubmissionStatus(vatRecord.status));

    // Attach the record to the ListItem.
    newItem.Data := vatRecord;

    // Add the ListItem to the ListView.
    newItem.SubItems.Add(vatRecord.username);
  end;

  if VATReturnList.Items.Count > 0 then
  begin
    VATReturnList.Selected := VATReturnList.Items[0];
  end;

  DBManager.Free;
end;

procedure TvatHistoryForm.vatReturnListColumnClick(Sender: TObject;
  Column: TListColumn);
begin
  // Sort on this column
  if vatReturnList.Tag = 0 then
    vatReturnList.Tag := 1
  else
    vatReturnList.Tag := 0;

  (Sender as TCustomListView).AlphaSort;
end;

procedure TvatHistoryForm.vatReturnListCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
begin
  if vatReturnList.Tag = 0 then
  begin
    If Item1.Caption >= Item2.Caption then
    begin
      Compare := 1;
    end
    else
      Compare := -1;
  end
  else
  begin
    If Item1.Caption >= Item2.Caption then
    begin
      Compare := -1;
    end
    else
      Compare := 1;
  end;
end;

(*



uses
  Winapi.CommCtrl;

var
  Header: HWND;
  Item: THDItem;
begin
  Header := ListView_GetHeader(ListView1.Handle);
  ZeroMemory(@Item, SizeOf(Item));
  Item.Mask := HDI_FORMAT;
  Header_GetItem(Header, 0, Item);
  Item.fmt := Item.fmt and not (HDF_SORTUP or HDF_SORTDOWN);//remove both flags
  Item.fmt := Item.fmt or HDF_SORTUP;//include the sort ascending flag
  Header_SetItem(Header, 0, Item);
end;

*)

procedure TvatHistoryForm.vatReturnListCustomDrawSubItem(
  Sender: TCustomListView; Item: TListItem; SubItem: Integer;
  State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  vatReturnList.Canvas.Brush.Color := clWhite;

//  if SubItem = 2 then
//  begin
    if Item.SubItems[1] = '' then
    begin
      vatReturnList.Canvas.Brush.Color := clWhite;
    end;

    if Item.SubItems[1] = 'Error' then
    begin
      vatReturnList.Canvas.Brush.Color := $008080FF;
      vatReturnList.Canvas.Font.Color := clBlack;
    end;

    if Item.SubItems[1] = 'Submitted' then
    begin
      vatReturnList.Canvas.Brush.Color := clYellow;
      vatReturnList.Canvas.Font.Color := clBlack;
    end;

    if Item.SubItems[1] = 'Pending' then
    begin
      vatReturnList.Canvas.Brush.Color := clBlue;
      vatReturnList.Canvas.Font.Color := clWhite;
    end;

    if Item.SubItems[1] = 'Accepted' then
    begin
      vatReturnList.Canvas.Brush.Color := $00C0FFC0;
      vatReturnList.Canvas.Font.Color := clBlack;
    end;
//  end;
end;

procedure TvatHistoryForm.vatReturnListCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin
    if Item.SubItems[1] = '' then
    begin
      vatReturnList.Canvas.Brush.Color := clWhite;
    end;

    if Item.SubItems[1] = 'Error' then
    begin
      vatReturnList.Canvas.Brush.Color := $008080FF;
      vatReturnList.Canvas.Font.Color := clBlack;
    end;

    if Item.SubItems[1] = 'Submitted' then
    begin
      vatReturnList.Canvas.Brush.Color := clYellow;
      vatReturnList.Canvas.Font.Color := clBlack;
    end;

    if Item.SubItems[1] = 'Pending' then
    begin
      vatReturnList.Canvas.Brush.Color := clBlue;
      vatReturnList.Canvas.Font.Color := clWhite;
    end;

    if Item.SubItems[1] = 'Accepted' then
    begin
      vatReturnList.Canvas.Brush.Color := $00C0FFC0;
      vatReturnList.Canvas.Font.Color := clBlack;
    end;
end;

procedure TvatHistoryForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
  vatHistoryForm := nil;
end;

end.
