unit SortJob;

interface

uses SysUtils, DB, ADODB, Classes, VarSortV, VarConst, SortViewU, ExWrap1U;

type
  TJobLedgerSortView = class(TBaseSortView)
  private
    FExLocal: TdExLocalPtr;
    FNHCtrl: TNHCtrlRec;

    { CJS - 2012-07-24: ABSEXCH-12962 - Sort View SQL Mods - Field Pointers}
    fldActCCode: TStringField;
    fldLineORef: TStringField;
    fldJDate: TStringField;
    fldAnalCode: TStringField;
    fldJDDT: TIntegerField; // DocTypes
    fldQty: TFloatField;
    fldCharge: TFloatField;
    fldActCurr: TIntegerField;
    fldCost: TFloatField;
    fldPCRates1: TFloatField;
    fldPCRates2: TFloatField;
    fldJUseORate: TIntegerField;
    fldCurrCharge: TIntegerField;
    fldCurrPrice: TIntegerField;
    fldUpliftTotal: TFloatField;
    fldPositionID: TIntegerField;

  protected
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
    function SyncFilter: Integer; override;
    function SyncRecord: Integer; override;
    function SyncTemp: Integer; override;
    property ExLocal: TdExLocalPtr read FExLocal write FExLocal;
    property NHCtrl: TNHCtrlRec read FNHCtrl write FNHCtrl;
  end;

implementation

uses BtrvU2, GlobVar, VarRec2U, BtKeys1U, StrUtil, ETMiscU, CurrncyU;

// =============================================================================
// TJobLedgerSortView
// =============================================================================

function TJobLedgerSortView.CheckListFilter: Boolean;
begin
  Result := True;
end;

// -----------------------------------------------------------------------------

constructor TJobLedgerSortView.Create;
begin
  inherited Create;
  HostListFileNo := JDetlF;
  ListType := svltJobLedger;
  ListDesc := 'Job Ledger List';
end;

// -----------------------------------------------------------------------------

function TJobLedgerSortView.GetFieldIDFromListIndex(
  ItemIndex: Integer): Integer;
begin
{
  Item                          List Index   Field ID
  ----------------------------  ----------   --------
  Header User Defined Field 1       0            0
  Header User Defined Field 2       1            1
  Header User Defined Field 3       2            2
  Header User Defined Field 4       3            3
  Header User Defined Field 5       4            9
  Header User Defined Field 6       5           10
  Header User Defined Field 7       6           11
  Header User Defined Field 8       7           12
  Header User Defined Field 9       8           13
  Header User Defined Field 10      9           14
  Line User Defined Field 1        10            4
  Line User Defined Field 2        11            5
  Line User Defined Field 3        12            6
  Line User Defined Field 4        13            7
  Line User Defined Field 5        14           15
  Line User Defined Field 6        15           16
  Line User Defined Field 7        16           17
  Line User Defined Field 8        17           18
  Line User Defined Field 9        18           19
  Line User Defined Field 10       19           20
  Transaction Type                 20            8
}
  case ItemIndex of
     0: Result :=  0;
     1: Result :=  1;
     2: Result :=  2;
     3: Result :=  3;
     4: Result :=  9;
     5: Result := 10;
     6: Result := 11;
     7: Result := 12;
     8: Result := 13;
     9: Result := 14;
    10: Result :=  4;
    11: Result :=  5;
    12: Result :=  6;
    13: Result :=  7;
    14: Result := 15;
    15: Result := 16;
    16: Result := 17;
    17: Result := 18;
    18: Result := 19;
    19: Result := 20;
    20: Result := 8;
    else //PR: 22/03/2016 v2016 R2 ABSEXCH-17390
      raise Exception.Create('Invalid ItemIndex in TJobLedgerSortView.GetFieldIDFromListIndex ' + IntToStr(ItemIndex));
  end;
end;

// -----------------------------------------------------------------------------

function TJobLedgerSortView.GetFilterDataType(
  const FilterFieldId: Integer): TSortViewFilterDataType;
begin
  { All the Job Ledger filters are strings. }
  Result := fdtString;
end;

// -----------------------------------------------------------------------------

function TJobLedgerSortView.GetFloatFilterValue(
  const FilterFieldId: Integer): Double;
begin
  Result := 0.0;
end;

// -----------------------------------------------------------------------------

function TJobLedgerSortView.GetListIndexFromFieldID(
  FieldID: Integer): Integer;
begin
{
  Item                           Field ID   List Index
  ----------------------------   --------   ----------
  Header User Defined Field 1        0          0
  Header User Defined Field 2        1          1
  Header User Defined Field 3        2          2
  Header User Defined Field 4        3          3
  Line User Defined Field 1          4         10
  Line User Defined Field 2          5         11
  Line User Defined Field 3          6         12
  Line User Defined Field 4          7         13
  Transaction Type                   8         20
  Header User Defined Field 5        9          4
  Header User Defined Field 6       10          5
  Header User Defined Field 7       11          6
  Header User Defined Field 8       12          7
  Header User Defined Field 9       13          8
  Header User Defined Field 10      14          9
  Line User Defined Field 5         15         14
  Line User Defined Field 6         16         15
  Line User Defined Field 7         17         16
  Line User Defined Field 8         18         17
  Line User Defined Field 9         19         18
  Line User Defined Field 10        20         19
}
  case FieldID of
     0: Result :=  0;
     1: Result :=  1;
     2: Result :=  2;
     3: Result :=  3;
     4: Result := 10;
     5: Result := 11;
     6: Result := 12;
     7: Result := 13;
     8: Result := 20;
     9: Result :=  4;
    10: Result :=  5;
    11: Result :=  6;
    12: Result :=  7;
    13: Result :=  8;
    14: Result :=  9;
    15: Result := 14;
    16: Result := 15;
    17: Result := 16;
    18: Result := 17;
    19: Result := 18;
    20: Result := 19;
    else //PR: 22/03/2016 v2016 R2 ABSEXCH-17390
      raise Exception.Create('Invalid FieldID in TJobLedgerSortView.GetListIndexFromFieldID ' + IntToStr(FieldId));
  end;
end;

// -----------------------------------------------------------------------------

function TJobLedgerSortView.GetSortValue(
  const Sort: TSortViewSortInfoRecType): ShortString;
var
  UOR  : Byte;
  TCr  : Byte;
  Dnum : Double;
begin
  Result := '';
{
  if (Sort.svsEnabled) then
  begin
    case Sort.svsFieldId of
      0: Result := JobDetl.JobActual.ActCCode;
      1: Result := JobDetl.JobActual.LineORef;
      2: Result := JobDetl.JobActual.JDate;
      3: Result := JobDetl.JobActual.AnalCode;
      4: Result := FormatFloat('0.00', JobDetl.JobActual.Qty);
      5: Result := FormatFloat('0.00', JobDetl.JobActual.Cost);
      6: Result := FormatFloat('0.00', JobDetl.JobActual.Charge);
      7: Result := FormatFloat('0.00', JobDetl.JobActual.UpliftTotal);
    else
    end;
  end;
}
  UOR := 0;
  with ExLocal^, NHCtrl, JobDetl^, JobActual do
  begin
    case Sort.svsFieldId of
         0: Result := AdjustSortStringValue(ActCCode, Sort);
         1: Result := AdjustSortStringValue(LineORef, Sort);
         2: Result := AdjustSortDateStringValue(JDate, Sort);
         3: Result := AdjustSortStringValue(AnalCode, Sort);
         4: begin // Hrs/Qty
              Dnum := Qty * DocCnst[JDDT];
              If (JDDT In SalesSplit) then
                Dnum := Dnum * DocNotCnst;
              Result := AdjustSortFloatValue(Dnum, Sort);
            end;
         5: begin // Cost
              TCr := ActCurr;
              If (JDDT In JAPSplit) then
                Dnum := (Round_Up(Cost, 2) * DocCnst[JDDT])
              else
                Dnum := (Round_Up(Qty * Cost, 2) * DocCnst[JDDT]);
              if (NHCr=0) then
              begin
                UOR  := fxUseORate(BOff, BOn, PCRates, JUseORate, ActCurr, 0);
                Dnum := Conv_TCurr(Dnum, XRate(PCRates, BOff, ActCurr), ActCurr, UOR, BOff);
                TCr  := 0;
              end;
              if (NHTxCr <> 0) then
              begin
                Dnum := Currency_Txlate(Dnum, NHCr, NHTxCr);
                TCr  := NHTxCr;
              end;
              Result := AdjustSortFloatValue(Dnum, Sort);
            end;
         6: begin // Charge
              if (JDDT = TSH) then
                TCr := CurrCharge
              else
                TCr  := LJobRec^.CurrPrice;
              Dnum   := Currency_ConvFT(Charge, CurrCharge, TCr, UseCoDayRate);
              Result := AdjustSortFloatValue(Dnum, Sort);
            end;
         7: begin // Uplift
              TCr  := ActCurr;
              Dnum := (Round_Up(Qty * UpliftTotal, 2) * DocCnst[JDDT]);
              if (NHCr = 0) then
              begin
                UOR  := fxUseORate(BOff, BOn, PCRates, JUseORate, ActCurr, 0);
                Dnum := Conv_TCurr(Dnum, XRate(PCRates, BOff, ActCurr), ActCurr, UOR, BOff);
                TCr  := 0;
              end;
              if (NHTxCr<>0) then
              begin
                Dnum := Currency_Txlate(Dnum, NHCr, NHTxCr);
                TCr  := NHTxCr;
              end;
              Result := AdjustSortFloatValue(Dnum, Sort);
            end;
         else
           Result := '';
    end; {Case..}
  end; {With..}
end;

// -----------------------------------------------------------------------------

function TJobLedgerSortView.GetSourceDataFolio: LongInt;
var
  FuncRes: Integer;
begin
  FuncRes := GetPos(F[JDetlF], JDetlF, Result);
  if (FuncRes <> 0) then
    raise Exception.Create('Failed to get record address for Job Ledger record, error ' + IntToStr(FuncRes));
end;

// -----------------------------------------------------------------------------

function TJobLedgerSortView.GetSourceDataStr: ShortString;
begin
  Result := '';
end;

// -----------------------------------------------------------------------------

function TJobLedgerSortView.GetSourceLineNo: LongInt;
begin
  Result := 0;
end;

// -----------------------------------------------------------------------------

function TJobLedgerSortView.GetSQLSortValue(
  const Sort: TSortViewSortInfoRecType): ShortString;
begin
  ReadRecord;
  Result := GetSortValue(Sort);
end;

// -----------------------------------------------------------------------------

function TJobLedgerSortView.GetSQLSourceDataFolio: LongInt;
begin
  Result := fldPositionID.Value;
end;

// -----------------------------------------------------------------------------

function TJobLedgerSortView.GetSQLSourceDataStr: ShortString;
begin
  Result := '';
end;

// -----------------------------------------------------------------------------

function TJobLedgerSortView.GetSQLSourceLineNo: LongInt;
begin
  Result := 0;
end;

// -----------------------------------------------------------------------------

function TJobLedgerSortView.GetStringFilterValue(
  const FilterFieldId: Integer): ShortString;
begin
  case FilterFieldId of
    0: Result := Inv.DocUser1;
    1: Result := Inv.DocUser2;
    2: Result := Inv.DocUser3;
    3: Result := Inv.DocUser4;
    //GS 26/10/2011 ABSEXCH-11706: update sortview to support 10 UDEFs
    4: Result := Inv.DocUser5;
    5: Result := Inv.DocUser6;
    6: Result := Inv.DocUser7;
    7: Result := Inv.DocUser8;
    8: Result := Inv.DocUser9;
    9: Result := Inv.DocUser10;
    10: Result := Id.LineUser1;
    11: Result := Id.LineUser2;
    12: Result := Id.LineUser3;
    13: Result := Id.LineUser4;
    //GS 26/10/2011 ABSEXCH-11706: update sortview to support 10 UDEFs
    14: Result := Id.LineUser5;
    15: Result := Id.LineUser6;
    16: Result := Id.LineUser7;
    17: Result := Id.LineUser8;
    18: Result := Id.LineUser9;
    19: Result := Id.LineUser10;
    20: Result := Copy(Inv.OurRef, 1, 3);
  else
    Result := ''; // Invalid field ID.
  end;
end;

// -----------------------------------------------------------------------------

procedure TJobLedgerSortView.PopulateFilterFields(List: TStrings);
begin
  List.Clear;
  List.Add('Header User Defined Field 1');  // 0
  List.Add('Header User Defined Field 2');  // 1
  List.Add('Header User Defined Field 3');  // 2
  List.Add('Header User Defined Field 4');  // 3
  //GS 26/10/2011 ABSEXCH-11706: update sortview to support 10 UDEFs
  List.Add('Header User Defined Field 5');  // 4
  List.Add('Header User Defined Field 6');  // 5
  List.Add('Header User Defined Field 7');  // 6
  List.Add('Header User Defined Field 8');  // 7
  List.Add('Header User Defined Field 9');  // 8
  List.Add('Header User Defined Field 10');  // 9
  List.Add('Line User Defined Field 1');    // 10
  List.Add('Line User Defined Field 2');    // 11
  List.Add('Line User Defined Field 3');    // 12
  List.Add('Line User Defined Field 4');    // 13
  //GS 26/10/2011 ABSEXCH-11706: update sortview to support 10 UDEFs
  List.Add('Line User Defined Field 5');    // 14
  List.Add('Line User Defined Field 6');    // 15
  List.Add('Line User Defined Field 7');    // 16
  List.Add('Line User Defined Field 8');    // 17
  List.Add('Line User Defined Field 9');    // 18
  List.Add('Line User Defined Field 10');   // 19
  List.Add('Transaction Type');             // 20
end;

// -----------------------------------------------------------------------------

procedure TJobLedgerSortView.PopulateSortFields(List: TStrings);
begin
  List.Clear;
  List.Add('Account Code');
  List.Add('Our Ref');
  List.Add('Date');
  List.Add('Analysis');
  List.Add('Hours/Qty');
  List.Add('Cost');
  List.Add('Charge');
  List.Add('Uplift');
end;

// -----------------------------------------------------------------------------

procedure TJobLedgerSortView.PrepareFields;
begin
  fldActCCode := SQLCaller.Records.FieldByName('ActCCode') as TStringField;
  fldLineORef := SQLCaller.Records.FieldByName('LineORef') as TStringField;
  fldJDate := SQLCaller.Records.FieldByName('JDate') as TStringField;
  fldAnalCode := SQLCaller.Records.FieldByName('AnalCode') as TStringField;
  fldJDDT := SQLCaller.Records.FieldByName('JDDT') as TIntegerField;
  fldQty := SQLCaller.Records.FieldByName('Qty') as TFloatField;
  fldActCurr := SQLCaller.Records.FieldByName('ActCurr') as TIntegerField;
  fldCharge := SQLCaller.Records.FieldByName('Charge') as TFloatField;
  fldCost := SQLCaller.Records.FieldByName('Cost') as TFloatField;
  fldPCRates1 := SQLCaller.Records.FieldByName('PCRates1') as TFloatField;
  fldPCRates2 := SQLCaller.Records.FieldByName('PCRates2') as TFloatField;
  fldJUseORate := SQLCaller.Records.FieldByName('JUseORate') as TIntegerField;
  fldCurrCharge := SQLCaller.Records.FieldByName('CurrCharge') as TIntegerField;
  fldCurrPrice := SQLCaller.Records.FieldByName('CurrPrice') as TIntegerField;
  fldUpliftTotal := SQLCaller.Records.FieldByName('UpliftTotal') as TFloatField;
  fldPositionID := SQLCaller.Records.FieldByName('PositionID') as TIntegerField;
end;

// -----------------------------------------------------------------------------

procedure TJobLedgerSortView.ReadRecord;
begin
  JobDetl^.JobActual.ActCCode       := fldActCCode.Value;
  JobDetl^.JobActual.LineORef       := fldLineORef.Value;
  JobDetl^.JobActual.JDate          := fldJDate.Value;
  JobDetl^.JobActual.AnalCode       := fldAnalCode.Value;
  JobDetl^.JobActual.JDDT           := DocTypes(fldJDDT.Value);
  JobDetl^.JobActual.Qty            := fldQty.Value;
  JobDetl^.JobActual.Charge         := fldCharge.Value;
  JobDetl^.JobActual.ActCurr        := fldActCurr.Value;
  JobDetl^.JobActual.Cost           := fldCost.Value;
  JobDetl^.JobActual.PCRates[False] := fldPCRates1.Value;
  JobDetl^.JobActual.PCRates[True]  := fldPCRates2.Value;
  JobDetl^.JobActual.JUseORate      := fldJUseORate.Value;
  JobDetl^.JobActual.CurrCharge     := fldCurrCharge.Value;
  ExLocal^.LJobRec.CurrPrice        := fldCurrPrice.Value;
  JobDetl^.JobActual.UpliftTotal    := fldUpliftTotal.Value;
end;

function TJobLedgerSortView.SyncFilter: Integer;
var
  KeyPath: Integer;
  Key: Str255;
begin
  Result := 0;
  Exit;
  { Locate the matching Transaction Header and Line records. }
  Key := FullNomKey(JobDetl.JobActual.LineFolio) +
         FullNomKey(JobDetl.JobActual.LineNo);
  Result := Find_Rec(B_GetEq, F[IdetailF], IdetailF, RecPtr[IdetailF]^, IdLinkK, Key);
  if (Result = 0) then
  begin
    { Locate the Header, unless we already have it. }
    if (Inv.FolioNum <> Id.FolioRef) then
    begin
      Key := FullNomKey(JobDetl.JobActual.LineFolio);
      Result := Find_Rec(B_GetEq, F[InvF], InvF, RecPtr[InvF]^, InvFolioK, Key);
    end;
  end;
end;

// -----------------------------------------------------------------------------

function TJobLedgerSortView.SyncRecord: Integer;
var
  RecAddr: LongInt;
  KeyPath: Integer;
begin
  { The Job Details file has no unique indexes, so we will have to use the
    record address instead. }
  RecAddr := SortTempRec.svtSourceDataFolio;
  KeyPath := HostListIndexNo;
  Result := Presrv_BTPos(JDetlF, KeyPath, F[JDetlF], RecAddr, True, True);
  if (Result = 0) then
    Result := SyncFilter;
end;

// -----------------------------------------------------------------------------

function TJobLedgerSortView.SyncTemp: Integer;
begin
  Result := 0; //PR: 22/03/2016 v2016 R2 ABSEXCH-17390
end;

// -----------------------------------------------------------------------------

end.
