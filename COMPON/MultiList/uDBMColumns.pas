unit uDBMColumns;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls
  , uExDatasets;

const
  DBM_COLCREATED = WM_USER + 100;
  DBM_COLDESTROYED = WM_USER + 101;
  DBM_CAPTIONCHANGED = WM_USER + 102;
  DBM_WIDTHCHANGED = WM_USER + 103;
  DBM_COLOURCHANGED = WM_USER + 104;
  DBM_ALIGNMENTCHANGED = WM_USER + 105;
  DBM_ITEMSCHANGED = WM_USER + 106;
  DBM_SELECTCHANGED = WM_USER + 107;
  DBM_VISIBLECHANGED = WM_USER + 108;
  DBM_SORTABLECHANGED = WM_USER + 109;

type
//  TDBMDataType = (dtString, dtInteger, dtDate, dtTime, dtDateTime, dtBoolean, dtFloat, dtCurrency);

  TDBMStringList = class(TStringList)
  private
    fUpdating: boolean;
    fChanged: boolean;
    fItemsChanged: TNotifyEvent;
  public
    constructor Create;
    function Add(const S: string): Integer; override;
    function AddObject(const S: string; AObject: TObject): Integer; override;
    procedure Delete(Index: Integer); override;
    procedure Insert(Index: Integer; const S: string); override;
    procedure Clear; override;
    procedure BeginUpdate;
    procedure EndUpdate;
    property IsChanged: boolean read fChanged write fChanged;
    property OnItemsChanged: TNotifyEvent read fItemsChanged write fItemsChanged;
    procedure Put(Index: Integer; const S: string); override;
  end;

  TDBMColumn = class(TCollectionItem)
  private
    fItems: TDBMStringList;

    fAlignment: TAlignment;
    fCaption: string;
    fColour: TColor;
    fDataType: TDBMDataType;
    fDrawFormat: cardinal;
    fDBMCol: integer;
    fDBMWidth: integer;
    fField: string;
    fSearchable: boolean;
    fSortable: boolean;
    fTag: integer;
    fVisible: boolean;
    fWidth: integer;
    fWrapCaption: boolean;
    fIndexNo: integer;
    fDesignColPos : byte;
    fCurrentColPos : byte;
    fCustomSortHandler: TStringListSortCompare;

    procedure SetDesignColPos(iNewPos : byte);
    procedure SetCurrentColPos(iNewPos : byte);
    procedure NotifyDBM(const DBMMsgID: integer; const DBMLParam: Word = 0; const DBMWParam: Word = 0);
    procedure ItemsChanged(Sender: TObject);
    procedure SetAlignment(NewAlignment: TAlignment);
    procedure SetCaption(NewCaption: string);
    procedure SetColour(NewColour: TColor);
    procedure SetField(NewField: string);
    procedure SetSortable(Value: boolean);
    procedure SetVisible(NewVisible: boolean);
    procedure SetWidth(NewWidth: integer);
    procedure SetWrapCaption(NewWrapCaption: boolean);
  protected
    function GetDisplayName: string; override;
  public
    constructor Create(Collection: TCollection); override;
    destructor Destroy; override;
    procedure Assign(Source: TPersistent); override;
    procedure BeginUpdate;
    procedure EndUpdate;
    property DBMCol: integer read fDBMCol write fDBMCol;
    property DBMWidth: integer read fDBMWidth write fDBMWidth;
    property Items: TDBMStringList read fItems write fItems;
    property DrawFormat: cardinal read fDrawFormat write fDrawFormat;
    property DesignColPos : byte read FDesignColPos write SetDesignColPos;
    property CurrentColPos : byte read FCurrentColPos write SetCurrentColPos;

    // CJS: 26/01/2010 - If CustomSortHandler is assigned, the
    // TStringList.CustomSort method will be used to sort by this column,
    // passing the CustomerSortHandler function to it (see the Delphi Help for
    // more information).
    property CustomSortHandler: TStringListSortCompare
      read fCustomSortHandler write fCustomSortHandler;
  published
    property Alignment: TAlignment read fAlignment write SetAlignment default taLeftJustify;
    property Caption: string read fCaption write SetCaption;
    property Color: TColor read fColour write SetColour default clWindow;
    property DataType: TDBMDataType read fDataType write fDataType default dtString;
    property Field: string read fField write SetField;
    property Searchable: boolean read fSearchable write fSearchable default false;
    property Sortable: boolean read fSortable write SetSortable default false;
    property Visible: boolean read fVisible write SetVisible default true;
    property Width: integer read fWidth write SetWidth default 100;
    property WrapCaption: boolean read fWrapCaption write SetWrapCaption default false;
    property Tag: integer read fTag write fTag default 0;
    property IndexNo: integer read fIndexNo write fIndexNo default 0;
  end;

  TDBMColumns = class(TOwnedCollection)
  private
    function GetItem(Index: Integer): TDBMColumn;
    procedure SetItem(Index: Integer; Value: TDBMColumn);
  protected
    procedure Update(Item: TCollectionItem); override;
  public
    constructor Create(AOwner: TComponent);
    function Add: TDBMColumn;
    function Insert(Index: Integer): TDBMColumn;
    property Items[Index: Integer]: TDBMColumn read GetItem write SetItem; default;
  end;

implementation

//*** TDBMStringList ***********************************************************

constructor TDBMStringList.Create;
begin
  {The DBMColumns items must notify parents when the items have changed, for
   repainting; The DBMStringlist is a stringlist with these capabilities; The
   OnItemsChanged event is used to notify DBMColumns of any item changes; If
   multiple items are being added, these notifications can be suspended using
   BeginUpdate and EndUpdate which toggle the fUpdating flag;

   The IsChanged property is used by DBMultiList to determine which columns must
   be repainted; Only those that need to be repainted will be; All columns
   initially need to be painted so fChanged is true;}

  inherited Create;
  fChanged:= true;
  fUpdating:= false;
end;

{The following overrides fire the OnItemsChanged event assigned to DBMColumns;
 The event is not fired if fUpdating is true and the stringlist is in update mode;}

function TDBMStringList.Add(const S: string): Integer;
begin
  Result:= inherited Add(S);
  if not fUpdating then OnItemsChanged(Self);
end;

function TDBMStringList.AddObject(const S: string; AObject: TObject): Integer;
begin
  Result:= inherited AddObject(S, AObject);
  if not fUpdating then OnItemsChanged(Self);
end;

procedure TDBMStringList.Delete(Index: Integer);
begin
  inherited Delete(Index);
  if not fUpdating then OnItemsChanged(Self);
end;

procedure TDBMStringList.Insert(Index: Integer; const S: string);
begin
  inherited Insert(Index, S);
  if not fUpdating then OnItemsChanged(Self);
end;

procedure TDBMStringList.Clear;
var
  iPos : integer;
begin
  For iPos := 0 to Count -1 do begin
    if Assigned(Objects[iPos]) then Objects[iPos].Free;
  end;{for}

  inherited Clear;
  if not fUpdating then OnItemsChanged(Self);
end;

procedure TDBMStringList.BeginUpdate;
begin
  fUpdating:= true;
end;

procedure TDBMStringList.EndUpdate;
begin
  {Once EndUpdate is called the OnItemsChanged event is finally fired;}

  fUpdating:= false;
  OnItemsChanged(Self);
end;

//*** TDBMColumn ***************************************************************

constructor TDBMColumn.Create(Collection: TCollection);
begin
  {Initializes each column and creates an items DBMStringlist to callback whenever
   the items are changed; The ItemsChanged method will capture the callbacks;
   DBMPanel is notified once a column is created;}

  inherited;

  fItems:= TDBMStringList.Create;
  fItems.OnItemsChanged:= ItemsChanged;

  fAlignment:= taLeftJustify;
  fCaption:= 'Column ' + IntToStr(Index);
  fColour:= clWindow;
  fDataType:= dtString;
  fDrawFormat:= DT_SINGLELINE or DT_VCENTER;
  fDBMCol:= Index;
  fDBMWidth:= 100;
  fSearchable:= false;
  fVisible:= true;
  fWidth:= 100;
  fWrapCaption:= false;
  fDesignColPos := Index;
  fCurrentColPos := Index;

  NotifyDBM(DBM_COLCREATED);
end;

destructor TDBMColumn.Destroy;
begin
  {DBMPanel is notified whenever a column is destroyed;}

  FreeAndNil(fItems);
  NotifyDBM(DBM_COLDESTROYED);

  inherited;
end;

procedure TDBMColumn.ItemsChanged(Sender: TObject);
begin
  {Whenever items have changed, DBMPanel is notified to invalidate and the IsChanged
   flag is set to indicate this column is amongst those to be invalidated;}

  Items.IsChanged:= true;
  NotifyDBM(DBM_ITEMSCHANGED, Index);
end;

procedure TDBMColumn.NotifyDBM(const DBMMsgID: integer; const DBMLParam, DBMWParam: Word);
var
DBMMsg: TMessage;
begin
  {NotifyDBM dispatches a message to the DefaultHandler on DBMPanel; A (WM_USER
   + x) message is sent with params;}

  DBMMsg.Msg:= DBMMsgID;
  DBMMsg.LParam:= DBMLParam;
  DBMMsg.WParam:= DBMWParam;
  Collection.Owner.Dispatch(DBMMsg);
end;

{BeginUpdate and EndUpdate calls are passed on to the DBMStringlist items to
 suspend repaint requests;}

procedure TDBMColumn.BeginUpdate;
begin
  fItems.BeginUpdate;
end;

procedure TDBMColumn.EndUpdate;
begin
  fItems.EndUpdate;
end;

{DBMPanel is notified whenever the following display properties are altered;}

procedure TDBMColumn.SetCaption(NewCaption: string);
begin
  fCaption:= NewCaption;
  NotifyDBM(DBM_CAPTIONCHANGED);
end;

procedure TDBMColumn.SetSortable(Value: boolean);
begin
  fSortable:= Value;
  NotifyDBM(DBM_SORTABLECHANGED, Index);
end;

procedure TDBMColumn.SetVisible(NewVisible: boolean);
begin
  fVisible:= NewVisible;
  NotifyDBM(DBM_VISIBLECHANGED, Index);
end;

procedure TDBMColumn.SetWidth(NewWidth: integer);
begin
  if NewWidth < 0 then NewWidth:= 0;

  fWidth:= NewWidth;
  NotifyDBM(DBM_WIDTHCHANGED, Index);
end;

procedure TDBMColumn.SetColour(NewColour: TColor);
begin
  fColour:= NewColour;
  NotifyDBM(DBM_COLOURCHANGED, Index);
end;

procedure TDBMColumn.SetField(NewField: string);
begin
  fField:= NewField;
  if (NewField <> '') and (Pos('Column', Caption) <> 0) then Caption:= NewField;
  NotifyDBM(DBM_CAPTIONCHANGED);
end;

procedure TDBMColumn.SetAlignment(NewAlignment: TAlignment);
begin
  fAlignment:= NewAlignment;
  NotifyDBM(DBM_ALIGNMENTCHANGED, Index);
end;

procedure TDBMColumn.SetWrapCaption(NewWrapCaption: boolean);
begin
  fWrapCaption:= NewWrapCaption;
  if fWrapCaption then DrawFormat:= DT_WORDBREAK
  else DrawFormat:= DT_SINGLELINE or DT_VCENTER;
  NotifyDBM(DBM_CAPTIONCHANGED);
end;

procedure TDBMColumn.Assign(Source: TPersistent);
begin
  {Used by the TDBMColumns collection and when moving columns;}

  if Source is TDBMColumn then
  begin
    Alignment:= TDBMColumn(Source).Alignment;
    Caption:= TDBMColumn(Source).Caption;
    Color:= TDBMColumn(Source).Color;
    DataType:= TDBMColumn(Source).DataType;
    DBMCol:= TDBMColumn(Source).DBMCol;
    DBMWidth:= TDBMColumn(Source).DBMWidth;
    DrawFormat:= TDBMColumn(Source).DrawFormat;
    Field:= TDBMColumn(Source).Field;
    IndexNo:= TDBMColumn(Source).IndexNo;
    Items.Assign(TDBMColumn(Source).Items);
    Searchable:= TDBMColumn(Source).Searchable;
    Sortable:= TDBMColumn(Source).Sortable;
    Tag:= TDBMColumn(Source).Tag;
    Visible:= TDBMColumn(Source).Visible;
    Width:= TDBMColumn(Source).Width;
    WrapCaption:= TDBMColumn(Source).WrapCaption;
    DesignColPos:= TDBMColumn(Source).DesignColPos;
    CurrentColPos:= TDBMColumn(Source).CurrentColPos;
  end
  else inherited;
end;

function TDBMColumn.GetDisplayName: string;
begin
  {For the object inspector;}

  Result:= Caption;
end;

procedure TDBMColumn.SetDesignColPos(iNewPos: byte);
begin
  fDesignColPos := iNewPos;
end;

procedure TDBMColumn.SetCurrentColPos(iNewPos: byte);
begin
  fCurrentColPos := iNewPos;
end;

//*** TDBMColumns **************************************************************

function TDBMColumns.Add: TDBMColumn;
begin
  Result:= TDBMColumn(inherited Add);
end;

constructor TDBMColumns.Create(AOwner: TComponent);
begin
  inherited Create(AOwner, TDBMColumn);
end;

function TDBMColumns.GetItem(Index: Integer): TDBMColumn;
begin
  Result:= TDBMColumn(inherited GetItem(Index));
end;

function TDBMColumns.Insert(Index: Integer): TDBMColumn;
begin
  Result := TDBMColumn(inherited Insert(Index));
end;

procedure TDBMColumns.SetItem(Index: Integer; Value: TDBMColumn);
begin
  inherited SetItem(Index, Value);
end;

procedure TDBMColumns.Update(Item: TCollectionItem);
begin
  inherited Update(Item);
end;

//******************************************************************************

procedure TDBMStringList.Put(Index: Integer; const S: string);
begin
  inherited Put(Index, S);
  if not fUpdating then OnItemsChanged(Self);
end;

end.
