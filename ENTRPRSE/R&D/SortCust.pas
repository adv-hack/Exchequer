unit SortCust;

interface

uses SysUtils, Classes, DB, VarSortV, SortViewU, ExWrap1U, VarConst;

type
  TCustomerSortView = class(TBaseSortView)
  private
    { CJS - 2012-07-20: ABSEXCH-12962 - Sort View SQL Mods - Field pointers }
    fldAcCode: TStringField;
    fldAcCompany: TStringField;
    fldAcBalance: TFloatField;
    fldAcPhone: TStringField;
  protected
    function GetFilterDataType(const FilterFieldId: LongInt): TSortViewFilterDataType; override;
    function GetBalance: double;
    function GetStringFilterValue(const FilterFieldId: LongInt): ShortString; override;
    function GetFloatFilterValue(const FilterFieldId: LongInt): Double; override;
    function GetSortValue(const Sort: TSortViewSortInfoRecType): ShortString; override;
    function GetSourceDataStr: ShortString; override;
    function GetSourceDataFolio: LongInt; override;
    function GetSourceLineNo: LongInt; override;

    { CJS - 2012-07-20: ABSEXCH-12962 - Sort View SQL Mods }
    procedure PrepareFields; override;
    function GetSQLSortValue(const Sort: TSortViewSortInfoRecType): ShortString; override;
    function GetSQLSourceDataStr: ShortString; override;
    function GetSQLSourceDataFolio: LongInt; override;
    function GetSQLSourceLineNo: LongInt; override;

  public
    constructor Create(AsCustomer: Boolean);
    function GetFieldIDFromListIndex(ItemIndex: Integer): Integer; override;
    function GetListIndexFromFieldID(FieldID: Integer): Integer; override;
    procedure PopulateSortFields(List: TStrings); override;
    procedure PopulateFilterFields(List: TStrings); override;
    function SyncRecord: Integer; override;
    function SyncTemp: Integer; override;
    function CheckListFilter : Boolean; override;
  end;

  TCustomerLedgerSortView = class(TBaseSortView)
  protected
    FExLocal: TdExLocalPtr;
    FNHCtrl: TNHCtrlRec;
    FDisplayMode: Byte;
    function GetFilterDataType(const FilterFieldId: LongInt): TSortViewFilterDataType; override;
    function GetStringFilterValue(const FilterFieldId: LongInt): ShortString; override;
    function GetFloatFilterValue(const FilterFieldId: LongInt): Double; override;
    function GetSortValue(const Sort: TSortViewSortInfoRecType): ShortString; override;
    function GetSourceDataStr: ShortString; override;
    function GetSourceDataFolio: LongInt; override;
    function GetSourceLineNo: LongInt; override;
    function HoldString: string;
    function UseStoredProcedure: Boolean; override;
    //PL 04/01/2017 2017-R1 ABSEXCH-17809 : Default list values for Status field in Sort View of Trader > Ledger is not correct.
    function GetResolvedFilterValue(aFilterId:Integer; aFilterValue:String) : String; override;
  public
    constructor Create(AsCustomer: Boolean);
    procedure PopulateSortFields(List: TStrings); override;
    procedure PopulateFilterFields(List: TStrings); override;
    function SyncRecord: Integer; override;
    function SyncTemp: Integer; override;
    property ExLocal: TdExLocalPtr read FExLocal write FExLocal;
    property NHCtrl: TNHCtrlRec read FNHCtrl write FNHCtrl;
    property DisplayMode: Byte read FDisplayMode write FDisplayMode;
  end;

implementation

uses GlobVar, BtrvU2, BtKeys1U, PWarnU, BtSupU1, SysU1, StrUtil,
  CustLedg;

// =============================================================================
// TCustomerSortView
// =============================================================================
// Customers & Suppliers

constructor TCustomerSortView.Create(AsCustomer: Boolean);
begin
  inherited Create;
  HostListFileNo := CustF;
  if AsCustomer then
  begin
    ListType := svltCustomer;
    ListDesc := 'Customer List';
  end
  else
  begin
    ListType := svltSupplier;
    ListDesc := 'Supplier List';
  end;
end;

// -----------------------------------------------------------------------------

function TCustomerSortView.GetFilterDataType(
  const FilterFieldId: Integer): TSortViewFilterDataType;
begin
  case FilterFieldId of
    // GS 26/10/2011 ABSEXCH-11706: changed floating point field index from 5 to 11
    // (adding UDEFs moved numeric field from index 5 to 11)

    // CS 30/11/2011 ABSEXCH-12248: Reverted to original numbering (functions
    // added to map between field id and list item index).
    5: Result := fdtFloat;
  else
    Result := fdtString;
  end;
end;

// -----------------------------------------------------------------------------

function TCustomerSortView.GetFieldIDFromListIndex(
  ItemIndex: Integer): Integer;
begin
{
  Item                      List Index    Field ID
  --------------------      ----------    --------
  Area                          0            0
  User Defined Field 1          1            1
  User Defined Field 2          2            2
  User Defined Field 3          3            3
  User Defined Field 4          4            4
  User Defined Field 5          5           10
  User Defined Field 6          6           11
  User Defined Field 7          7           12
  User Defined Field 8          8           13
  User Defined Field 9          9           14
  User Defined Field 10        10           15
  Balance                      11            5
  Cost Centre                  12            6
  Department                   13            7
  Type                         14            8
  Status                       15            9
}
  case ItemIndex of
     0: Result :=  0;
     1: Result :=  1;
     2: Result :=  2;
     3: Result :=  3;
     4: Result :=  4;
     5: Result := 10;
     6: Result := 11;
     7: Result := 12;
     8: Result := 13;
     9: Result := 14;
    10: Result := 15;
    11: Result :=  5;
    12: Result :=  6;
    13: Result :=  7;
    14: Result :=  8;
    15: Result :=  9;
    else
      raise Exception.Create('Invalid ItemIndex in GetFieldIDFromListIndex: ' + IntToStr(ItemIndex));
  end;
end;

// -----------------------------------------------------------------------------

function TCustomerSortView.GetFloatFilterValue(
  const FilterFieldId: Integer): Double;
begin
  case FilterFieldId of
    5: Result := GetBalance;
  else
    Result := 0.0;
  end;
end;

// -----------------------------------------------------------------------------

function TCustomerSortView.GetBalance: double;
var
  Profit,
  Sales,
  Purch,
  Cleared      :  Double;
begin
  Result := 0.0;
  {$B-}
  if (IsACust(Cust.CustSupp) and PChkAllowed_In(404)) or
     ((not IsACust(Cust.CustSupp)) and PChkAllowed_In(424)) then
  {$B+}
    Result := Profit_to_Date(CustHistCde, Cust.CustCode, 0, GetLocalPr(0).CYr, GetLocalPr(0).CPr, Purch, Sales, Cleared, BOn);
end;

// -----------------------------------------------------------------------------

function TCustomerSortView.GetListIndexFromFieldID(
  FieldID: Integer): Integer;
begin
{
  Item                     Field ID    List Index
  --------------------     --------    ----------
  Area                        0            0
  User Defined Field 1        1            1
  User Defined Field 2        2            2
  User Defined Field 3        3            3
  User Defined Field 4        4            4
  Balance                     5           11
  Cost Centre                 6           12
  Department                  7           13
  Type                        8           14
  Status                      9           15
  User Defined Field 5       10            5
  User Defined Field 6       11            6
  User Defined Field 7       12            7
  User Defined Field 8       13            8
  User Defined Field 9       14            9
  User Defined Field 10      15           10
}
  case FieldID of
     0: Result :=  0;
     1: Result :=  1;
     2: Result :=  2;
     3: Result :=  3;
     4: Result :=  4;
     5: Result := 11;
     6: Result := 12;
     7: Result := 13;
     8: Result := 14;
     9: Result := 15;
    10: Result :=  5;
    11: Result :=  6;
    12: Result :=  7;
    13: Result :=  8;
    14: Result :=  9;
    15: Result := 10;
    else
      raise Exception.Create('Invalid FieldId in GetListIndexFromFieldID: ' + IntToStr(FieldId));

  end;
end;

// -----------------------------------------------------------------------------

function TCustomerSortView.GetSortValue(
  const Sort: TSortViewSortInfoRecType): ShortString;
begin
  Result := '';
  if (Sort.svsEnabled) then
  begin
    case Sort.svsFieldId of
      0: Result := AdjustSortStringValue(Cust.CustCode, Sort);
      1: Result := AdjustSortStringValue(Cust.Company, Sort);
      2: Result := AdjustSortFloatValue(GetBalance, Sort);
      3: Result := AdjustSortStringValue(Cust.Phone, Sort);
    else
      // Invalid field id (raise exception?)
    end;
  end;
end;

// -----------------------------------------------------------------------------

function TCustomerSortView.GetSourceDataFolio: LongInt;
begin
  Result := 0;
end;

// -----------------------------------------------------------------------------

function TCustomerSortView.GetSourceDataStr: ShortString;
begin
  Result := Cust.CustCode;
end;

// -----------------------------------------------------------------------------

function TCustomerSortView.GetSourceLineNo: LongInt;
begin
  Result := 0;
end;

// -----------------------------------------------------------------------------

function TCustomerSortView.GetSQLSortValue(
  const Sort: TSortViewSortInfoRecType): ShortString;
begin
  Result := '';
  if (Sort.svsEnabled) then
  begin
    case Sort.svsFieldId of
      0: Result := AdjustSortStringValue(fldAcCode.Value, Sort);
      1: Result := AdjustSortStringValue(fldAcCompany.Value, Sort);
      2: Result := AdjustSortFloatValue(fldAcBalance.Value, Sort);
      3: Result := AdjustSortStringValue(fldAcPhone.Value, Sort);
    else
      // Invalid field id (raise exception?)
    end;
  end;
end;

// -----------------------------------------------------------------------------

function TCustomerSortView.GetSQLSourceDataFolio: LongInt;
begin
  Result := 0;
end;

// -----------------------------------------------------------------------------

function TCustomerSortView.GetSQLSourceDataStr: ShortString;
begin
  Result := fldAcCode.Value;
end;

// -----------------------------------------------------------------------------

function TCustomerSortView.GetSQLSourceLineNo: LongInt;
begin
  Result := 0;
end;

// -----------------------------------------------------------------------------

function TCustomerSortView.GetStringFilterValue(
  const FilterFieldId: Integer): ShortString;
begin
  case FilterFieldId of
    0: Result := Cust.AreaCode;
    1: Result := Cust.UserDef1;
    2: Result := Cust.UserDef2;
    3: Result := Cust.UserDef3;
    4: Result := Cust.UserDef4;
    6:  Result := Cust.CustCC;
    7:  Result := Cust.CustDep;
    8:  Result := Cust.RepCode;
    9: Result := IntToStr(Cust.AccStatus); //HV 19/04/2016 2016-R2 ABSEXCH-9497: Drop down list be added when Status is selected to avoid mis-typing the three valid options
    //GS 21/10/2011 ABSEXCH-11706: added support for UDEF 6-10
    10: Result := Cust.UserDef5;
    11: Result := Cust.UserDef6;
    12: Result := Cust.UserDef7;
    13: Result := Cust.UserDef8;
    14: Result := Cust.UserDef9;
    15: Result := Cust.UserDef10;
  else
    Result := ''; // Invalid field id (raise exception?)
  end;
end;

// -----------------------------------------------------------------------------

procedure TCustomerSortView.PopulateFilterFields(List: TStrings);
begin
  List.Clear;
  List.Add('Area');                    //  0
  List.Add('User Defined Field 1');    //  1
  List.Add('User Defined Field 2');    //  2
  List.Add('User Defined Field 3');    //  3
  List.Add('User Defined Field 4');    //  4
  //GS 21/10/2011 ABSEXCH-11706: added support for UDEF 6-10
  List.Add('User Defined Field 5');    // 10
  List.Add('User Defined Field 6');    // 11
  List.Add('User Defined Field 7');    // 12
  List.Add('User Defined Field 8');    // 13
  List.Add('User Defined Field 9');    // 14
  List.Add('User Defined Field 10');   // 15
  List.Add('Balance');                 //  5
  List.Add('Cost Centre');             //  6
  List.Add('Department');              //  7
  List.Add('Type');                    //  8
  List.Add('Status');                  //  9
end;

// -----------------------------------------------------------------------------

procedure TCustomerSortView.PopulateSortFields(List: TStrings);
begin
  List.Clear;
  List.Add('Account Code');
  List.Add('Company Name');
  List.Add('Balance');
  List.Add('Telephone No');
end;

// -----------------------------------------------------------------------------

procedure TCustomerSortView.PrepareFields;
begin
  fldAcCode    := SQLCaller.Records.FieldByName('acCode') as TStringField;
  fldAcCompany := SQLCaller.Records.FieldByName('acCompany') as TStringField;
  fldAcBalance := SQLCaller.Records.FieldByName('Balance') as TFloatField;
  fldAcPhone   := SQLCaller.Records.FieldByName('acPhone') as TStringField;
end;

// -----------------------------------------------------------------------------

function TCustomerSortView.SyncRecord: Integer;
var
  Key : Str255;
  FuncRes: Integer;
Begin
  // Find the matching Cust record.
  Key := SortTempRec.svtSourceDataStr;
  Result := Find_Rec(B_GetEq, F[CustF], CustF, RecPtr[CustF]^, CustCodeK, Key);
end;

// -----------------------------------------------------------------------------

{
  SyncTemp does the opposite of SyncRecord -- it locates the record in the
  temporary Sort file which matches the current record in the Cust file.
}
function TCustomerSortView.SyncTemp: Integer;
var
  Key: Str255;
  FuncRes: Integer;
begin
  Key := FullNomKey(ListID) + Cust.CustCode;
  Result := Find_Rec(B_GetEq, F[SortTempF], SortTempF, RecPtr[SortTempF]^, STLinkStrK, Key);
end;

// -----------------------------------------------------------------------------

function TCustomerSortView.CheckListFilter : Boolean;
begin
  Result := True;
end;

// =============================================================================
// TCustomerLedgerSortView
// =============================================================================

constructor TCustomerLedgerSortView.Create(AsCustomer: Boolean);
begin
  inherited Create;
  HostListFileNo := InvF;
  if AsCustomer then
  begin
    ListType := svltCustLedger;
    ListDesc := 'Customer Ledger List';
  end
  else
  begin
    ListType := svltSuppLedger;
    ListDesc := 'Supplier Ledger List';
  end;
end;

// -----------------------------------------------------------------------------

function TCustomerLedgerSortView.GetFilterDataType(
  const FilterFieldId: Integer): TSortViewFilterDataType;
begin
  case FilterFieldId of
  //GS 26/10/2011 ABSEXCH-11706: changed floating point field index from 4 to 10
  //(adding UDEFs moved numeric field from index 4 to 10)
    10: Result := fdtFloat;
  else
    Result := fdtString;
  end;
end;

// -----------------------------------------------------------------------------

function TCustomerLedgerSortView.GetFloatFilterValue(
  const FilterFieldId: Integer): Double;
begin
  case FilterFieldID of
    4,10: Result := LedgerColumnAsFloat(ExLocal, NHCtrl, DisplayMode, 3);
    //HV 09/03/2016 2016-R2 ABSEXCH-14389: Sort Views not returning results when filtering for outstanding amounts.
  else
    Result := 0.0;
  end;
end;

// -----------------------------------------------------------------------------

function TCustomerLedgerSortView.GetSortValue(
  const Sort: TSortViewSortInfoRecType): ShortString;
var
  LedgerCol: Byte;
begin
{
1  List.Add('Our Ref');
2  List.Add('Date');
3  List.Add('Amount Settled');
4  List.Add('Outstanding');
5  List.Add('Original Value');
6  List.Add('Your Ref');
7  List.Add('Date Due');
}
  Result := '';
  if (Sort.svsEnabled) then
  begin
    if (FExLocal <> nil) then
    begin
      case Sort.svsFieldId of
        4: LedgerCol := 5;  // Original Value
        5: LedgerCol := 6;  // Your Ref
        6: LedgerCol := 7;  // Date Due
      else
        LedgerCol := Sort.svsFieldId;
      end;
      case Sort.svsFieldId of
        1: Result := AdjustSortDateStringValue(LedgerColumn(ExLocal, NHCtrl, DisplayMode, LedgerCol, True), Sort);
        2: Result := AdjustSortFloatValue(LedgerColumnAsFloat(ExLocal, NHCtrl, DisplayMode, LedgerCol), Sort);
        3: Result := AdjustSortFloatValue(LedgerColumnAsFloat(ExLocal, NHCtrl, DisplayMode, LedgerCol), Sort);
        4: Result := AdjustSortFloatValue(LedgerColumnAsFloat(ExLocal, NHCtrl, DisplayMode, LedgerCol), Sort);
        6: Result := AdjustSortDateStringValue(LedgerColumn(ExLocal, NHCtrl, DisplayMode, LedgerCol, True), Sort);
      else
        Result := AdjustSortStringValue(LedgerColumn(ExLocal, NHCtrl, DisplayMode, LedgerCol, True), Sort);
      end;
    end
    else
      raise Exception.Create('Customer Ledger Sort View not initialised');
  end;
end;

// -----------------------------------------------------------------------------

function TCustomerLedgerSortView.GetSourceDataFolio: LongInt;
begin
  Result := Inv.FolioNum;
end;

// -----------------------------------------------------------------------------

function TCustomerLedgerSortView.GetSourceDataStr: ShortString;
begin
  Result := '';
end;

// -----------------------------------------------------------------------------

function TCustomerLedgerSortView.GetSourceLineNo: LongInt;
begin
  Result := 0;
end;

// -----------------------------------------------------------------------------

function TCustomerLedgerSortView.GetStringFilterValue(
  const FilterFieldId: Integer): ShortString;
begin
  case FilterFieldId of
    0: Result := Inv.DocUser1;
    1: Result := Inv.DocUser2;
    2: Result := Inv.DocUser3;
    3: Result := Inv.DocUser4;
    //GS 21/10/2011 ABSEXCH-11706: added support for UDEF 6-10
    4: Result := Inv.DocUser5;
    5: Result := Inv.DocUser6;
    6: Result := Inv.DocUser7;
    7: Result := Inv.DocUser8;
    8: Result := Inv.DocUser9;
    9: Result := Inv.DocUser10;
    11: Result := Copy(Inv.OurRef, 1, 3);
    12: Result := HoldString;
  else
    Result := ''; // Invalid field id (raise exception?)
  end;
end;

// -----------------------------------------------------------------------------

function TCustomerLedgerSortView.HoldString: string;
var
  HoldState:  Byte;
  n: Byte;
  // ...........................................................................
  function AddSlash(ToString, AddString: string): string;
  begin
    Result := ToString;
    if (ToString <> '') then
      Result := Result + '/';
    Result := Result + AddString;
  end;
  // ...........................................................................
const
  DiscountString: array[0..2] of string =
  (
    '',
    'Settle Disc Avail',
    'Settle Disc Taken'
  );
begin
  HoldState := 0;

  // MH 20/03/2015 v7.0.14 ABSEXCH-16284: Added Prompt Payment Discount fields
  n := (1 * Ord((Inv.DiscSetAm <> 0) Or (Inv.thPPDGoodsValue <> 0.0) Or (Inv.thPPDVATValue <> 0.0))) +
       // MH 05/05/2015 v7.0.14 ABSEXCH-16284: PPD Mods
       (1 * Ord((Inv.DiscTaken = True) or (Inv.PDiscTaken = True) Or (Inv.thPPDTaken <> ptPPDNotTaken)));

  Result := DiscountString[n];

  if (Inv.Tagged <> 0) then
    Result := AddSlash(Result, 'Tag ' + Format('%.2d', [Inv.Tagged]));

  if (Inv.HoldFlg <> 0) then
  begin
    HoldState := Inv.HoldFlg and (not HoldNotes) and (not HoldSuspend);
    if (HoldState > 0) then
      Result := AddSlash(Result, DisplayHold(HoldState));

    if ((Inv.HoldFlg and HoldSUSPEND) = HoldSUSPEND) then
      Result := AddSlash(Result, DisplayHold(HoldSUSPEND));

    if ((Inv.HoldFlg and HoldNotes) = HoldNotes) then
      Result := AddSlash(Result, DisplayHold(HoldNotes));
  end;

  if (Inv.OnPickRun) then
    Result := AddSlash(Result,'Pick run');

  if (Inv.PrintedDoc) then
    Result := AddSlash(Result,'Printed');

end;

// -----------------------------------------------------------------------------

procedure TCustomerLedgerSortView.PopulateFilterFields(List: TStrings);
begin
  List.Clear;
  List.Add('User Defined Field 1'); // 0
  List.Add('User Defined Field 2'); // 1
  List.Add('User Defined Field 3'); // 2
  List.Add('User Defined Field 4'); // 3
  //GS 21/10/2011 ABSEXCH-11706: added support for UDEF 6-10
  List.Add('User Defined Field 5'); // 4
  List.Add('User Defined Field 6'); // 5
  List.Add('User Defined Field 7'); // 6
  List.Add('User Defined Field 8'); // 7
  List.Add('User Defined Field 9'); // 8
  List.Add('User Defined Field 10');// 9
  List.Add('Outstanding');          // 10
  List.Add('Type');                 // 11
  List.Add('Status');               // 12

end;

// -----------------------------------------------------------------------------

procedure TCustomerLedgerSortView.PopulateSortFields(List: TStrings);
begin
  List.Clear;
  List.Add('Our Ref');
  List.Add('Date');
  List.Add('Amount Settled');
  List.Add('Outstanding');
  List.Add('Original Value');
  List.Add('Your Ref');
  List.Add('Date Due');
end;

// -----------------------------------------------------------------------------

function TCustomerLedgerSortView.SyncRecord: Integer;
var
  Key : Str255;
  FuncRes: Integer;
Begin
  // Find the matching Transaction record.
  Key := FullNomKey(SortTempRec.svtSourceDataFolio);
  Result := Find_Rec(B_GetEq, F[InvF], InvF, RecPtr[InvF]^, InvFolioK, Key);
end;

// -----------------------------------------------------------------------------

function TCustomerLedgerSortView.SyncTemp: Integer;
var
  Key: Str255;
  FuncRes: Integer;
begin
  Key := FullNomKey(ListID) + FullNomKey(Inv.FolioNum);
  Result := Find_Rec(B_GetEq, F[SortTempF], SortTempF, RecPtr[SortTempF]^, STLinkFolioK, Key);
end;

// -----------------------------------------------------------------------------

function TCustomerLedgerSortView.UseStoredProcedure: Boolean;
begin
  // We can't use the SQL stored procedures for this Sort View as it relies
  // on calculations that would result in rounding discrepancies under SQL.
  Result := False;
end;

// -----------------------------------------------------------------------------
{ PL 04/01/2017 2017-R1 ABSEXCH-17809 : added this virtual method in baseclass
 TBaseSortView if the FilterId is other than "12(status)' it will work as
 existing system flow(case 0...11) and we have overrided this method in
 TCustomerLedgerSortView class which leaves current system flow unchanged .}
 
function TCustomerLedgerSortView.GetResolvedFilterValue(aFilterId : Integer; aFilterValue:String) : String;
var
  lVal,PadTo: Integer;
  lTemp : string;
begin
  case aFilterId of
  { added case 0 to 11 for the filtering options other then "Status"}
    0..11: Result := aFilterValue;
    12:
    begin
      Result := '';
      lVal := StrToInt(Trim(aFilterValue));
      Case lVal of
      {passed empty string for to "Case : 0"  because transaction's status field is empty in "NO Hold"  }
        0   : lTemp := '';
        1   : lTemp := 'Query';
        2   : lTemp := 'untilalloc';
        3   : lTemp := 'authorise';
        4   : lTemp := 'WaitallStk';
        5   : lTemp := 'Credit Hld';
        6   : lTemp := 'Notes';
        7   : lTemp := 'suspend  ';
        8   : lTemp := 'Settle Disc Avail';
        9  : lTemp := 'Settle Disc Taken';
      end;
      Result := lTemp;
    end;

  end;

end;

end.
