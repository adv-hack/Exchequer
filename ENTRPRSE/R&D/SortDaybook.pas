unit SortDaybook;

interface

uses SysUtils, Classes, ADODB, DB, VarSortV, SortViewU, ExWrap1U, VarConst;

type
  TDaybookSortView = class(TBaseSortView)
  private
    fldThOurRef: TStringField;
    fldThTransDate: TStringField;
    fldThAcCode: TStringField;
    fldAmount: TFloatField;
    fldHoldFlag: TIntegerField;
    fldThYourRef: TStringField;
    fldOrderPaymentStatus: TStringField;
  protected
    function GetFilterDataType(const FilterFieldId: LongInt): TSortViewFilterDataType; override;
    function GetAmount: Double;
    function GetHoldFlag: Double;
    function GetStringFilterValue(const FilterFieldId: LongInt): ShortString; override;
    function GetFloatFilterValue(const FilterFieldId: LongInt): Double; override;
    function GetSortValue(const Sort: TSortViewSortInfoRecType): ShortString; override;
    function GetSourceDataStr: ShortString; override;
    function GetSourceDataFolio: LongInt; override;
    function GetSourceLineNo: LongInt; override;
    // SQL access
    procedure PrepareFields; override;
    function GetSQLSortValue(const Sort: TSortViewSortInfoRecType): ShortString; override;
    function GetSQLSourceDataStr: ShortString; override;
    function GetSQLSourceDataFolio: LongInt; override;
    function GetSQLSourceLineNo: LongInt; override;
  public
    constructor Create(ForListType: TSortViewListType);
    procedure PopulateSortFields(List: TStrings); override;
    procedure PopulateFilterFields(List: TStrings); override;
    function SyncFilter: Integer; override;
    function SyncRecord: Integer; override;
    function SyncTemp: Integer; override;
    function CheckListFilter : Boolean; override;
  end;

implementation

uses GlobVar, BtrvU2, BtKeys1U, PWarnU, BtSupU1, SysU1, StrUtil, ComnUnit,
  ETMiscU, Saltxl1U, {$IFDEF SOP}OrderPaymentFuncs,{$ENDIF} SQLUtils;

// =============================================================================
// TDaybookSortView
// =============================================================================
// Transactions

function TDaybookSortView.CheckListFilter: Boolean;
begin
  Result := True;
end;

// -----------------------------------------------------------------------------

constructor TDaybookSortView.Create(ForListType: TSortViewListType);
begin
  inherited Create;
  HostListFileNo := InvF;
  ListType := ForListType;
end;

// -----------------------------------------------------------------------------

function TDaybookSortView.GetFilterDataType(
  const FilterFieldId: Integer): TSortViewFilterDataType;
begin
  // All the filter fields are strings
  Result := fdtString;
end;

// -----------------------------------------------------------------------------

function TDaybookSortView.GetFloatFilterValue(
  const FilterFieldId: Integer): Double;
begin
  // There are no float filters
  Result := 0.0;
end;

// -----------------------------------------------------------------------------

function TDaybookSortView.GetAmount: Double;
begin
  with Inv do
  begin
    if (InvDocHed in OrderSet) then
      Result := TotOrdOS
    else
      Result := Itotal(Inv);

    if (InvDocHed in CreditSet + RecieptSet) then
      Result := Result * DocNotCnst;
  end;
end;

// -----------------------------------------------------------------------------

function TDaybookSortView.GetHoldFlag: Double;
var
  Hold: Byte;
begin
  Hold := (Inv.HoldFlg - (Inv.HoldFlg And (HoldSuspend + HoldNotes)));
  // SortViews sort by floats, not integers, so convert the result to a float
  Result := 0.0 + Hold;
end;

//-------------------------------------------------------------------------

function TDaybookSortView.GetSortValue(
  const Sort: TSortViewSortInfoRecType): ShortString;
begin
  Result := '';
  if (Sort.svsEnabled) then
  begin
    case Sort.svsFieldId of
      0: Result := AdjustSortStringValue(Inv.OurRef, Sort);
      1: Result := AdjustSortStringValue(Inv.TransDate, Sort);
      2: Result := AdjustSortStringValue(Inv.CustCode, Sort);
      3: Result := AdjustSortFloatValue(GetAmount, Sort);
      4: Result := AdjustSortFloatValue(GetHoldFlag, Sort);
      5: Result := AdjustSortStringValue(Inv.YourRef, Sort);
      {$IFDEF SOP}
      // MH 26/06/2015 Exch-R1 ABSEXCH-16459: Added Order Payments Payment Status column
      6: Result := AdjustSortStringValue(CalcOrderPaymentStatus(Inv.thOrderPaymentElement, Inv.thOrderPaymentFlags), Sort);
      {$ENDIF SOP}
    else
      // Invalid field id
    end;
  end;
end;

// -----------------------------------------------------------------------------

function TDaybookSortView.GetSourceDataFolio: LongInt;
begin
  Result := 0;
end;

// -----------------------------------------------------------------------------

function TDaybookSortView.GetSourceDataStr: ShortString;
begin
  Result := Inv.OurRef;
end;

// -----------------------------------------------------------------------------

function TDaybookSortView.GetSourceLineNo: LongInt;
begin
  Result := 0;
end;

// -----------------------------------------------------------------------------

function TDaybookSortView.GetSQLSortValue(
  const Sort: TSortViewSortInfoRecType): ShortString;
begin
  Result := '';
  if (Sort.svsEnabled) then
  begin
    case Sort.svsFieldId of
      0: Result := AdjustSortStringValue(fldThOurRef.Value, Sort);
      1: Result := AdjustSortStringValue(fldThTransDate.Value, Sort);
      2: Result := AdjustSortStringValue(fldThAcCode.Value, Sort);
      3: Result := AdjustSortFloatValue (fldAmount.Value, Sort);
      4: Result := AdjustSortFloatValue (fldHoldFlag.Value, Sort);
      5: Result := AdjustSortStringValue(fldThYourRef.Value, Sort);
      // MH 26/06/2015 Exch-R1 ABSEXCH-16459: Added Order Payments Payment Status column
      // MH 18/08/2015 2015-R1 ABSEXCH-16770: Stored Procedure only returning OrderPaymentStatus
      // column for the Sales Order Daybook so have to skip it
      6: If Assigned(fldOrderPaymentStatus) Then
           Result := AdjustSortStringValue(fldOrderPaymentStatus.Value, Sort)
         Else
           Result := '';
    else
      // Invalid field id (raise exception?)
    end;
  end;
end;

// -----------------------------------------------------------------------------

function TDaybookSortView.GetSQLSourceDataFolio: LongInt;
begin
  Result := 0;
end;

// -----------------------------------------------------------------------------

function TDaybookSortView.GetSQLSourceDataStr: ShortString;
begin
  Result := fldThOurRef.Value;
end;

// -----------------------------------------------------------------------------

function TDaybookSortView.GetSQLSourceLineNo: LongInt;
begin
  Result := 0;
end;

// -----------------------------------------------------------------------------

function TDaybookSortView.GetStringFilterValue(
  const FilterFieldId: Integer): ShortString;
begin
  case FilterFieldId of
    0: Result := Inv.CustCode;
    1: Result := Cust.AreaCode;
    2:
      begin
        case Cust.AccStatus of
          1: Result := 'See notes';
          2: Result := 'On hold';
          3: Result := 'Closed';
        else
          Result := '';
        end;
      end;
    3: Result := Inv.OurRef;
    4: Result := Inv.YourRef;
    5: Result := Copy(Inv.OurRef, 1, 3);
    6: Result := Inv.TransDate;
    7: Result := Format('%.2d%.4d', [Inv.AcPr, Inv.AcYr + 1900]);
    8: Result := IntToStr(Inv.Currency); //HV 08/04/2016 2016-R2 ABSEXCH-15408: Introduce a filter to permit the daybooks to be sorted by transaction currency
    {$IFDEF SOP}
    // MH 26/06/2015 Exch-R1 ABSEXCH-16459: Added Order Payments Payment Status column
    9: Result := CalcOrderPaymentStatus(Inv.thOrderPaymentElement, Inv.thOrderPaymentFlags);
    {$ENDIF SOP}
  else
    Result := ''; // Invalid field id
  end;
end;

// -----------------------------------------------------------------------------

procedure TDaybookSortView.PopulateFilterFields(List: TStrings);
begin
  List.Clear;
  List.Add('Account Code');                 // 0
  List.Add('Account Area');                 // 1
  List.Add('Account Status');               // 2
  List.Add('Our Ref');                      // 3  //HV 06/04/2016 2016-R2 ABSEXCH-14691: Most sort and filter options on the new Sort Views abbreviations are replaced with full names
  List.Add('Your Ref');                     // 4
  List.Add('Transaction Type');             // 5
  List.Add('Transaction Date (YYYYMMDD)');  // 6
  List.Add('Transaction Period (MMYYYY)');  // 7
  List.Add('Transaction Currency');         // 8 //HV 08/04/2016 2016-R2 ABSEXCH-15408: Introduce a filter to permit the daybooks to be sorted by transaction currency
  // MH 26/06/2015 Exch-R1 ABSEXCH-16459: Added Order Payments Payment Status column
  If Syss.ssEnableOrderPayments And (ListType = svltSalesDaybookOrders) Then
    List.Add('Order Payment Status');       // 9
  // Probably need to split Sales Daybook Orders off if any new filters need to be added
end;

// -----------------------------------------------------------------------------

procedure TDaybookSortView.PopulateSortFields(List: TStrings);
begin
  //HV 06/04/2016 2016-R2 ABSEXCH-14691: Most sort and filter options on the new Sort Views abbreviations are replaced with full names
  List.Clear;
  List.Add('Our Ref');           // 0
  List.Add('Transaction Date');  // 1
  List.Add('Account Code');      // 2
  List.Add('Amount');            // 3
  List.Add('Status');            // 4
  List.Add('Your Ref');          // 5  
  // MH 26/06/2015 Exch-R1 ABSEXCH-16459: Added Order Payments Payment Status column
  If Syss.ssEnableOrderPayments And (ListType = svltSalesDaybookOrders) Then
    List.Add('Order Payment Status');  // 6
  // Probably need to split Sales Daybook Orders off if any new sorts need to be added

end;

// -----------------------------------------------------------------------------

procedure TDaybookSortView.PrepareFields;
begin
  fldThOurRef    := SQLCaller.Records.FieldByName('thOurRef')    as TStringField;
  fldThTransDate := SQLCaller.Records.FieldByName('thTransDate') as TStringField;
  fldThAcCode    := SQLCaller.Records.FieldByName('thAcCode')    as TStringField;
  fldAmount      := SQLCaller.Records.FieldByName('Amount')      as TFloatField;
  fldHoldFlag    := SQLCaller.Records.FieldByName('HoldFlag')    as TIntegerField;
  fldThYourRef   := SQLCaller.Records.FieldByName('thYourRef')   as TStringField;

  // MH 18/08/2015 2015-R1 ABSEXCH-16770: Stored Procedure only returning OrderPaymentStatus
  // column for the Sales Order Daybook so have to skip it
  If (ListType = svltSalesDaybookOrders) Then
    // MH 26/06/2015 Exch-R1 ABSEXCH-16459: Added Order Payments Payment Status column
    fldOrderPaymentStatus := SQLCaller.Records.FieldByName('OrderPaymentStatus') as TStringField;
end;

// -----------------------------------------------------------------------------

function TDaybookSortView.SyncFilter: Integer;
var
  KeyPath: Integer;
  Key: Str255;
begin
  Result := 0;
  { Locate the Customer Account record. }
//  if (SQLUtils.UsingSQL) then
  if UseStoredProcedure Then
    Key := FullCustCode(fldThAcCode.Value)
  else
    Key := FullCustCode(Inv.CustCode);
  Result := Find_Rec(B_GetEq, F[CustF], CustF, RecPtr[CustF]^, CustCodeK, Key);
end;

// -----------------------------------------------------------------------------

function TDaybookSortView.SyncRecord: Integer;
var
  Key : Str255;
  FuncRes: Integer;
Begin
  // Find the Document record matching the current Sort View record.
  Key := SortTempRec.svtSourceDataStr;
  Result := Find_Rec(B_GetEq, F[InvF], InvF, RecPtr[InvF]^, InvOurRefK, Key);
end;

// -----------------------------------------------------------------------------

{
  SyncTemp does the opposite of SyncRecord -- it locates the record in the
  temporary Sort file which matches the current record in the Document file.
}
function TDaybookSortView.SyncTemp: Integer;
var
  Key: Str255;
  FuncRes: Integer;
begin
  Key := FullNomKey(ListID) + FullNomKey(Inv.FolioNum);
  Result := Find_Rec(B_GetEq, F[SortTempF], SortTempF, RecPtr[SortTempF]^, STLinkFolioK, Key);
end;

// -----------------------------------------------------------------------------

end.
