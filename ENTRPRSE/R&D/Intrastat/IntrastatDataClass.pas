unit IntrastatDataClass;

interface

uses
  ExBtth1U;

type

  TIntrastatDirection = (idArrivals, idDispatches);

  TIntrastatReportMode = (irmAggregated, irmDetailed, irmAudit);

  IIntrastatDataClass = Interface
  ['{D29B501F-0A76-453F-A25C-DF732AC86834}']

    //General properties
    function GetPeriod : string;
    procedure SetPeriod(const Value : string);
    property isdPeriod : string read GetPeriod write SetPeriod;

    function GetStartDate : string;
    procedure SetStartDate(const Value : string);
    property isdStartDate : string read GetStartDate write SetStartDate;

    function GetEndDate : string;
    procedure SetEndDate(const Value : string);
    property isdEndDate : string read GetEndDate write SetEndDate;

    function GetReportDirection : TIntrastatDirection;
    procedure SetReportDirection(const Value : TIntrastatDirection);
    property isdReportDirection : TIntrastatDirection read GetReportDirection write SetReportDirection;

    function GetReportMode : TIntrastatReportMode;
    procedure SetReportMode(Value : TIntrastatReportMode);
    property isdReportMode : TIntrastatReportMode read GetReportMode write SetReportMode;

    function GetOutOfPeriodOnly : Boolean;
    procedure SetOutOfPeriodOnly(Value : Boolean);
    property isdOutOfPeriodOnly : Boolean read GetOutOfPeriodOnly write SetOutOfPeriodOnly;

    //Line properties
    function GetCountry : string;
    property isdCountry : string read GetCountry;

    function GetCommodityCode : string;
    property isdCommodityCode : string read GetCommodityCode;

    function GetDeliveryTerms : string;
    property isdDeliveryTerms : string read GetDeliveryTerms;

    function GetNatureOfTransaction : string;
    property isdNatureOfTransaction : string read GetNatureOfTransaction;

    function GetTransportMode : string;
    property isdTransportMode : string read GetTransportMode;

    function GetValue : Double;
    property isdValue : Double read GetValue;

    function GetWeight : Double;
    property isdWeight : Double read GetWeight;

    function GetSupplementaryUnits : Double;
    property isdSupplementaryUnits : Double read GetSupplementaryUnits;

    function GetSupplementaryUnitsString : String;
    property isdSupplementaryUnitsString : String read GetSupplementaryUnitsString;

    function GetOurRef : string;
    property isdOurRef : string read GetOurRef;

    function GetStockCode : string;
    property isdStockCode : string read GetStockCode;

    function GetProcess : string;
    property isdProcess : string read GetProcess;

    function GetAggregated : Boolean;
    property isdAggregated : Boolean read GetAggregated;

    function GetOutOfPeriod : Boolean;
    property isdOutOfPeriod : Boolean read GetOutOfPeriod;

    function GetExLocal : TdPostExLocalPtr;
    procedure SetExLocal(const Value : TdPostExLocalPtr);
    property isdExLocal : TdPostExLocalPtr read GetExLocal write SetExLocal;

    function GetLineNumber : Integer;
    property isdLineNumber : Integer read GetLineNumber;

    function GetCount : Integer;
    property isdCount : Integer read GetCount;

    //Totals
    function GetTotalLessCreditNotes : Double;
    property isdTotalLessCreditNotes : Double read GetTotalLessCreditNotes;

    function GetTotalCreditNotes : Double;
    property isdTotalCreditNotes : Double read GetTotalCreditNotes;

    function GetTotalWeight : Double;
    property isdTotalWeight : Double read GetTotalWeight;

    function GetTotalSupplementaryUnits : Double;
    property isdTotalSupplementaryUnits : Double read GetTotalSupplementaryUnits;


    //functions
    function LoadData : Integer;
    function GetFirst : Integer;
    function GetNext : Integer;

  end;

  function GetIntrastatDataObject : IIntrastatDataClass;
  procedure TestIntrastat;

const
  DirectionChar : Array[idArrivals..idDispatches] of Char = ('A', 'D');
  DirectionString : Array[idArrivals..idDispatches] of string = ('Arrivals','Dispatches');


implementation

uses
  Classes, SQLCallerU, ADOConnect, DB, VarConst, StrUtils, SQLUtils, SysUtils, GlobVar, BtrvU2, BtKeys1U,
  ComnU2, StrUtil, VarRec2U, EtMiscU, CurrncyU, oSystemSetup, ComnUnit, CountryCodes, CountryCodeUtils;

const
  AGGREGATE_LENGTH = 17; //First 17 chars of sort string contain the fields on which the report is aggregated

type

  //Object containing the report details for one line
  TIntrastatReportLine = Class
    Country : String[2];
    CommodityCode : string[8];
    DeliveryTerms : string[3];
    NatureofTransaction : string[2];
    TransportMode : Byte;
    Value : Double;
    Weight : Double;
    SuppUnitsValue : Double;
    SuppUnitsString : String[10];
    OurRef : String[10];
    StockCode : String[16];
    Process : string[1];
    Aggregated : Boolean;
    OutOfPeriod : Boolean;
    FolioNumber : longint;
    LineNumber : longint;
    procedure Assign(const ALine : TIntrastatReportLine);
  end;

  //TStringList descendant - the objects are the report line details and the strings contain the sort key.
  {$WARNINGS OFF}
  TIntrastatReportLineList = Class(TStringList)
  protected
    function  GetObject(Index: Integer): TIntrastatReportLine;
    procedure PutObject(Index: Integer; Item: TIntrastatReportLine);
  public
    property  Objects[Index: Integer]: TIntrastatReportLine read GetObject write PutObject; default;
  end;
  {$WARNINGS ON}
  //Base data class - never implemented. Specific descendants implement Pervasive and MS_SQL variants
  TBaseIntrastatDataClass = Class(TInterfacedObject, IIntrastatDataClass)
  protected
    FExLocal : TdPostExLocalPtr;
    FCurrentLine : Integer;

    //Main list for lines
    FLineList : TIntrastatReportLineList;

    //List for aggregated lines, once everything is loaded it will be added to or replace the main list
    FAggregatedList : TIntrastatReportLineList;

    //List of commodity codes for out of period transactions
    FOutOfPeriodList : TStringList;

    FPeriod : string;
    FStartDate : string;
    FEndDate : string;
    FReportMode : TIntrastatReportMode;
    FOutOfPeriodOnly : Boolean;
    FReportDirection : TIntrastatDirection;

    FCurrency : Integer;
    FOriginalRates : CurrTypes;
    FVATRates : CurrTypes;
    FUseORate : Integer;

    FIncludeTransportMode : Boolean;
    FIncludeDeliveryTerms : Boolean;


    TotalDeliveryCharge : Double;
    TotalStockLines : Integer;

    FTotalLessCreditNotes : Double;
    FTotalCreditNotes : Double;
    FTotalWeight : Double;
    FTotalSupplementaryUnits : Double;


    // Called after all the lines of a transaction have been loaded into FLineList.
    // Adds any freight values, plus updates the aggregated list
    procedure FinaliseTransaction(FolioRef: LongInt; ItemCount: Integer;
                                DeliveryCharge: Double; const AList : TStringList);

    //General properties
    function GetPeriod : string;
    procedure SetPeriod(const Value : string);

    function GetStartDate : string;
    procedure SetStartDate(const Value : string);

    function GetEndDate : string;
    procedure SetEndDate(const Value : string);

    function GetReportDirection : TIntrastatDirection;
    procedure SetReportDirection(const Value : TIntrastatDirection);

    function GetReportMode : TIntrastatReportMode;
    procedure SetReportMode(Value : TIntrastatReportMode);

    function GetOutOfPeriodOnly : Boolean;
    procedure SetOutOfPeriodOnly(Value : Boolean);

    function GetLineNumber : Integer;
    function GetCount : Integer;

    function GetExLocal : TdPostExLocalPtr;
    procedure SetExLocal(const Value : TdPostExLocalPtr);

    //Line properties
    function GetCountry : string;
    function GetCommodityCode : string;
    function GetDeliveryTerms : string;

    function GetNatureOfTransaction : string;
    function GetTransportMode : string;
    function GetValue : Double;
    function GetWeight : Double;
    function GetSupplementaryUnits : Double;
    function GetSupplementaryUnitsString : String;

    function GetOurRef : string;

    function GetStockCode : string;
    function GetProcess : string;
    function GetOutOfPeriod : Boolean;

    function GetTotalLessCreditNotes : Double;
    function GetTotalCreditNotes : Double;
    function GetTotalWeight : Double;
    function GetTotalSupplementaryUnits : Double;

    function GetAggregated : Boolean;


    //'Local' functions
    function LoadData : Integer; virtual;
    function GetFirst : Integer;
    function GetNext : Integer;
    function TraderType : string; virtual;
    function IncludeTransaction : Boolean; virtual;
    function IncludeLine : Boolean; virtual;
    function GetSortString(const LineRec : TIntrastatReportLine) : string;
    function DoGetLineValue(Idr : IDetail) : Double;
    procedure UpdateAggregated(SortString : string; LineRec : TIntrastatReportLine);
    function LinePassesFilter : Boolean;
    procedure UpdateTotals(const ALine : TIntrastatReportLine);

    //PR: 28/01/2016 ABSEXCH-17214 v2016 R1 Function to onvert ISO country to intrastat country
    function IntrastatCountry(const ACountry : string) : string;

  public
    constructor Create;
    destructor Destroy; override;
    function IsSalesReport : Boolean;
  end;

  //MS-SQL descendant
  TSQLIntrastatDataClass = Class(TBaseIntrastatDataClass)
  protected
    FSQLData : TSQLCaller;

    fldOurRef,
    fldDeliveryTerms,
    fldProcess,

    fldDiscFlag,
    fldDiscount2Chr,
    fldDiscount3Chr,

    fldStockCode,
    fldPayment,
    fldNatureOfTransaction,
    fldSSDUnitDesc,

    fldCountry,
    fldSSDCountry,
    fldCommodityCode : TStringField;

    fldVATCompanyRate,
    fldVATDailyRate,
    fldOriginalCompanyRate,
    fldOriginalDailyRate,

    fldNetValue,
    fldQty,
    fldQtyMul,
    fldPriceMultiplier,
    fldQtyPack,
    fldDiscount,
    fldDiscount2,
    fldDiscount3,
    fldPriceMulx,
    fldSSDStockUnits,
    fldWeight : TFloatField;

    fldIdDocHed,
    fldTransportMode,
    fldUseOriginalRates,
    fldCurrency,
    fldDocLTLink,
    fldFolioNumber : TIntegerField;


    fldUsePack,
    fldPrxPack,
    fldShowCase,
    fldOutOfPeriod : TBooleanField;

    function  FillDetailRecord : IDetail;
    procedure AssignFields;
    function LoadData : Integer; override;
    function GetLineValue : Double;
  public
    constructor Create;
    destructor Destroy; override;
  end;

  //Pervasive descendant
  TPervasiveIntrastatDataClass = Class(TBaseIntrastatDataClass)
  protected
    function AddLine : Integer;
    procedure LoadStockRecord;
    function LoadData : Integer; override;
    function GetLineValue : Double; virtual;
  public
    constructor Create;
    destructor Destroy; override;
  end;

//Return interface implemented by the correct type of object
function GetIntrastatDataObject : IIntrastatDataClass;
begin
  if SQLUtils.UsingSQL then
    Result := TSQLIntrastatDataClass.Create
  else
    Result := TPervasiveIntrastatDataClass.Create;
end;

{ TIntrastatReportLineList }
{$WARNINGS OFF}
function TIntrastatReportLineList.GetObject(
  Index: Integer): TIntrastatReportLine;
begin
  Result := TIntrastatReportLine(inherited GetObject(Index));
end;

procedure TIntrastatReportLineList.PutObject(Index: Integer;
  Item: TIntrastatReportLine);
begin
  Inherited PutObject(Index, Pointer(Item));
end;
{$WARNINGS ON}
{ TBaseIntrastatDataClass }

constructor TBaseIntrastatDataClass.Create;
begin
  inherited Create;

  FLineList := TIntrastatReportLineList.Create;
  FLineList.Sorted := False;
  FLineList.Duplicates := dupAccept;

  FAggregatedList := TIntrastatReportLineList.Create;
  FAggregatedList.Sorted := False;

  FOutOfPeriodList := TStringList.Create;
  FOutOfPeriodList.Sorted := True;
  FOutOfPeriodList.Duplicates := dupIgnore;

  FIncludeTransportMode := SystemSetup.Intrastat.isShowModeOfTransport;
  FIncludeDeliveryTerms := SystemSetup.Intrastat.isShowDeliveryTerms;

  FCurrentLine := 0;
end;

destructor TBaseIntrastatDataClass.Destroy;
var
  i : integer;
begin
  if Assigned(FLineList) then
  begin
    for i := 0 to FLineList.Count - 1 do
      if Assigned(FLineList.Objects[i]) then
        FLineList.Objects[i].Free;

    FreeAndNil(FLineList);
  end;

  if Assigned(FAggregatedList) then
    FreeAndNil(FAggregatedList);

  if Assigned(FOutOfPeriodList) then
    FreeAndNil(FOutOfPeriodList);

  inherited Destroy;
end;


function TBaseIntrastatDataClass.GetPeriod: string;
begin
  Result := FPeriod;
end;

procedure TBaseIntrastatDataClass.SetPeriod(const Value: string);
begin
  FPeriod := Value;
end;

function TBaseIntrastatDataClass.GetStartDate : string;
begin
  Result := FStartDate;
end;

procedure TBaseIntrastatDataClass.SetStartDate(const Value : string);
begin
  FStartDate := Value;
end;


function TBaseIntrastatDataClass.GetEndDate : string;
begin
  Result := FEndDate;
end;

procedure TBaseIntrastatDataClass.SetEndDate(const Value : string);
begin
  FEndDate := Value;
end;


function TBaseIntrastatDataClass.GetReportMode : TIntrastatReportMode;
begin
  Result := FReportMode;
end;

procedure TBaseIntrastatDataClass.SetReportMode(Value : TIntrastatReportMode);
begin
  FReportMode := Value;
end;


function TBaseIntrastatDataClass.GetOutOfPeriodOnly : Boolean;
begin
  Result := FOutOfPeriodOnly;
end;

procedure TBaseIntrastatDataClass.SetOutOfPeriodOnly(Value : Boolean);
begin
  FOutOfPeriodOnly := Value;
end;


//Line properties
function TBaseIntrastatDataClass.GetCountry : string;
begin
  Result := FLineList[FCurrentLine].Country;
end;

function TBaseIntrastatDataClass.GetCommodityCode : string;
begin
  Result := FLineList[FCurrentLine].CommodityCode
end;

function TBaseIntrastatDataClass.GetDeliveryTerms : string;
begin
  Result := FLineList[FCurrentLine].DeliveryTerms
end;


function TBaseIntrastatDataClass.GetNatureOfTransaction : string;
begin
  Result := FLineList[FCurrentLine].NatureOfTransaction
end;

function TBaseIntrastatDataClass.GetTransportMode : string;
begin
  Result := IntToStr(FLineList[FCurrentLine].TransportMode);
end;

function TBaseIntrastatDataClass.GetValue : Double;
begin
  Result := FLineList[FCurrentLine].Value
end;

function TBaseIntrastatDataClass.GetWeight : Double;
begin
  Result := FLineList[FCurrentLine].Weight
end;

function TBaseIntrastatDataClass.GetSupplementaryUnits : Double;
begin
  Result := FLineList[FCurrentLine].SuppUnitsValue
end;

function TBaseIntrastatDataClass.GetSupplementaryUnitsString : String;
begin
  Result := FLineList[FCurrentLine].SuppUnitsString
end;


function TBaseIntrastatDataClass.GetOurRef : string;
begin
  Result := FLineList[FCurrentLine].OurRef
end;


function TBaseIntrastatDataClass.GetStockCode : string;
begin
  Result := FLineList[FCurrentLine].StockCode;
end;

//functions
function TBaseIntrastatDataClass.GetFirst : Integer;
begin
  if FLineList.Count > 0 then
  begin
    FCurrentLine := 0;
    while (FCurrentLine < FLineList.Count) and not LinePassesFilter do
      inc(FCurrentLine);

     if FCurrentLine < FLineList.Count then
       Result := 0
     else
       Result := 9;
  end
  else
    Result := 9;
end;

function TBaseIntrastatDataClass.GetNext : Integer;
begin
  Inc(FCurrentLine);
  while (FCurrentLine < FLineList.Count) and not LinePassesFilter do
    inc(FCurrentLine);

  if FCurrentLine < FLineList.Count then
    Result := 0
  else
    Result := 9;
end;

function TBaseIntrastatDataClass.GetReportDirection: TIntrastatDirection;
begin
  Result := FReportDirection;
end;

procedure TBaseIntrastatDataClass.SetReportDirection(const Value : TIntrastatDirection);
begin
  FReportDirection := Value;
end;

function TBaseIntrastatDataClass.IsSalesReport: Boolean;
begin
  Result := FReportDirection = idDispatches;
end;

function TBaseIntrastatDataClass.GetExLocal: TdPostExLocalPtr;
begin
  Result := FExLocal;
end;

procedure TBaseIntrastatDataClass.SetExLocal(const Value: TdPostExLocalPtr);
begin
  FExLocal := Value;
end;

function TBaseIntrastatDataClass.TraderType: string;
begin
  If IsSalesReport then
    Result := 'C'
  else
    Result := 'S';
end;

function TBaseIntrastatDataClass.IncludeTransaction: Boolean;
begin
  with FExLocal.LInv do
  begin
    Result := ((RunNo > 0) or (RunNo = -10)) and
              (SSDProcess <> 'P') and
              not (InvDocHed in [SQU, PQU, SRC, PPY, SOR, POR, SDN, PDN]);

  end;
end;

function TBaseIntrastatDataClass.IncludeLine: Boolean;
begin
  with FExLocal.LId do
  begin
    Result := ((Trim(StockCode) <> '') or (DocLTLink = 3)) and
              (LineNo > 0) and
              not ECService and
              (VATCode = DirectionChar[FReportDirection]) and
              //PR: 25/01/2016 ABSEXCH-17197 Add check for blank commodity code
              ((DocLTLink = 3) or (Trim(IfThen(SSDUseLine, SSDCommod, FExLocal.LStock.CommodCode)) <> ''));
  end;
end;

function TBaseIntrastatDataClass.GetSortString(
  const LineRec: TIntrastatReportLine): string;

  function PadLeft(Value : Integer) : string;
  begin
    Result := IntToStr(Value);

    if Length(Result) = 1 then
      Result := '0' + Result;
  end;
begin
  with LineRec do
  begin
    Result := Country + CommodityCode + DeliveryTerms + NatureOfTransaction;

    if FIncludeTransportMode then
      Result := Result + PadLeft(TransportMode);

    if FReportMode = irmAudit then
      Result := Result + OurRef + StockCode
    else
    if FReportMode = irmDetailed then
      Result := Result + OurRef;

  end;
end;

//Add freight charges if any plus update aggregated list
procedure TBaseIntrastatDataClass.FinaliseTransaction(FolioRef,
  ItemCount: Integer; DeliveryCharge: Double; const AList : TStringList);
var
  i : integer;
  LinePos : Integer;
  Count: Integer;
  Value: Double;
  ThisValue : Double;
begin
  Count := ItemCount;
  Value := DeliveryCharge;
  for i := 0 to AList.Count - 1 do
  begin
    LinePos := StrToInt(AList[i]);

    if (Count > 0) and (Value > 0) then
    begin
      ThisValue := Value / Count;
      // Decrement the remaining Delivery Charge and Item Count
      Value := Value - ThisValue;
      Count := Count - 1;
    end
    else
      ThisValue := 0;

    ThisValue := ThisValue + FLineList[LinePos].Value;

    FLineList.Objects[LinePos].Value := ForceNearestWhole(Conv_VATCurr(ThisValue,FVATRates[UseCoDayRate],
                                     XRate(FOriginalRates,BOff,FCurrency),FCurrency,FUseORate),2);

    if FReportMode <> irmDetailed then
      UpdateAggregated(Copy(FLineList.Strings[LinePos], 1, AGGREGATE_LENGTH), FLineList.Objects[LinePos]);

    UpdateTotals(FLineList.Objects[LinePos]);
  end;

  if FReportMode = irmAggregated then //We don't need the detailed list, so clear it now to save memory
  begin
    while FLineList.Count > 0 do
    begin
      FLineList.Objects[0].Free;
      FLineList.Delete(0);
    end;
  end;
end;


function TBaseIntrastatDataClass.DoGetLineValue(Idr: IDetail): Double;
begin
  Result := DetLTotal(Idr,BOn,BOff,0.0)*LineCnst(Idr.Payment);
end;


procedure TBaseIntrastatDataClass.UpdateAggregated(
  SortString: string; LineRec: TIntrastatReportLine);
var
  LocalLineRec : TIntrastatReportLine;
  LinePos : Integer;
begin
  LinePos := FAggregatedList.IndexOf(SortString);
  if LinePos = -1 then
  begin
    //Aggregated record doesn't exist so add it into Aggregated list
    LocalLineRec := TIntrastatReportLine.Create;
    LocalLineRec.Assign(LineRec);

    //Blank out OurRef, stock code, etc  as not relevant
    LocalLineRec.OurRef := '';
    LocalLineRec.StockCode := '';
    LocalLineRec.Process := '';
//    LocalLineRec.SuppUnitsString := '';
    LocalLineRec.Aggregated := True;
    LocalLineRec.OutOfPeriod := False;
    FAggregatedList.AddObject(SortString, LocalLineRec);
  end
  else
  begin
    //Aggregated record already exists so update from line record
    FAggregatedList.Objects[LinePos].Value := FAggregatedList.Objects[LinePos].Value + LineRec.Value;
    FAggregatedList.Objects[LinePos].Weight := FAggregatedList.Objects[LinePos].Weight + LineRec.Weight;
    FAggregatedList.Objects[LinePos].SuppUnitsValue := FAggregatedList.Objects[LinePos].SuppUnitsValue +
                                                         LineRec.SuppUnitsValue;
  end;
end;

function TBaseIntrastatDataClass.LoadData: Integer;
var
  i : integer;
  LineNo : Integer;
begin
  if FReportMode = irmAggregated then
  begin
    FLineList := FAggregatedList;
    FAggregatedList := nil;
  end
  else
  if FReportMode = irmAudit then
  begin
   //If we're auditing, then we need detail and aggregate, so add char at end of string to position it after
    //the detailed strings for this group
    for i := 0 to FAggregatedList.Count -1 do
      FAggregatedList.Strings[i] := FAggregatedList.Strings[i] + 'z';

    FLineList.AddStrings(FAggregatedList);
    FreeAndNil(FAggregatedList);
  end;

  FLineList.Sort;

  //PR: 25/01/2016 ABSEXCH-17198 v2016 R1 Set line numbers on objects
  LineNo := 1;

  //PR: 02/02/2016 v2016 R1 ABSEXCH-17238
  // Reset totals as we're going to recalculate them to include only OutOfPeriod commodity codes
  if FOutOfPeriodOnly then
  begin
    FTotalLessCreditNotes := 0.0;
    FTotalCreditNotes := 0.0;
    FTotalWeight := 0.0;
    FTotalSupplementaryUnits := 0.0;
  end;

  for i := 0 to FLineList.Count - 1 do
  begin
    //PR: 02/02/2016 v2016 R1 ABSEXCH-17238 if Out of Period only then only put line numbers on
    //lines with commodity code in oop list
    if (not FOutOfPeriodOnly or (FOutOfPeriodList.IndexOf(FLineList[i].CommodityCode) >= 0))
         and (not FLineList.Objects[i].Aggregated or (FReportMode <> irmAudit)) then
    begin
      FLineList.Objects[i].LineNumber := LineNo;
      inc(LineNo);

      //PR: 02/02/2016 v2016 R1 ABSEXCH-17238 Update totals here
      if FOutOfPeriodOnly then
        UpdateTotals(FLineList.Objects[i]);
    end
    else
      FLineList.Objects[i].LineNumber := 0;

  end;

  Result := FLineList.Count;
end;

//Filter function for criteria which can only be determined once all the data has been loaded
function TBaseIntrastatDataClass.LinePassesFilter: Boolean;
begin
  Result := True;
  if FOutOfPeriodOnly then //Check if this commodity code is in the out of period list
    Result := FOutOfPeriodList.IndexOf(GetCommodityCode) >= 0;
end;

function TBaseIntrastatDataClass.GetAggregated: Boolean;
begin
  Result := FLineList[FCurrentLine].Aggregated;
end;

function TBaseIntrastatDataClass.GetLineNumber: Integer;
begin
  //PR: 25/01/2016 ABSEXCH-17198 v2016 R1 Change to use LineNumber property from object
  Result :=  FLineList[FCurrentLine].LineNumber;
end;

function TBaseIntrastatDataClass.GetProcess: string;
begin
  Result := FLineList[FCurrentLine].Process;
end;

function TBaseIntrastatDataClass.GetCount: Integer;
begin
  Result := FLineList.Count;
end;

function TBaseIntrastatDataClass.GetTotalCreditNotes: Double;
begin
  Result := FTotalCreditNotes;
end;

function TBaseIntrastatDataClass.GetTotalLessCreditNotes: Double;
begin
  Result := FTotalLessCreditNotes;
end;

procedure TBaseIntrastatDataClass.UpdateTotals(
  const ALine: TIntrastatReportLine);
begin
  if (Length(ALine.NatureOfTransaction) > 1) and (ALine.NatureOfTransaction[2] = '6' ) then
    FTotalCreditNotes := FTotalCreditNotes + ALine.Value
  else
    FTotalLessCreditNotes := FTotalLessCreditNotes + ALine.Value;

  FTotalWeight := FTotalWeight + ALine.Weight;
  FTotalSupplementaryUnits := FTotalSupplementaryUnits + ALine.SuppUnitsValue;
end;

function TBaseIntrastatDataClass.GetTotalSupplementaryUnits: Double;
begin
  Result := FTotalSupplementaryUnits;
end;

function TBaseIntrastatDataClass.GetTotalWeight: Double;
begin
  Result := FTotalWeight;
end;

function TBaseIntrastatDataClass.GetOutOfPeriod: Boolean;
begin
  Result := FLineList[FCurrentLine].OutOfPeriod;
end;

function TBaseIntrastatDataClass.IntrastatCountry(
  const ACountry: string): string;
begin
  //PR: 28/01/2016 ABSEXCH-17214 v2016 R1 Convert ISO country to intrastat country
  Result := IntrastatCountryCode(ifCountry2, ACountry);
  if Result = '' then
    Result := ACountry;
end;

{ TSQLIntrastatDataClass }

procedure TSQLIntrastatDataClass.AssignFields;
begin
  with FSQLData.Records do
  begin
    //String Fields
    fldOurRef := FieldByName('thOurRef') as TStringField;
    fldDeliveryTerms := FieldByName('thDeliveryTerms') as TStringField;
    fldProcess := FieldByName('thProcess') as TStringField;

    fldDiscFlag := FieldByName('tlDiscFlag') as TStringField;
    fldDiscount2Chr := FieldByName('tlDiscount2Chr') as TStringField;
    fldDiscount3Chr := FieldByName('tlDiscount2Chr') as TStringField;
    fldSSDCountry := FieldByName('tlSSDCountry') as TStringField;

    fldStockCode := FieldByName('stCode') as TStringField;

    fldCountry := FieldByName('Country') as TStringField;
    fldCommodityCode := FieldByName('CommodityCode') as TStringField;
    fldPayment := FieldByName('tlPaymentCode') as TStringField;
    fldNatureOfTransaction := FieldByName('NatureOfTransaction') as TStringField;
    fldSSDUnitDesc := FieldByName('stSSDUnitDesc') as TStringField;

    //Float Fields
    fldVATCompanyRate := FieldByName('thVATCompanyRate') as TFloatField;
    fldVATDailyRate := FieldByName('thVATDailyRate') as TFloatField;
    fldOriginalCompanyRate := FieldByName('thOriginalCompanyRate') as TFloatField;
    fldOriginalDailyRate  := FieldByName('thOriginalCompanyRate') as TFloatField;
    fldPriceMulx := FieldByName('tlPriceMultiplier') as TFloatField;

    fldNetValue := FieldByName('tlNetValue') as TFloatField;
    fldQty := FieldByName('tlQty') as TFloatField;
    fldQtyMul := FieldByName('tlQtyMul') as TFloatField;
    fldPriceMultiplier := FieldByName('tlPriceMultiplier') as TFloatField;
    fldQtyPack := FieldByName('tlQtyPack') as TFloatField;
    fldDiscount := FieldByName('tlDiscount') as TFloatField;
    fldDiscount2 := FieldByName('tlDiscount2') as TFloatField;
    fldDiscount3 := FieldByName('tlDiscount3') as TFloatField;

    //PR: 07/03/2016 ABSEXCH-17354
    fldSSDStockUnits := FieldByName('StockUnits') as TFloatField;
    fldWeight := FieldByName('LWeight') as TFloatField;

    //Integer fields
    fldIdDocHed := FieldByName('tlDocType') as TIntegerField;
    fldCurrency := FieldByName('thCurrency') as TIntegerField;
    fldDocLTLink := FieldByName('tlDocLTLink') as TIntegerField;
    fldFolioNumber := FieldByName('thFolioNum') as TIntegerField;
    fldTransportMode := FieldByName('thTransportMode') as TIntegerField;
    fldUseOriginalRates := FieldByName('thUseOriginalRates') as TIntegerField;

    //Boolean fields
    fldUsePack := FieldByName('tlUsePack') as TBooleanField;
    fldPrxPack := FieldByName('tlPrxPack') as TBooleanField;
    fldShowCase := FieldByName('tlShowCase') as TBooleanField;
    fldOutOfPeriod := FieldByName('thIntrastatOutOfPeriod') as TBooleanField;

  end;
end;

constructor TSQLIntrastatDataClass.Create;
begin
  inherited;
  FSQLData := TSQLCaller.Create(GlobalADOConnection);
end;

destructor TSQLIntrastatDataClass.Destroy;
begin
  if Assigned(FSQLData) then
    FSQLData.Free;
  inherited;
end;
//Fills Id record with fields required for DetLTotal function
function TSQLIntrastatDataClass.FillDetailRecord : IDetail;
  function GetChar(const s : string) : char;
  begin
    if Length(s) > 0 then
      Result := s[1]
    else
      Result := #0;
  end;
begin
  FillChar(Result, SizeOf(Result), 0);

  with Result do
  begin
    DiscountChr := GetChar(fldDiscFlag.Value);
    Discount2Chr := GetChar(fldDiscount2Chr.Value);
    Discount3Chr := GetChar(fldDiscount3Chr.Value);


    Discount := fldDiscount.Value;
    Discount2 := fldDiscount2.Value;
    Discount3 := fldDiscount3.Value;

    Payment := GetChar(fldPayment.Value);

    NetValue := fldNetValue.Value;
    Qty := fldQty.Value;
    QtyMul := fldQtyMul.Value;

    UseORate := fldUseOriginalRates.Value;
    UsePack := fldUsePack.Value;
    PrxPack := fldPrxPack.Value;
    ShowCase := fldShowCase.Value;
    PriceMulX := fldPriceMulx.Value;

    IdDocHed := Doctypes(fldIdDocHed.Value);

  end;
end;

function TSQLIntrastatDataClass.GetLineValue: Double;
var
  Idr : IDetail;
begin
  //Fill Id record with fields DetLTotal function needs 
  Idr := FillDetailRecord;

  Result := DoGetLineValue(Idr);
end;

//Uses SQL query to populate record set, then iterate through records and add to list
function TSQLIntrastatDataClass.LoadData: Integer;
var
  SQLQuery : AnsiString;
  Res : Integer;
  LineRec : TIntrastatReportLine;
  SortString : string;
  ThisTrans : string;
  LineValue : Double;
  i : Integer;
  IndexList : TStringList;

  procedure SetTransValues;
  begin
    ThisTrans := fldOurRef.Value;

    FCurrency := fldCurrency.Value;
    FUseORate := fldUseOriginalRates.Value;
    FVATRates[False] := fldVATCompanyRate.Value;
    FVATRates[True]  := fldVATDailyRate.Value;
    FOriginalRates[False] := fldOriginalCompanyRate.Value;
    FOriginalRates[True]  := fldOriginalDailyRate.Value;
  end;
begin
  SQLQuery := Format('SELECT ' +

                      'thOurRef, thDeliveryTerms, thCurrency, thTransportMode, thProcess, ' +
                      'thVATCompanyRate, thVATDailyRate, thOriginalCompanyRate, thOriginalDailyRate, thFolioNum, ' +
                      'thUseOriginalRates, thIntrastatOutOfPeriod, ' +

                      'tlNetValue, tlQty, tlQtyMul, tlDocLTLink, tlUsePack, tlSSDCountry, tlPriceMultiplier, ' +
                      'tlPrxPack, tlQtyPack, tlShowCase, tlDiscount, tlDiscFlag, tlDocType, ' +
                      'tlDiscount2, tlDiscount2Chr, tlDiscount3, tlDiscount3Chr, tlPaymentCode, ' +

                      'stCode, stSSDUnitDesc, ' +

                      //PR: 07/03/2016 ABSEXCH-17354 Wasn't taking units and weight from line when required
                      'CASE tlSSDUseLineValues ' +
                      '  WHEN 1 THEN tlSSDSalesUnit ' +
                      '  WHEN 0 THEN stSSDStockUnits ' +
                      'END StockUnits, ' +

                      'CASE tlSSDUseLineValues ' +
                      '  WHEN 1 THEN tlUnitWeight ' +
                      '  WHEN 0 THEN %s  ' +
                      'END  LWeight, ' +

                      'CASE  ' +
                      '  WHEN (thDeliveryCountry <> '''' AND thCustSupp = ''C'') THEN thDeliveryCountry ' +
                      '  WHEN acCountry <> '''' THEN acCountry ' +
                      'END Country, ' +

                      'CASE   ' +
                      '  WHEN tlIntrastatNoTC = '''' THEN Cast(thTransportNature as VarChar(2)) ' +
                      '  WHEN tlIntrastatNoTC <> '''' THEN tlIntrastatNoTC ' +
                      'END NatureOfTransaction, ' +


                      'CASE tlSSDUseLineValues ' +
                      '  WHEN 1 THEN tlSSDCommodCode ' +
                      '  WHEN 0 THEN stSSDCommodityCode ' +
                      'END CommodityCode ' +

                     'FROM [COMPANY].DETAILS ' +
                     'INNER JOIN [COMPANY].DOCUMENT on tlFolioNum = thFolioNum ' +
                     'INNER JOIN [COMPANY].CUSTSUPP on thAcCode = acCode ' +
                     'INNER JOIN [COMPANY].STOCK on tlStockCodeTrans1 = stCode ' +

                     'WHERE thTransDate >= ''%s'' AND thTransDate <= ''%s'' ' +
                     //PR: 25/01/2016 ABSEXCH-17197 Add check for blank commodity code
                     'AND ((tlSSDUseLineValues = 0 AND stSSDCommodityCode <> '''') ' +
                            'OR (tlSSDUseLineValues = 1 AND tlSSDCommodCode <> '''') ' +
                            'OR (tlDocLTLink = 3)) ' +
                     'AND (thRunNo > 0 OR thRunNo = -10) AND thProcess <> ''P'' ' +
                     'AND acCustSupp = ''%s'' AND acECMember = 1 ' +
                     'and tlLineNo > 0 AND tlVATCode = ''%s'' AND tlECService = 0 ' +
                     'AND (tlStockCode <> '''' OR tlDocLTLink = 3) ' +
                     'ORDER BY thOurRef ',
                     [IfThen(IsSalesReport, 'stSSDSalesUnitWeight', 'stSSDPurchaseUnitWeight'),
                      FStartDate, FEndDate,
                      TradeCode[IsSalesReport],
                      DirectionChar[FReportDirection]]);

  FSQLData.Select(SQLQuery, GetCompanyCode(SetDrive));

  //If we have records then add to list
  if FSQLData.Records.RecordCount > 0 then
  begin
    AssignFields;

    TotalDeliveryCharge := 0;
    TotalStockLines := 0;

    //Index list is a list of the positions in the main list of the current transactions lines.
    IndexList := TStringList.Create;

    Try
      FSQLData.Records.First;

      SetTransValues;

      //PR: 28/01/2016 ABSEXCH-17206 v2016 R1 Changed to use two loops as was getting confused at end of data

      while not FSQLData.Records.EOF do
      begin

        while (ThisTrans = fldOurRef.Value) and not FSQLData.Records.EOF do
        begin
          if fldDocLTLink.Value = 3 then
          begin
            //Delivery charge line - gets apportioned to value lines on transaction
            LineValue := GetLineValue;

            TotalDeliveryCharge := TotalDeliveryCharge + LineValue;

          end
          else
          begin
            inc(TotalStockLines);

            LineRec := TIntrastatReportLine.Create;
            LineRec.Aggregated := False;

            with LineRec do
            begin
              Country := fldSSDCountry.Value;
              if Trim(Country) = '' then
                Country := fldCountry.Value;

              //PR: 28/01/2016 ABSEXCH-17214 v2016 R1 Use Intrastat Country
              Country := IntrastatCountry(Country);
              // MH 31/05/2016 2016-R2 ABSEXCH-17488: Added support for 10 character TARIC Codes
              CommodityCode := Copy(fldCommodityCode.Value, 1, 8);
              DeliveryTerms := IfThen(FIncludeDeliveryTerms, fldDeliveryTerms.Value, '');
              NatureofTransaction := fldNatureOfTransaction.Value;
              TransportMode := fldTransportMode.Value;
              Value         := GetLineValue;
              Weight        := fldWeight.Value;
              SuppUnitsValue := fldSSDStockUnits.Value;
              SuppUnitsString := fldSSDUnitDesc.Value;
              OurRef := fldOurRef.Value;

              StockCode := fldStockCode.Value;

              Process := fldProcess.Value;
              FolioNumber := fldFolioNumber.Value;
              OutOfPeriod := fldOutOfPeriod.Value;

              Weight := ForceNearestWhole(Calc_IdQty(fldQty.Value, fldQtyMul.Value, fldUsePack.Value) * Weight, 2);

              //PR: 04/02/2016 v2016 R1 ABSEXCH-17245 Round supp units up or down to nearest whole
              SuppUnitsValue := Round_Up(DivWChk((fldQty.Value * fldQtyMul.Value), SuppUnitsValue), 0);
              // 0 not allowed, so set to 1
              if SuppUnitsValue = 0 then
                SuppUnitsValue := 1;

            end;

            SortString := GetSortString(LineRec);

            //Add to list
            i := FLineList.AddObject(SortString, LineRec);
            IndexList.Add(IntToStr(i));


            if LineRec.OutOfPeriod then //add to list of OOP commodity codes
              FOutOfPeriodList.Add(LineRec.CommodityCode);

          end;

          FSQLData.Records.Next;

        end; // while ThisTrans = fldOurRef.Value

        //End of this transaction so apportion delivery charges, if any, and convert value to base
        FinaliseTransaction(fldFolioNumber.Value, TotalStockLines, TotalDeliveryCharge, IndexList);

        //Reset counters
        SetTransValues; //Set currency, rates, etc. to new transaction.

        TotalDeliveryCharge := 0;
        TotalStockLines := 0;
        IndexList.Clear;

      end;
    Finally
      IndexList.Free;
    End;
  end; //if FSQLData.Records.RecordCount > 0
  Result := inherited LoadData;
end;

{ TPervasiveIntrastatDataClass }

function TPervasiveIntrastatDataClass.AddLine : Integer;
var
  LineRec : TIntrastatReportLine;
  LineValue : Double;
  SortString : string;
begin
  Result := -1;
  if FExLocal.LId.DocLTLink = 3 then
  begin
    LineValue := (DetLTotal(FExLocal.LId,BOn,BOff,0.0)) * LineCnst(FExLocal.LId.Payment);

    TotalDeliveryCharge := TotalDeliveryCharge + LineValue;
  end
  else
  begin
    inc(TotalStockLines);

    LineRec := TIntrastatReportLine.Create;
    LineRec.Aggregated := False;

    with FExLocal^ do
    begin
      if FReportDirection = idArrivals then //Take from Line, else Supplier Country
        LineRec.Country := StrUtil.GetFirstPopulatedString([LId.SSDCountry,
                                                            LCust.acCountry])
      else  //Dispatches - take from Line, else Transaction Delivery Address, else Customer Country
        LineRec.Country := StrUtil.GetFirstPopulatedString([LId.SSDCountry,
                                                            LInv.thDeliveryCountry,
                                                            LCust.acCountry]);

      //PR: 28/01/2016 ABSEXCH-17214 v2016 R1 Use Intrastat Country
      LineRec.Country := IntrastatCountry(LineRec.Country);
      if LId.SSDUseLine then  //Take from line
      begin
        // MH 31/05/2016 2016-R2 ABSEXCH-17488: Added support for 10 character TARIC Codes
        LineRec.CommodityCode := Copy(LId.SSDCommod, 1, 8);
        LineRec.Weight := LId.LWeight;
        LineRec.SuppUnitsValue := LId.SSDSPUnit;
      end
      else
      begin //Take from stock
        // MH 31/05/2016 2016-R2 ABSEXCH-17488: Added support for 10 character TARIC Codes
        LineRec.CommodityCode := Copy(LStock.CommodCode, 1, 8);
        if IsSalesReport then
          LineRec.Weight := LStock.SWeight
        else
          LineRec.Weight := LStock.PWeight;
        LineRec.SuppUnitsValue := LStock.SuppSUnit;
      end;

      //Weight and supplementary units
      LineRec.Weight := ForceNearestWhole(Calc_IdQty(LId.Qty,LId.QtyMul,LId.UsePack)*LineRec.Weight,2);
      LineRec.SuppUnitsValue := DivWChk((LId.Qty*LId.QtyMul),LineRec.SuppUnitsValue);

      LineRec.SuppUnitsString := LStock.UnitSupp;
      LineRec.Value := GetLineValue;
      LineRec.DeliveryTerms := IfThen(FIncludeDeliveryTerms, LInv.DelTerms, '');
      if Trim(LId.tlIntrastatNoTC) <> '' then
        LineRec.NatureOfTransaction := LId.tlIntrastatNoTC
      else
        LineRec.NatureOfTransaction := IntToStr(LInv.TransNat);

      LineRec.TransportMode := LInv.TransMode;
      LineRec.OurRef := LInv.OurRef;

      LineRec.StockCode := LId.StockCode;

      LineRec.Process := LInv.SSDProcess;
      LineRec.FolioNumber := LInv.FolioNum;
      LineRec.OutOfPeriod := LInv.thIntrastatOutOfPeriod;

//      UpdateTotals(LineRec);


      SortString := GetSortString(LineRec);

      Result := FLineList.AddObject(SortString, LineRec);

      if LineRec.OutOfPeriod then
        FOutOfPeriodList.Add(LineRec.CommodityCode);
    end;
  end;
end;

constructor TPervasiveIntrastatDataClass.Create;
begin
  inherited;

end;

destructor TPervasiveIntrastatDataClass.Destroy;
begin

  inherited;
end;

function TPervasiveIntrastatDataClass.GetLineValue: Double;
begin
  Result := DoGetLineValue(FExLocal.LId);
end;

function TPervasiveIntrastatDataClass.LoadData: Integer;
var
  Res : Integer;
  KeyS : Str255;
  KeyChk : Str255;

  KeySTrans : Str255;
  KeyChkTrans : Str255;

  KeySLine : Str255;

  IndexList : TStringList;
  i : Integer;

  procedure SetTransValues;
  begin
    with FExLocal^ do
    begin
      FCurrency := LInv.Currency;
      FUseORate := LInv.UseORate;
      FVATRates := LInv.VATCRate;
      FOriginalRates := LInv.OrigRates;
    end;
  end;

begin
  Assert(Assigned(FExLocal), 'ExLocal has not been assigned');

  IndexList := TStringList.Create;
  Try
    with FExLocal^ do
    begin
      KeyS := TraderType;
      KeyChk := KeyS;
      Res :=  LFind_Rec(B_GetGEq, CustF, ATCodeK, KeyS);

      while (Res = 0) and (Copy(KeyS, 1, Length(KeyChk)) = KeyChk) do
      begin
        if LCust.EEcMember then
        begin
          KeySTrans := LCust.CustCode + LCust.CustSupp + #1 + FStartDate;
          KeyChkTrans := LCust.CustCode + LCust.CustSupp + #1;

          Res := LFind_Rec(B_GetGEq, InvF, InvCustLedgK, KeySTrans);

          while (Res = 0) and (Copy(KeySTrans, 1, Length(KeyChkTrans)) = KeyChkTrans) and (LInv.TransDate <= FEndDate) do
          begin
            if IncludeTransaction then
            begin
              SetTransValues;

              TotalDeliveryCharge := 0;
              TotalStockLines := 0;

              KeySLine := FullRunNoKey(LInv.FolioNum, 1);

              Res := LFind_Rec(B_GetGEq, IDetailF, IdFolioK, KeySLine);

              while (Res = 0) and (LId.FolioRef = LInv.FolioNum) do
              begin
                //PR: 26/01/2016 ABSEXCH-17202 v2016 R1 Moved LoadStockRecord call from AddLine as we now need to have
                //                                      stock record loaded for IncludeLine
                LoadStockRecord;
                if IncludeLine then
                begin
                  i := AddLine;
                  if i >= 0 then
                    IndexList.Add(IntToStr(i));
                end;

                Res := LFind_Rec(B_GetNext, IDetailF, IdFolioK, KeySLine);
              end; //while (Res = 0) and (Lid.FolioNum = LInv.FolioNum)

              FinaliseTransaction(LInv.FolioNum, TotalStockLines, TotalDeliveryCharge, IndexList);

              IndexList.Clear;
            end; //if IncludeTransaction

            Res := LFind_Rec(B_GetNext, InvF, InvCustLedgK, KeySTrans);
          end; // while (Res = 0) and (Copy(KeySTrans, 1, Length(KeyChkTrans)) = KeyChkTrans) and (LInv.TransDate <= FEndDate)

        end; //if LCust.EEcMember

        Res :=  LFind_Rec(B_GetNext, CustF, ATCodeK, KeyS);
      end; // while (Res = 0) Customer/Supplier

    end; // with FExLocal^

  Finally
   IndexList.Free;
  End;
  Result := inherited LoadData;
end;

procedure TPervasiveIntrastatDataClass.LoadStockRecord;
var
  KeyS : Str255;
  Res : Integer;
begin
  with FExLocal^ do
  if Trim(LStock.StockCode) <> Trim(LId.StockCode) then
  begin
    KeyS := LId.StockCode;
    Res := LFind_Rec(B_GetEq, StockF, StkCodeK, KeyS);
  end;
end;

{ TIntrastatReportLine }

procedure TIntrastatReportLine.Assign(const ALine: TIntrastatReportLine);
begin
  if Assigned(ALine) then
  begin
    Country := ALine.Country;
    CommodityCode := ALine.CommodityCode;
    DeliveryTerms := ALine.DeliveryTerms;
    NatureofTransaction := ALine.NatureofTransaction;
    TransportMode := ALine.TransportMode;
    Value := ALine.Value;
    Weight := ALine.Weight;
    SuppUnitsValue := ALine.SuppUnitsValue;
    SuppUnitsString := ALine.SuppUnitsString;
    OurRef := ALine.OurRef;
    StockCode := ALine.StockCode;
    FolioNumber := ALine.FolioNumber;
    Aggregated := ALine.Aggregated;
  end;
end;

//==================================================================================
procedure TestIntrastat;
var
  oTest : IIntrastatDataClass;
  ExLocal : TdPostExLocalPtr;
  AList : TStringList;
  Res : Integer;
begin
  oTest := GetIntrastatDataObject;
  AList := TStringList.Create;
  if Assigned(oTest) then
  begin
    oTest.isdStartDate := '20160101';
    oTest.isdEndDate   := '20160131';
    oTest.isdReportDirection := idDispatches;
    oTest.isdReportMode := irmAudit;

    New(ExLocal, Create(1));
    Try
      ExLocal.Open_System(CustF, StockF);

      oTest.isdExLocal := ExLocal;
      oTest.LoadData;

      Res := oTest.GetFirst;
      while Res = 0 do
      begin
        AList.Add(oTest.isdCommodityCode + ',' + FloatToStr(oTest.isdValue) + ',' + BoolToStr(oTest.isdAggregated, True));

        Res := oTest.GetNext;
      end;
      AList.SaveToFile('c:\aaa\Intrastat.txt');
    Finally
      Dispose(ExLocal, Destroy);
    End;
  end; //If assigned


end;


end.
