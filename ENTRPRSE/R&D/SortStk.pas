unit SortStk;

{$I DEFOVR.Inc}

interface

uses SysUtils, Classes, DB, ADODB, VarConst, VarSortV, SortViewU, ExWrap1U;

type
  { CJS - 2012-07-24: ABSEXCH-12962 - Sort View SQL Mods - base class for Stock
                                      sort views }
  TStockBaseSortView = class(TBaseSortView)
  protected
    // Fields common to all three Stock lists
    fldStCode           : TStringField;
    fldStQtyInStock     : TFloatField;
    fldStShowQtyAsPacks : TBooleanField;
    fldStSalesUnits     : TFloatField;
    fldStQtyPicked      : TFloatField;
    fldStQtyAllocated   : TFloatField;
    fldStQtyPickedWOR   : TFloatField;
    fldStQtyAllocWOR    : TFloatField;
    // SQL access
    procedure PrepareFields; override;
    procedure ReadRecord; override;
    // Utility functions, based on equivalents in SysU2.pas
    function SQLCaseQty(Qty: Double): Double;
    function SQLAllocStock: Double;
    function SQLFreeStock: Real;
  end;

  TStockListSortView = class(TStockBaseSortView)
  protected
    { CJS - 2012-07-24: ABSEXCH-12962 - Sort View SQL Mods }
    fldStDescLine1: TStringField;
    fldStQtyOnOrder: TFloatField;

    function GetFilterDataType(const FilterFieldId: LongInt): TSortViewFilterDataType; override;
    function GetStringFilterValue(const FilterFieldId: LongInt): ShortString; override;
    function GetFloatFilterValue(const FilterFieldId: LongInt): Double; override;
    function GetSortValue(const Sort: TSortViewSortInfoRecType): ShortString; override;
    function GetSourceDataStr: ShortString; override;
    function GetSourceDataFolio: LongInt; override;
    function GetSourceLineNo: LongInt; override;

    { CJS - 2012-07-24: ABSEXCH-12962 - Sort View SQL Mods }
    procedure PrepareFields; override;
    procedure ReadRecord; override;
    function GetSQLSortValue(const Sort: TSortViewSortInfoRecType): ShortString; override;
    function GetSQLSourceDataStr: ShortString; override;
    function GetSQLSourceDataFolio: LongInt; override;
    function GetSQLSourceLineNo: LongInt; override;

  public
    constructor Create;
    function GetFieldIDFromListIndex(ItemIndex: Integer): Integer; override;
    function GetListIndexFromFieldID(FieldID: Integer): Integer; override;
    function CheckListFilter : Boolean; override;
    procedure PopulateSortFields(List: TStrings); override;
    procedure PopulateFilterFields(List: TStrings); override;
    function SyncRecord: Integer; override;
    function SyncTemp: Integer; override;
  end;

  TStockReorderSortView = class(TStockBaseSortView)
  private
    FBack2Back: Boolean;
    FGenWORMode: Boolean;
  protected
    { CJS - 2012-07-24: ABSEXCH-12962 - Sort View SQL Mods }
    fldStSupplier: TStringField;
    fldStQtyOnOrder: TFloatField;
    fldStQtyMin: TFloatField;
    fldStQtyMax: TFloatField;
    fldStType: TStringField; // Char
    fldStPurchaseUnits: TFloatField;

    function GetFilterDataType(const FilterFieldId: LongInt): TSortViewFilterDataType; override;
    function GetStringFilterValue(const FilterFieldId: LongInt): ShortString; override;
    function GetFloatFilterValue(const FilterFieldId: LongInt): Double; override;
    function GetSortValue(const Sort: TSortViewSortInfoRecType): ShortString; override;
    function GetSourceDataStr: ShortString; override;
    function GetSourceDataFolio: LongInt; override;
    function GetSourceLineNo: LongInt; override;

    { CJS - 2012-07-24: ABSEXCH-12962 - Sort View SQL Mods }
    procedure PrepareFields; override;
    procedure ReadRecord; override;
    function GetSQLSortValue(const Sort: TSortViewSortInfoRecType): ShortString; override;
    function GetSQLSourceDataStr: ShortString; override;
    function GetSQLSourceDataFolio: LongInt; override;
    function GetSQLSourceLineNo: LongInt; override;

  public
    constructor Create;
    function CheckListFilter : Boolean; override;
    procedure PopulateSortFields(List: TStrings); override;
    procedure PopulateFilterFields(List: TStrings); override;
    function SyncRecord: Integer; override;
    function SyncTemp: Integer; override;
    property Back2Back: Boolean read FBack2Back write FBack2Back default False;
    property GenWORMode: Boolean read FGenWORMode write FGenWORMode default False;
  end;

  TStockTakeSortView = class(TStockBaseSortView)
  protected
    { CJS - 2012-07-24: ABSEXCH-12962 - Sort View SQL Mods }
    fldStDescLine1: TStringField;
    fldStQtyFreeze: TFloatField;
    fldStBinLocation: TStringField;

    function GetFilterDataType(const FilterFieldId: LongInt): TSortViewFilterDataType; override;
    function GetStringFilterValue(const FilterFieldId: LongInt): ShortString; override;
    function GetFloatFilterValue(const FilterFieldId: LongInt): Double; override;
    function GetSortValue(const Sort: TSortViewSortInfoRecType): ShortString; override;
    function GetSourceDataStr: ShortString; override;
    function GetSourceDataFolio: LongInt; override;
    function GetSourceLineNo: LongInt; override;

    { CJS - 2012-07-24: ABSEXCH-12962 - Sort View SQL Mods }
    procedure PrepareFields; override;
    procedure ReadRecord; override;
    function GetSQLSortValue(const Sort: TSortViewSortInfoRecType): ShortString; override;
    function GetSQLSourceDataStr: ShortString; override;
    function GetSQLSourceDataFolio: LongInt; override;
    function GetSQLSourceLineNo: LongInt; override;

  public
    constructor Create;
    function CheckListFilter : Boolean; override;
    procedure PopulateSortFields(List: TStrings); override;
    procedure PopulateFilterFields(List: TStrings); override;
    function SyncRecord: Integer; override;
    function SyncTemp: Integer; override;
  end;

  TStockLedgerSortView = class(TBaseSortView)
  private
    FExLocal: TdExLocalPtr;
    FNHCtrl: TNHCtrlRec;
  protected
    { CJS - 2012-07-25: ABSEXCH-12962 - Sort View SQL Mods - Field pointers}
    fldTlFolioNum         : TIntegerField;
    fldTlLineNo           : TIntegerField;
    fldTlDocType          : TIntegerField;
    fldTlAcCode           : TStringField;
    fldTlOurRef           : TStringField;
    fldTlLineDate         : TStringField;
    fldTlQty              : TFloatField;
    fldTlQtyPicked        : TFloatField;
    fldTlQtyMul           : TFloatField;
    fldTlQtyDel           : TFloatField;
    fldTlQtyWoff          : TFloatField;
    fldTlQtyPickedWO      : TFloatField;
    fldTlCost             : TFloatField;
    fldTlPaymentCode      : TStringField; // Char
    fldTlPriceMultiplier  : TFloatField;
    fldTlNetValue         : TFloatField;
    fldTlUsePack          : TBooleanField;
    fldTlPrxPack          : TBooleanField;
    fldTlQtyPack          : TFloatField;
    fldTlVATIncValue      : TFloatField;
    fldTlDiscount         : TFloatField;
    fldTlDiscFlag         : TStringField; // Char
    fldTlDiscount2        : TFloatField;
    fldTlDiscount2Chr     : TStringField; // Char
    fldTlDiscount3        : TFloatField;
    fldTlDiscount3Chr     : TStringField; // Char
    fldTlUseOriginalRates : TIntegerField;
    fldTlCurrency         : TIntegerField;
    function GetFilterDataType(const FilterFieldId: LongInt): TSortViewFilterDataType; override;
    function GetStringFilterValue(const FilterFieldId: LongInt): ShortString; override;
    function GetFloatFilterValue(const FilterFieldId: LongInt): Double; override;
    function GetSortValue(const Sort: TSortViewSortInfoRecType): ShortString; override;
    function GetSourceDataStr: ShortString; override;
    function GetSourceDataFolio: LongInt; override;
    function GetSourceLineNo: LongInt; override;

    { CJS - 2012-07-25: ABSEXCH-12962 - Sort View SQL Mods }
    procedure PrepareFields; override;

    //PR: 22/03/2016 v2016 R2 ABSEXCH-17390 Changed to ReadRecordEx to avoid warning message
    procedure ReadRecordEx(var IdRec: Idetail);
    function GetSQLSortValue(const Sort: TSortViewSortInfoRecType): ShortString; override;
    function GetSQLSourceDataStr: ShortString; override;
    function GetSQLSourceDataFolio: LongInt; override;
    function GetSQLSourceLineNo: LongInt; override;

  public
    constructor Create;
    function CheckListFilter : Boolean; override;
    procedure PopulateSortFields(List: TStrings); override;
    procedure PopulateFilterFields(List: TStrings); override;
    function SyncRecord: Integer; override;
    function SyncTemp: Integer; override;
    property ExLocal: TdExLocalPtr read FExLocal write FExLocal;
    property NHCtrl: TNHCtrlRec read FNHCtrl write FNHCtrl;
  end;

implementation

uses BtrvU2, GlobVar, SysU2, BtKeys1U,
  {$IFDEF SOP}
  StkROrdr,
  {$ENDIF}
  BtSupU1,
  ETMiscU,
  ETStrU,
  StrUtil,
  ComnU2, CurrncyU, PWarnU, InvCtSuU, ETDateU;

// =============================================================================
// TStockBaseSortView
// =============================================================================

procedure TStockBaseSortView.PrepareFields;
begin
  fldStCode           := SQLCaller.Records.FieldByName('stCode') as TStringField;
  fldStQtyInStock     := SQLCaller.Records.FieldByName('stQtyInStock') as TFloatField;
  fldStShowQtyAsPacks := SQLCaller.Records.FieldByName('stShowQtyAsPacks') as TBooleanField;
  fldStSalesUnits     := SQLCaller.Records.FieldByName('stSalesUnits') as TFloatField;
  fldStQtyPicked      := SQLCaller.Records.FieldByName('stQtyPicked') as TFloatField;
  fldStQtyAllocated   := SQLCaller.Records.FieldByName('stQtyAllocated') as TFloatField;
  fldStQtyPickedWOR   := SQLCaller.Records.FieldByName('stQtyPickedWOR') as TFloatField;
  fldStQtyAllocWOR    := SQLCaller.Records.FieldByName('stQtyAllocWOR') as TFloatField;
end;

procedure TStockBaseSortView.ReadRecord;
begin
  Stock.StockCode    := fldStCode.Value;
  Stock.QtyInStock   := fldStQtyInStock.Value;
  Stock.DPackQty     := fldStShowQtyAsPacks.Value;
  Stock.SellUnit     := fldStSalesUnits.Value;
  Stock.QtyPicked    := fldStQtyPicked.Value;
  Stock.QtyAllocated := fldStQtyAllocated.Value;
  Stock.QtyPickWOR   := fldStQtyPickedWOR.Value;
  Stock.QtyAllocWOR  := fldStQtyAllocWOR.Value;
end;

function TStockBaseSortView.SQLAllocStock: Double;
begin
  {$IFDEF SOP}
  if (Syss.UsePick4All) then
    Result := fldStQtyPicked.Value
  else
  {$ENDIF}
    Result := fldStQtyAllocated.Value;
end;

function TStockBaseSortView.SQLCaseQty(Qty: Double): Double;
var
  DecStr,
  TmpStr :   Str20;
  CQty,EQty,
  RatQty :  Double;
  MDec   :  Byte;
begin
  Result := Qty;
  MDec   := 0;
  if (fldStShowQtyAsPacks.Value) then
  begin
    RatQty := DivWChk(Qty, fldStSalesUnits.Value);

    MDec := Syss.NoQtyDec;
    if (Syss.NoQtyDec < 4) then
      MDec := MDec + 4;

    CQty := Trunc(Round_Up(RatQty, MDec));
    EQty := Round_Up((Qty - (Cqty * fldStSalesUnits.Value)), 0);

    if (Syss.NoQtyDec > 1) or (fldStSalesUnits.Value > 10) then
      DecStr := SetPadNo(Form_Int(Round(ABS(EQty)), 0), Syss.NoQtyDec)
    else
      DecStr := Form_Real(ABS(EQty), 0, 0);

    TmpStr := Form_Real(CQty, 0, 0) + '.' + DecStr;

    if (CQty = 0.0) and (EQty < 0) then
      TmpStr := '-' + TmpStr;

    Result := Round_Up(RealStr(TmpStr), Syss.NoQtyDec);
  end;
end;

function TStockBaseSortView.SQLFreeStock: Real;

  function WOPAllocStock: Double;
  begin
    {$IFDEF WOP}
    If (Syss.UseWIss4All) then
      Result := fldStQtyPickedWOR.Value
    else
    {$ENDIF}
      Result := fldStQtyAllocWOR.Value;
  end;

begin
  if (Syss.FreeExAll) then
    Result := fldStQtyInStock.Value
  else
  begin
    Result := fldStQtyInStock.Value - SQLAllocStock;
    Result := Result - WOPAllocStock;
  end;
end;

// =============================================================================
// TStockListSortView
// =============================================================================

function TStockListSortView.CheckListFilter: Boolean;
begin
  Result := True;
end;

// -----------------------------------------------------------------------------

constructor TStockListSortView.Create;
begin
  inherited Create;
  HostListFileNo := StockF;
  ListType := svltStockList;
  ListDesc := 'Stock List';
end;

function TStockListSortView.GetFieldIDFromListIndex(
  ItemIndex: Integer): Integer;
begin
{
  Item                  List Index   Field ID
  --------------------  ----------   --------
  Cost Centre Code           0           0
  Department Code            1           1
  User Defined Field 1       2           2
  User Defined Field 2       3           3
  User Defined Field 3       4           4
  User Defined Field 4       5           5
  User Defined Field 5       6           9
  User Defined Field 6       7          10
  User Defined Field 7       8          11
  User Defined Field 8       9          12
  User Defined Field 9      10          13
  User Defined Field 10     11          14
  Product Type              12           6
  Default Location          13           7
  Default Bin               14           8
}
  case ItemIndex of
     0: Result :=  0;
     1: Result :=  1;
     2: Result :=  2;
     3: Result :=  3;
     4: Result :=  4;
     5: Result :=  5;
     6: Result :=  9;
     7: Result := 10;
     8: Result := 11;
     9: Result := 12;
    10: Result := 13;
    11: Result := 14;
    12: Result :=  6;
    13: Result :=  7;
    14: Result :=  8;
    else
      raise Exception.Create('Invalid ItemIndex in TStockListSortView.GetFieldIDFromListIndex ' + IntToStr(ItemIndex));
  end;
end;

// -----------------------------------------------------------------------------

function TStockListSortView.GetFilterDataType(
  const FilterFieldId: Integer): TSortViewFilterDataType;
begin
  { All the Stock List filters are strings. }
  Result := fdtString;
end;

// -----------------------------------------------------------------------------

function TStockListSortView.GetFloatFilterValue(
  const FilterFieldId: Integer): Double;
begin
  Result := 0.0;
end;

// -----------------------------------------------------------------------------

function TStockListSortView.GetListIndexFromFieldID(
  FieldID: Integer): Integer;
begin
{
  Item                  Field ID   List Index
  --------------------  --------   ----------
  Cost Centre Code          0           0
  Department Code           1           1
  User Defined Field 1      2           2
  User Defined Field 2      3           3
  User Defined Field 3      4           4
  User Defined Field 4      5           5
  User Defined Field 5      9           6
  User Defined Field 6     10           7
  User Defined Field 7     11           8
  User Defined Field 8     12           9
  User Defined Field 9     13          10
  User Defined Field 10    14          11
  Product Type              6          12
  Default Location          7          13
  Default Bin               8          14
}
  case FieldID of
     0: Result :=  0;
     1: Result :=  1;
     2: Result :=  2;
     3: Result :=  3;
     4: Result :=  4;
     5: Result :=  5;
     9: Result :=  6;
    10: Result :=  7;
    11: Result :=  8;
    12: Result :=  9;
    13: Result := 10;
    14: Result := 11;
     6: Result := 12;
     7: Result := 13;
     8: Result := 14;
     else
      raise Exception.Create('Invalid FieldId in TStockListSortView.GetListIndexFromFieldID ' + IntToStr(FieldId));

  end;
end;

// -----------------------------------------------------------------------------

function TStockListSortView.GetSortValue(
  const Sort: TSortViewSortInfoRecType): ShortString;
begin
  Result := '';
  if (Sort.svsEnabled) then
  begin
    case Sort.svsFieldId of
      0: Result := AdjustSortStringValue(Stock.StockCode, Sort);
      1: Result := AdjustSortStringValue(Stock.Desc[1], Sort);
      2: Result := AdjustSortFloatValue(Stock.QtyInStock, Sort);
      3: Result := AdjustSortFloatValue(CaseQty(Stock, FreeStock(Stock)), Sort);
      4: Result := AdjustSortFloatValue(Stock.QtyOnOrder, Sort);
//      5: Result := Stock.Supplier;
    else
      // Invalid field id (raise exception?)
    end;
  end;
end;

// -----------------------------------------------------------------------------

function TStockListSortView.GetSourceDataFolio: LongInt;
begin
  Result := 0;
end;

// -----------------------------------------------------------------------------

function TStockListSortView.GetSourceDataStr: ShortString;
begin
  Result := Stock.StockCode;
end;

// -----------------------------------------------------------------------------

function TStockListSortView.GetSourceLineNo: LongInt;
begin
  Result := 0;
end;

// -----------------------------------------------------------------------------

function TStockListSortView.GetSQLSortValue(
  const Sort: TSortViewSortInfoRecType): ShortString;
begin
  ReadRecord;
  Result := GetSortValue(Sort);
end;

function TStockListSortView.GetSQLSourceDataFolio: LongInt;
begin
  Result := 0;
end;

function TStockListSortView.GetSQLSourceDataStr: ShortString;
begin
  Result := fldStCode.Value;
end;

function TStockListSortView.GetSQLSourceLineNo: LongInt;
begin
  Result := 0;
end;

function TStockListSortView.GetStringFilterValue(
  const FilterFieldId: Integer): ShortString;
begin
  case FilterFieldId of
    0: Result := Stock.CCDep[True];
    1: Result := Stock.CCDep[False];
    2: Result := Stock.StkUser1;
    3: Result := Stock.StkUser2;
    4: Result := Stock.StkUser3;
    5: Result := Stock.StkUser4;
    // CS 30/11/2011 ABSEXCH-12248: Reverted to original numbering (functions
    // added to map between field id and list item index).
    6: Result := Stock.StockType;
    7: Result := Stock.DefMLoc;
    8: Result := Stock.BinLoc;
    //GS 21/10/2011 ABSEXCH-11706: added support for UDEF 6-10
    9: Result := Stock.StkUser5;
    10: Result := Stock.StkUser6;
    11: Result := Stock.StkUser7;
    12: Result := Stock.StkUser8;
    13: Result := Stock.StkUser9;
    14: Result := Stock.StkUser10;
  else
    Result := ''; // Invalid field id (raise exception?)
  end;
end;

// -----------------------------------------------------------------------------

procedure TStockListSortView.PopulateFilterFields(List: TStrings);
begin
  List.Clear;
  List.Add('Cost Centre Code');       // 0
  List.Add('Department Code');        // 1
  List.Add('User Defined Field 1');   // 2
  List.Add('User Defined Field 2');   // 3
  List.Add('User Defined Field 3');   // 4
  List.Add('User Defined Field 4');   // 5
  //GS 21/10/2011 ABSEXCH-11706: added support for UDEF 6-10
  List.Add('User Defined Field 5');   // 6
  List.Add('User Defined Field 6');   // 7
  List.Add('User Defined Field 7');   // 8
  List.Add('User Defined Field 8');   // 9
  List.Add('User Defined Field 9');   // 10
  List.Add('User Defined Field 10');  // 11
  List.Add('Stock Type');             // 12 //HV 12/04/2016 2016-R2 ABSEXCH-9505: Stock List Sort Views - add the ability to sort by stock type with dropdown
  List.Add('Default Location');       // 13
  List.Add('Default Bin');            // 14

end;

// -----------------------------------------------------------------------------

procedure TStockListSortView.PopulateSortFields(List: TStrings);
begin
  List.Clear;
  List.Add('Stock Code');
  List.Add('Description');
  List.Add('In Stock Qty');
  List.Add('Free Stock Qty');
  List.Add('On Order Qty');
//  List.Add('Supplier');
end;

// -----------------------------------------------------------------------------

procedure TStockListSortView.PrepareFields;
begin
  inherited;
  fldStDescLine1  := SQLCaller.Records.FieldByName('stDescLine1') as TStringField;
  fldStQtyOnOrder := SQLCaller.Records.FieldByName('stQtyOnOrder') as TFloatField;
end;

// -----------------------------------------------------------------------------

procedure TStockListSortView.ReadRecord;
begin
  inherited;
  Stock.Desc[1] := fldStDescLine1.Value;
  Stock.QtyOnOrder := fldStQtyOnOrder.Value;
end;

function TStockListSortView.SyncRecord: Integer;
var
  Key: str255;
begin
  Key := FullStockCode(SortTempRec.svtSourceDataStr);
  Result := Find_Rec(B_GetEq, F[StockF], StockF, RecPtr[StockF]^, StkCodeK, Key);
end;

// -----------------------------------------------------------------------------

function TStockListSortView.SyncTemp: Integer;
var
  Key: Str255;
  FuncRes: Integer;
begin
  Key := FullNomKey(ListID) + Stock.StockCode;
  Result := Find_Rec(B_GetEq, F[SortTempF], SortTempF, RecPtr[SortTempF]^, STLinkStrK, Key);
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TStockReorderSortView
// =============================================================================

function TStockReorderSortView.CheckListFilter: Boolean;
begin
  Result := True;
end;

// -----------------------------------------------------------------------------

constructor TStockReorderSortView.Create;
begin
  inherited Create;
  HostListFileNo := StockF;
  ListType := svltStockReOrder;
  ListDesc := 'Stock Re-Order List';
  FBack2Back := False;
  FGenWORMode := False;
end;

function TStockReorderSortView.GetFilterDataType(
  const FilterFieldId: Integer): TSortViewFilterDataType;
begin
  Result := fdtString;
end;

// -----------------------------------------------------------------------------

function TStockReorderSortView.GetFloatFilterValue(
  const FilterFieldId: Integer): Double;
begin
  Result := 0.0;
end;

// -----------------------------------------------------------------------------

function TStockReorderSortView.GetSortValue(
  const Sort: TSortViewSortInfoRecType): ShortString;
var
  Value: Double;
begin
  Result := '';
  if (Sort.svsEnabled) then
  begin
    case Sort.svsFieldId of
      0: Result := AdjustSortStringValue(Stock.StockCode, Sort);
      1: Result := AdjustSortFloatValue(CaseQty(Stock, FreeStock(Stock)), Sort);   // Free Stock
      2: Result := AdjustSortFloatValue(CaseQty(Stock, Stock.QtyOnOrder), Sort);   // On Order
      3: Result := AdjustSortStringValue(Stock.Supplier, Sort);
      4: begin
           if (Back2Back) then
             Value := AllocStock(Stock)
           else
             Value := Stock.QtyMin;
           Result := AdjustSortFloatValue(CaseQty(Stock, Value), Sort);
         end;
      {$IFDEF SOP}
      5: Result := AdjustSortFloatValue(CaseQty(Stock, Stk_SuggROQ(Stock, Back2Back, (GenWORMode and (Stock.StockType = StkBillCode)))), Sort);
      {$ELSE}
      5: Result := '?';
      {$ENDIF}
    else
      Result := '?';
    end;
  end;
end;

// -----------------------------------------------------------------------------

function TStockReorderSortView.GetSourceDataFolio: LongInt;
begin
  Result := 0;
end;

// -----------------------------------------------------------------------------

function TStockReorderSortView.GetSourceDataStr: ShortString;
begin
  Result := Stock.StockCode;
end;

// -----------------------------------------------------------------------------

function TStockReorderSortView.GetSourceLineNo: LongInt;
begin
  Result := 0;
end;

// -----------------------------------------------------------------------------

function TStockReorderSortView.GetSQLSortValue(
  const Sort: TSortViewSortInfoRecType): ShortString;
begin
  ReadRecord;
  Result := GetSortValue(Sort);
end;

function TStockReorderSortView.GetSQLSourceDataFolio: LongInt;
begin
  Result := 0;
end;

function TStockReorderSortView.GetSQLSourceDataStr: ShortString;
begin
  Result := fldStCode.Value;
end;

function TStockReorderSortView.GetSQLSourceLineNo: LongInt;
begin
  Result := 0;
end;

function TStockReorderSortView.GetStringFilterValue(
  const FilterFieldId: Integer): ShortString;
begin
  case FilterFieldId of
    //HV 17/03/2016 2016-R2 ABSEXCH-13215: Stock Reorder Sort Views do not filter correctly for Cost Centres/Departments.
    0: Result := Stock.ROCCDep[True];
    1: Result := Stock.ROCCDep[False];
    2: Result := Stock.StkUser1;
    3: Result := Stock.StkUser2;
    4: Result := Stock.StkUser3;
    5: Result := Stock.StkUser4;
    //GS 21/10/2011 ABSEXCH-11706: added support for UDEF 6-10
    6: Result := Stock.StkUser5;
    7: Result := Stock.StkUser6;
    8: Result := Stock.StkUser7;
    9: Result := Stock.StkUser8;
    10: Result := Stock.StkUser9;
    11: Result := Stock.StkUser10;
  else
    Result := ''; // Invalid field id (raise exception?)
  end;
end;

// -----------------------------------------------------------------------------

procedure TStockReorderSortView.PopulateFilterFields(List: TStrings);
begin
  List.Clear;
  List.Add('Cost Centre Code');
  List.Add('Department Code');
  List.Add('User Defined Field 1');
  List.Add('User Defined Field 2');
  List.Add('User Defined Field 3');
  List.Add('User Defined Field 4');
  //GS 21/10/2011 ABSEXCH-11706: added support for UDEF 6-10
  List.Add('User Defined Field 5');
  List.Add('User Defined Field 6');
  List.Add('User Defined Field 7');
  List.Add('User Defined Field 8');
  List.Add('User Defined Field 9');
  List.Add('User Defined Field 10');
end;

// -----------------------------------------------------------------------------

procedure TStockReorderSortView.PopulateSortFields(List: TStrings);
begin
  List.Clear;
  List.Add('Stock Code');
  List.Add('Free Stock Qty');
  List.Add('On Order Qty');
  List.Add('Supplier');
  List.Add('Min Stock Qty');
  List.Add('Need Qty');
end;

// -----------------------------------------------------------------------------

procedure TStockReorderSortView.PrepareFields;
begin
  inherited;
  fldStQtyOnOrder    := SQLCaller.Records.FieldByName('stQtyOnOrder') as TFloatField;
  fldStSupplier      := SQLCaller.Records.FieldByName('stSupplier') as TStringField;
  fldStQtyMin        := SQLCaller.Records.FieldByName('stQtyMin') as TFloatField;
  fldStQtyMax        := SQLCaller.Records.FieldByName('stQtyMax') as TFloatField;
  fldStType          := SQLCaller.Records.FieldByName('stType') as TStringField;
  fldStPurchaseUnits := SQLCaller.Records.FieldByName('stPurchaseUnits') as TFloatField;
end;

procedure TStockReorderSortView.ReadRecord;
begin
  inherited;
  Stock.Supplier   := fldStSupplier.Value;
  Stock.QtyOnOrder := fldStQtyOnOrder.Value;
  Stock.QtyMin     := fldStQtyMin.Value;
  Stock.QtyMax     := fldStQtyMax.Value;
  Stock.StockType  := ExtractCharAtPos(fldStType.Value);
  Stock.BuyUnit    := fldStPurchaseUnits.Value;
end;

function TStockReorderSortView.SyncRecord: Integer;
var
  Key: str255;
begin
  Key := FullStockCode(SortTempRec.svtSourceDataStr);
  Result := Find_Rec(B_GetEq, F[StockF], StockF, RecPtr[StockF]^, StkCodeK, Key);
end;

// -----------------------------------------------------------------------------

function TStockReorderSortView.SyncTemp: Integer;
var
  Key: Str255;
  FuncRes: Integer;
begin
  Key := FullNomKey(ListID) + Stock.StockCode;
  Result := Find_Rec(B_GetEq, F[SortTempF], SortTempF, RecPtr[SortTempF]^, STLinkStrK, Key);
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TStockTakeSortView
// =============================================================================

function TStockTakeSortView.CheckListFilter: Boolean;
begin
  Result := True;
end;

// -----------------------------------------------------------------------------

constructor TStockTakeSortView.Create;
begin
  inherited Create;
  HostListFileNo := StockF;
  ListType := svltStockTake;
  ListDesc := 'Stock Take List';
end;

function TStockTakeSortView.GetFilterDataType(
  const FilterFieldId: Integer): TSortViewFilterDataType;
begin
  Result := fdtString;
end;

// -----------------------------------------------------------------------------

function TStockTakeSortView.GetFloatFilterValue(
  const FilterFieldId: Integer): Double;
begin
  Result := 0.0;
end;

// -----------------------------------------------------------------------------

function TStockTakeSortView.GetSortValue(
  const Sort: TSortViewSortInfoRecType): ShortString;
begin
  Result := '';
  if (Sort.svsEnabled) then
  begin
    case Sort.svsFieldId of
      0: Result := AdjustSortStringValue(Stock.StockCode, Sort);
      1: Result := AdjustSortStringValue(Stock.Desc[1], Sort);
      2: Result := AdjustSortFloatValue(CaseQty(Stock, Stock.QtyFreeze), Sort);
      3: Result := AdjustSortStringValue(Stock.BinLoc, Sort);
    else
      // Invalid field id (raise exception?)
    end;
  end;
end;

// -----------------------------------------------------------------------------

function TStockTakeSortView.GetSourceDataFolio: LongInt;
begin
  Result := 0;
end;

// -----------------------------------------------------------------------------

function TStockTakeSortView.GetSourceDataStr: ShortString;
begin
  Result := Stock.StockCode;
end;

// -----------------------------------------------------------------------------

function TStockTakeSortView.GetSourceLineNo: LongInt;
begin
  Result := 0;
end;

// -----------------------------------------------------------------------------

function TStockTakeSortView.GetSQLSortValue(
  const Sort: TSortViewSortInfoRecType): ShortString;
begin
  ReadRecord;
  Result := GetSortValue(Sort);
end;

function TStockTakeSortView.GetSQLSourceDataFolio: LongInt;
begin
  Result := 0;
end;

function TStockTakeSortView.GetSQLSourceDataStr: ShortString;
begin
  Result := fldStCode.Value;
end;

function TStockTakeSortView.GetSQLSourceLineNo: LongInt;
begin
  Result := 0;
end;

function TStockTakeSortView.GetStringFilterValue(
  const FilterFieldId: Integer): ShortString;
begin
  case FilterFieldId of
    0: Result := Stock.StkUser1;
    1: Result := Stock.StkUser2;
    2: Result := Stock.StkUser3;
    3: Result := Stock.StkUser4;
    //GS 21/10/2011 ABSEXCH-11706: added support for UDEF 6-10
    4: Result := Stock.StkUser5;
    5: Result := Stock.StkUser6;
    6: Result := Stock.StkUser7;
    7: Result := Stock.StkUser8;
    8: Result := Stock.StkUser9;
    9: Result := Stock.StkUser10;
  else
    Result := ''; // Invalid field id (raise exception?)
  end;
end;

// -----------------------------------------------------------------------------

procedure TStockTakeSortView.PopulateFilterFields(List: TStrings);
begin
  List.Clear;
  List.Add('User Defined Field 1');
  List.Add('User Defined Field 2');
  List.Add('User Defined Field 3');
  List.Add('User Defined Field 4');
  //GS 21/10/2011 ABSEXCH-11706: added support for UDEF 6-10
  List.Add('User Defined Field 5');
  List.Add('User Defined Field 6');
  List.Add('User Defined Field 7');
  List.Add('User Defined Field 8');
  List.Add('User Defined Field 9');
  List.Add('User Defined Field 10');
end;

// -----------------------------------------------------------------------------

procedure TStockTakeSortView.PopulateSortFields(List: TStrings);
begin
  List.Clear;
  List.Add('Stock Code');
  List.Add('Description');
  List.Add('In Stock Qty');
  List.Add('Bin Location');
end;

// -----------------------------------------------------------------------------

procedure TStockTakeSortView.PrepareFields;
begin
  inherited;
  fldStDescLine1   := SQLCaller.Records.FieldByName('stDescLine1') as TStringField;
  fldStQtyFreeze   := SQLCaller.Records.FieldByName('stQtyFreeze') as TFloatField;
  fldStBinLocation := SQLCaller.Records.FieldByName('stBinLocation') as TStringField;
end;

procedure TStockTakeSortView.ReadRecord;
begin
  inherited;
  Stock.Desc[1]   := fldStDescLine1.Value;
  Stock.QtyFreeze := fldStQtyFreeze.Value;
  Stock.BinLoc    := fldStBinLocation.Value;
end;

function TStockTakeSortView.SyncRecord: Integer;
var
  Key: str255;
begin
  Key := FullStockCode(SortTempRec.svtSourceDataStr);
  Result := Find_Rec(B_GetEq, F[StockF], StockF, RecPtr[StockF]^, StkCodeK, Key);
end;

// -----------------------------------------------------------------------------

function TStockTakeSortView.SyncTemp: Integer;
var
  Key: Str255;
  FuncRes: Integer;
begin
  Key := FullNomKey(ListID) + Stock.StockCode;
  Result := Find_Rec(B_GetEq, F[SortTempF], SortTempF, RecPtr[SortTempF]^, STLinkStrK, Key);
end;

// -----------------------------------------------------------------------------

// =============================================================================
// TStockLedgerSortView
// =============================================================================

function TStockLedgerSortView.CheckListFilter: Boolean;
begin
  Result := True;
end;

// -----------------------------------------------------------------------------

constructor TStockLedgerSortView.Create;
begin
  inherited Create;
  HostListFileNo := IdetailF;
  ListType := svltStockLedger;
  ListDesc := 'Stock Ledger List';
end;

function TStockLedgerSortView.GetFilterDataType(
  const FilterFieldId: Integer): TSortViewFilterDataType;
begin
  Result := fdtString;
end;

// -----------------------------------------------------------------------------

function TStockLedgerSortView.GetFloatFilterValue(
  const FilterFieldId: Integer): Double;
begin
  Result := 0.0;
end;

// -----------------------------------------------------------------------------

function TStockLedgerSortView.GetSortValue(
  const Sort: TSortViewSortInfoRecType): ShortString;
{
  This is largely a copy of the TSLMList.OutLine method in SLTI1U.pas,
  modified for use by the Sort View.
}

  procedure Link2Inv;
  const
    Fnum     =  InvF;
    KeyPath2 =  InvFolioK;
  var
    TmpKPath,
    TmpStat:  Integer;
    TmpRecAddr
           :  LongInt;
    KeyS   :  Str255;
  begin
    If (ExLocal^.LInv.FolioNum<>Id.FolioRef) then
    Begin
      TmpKPath:=GetPosKey;
      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOff,BOff);
      ResetRec(Fnum);
      KeyS:=FullNomKey(Id.FolioRef);
      If (Id.FolioRef<>0) then
        Status:=Find_Rec(B_GetEq,F[Fnum],Fnum,RecPtr[Fnum]^,KeyPath2,KeyS);
      ExLocal^.AssignFromGlobal(Fnum);
      TmpStat:=Presrv_BTPos(Fnum,TmpKPath,F[Fnum],TmpRecAddr,BOn,BOff);
    end;
  end;

var
  TxCr   :  Integer;
  UPCost :  Double;
  KeyS   :  Str255;
  StockPos:  StockPosType;
  TmpQtyMul,
  TmpQty,
  Rnum   :  Real;
  GenStr :  Str255;
  UOR,
  TCr    :  Byte;
begin
  Result := '';
  if (Sort.svsEnabled) then
  begin
    With Id do
    Begin
      Rnum:=0;
      UPCost:=0.0;
      TmpQty:=0;
      TmpQtyMul:=0;
      UOR:=0;

      {$IFDEF Inv}
        Stock_Effect(StockPos,Id,DeductQty,BOn);
        {$IFDEF SOP}
          If (Syss.UsePick4All) then {* Subst Picked for allocated *}
            StockPos[3]:=StockPos[5];
        {$ENDIF}
      {$ELSE}
        FillChar(StockPos, Sizeof(StockPos), 0);
        StockPos[2]:=DeductQty;
      {$ENDIF}

      {$IFDEF PF_On}
        {$IFDEF Inv}
          Job_StockEffect(StockPos,Id);
        {$ENDIF}
      {$ENDIF}

      Link2Inv;

      With ExLocal^, NHCtrl, LInv do
      Begin
        case Sort.svsFieldId of
         0   :  Result:= AdjustSortStringValue(CustCode, Sort);
         1   :  Result:= AdjustSortStringValue(OurRef, Sort);
         2   :  Result:= AdjustSortDateStringValue(PDate, Sort);
         3..6:  Result:= AdjustSortFloatValue(CaseQty(Stock,StockPos[Sort.svsFieldId-2]), Sort);
         7,8 :  Result:= AdjustSortFloatValue(CaseQty(Stock,StockPos[Sort.svsFieldId-1]), Sort);
         9,10:  Result:= AdjustSortFloatValue(CaseQty(Stock,StockPos[Sort.svsFieldId]), Sort);
         11  :  begin
                 If (IdDocHed In StkAdjSplit) then
                 Begin
                   If (Qty<0) then
                     TmpQty:=-1
                   else
                     TmpQty:=1;
                   Rnum:=CostPrice*TmpQty;
                 end
                 else
                 Begin
                   TmpQty:=Qty;
                   TmpQtyMul:=QtyMul;
                   If (Stock.CalcPack) then
                     QtyMul:=1;
                   Qty:=1;
                   If (IdDocHed In PurchSplit) then
                     UPCost:=CostPrice * DocCnst[IdDocHed];
                   Rnum:=(DetLTotalND(Id,BOn,BOff,BOn,LInv.DiscSetl)+UPCost)*DocNotCnst;

                   Qty:=TmpQty;
                   QtyMul:=TmpQtyMul;
                 end;

                 TxCr:=NHCr;

                 If (NHCr=0) then
                 Begin
                   UOR:=fxUseORate(BOff,BOn,CXRate,UseORate,Currency,0);
                   Rnum:=Conv_TCurr(Rnum,XRate(CXRate,BOff,Currency),Currency,UOR,BOff);
                 end;

                 If (NHTxCr<>0) then
                 Begin
                   Rnum:=Currency_Txlate(Rnum,NHCr,NHTxCr);
                   TxCr:=NHTxCr;
                 end;

                 If (Not PChkAllowed_In(143)) and (Not (IdDocHed In SalesSplit)) then {* Hide Unit Cost *}
                   Rnum:=0.0;

                 Result:= AdjustSortFloatValue(Rnum, Sort);
               end;
        else
         { Invalid Field ID }
         Result:='';
        end;
      end;
    end;
  end;
end;

// -----------------------------------------------------------------------------

function TStockLedgerSortView.GetSourceDataFolio: LongInt;
begin
  Result := Id.FolioRef;
end;

// -----------------------------------------------------------------------------

function TStockLedgerSortView.GetSourceDataStr: ShortString;
begin
  Result := '';
end;

// -----------------------------------------------------------------------------

function TStockLedgerSortView.GetSourceLineNo: LongInt;
begin
  Result := Id.LineNo;
end;

// -----------------------------------------------------------------------------

function TStockLedgerSortView.GetSQLSortValue(
  const Sort: TSortViewSortInfoRecType): ShortString;
begin
  //PR: 22/03/2016 v2016 R2 ABSEXCH-17390 Changed ReadRecord procedure to ReadRecordEx to avoid warning message
  ReadRecordEx(Id);
  Result := GetSortValue(Sort);
end;

function TStockLedgerSortView.GetSQLSourceDataFolio: LongInt;
begin
  Result := fldTlFolioNum.Value;
end;

function TStockLedgerSortView.GetSQLSourceDataStr: ShortString;
begin
  Result := '';
end;

function TStockLedgerSortView.GetSQLSourceLineNo: LongInt;
begin
  Result := fldTlLineNo.Value;
end;

function TStockLedgerSortView.GetStringFilterValue(
  const FilterFieldId: Integer): ShortString;
begin
  case FilterFieldId of
    0: Result := Id.LineUser1;
    1: Result := Id.LineUser2;
    2: Result := Id.LineUser3;
    3: Result := Id.LineUser4;
    //GS 21/10/2011 ABSEXCH-11706: added support for UDEF 6-10
    4: Result := Id.LineUser5;
    5: Result := Id.LineUser6;
    6: Result := Id.LineUser7;
    7: Result := Id.LineUser8;
    8: Result := Id.LineUser9;
    9: Result := Id.LineUser10;
  else
    Result := ''; // Invalid field id (raise exception?)
  end;
end;

// -----------------------------------------------------------------------------

procedure TStockLedgerSortView.PopulateFilterFields(List: TStrings);
begin
  List.Clear;
  List.Add('User Defined Field 1');
  List.Add('User Defined Field 2');
  List.Add('User Defined Field 3');
  List.Add('User Defined Field 4');
  //GS 21/10/2011 ABSEXCH-11706: added support for UDEF 6-10
  List.Add('User Defined Field 5');
  List.Add('User Defined Field 6');
  List.Add('User Defined Field 7');
  List.Add('User Defined Field 8');
  List.Add('User Defined Field 9');
  List.Add('User Defined Field 10');
end;

// -----------------------------------------------------------------------------

procedure TStockLedgerSortView.PopulateSortFields(List: TStrings);
begin
  List.Add('Account Code');
  List.Add('Our Ref');
  List.Add('Date');
  List.Add('Qty In');
  List.Add('Qty Out');
  List.Add('Allocated');
  List.Add('On Order');
  List.Add('Alloc WOR');
  List.Add('Issued WOR');
  List.Add('Sales Ret');
  List.Add('Purch Ret');
  List.Add('Unit Price');
end;

// -----------------------------------------------------------------------------

procedure TStockLedgerSortView.PrepareFields;
begin
  fldTlFolioNum := SQLCaller.Records.FieldByName('tlFolioNum') as TIntegerField;
  fldTlLineNo := SQLCaller.Records.FieldByName('tlLineNo') as TIntegerField;
  fldTlDocType := SQLCaller.Records.FieldByName('tlDocType') as TIntegerField;
  fldTlAcCode := SQLCaller.Records.FieldByName('tlAcCode') as TStringField;
  fldTlOurRef := SQLCaller.Records.FieldByName('tlOurRef') as TStringField;
  fldTlLineDate := SQLCaller.Records.FieldByName('tlLineDate') as TStringField;
  fldTlQty := SQLCaller.Records.FieldByName('tlQty') as TFloatField;
  fldTlQtyPicked := SQLCaller.Records.FieldByName('tlQtyPicked') as TFloatField;
  fldTlQtyMul := SQLCaller.Records.FieldByName('tlQtyMul') as TFloatField;
  fldTlQtyDel := SQLCaller.Records.FieldByName('tlQtyDel') as TFloatField;
  fldTlQtyWoff := SQLCaller.Records.FieldByName('tlQtyWoff') as TFloatField;
  fldTlQtyPickedWO := SQLCaller.Records.FieldByName('tlQtyPickedWO') as TFloatField;
  fldTlCost := SQLCaller.Records.FieldByName('tlCost') as TFloatField;
  fldTlPaymentCode := SQLCaller.Records.FieldByName('tlPaymentCode') as TStringField;
  fldTlPriceMultiplier := SQLCaller.Records.FieldByName('tlPriceMultiplier') as TFloatField;
  fldTlNetValue := SQLCaller.Records.FieldByName('tlNetValue') as TFloatField;
  fldTlUsePack := SQLCaller.Records.FieldByName('tlUsePack') as TBooleanField;
  fldTlPrxPack := SQLCaller.Records.FieldByName('tlPrxPack') as TBooleanField;
  fldTlQtyPack := SQLCaller.Records.FieldByName('tlQtyPack') as TFloatField;
  fldTlVATIncValue := SQLCaller.Records.FieldByName('tlVATIncValue') as TFloatField;
  fldTlDiscount := SQLCaller.Records.FieldByName('tlDiscount') as TFloatField;
  fldTlDiscFlag := SQLCaller.Records.FieldByName('tlDiscFlag') as TStringField;
  fldTlDiscount2 := SQLCaller.Records.FieldByName('tlDiscount2') as TFloatField;
  fldTlDiscount2Chr := SQLCaller.Records.FieldByName('tlDiscount2Chr') as TStringField;
  fldTlDiscount3 := SQLCaller.Records.FieldByName('tlDiscount3') as TFloatField;
  fldTlDiscount3Chr := SQLCaller.Records.FieldByName('tlDiscount3Chr') as TStringField;
  fldTlUseOriginalRates := SQLCaller.Records.FieldByName('tlUseOriginalRates') as TIntegerField;
  fldTlCurrency := SQLCaller.Records.FieldByName('tlCurrency') as TIntegerField;
end;
//PR: 22/03/2016 v2016 R2 ABSEXCH-17390 Changed to ReadRecordEx to avoid warning message
procedure TStockLedgerSortView.ReadRecordEx(var IdRec: Idetail);
begin
  IdRec.FolioRef := fldTlFolioNum.Value;
  IdRec.LineNo := fldTlLineNo.Value;
  IdRec.IdDocHed := DocTypes(fldTlDocType.Value);
  IdRec.CustCode := fldTlAcCode.Value;
  IdRec.DocPRef := fldTlOurRef.Value;
  IdRec.PDate := fldTlLineDate.Value;
  IdRec.Qty := fldTlQty.Value;
  IdRec.QtyPick := fldTlQtyPicked.Value;
  IdRec.QtyMul := fldTlQtyMul.Value;
  IdRec.QtyDel := fldTlQtyDel.Value;
  IdRec.QtyWOFF := fldTlQtyWoff.Value;
  IdRec.QtyPWOFF := fldTlQtyPickedWO.Value;
  IdRec.CostPrice := fldTlCost.Value;
  IdRec.Payment := ExtractCharAtPos(fldTlPaymentCode.Value);
  IdRec.PriceMulx := fldTlPriceMultiplier.Value;
  IdRec.NetValue := fldTlNetValue.Value;
  IdRec.UsePack := fldTlUsePack.Value;
  IdRec.PrxPack := fldTlPrxPack.Value;
  IdRec.QtyPack := fldTlQtyPack.Value;
  IdRec.IncNetValue := fldTlVATIncValue.Value;
  IdRec.Discount := fldTlDiscount.Value;
  IdRec.DiscountChr := ExtractCharAtPos(fldTlDiscFlag.Value);
  IdRec.Discount2 := fldTlDiscount2.Value;
  IdRec.Discount3Chr := ExtractCharAtPos(fldTlDiscount2Chr.Value);
  IdRec.Discount3 := fldTlDiscount3.Value;
  IdRec.Discount3Chr := ExtractCharAtPos(fldTlDiscount3Chr.Value);
  IdRec.UseORate := fldTlUseOriginalRates.Value;
  IdRec.Currency := fldTlCurrency.Value;
end;

function TStockLedgerSortView.SyncRecord: Integer;
var
  Key: str255;
begin
  Key := FullIDKey(SortTempRec.svtSourceDataFolio, SortTempRec.svtSourceLineNo);
  Result := Find_Rec(B_GetEq, F[IdetailF], IdetailF, RecPtr[IdetailF]^, IdFolioK, Key);
end;

// -----------------------------------------------------------------------------

function TStockLedgerSortView.SyncTemp: Integer;
var
  Key: Str255;
  FuncRes: Integer;
begin
  Key := FullNomKey(ListID) + FullIDKey(Id.FolioRef, Id.LineNo);
  Result := Find_Rec(B_GetEq, F[SortTempF], SortTempF, RecPtr[SortTempF]^, STLinkFolioK, Key);
end;

// -----------------------------------------------------------------------------

end.
