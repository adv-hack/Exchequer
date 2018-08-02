unit XmlUtil;

{ prutherford440 09:52 30/10/2001: Disabled Byte Alignment in Delphi 6.0 }
{$ALIGN 1}  { Variable Alignment Disabled }


interface

uses
{$IFNDEF StandAlone}
  VarConst,
{$ELSE}
   {VarRec2U,}
   GlobVar,
{$ENDIF}

  {$IFDEF VCXML}
    vcxml_tlb
  {$ELSE}
    msxml_tlb
  {$ENDIF} ;

{$IFDEF StandAlone}
const
  CurrencyType    =  90;
  LastAddrD  = 2147483647;
  {$I VARCOMNU.Pas}
{$ENDIF}


type
  TXMLExportType = (xxpError, xxpCustomers, xxpStock, xxpStockGroups);
  TStringArray = array of string;

  TAddressLines = Array[1..5] of string[30];
  TAddressDetails = Record
    Lines : array[1..5] of string[30];
    CountryName : string;
    CountryCode : string;
  end;

  //PR: 16/10/2013 ASEXCH-14703
  TPostcodeString = String[20];

  TGetSenderDetails = class
    private
      fOriginator  : String;
      fOrigAddr    : String;
      fSubject     : String;

    public
{$IFNDEF StandAlone}

      Procedure ReadEmailSettings(XMLFileName :  String);
{$ENDIF}
      property Originator  : String read fOriginator;
      property OrigAddr    : String read fOrigAddr;
      property TheSubject  : String read fSubject;
  end;



function BooleanToString(Value : boolean) : string;
function JustAlphaNum(ch : char) : string;
function EntRef(Data : string) : string;
function TransNoToLogName(const TransNo : string) : string;
function TimeToBASDATime(Time : string) : string;
function DateToBASDADate(Date : string) : string;
function BASDADateToDate(Date : string) : string;
function DaysToMonthEnd(Date : TDateTime) : integer;
function DaysBetween(FirstDate, SecondDate : TDateTime) : integer;
function EntTransToEBisTrans(OrderType : DocTypes) : string; overload;
function EntTransToEBisTrans(SearchDocCode : string) : string; overload;
function EBisTransToEntTrans(EBisSearchCode : string) : string;
function EntTransStrToEnum(SearchDocCode : string) : DocTypes;
function GetTransDesc(SearchDocCode : string) : string;

{$IFNDEF StandAlone}
  {$IFDEF EXTERNALIMPORT}
    function EBisCurrToEntCurr(const CompanyCode, CompanyPath, EBisCurrCode : string; var EntCurrNum : smallint) : integer;
  {$ELSE}
    function EBisCurrToEntCurr(const CompanyCode, EBisCurrCode : string; var EntCurrNum : smallint) : integer;
  {$ENDIF}

  function EntCurrToEBisCurr(const DataPath : string; EntCurrNum : smallint; var EBisCurrCode : string) : integer;

  {$IFDEF EXTERNALIMPORT}
    function ExternalTaxToEntTaxCode(const TaxCode, CompanyCode, CompanyPath, TradCode : string) : char;
  {$ELSE}
    function ExternalTaxToEntTaxCode(const TaxCode, CompanyCode, TradCode : string) : char;
  {$ENDIF}
{$ENDIF}

function BASDALineTypeToDesc(const LineTypeCode : string) : string;
function BASDADiscountTypeToDesc(const DiscountTypeCode : string) : string;
function BASDAPropertiesUOMToDesc(const UOMCode : string) : string;
function BASDATaxToEntTaxCode(BASDATaxCode : char) : char;
function VATCodeToIndex(VATCode : char) : integer;
function DateOK(Date : string) : boolean;
function AltStockToEntStockCode(const AltStockCode, TraderCode : string) : string;
function BarCodeToEntStockCode(const BarCode : string) : string;
function StockCodeExists(const Code : string) : boolean;
function CustSuppCodeExists(CustSuppCode : string; IsCustomer : boolean) : boolean;
function CCDepExists(CCDep : string; IsCostCentre : boolean) : boolean;
function LocationExists(Location : string) : boolean;
function NominalCodeExists(NomCode : integer) : boolean;
function TheirCodeForUsToCustSuppCode(TheirCodeForUs : string; IsCustomer : boolean;
  var CustSuppCode : string) : integer;

function XSLQuery(Tags : array of string) : string;
function AddNameSpace(const TagName, NameSpace : string) : string;
function LoadXMLDocument(DocName : string; var XMLDoc : IXMLDOMDocument) : boolean;
procedure PostProcessHTML(DocName : string);

function GetAddressDetails(const ALines : TAddressLines;
                           const ACountryCode : string) : TAddressDetails;

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

Implementation

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

uses
  CountryCodeUtils, CountryCodes,
  SysUtils, Math, Classes,   Dialogs, FileCtrl,XMLConst, UseDLLU,
{$IFNDEF StandAlone}
  EBusUtil, EbusVar, EBusBtrv, EBusLkUp,
  BTSupU1,
{$ELSE}
  ETMiscU,
{$ENDIF}
  StrUtil;

{$I Exdllbt.inc}
{$I Exchdll.inc}

type
  EBisConvertError = class(Exception);

  TTransEBis =
    record
      Ent : DocTypes;
      EBis : string;
    end;

const
  MAX_TRANS = 5;
  EBIS_CODES : array[1..MAX_TRANS] of TTransEBis =
    ((Ent : POR; EBis : BASDA_PURCH_ORDER),
     (Ent : SIN; EBis : BASDA_COMMERCIAL_INVOICE),
     (Ent : SOR; EBis : BASDA_SALES_ORDER),
     (Ent : PIN; EBis : BASDA_USER_DEFINED),
     (Ent : SCR; EBis : BASDA_CREDIT_INVOICE));

//-----------------------------------------------------------------------------------

function BooleanToString(Value : boolean) : string;
begin
  if Value then
    Result := 'true'
  else
    Result := 'false';
end;

//-----------------------------------------------------------------------------------

function JustAlphaNum(ch : char) : string;
begin
  if not (ch in ['0'..'9', 'A'..'Z']) then
    Result := ''
  else
    Result := ch;
end;

//-----------------------------------------------------------------------------------

function TimeToBASDATime(Time : string) : string;
// Pre  : Date in format hhmmdd
// Post : Returns date in format hh:mm:dd
begin
  if Trim(Time) = '' then
    Result := ''
  else
    Result := Format('%s:%s:%s',[copy(Time,1,2), copy(Time,3,2), copy(Time,5,2)]);
end;

//-----------------------------------------------------------------------------------

function DateToBASDADate(Date : string) : string;
// Pre  : Date in format yyyymmdd
// Post : Returns date in format yyyy-mm-dd
begin
  if Trim(Date) = '' then
    Result := ''
  else
    Result := Format('%s-%s-%s',[copy(Date,1,4), copy(Date,5,2), copy(Date,7,2)]);
end;

//-----------------------------------------------------------------------------------

function BASDADateToDate(Date : string) : string;
// Pre  : Date in format yyyy-mm-dd
// Post : Returns date in format yyyymmdd
begin
  Result := copy(Date,1,4) + copy(Date,6,2) + copy(Date,9,2);
end;

//-----------------------------------------------------------------------------------

function DaysToMonthEnd(Date : TDateTime) : integer;
// Post : Returns the number of days from the date until the end of month
const
  DAYS_PER_MONTH : array[1..12] of word = (31,28,31,30,31,30,31,31,30,31,30,31);
var
  Year, Month, Day : word;
  Days : word;
begin
  DecodeDate(Date, Year, Month, Day);
  Days := DAYS_PER_MONTH[Month];
  if IsLeapYear(Year) then
    inc(Days);
  Result := Days - Day;
end;

//-----------------------------------------------------------------------------------

function DaysBetween(FirstDate, SecondDate : TDateTime) : integer;
begin
  Result := round(SecondDate - FirstDate);
  if Result < 0 then
    Result := 0;
end;

//-----------------------------------------------------------------------------------

function EntRef(Data : string) : string;
// Notes : Replaces characters which are not permitted in XML data with their
//         equivalent entities.
type
  TEntRef =
    record
      Ch : char;
      Equiv : string;
    end;
const
  MAX_ENT = 5;
  ENTITIES : array[1..MAX_ENT] of TEntRef =
    ((Ch: '<';  Equiv: '&lt;'),
     (Ch: '>';  Equiv: '&gt;'),
     (Ch: '&';  Equiv: '&amp;'),
     (Ch: ''''; Equiv: '&apos;'),
     (Ch: '"';  Equiv: '&quot;'));
var
  ChPos,
  EntPos : integer;
  FoundEnt : boolean;
  s128 : String;
begin
  ChPos := 1;
  while ChPos <= length(Data) do
  begin
    EntPos := 1;
    FoundEnt := false;
    while (EntPos <= MAX_ENT) and not FoundEnt do
    begin
      FoundEnt := Data[ChPos] = ENTITIES[EntPos].Ch;
      if FoundEnt then
      begin
        delete(Data, ChPos, 1);
        insert(ENTITIES[EntPos].Equiv, Data, ChPos);
        ChPos := ChPos + length(ENTITIES[EntPos].Equiv);
      end;
      inc(EntPos);
    end;

    if not FoundEnt and (Ord(Data[ChPos]) > 127) then
    begin
      s128 := '&#' + IntToStr(Ord(Data[ChPos])) + ';';
      delete(Data, ChPos, 1);
      insert(s128, Data, ChPos);
      ChPos := ChPos + length(s128);
      FoundEnt := True;
    end;

    if not FoundEnt then
      inc(ChPos,1);
  end;
  Result := Data;
end; // EntRef

//-----------------------------------------------------------------------------------

function TransNoToLogName(const TransNo : string) : string;
// Pre  : Transaction number in the form SIN000123 etc.
// Post : Equivalent log file name in the form SI000123.LOG
var
  s : string;
  i : integer;
begin
  // Assume all transaction numbers have a 3 letter prefix
  s := ExtractLeadingString(TransNo);
  Result := copy(s, 1, 2);

  s := ExtractTrailingInteger(TransNo);
  try
    i := StrToInt(Trim(s));
    Result := Result + Format('%.6d', [i]);
  except
    Result := Result + copy(TransNo, 4, length(TransNo) - 3);
  end;
  Result := Result + '.LOG';
end;

//-----------------------------------------------------------------------------------

function EntTransToEBisTrans(OrderType : DocTypes) : string;
// Notes : Converts Enterprise enumerated document type to equivalent EBis code
var
  Found : boolean;
  Posn : integer;
begin
  Found := false;
  Posn := 1;
  while not Found and (Posn <= MAX_TRANS) do
  begin
    Found := OrderType = EBIS_CODES[Posn].Ent;
    if not Found then
      inc(Posn);
  end;
  if Found then
    Result := EBIS_CODES[Posn].EBis
  else
    raise EBisConvertError.CreateFmt('%s has no EBis equivalent',[DocCodes[OrderType]]);
end;

//-----------------------------------------------------------------------------------

function EntTransToEBisTrans(SearchDocCode : string) : string;
// Notes : Converts Enterprise 3 letter document string to equivalent EBis code
begin
  Result := EntTransToEBisTrans(EntTransStrToEnum(SearchDocCode));
end;

//-----------------------------------------------------------------------------------

function EntTransStrToEnum(SearchDocCode : string) : DocTypes;
// Pre  : SearchDocCode = Enterprise 3 letter document string
// Post : Result = Enumerated equivalent
var
  Found : boolean;
  Posn : DocTypes;
begin
  Found := false;
  Result := Low(DocCodes);
  SearchDocCode := Trim(UpperCase(SearchDocCode));

  for Posn := Low(DocCodes) to High(DocCodes) do
  begin
    if DocCodes[Posn]= SearchDocCode then
    begin
      Result := Posn;
      Found := true;
    end;
  end;

  if not Found then
    raise EBisConvertError.CreateFmt
      ('%s is an invalid 3 char Exchequer transaction string', [SearchDocCode]);
end;

//-----------------------------------------------------------------------------------

function GetTransDesc(SearchDocCode : string) : string;
// Pre  : SearchDocCode = Enterprise 3 letter document string
// Post : Result = Full transaction description
begin
  Result := DocNames[EntTransStrToEnum(SearchDocCode)];
end; // GetTransDesc

//-----------------------------------------------------------------------------------

function EBisTransToEntTrans(EBisSearchCode : string) : string;
var
  Found : boolean;
  Posn : integer;
begin
  Found := false;
  Posn := 1;
  while not Found and (Posn <= MAX_TRANS) do
  begin
    Found := EBisSearchCode = EBIS_CODES[Posn].EBis;
    if not Found then
      inc(Posn);
  end;
  if Found then
    Result := DocCodes[EBIS_CODES[Posn].Ent]
  else
    raise EBisConvertError.CreateFmt('%s has no Exchequer equivalent', [EBisSearchCode]);
end;

//-----------------------------------------------------------------------------------

function XSLQuery(Tags : array of string) : string;
// Notes : MSXML COM object routine getElementsByTagName can use XSL patterns
//         for queries.  These are the tags in order separated by '/'
const
  SEP = '/';
var
  i : integer;
begin
  for i := Low(Tags) to High(Tags) do
    if i = Low(Tags) then
      Result := Tags[i]
    else
      Result := Result + SEP + Tags[i];
end; // XSLQuery

//-----------------------------------------------------------------------------------

function AddNameSpace(const TagName, NameSpace : string) : string;
begin
  Result := Format('%s:%s', [NameSpace, TagName]);
end;

//-----------------------------------------------------------------------------------
{$IFNDEF StandAlone}

function EntCurrToEBisCurr(const DataPath : string; EntCurrNum : smallint;
                             var EBisCurrCode : string) : integer;
// Pre  : DataPath = Path to company's data
//        EntCurrNum = Enterprise currency integer value, multi-company specific
// Post : EBisCurrCode e.g. GBP etc.
//        Result = Btrieve status
begin
  with TEBusBtrieveLookupCurrency.Create do
  try
    FileLocation := IncludeTrailingBackSlash(IncludeTrailingBackSlash(DataPath) + EBUS_DIR);
    OpenFile;
    OurCurrencyCode := EntCurrNum;
    UseOurItemCode;  // Set the index
    Result := FindRecord;
    if Result = 0 then
      EBisCurrCode := Trim(TheirCurrencyCode);
    CloseFile;
  finally
    Free;
  end;
end;
{$ENDIF}
//-----------------------------------------------------------------------------------

function BASDALineTypeToDesc(const LineTypeCode : string) : string;
begin
  Result := 'unknown line type!';
  if LineTypeCode = BASDA_GOODS then
    Result := 'Goods and services';
  if LineTypeCode = BASDA_DESCRIPTION then
    Result := 'Description';
  if LineTypeCode = BASDA_BLANKLINE then
    Result := 'Blank line';
  if LineTypeCode = BASDA_ORDER_LINE then
    Result := 'Order line';
  if LineTypeCode = BASDA_INVOICE_LINE then
    Result := 'Invoice line';
  if LineTypeCode = BASDA_FREIGHT_CHARGES then
    Result := 'Freight charges';
  if LineTypeCode = BASDA_MISC_CHARGES then
    Result := 'Miscellaneous charges';
end; // BASDALineTypeToDesc

//-----------------------------------------------------------------------------------

function BASDADiscountTypeToDesc(const DiscountTypeCode : string) : string;
begin
  Result := 'unknown discount type!';
  if DiscountTypeCode = BASDA_SPECIAL_DISCOUNT then
    Result := 'Special line discount';
  if DiscountTypeCode = BASDA_LINE_DISCOUNT then
    Result := 'Line discount';
  if DiscountTypeCode = BASDA_VOLUME_DISCOUNT then
    Result := 'Volume discount';
  if DiscountTypeCode = BASDA_EARLY_SETTLE_DISCOUNT then
    Result := 'Early settlement discount';
  if DiscountTypeCode = BASDA_RECIPE_DISCOUNT then
    Result := 'Derived discount';
  if DiscountTypeCode = BASDA_TRADE_DISCOUNT then
    Result := 'Trade discount';
end; // BASDADiscountTypeToDesc

//-----------------------------------------------------------------------------------

function BASDAPropertiesUOMToDesc(const UOMCode : string) : string;
begin
  Result := 'unknown UOM';
  if UOMCode = BASDA_WEIGHT_KG then
    Result := 'kilogrammes';
end;

//-----------------------------------------------------------------------------------
{$IFNDEF StandAlone}

{$IFDEF EXTERNALIMPORT}
function EBisCurrToEntCurr(const CompanyCode, CompanyPath, EBisCurrCode : string; var EntCurrNum : smallint) : integer;
{$ELSE}
function EBisCurrToEntCurr(const CompanyCode, EBisCurrCode : string; var EntCurrNum : smallint) : integer;
{$ENDIF}

// Pre  : CompanyCode i.e. code of company containing lookup file
//        EBisCurrCode e.g. GBP etc.
// Post : EntCurrNum = Enterprise currency integer value, multi-company specific
//        Result = Btrieve status, -1 if non integer value found in file
begin
  with TEBusBtrieveLookupCurrency.Create(true) do
  try

    {$IFDEF EXTERNALIMPORT}
      FileLocation := IncludeTrailingBackSlash(IncludeTrailingBackSlash(
                          GetCompanyDirFromCode(CompanyCode, CompanyPath)) + EBUS_DIR);
    {$ELSE}
      FileLocation := IncludeTrailingBackSlash(IncludeTrailingBackSlash(
                          GetCompanyDirFromCode(CompanyCode)) + EBUS_DIR);
    {$ENDIF}

    OpenFile;
    TheirCurrencyCode := EBisCurrCode;
    UseTheirItemCode;
    Result := FindRecord;
    if Result = 0 then
      EntCurrNum := OurCurrencyCode;
    CloseFile;
  finally
    Free;
  end;
end;
{$ENDIF}
//-----------------------------------------------------------------------------------

function CustSuppCodeExists(CustSuppCode : string; IsCustomer : boolean) : boolean;
// Pre  : CustSuppCode = possible customer/supplier code
//        IsCustomer true => customer code; false => supplier code
// Post : Returns true if a customer or supplier code was found
var
  CustSuppRec : ^TBatchCURec;
  SearchRef : array[0..255] of char;
  CustSuppIndex : integer;
begin
  new(CustSuppRec);
  if length(CustSuppCode) < 6 then
    CustSuppCode := CustSuppCode + copy(StringOfChar(' ',6), 1,  6 - length(CustSuppCode));
  StrPCopy(SearchRef, CustSuppCode);
  if IsCustomer then
    CustSuppIndex := 1
  else
    CustSuppIndex := 2;
  Result := Ex_GetAccount(CustSuppRec, SizeOf(CustSuppRec^), SearchRef, 0, B_GetEq,
    CustSuppIndex, false) = 0;
  dispose(CustSuppRec);
end; // CustSuppCodeExists

//-----------------------------------------------------------------------------------

function CCDepExists(CCDep : string; IsCostCentre : boolean) : boolean;
// Pre  : CCDep = possible cost centre / department code
//        IsCostCentre true => cost centre; false => department
// Post : Returns true if a cost centre or department was found
var
  CCDepRec : ^TBatchCCDepRec;
  SearchRef : array[0..255] of char;
  CCDepIndex : integer;
begin
  new(CCDepRec);
  StrPCopy(SearchRef, Trim(CCDep));
  if IsCostCentre then
    CCDepIndex := 0
  else
    CCDepIndex := 1;
  Result := Ex_GetCCDep(CCDepRec, SizeOf(CCDepRec^), SearchRef, 0, B_GetEq,
    CCDepIndex, false) = 0;
  dispose(CCDepRec);
end; // CCDepExists

//-----------------------------------------------------------------------------------

function LocationExists(Location : string) : boolean;
// Pre  : Location = possible location
// Post : Returns true if a location was found
var
  LocRec : ^TBatchMLocRec;
  SearchRef : array[0..255] of char;
begin
  new(LocRec);
  StrPCopy(SearchRef, Trim(Location));
  Result := Ex_GetLocation(LocRec, SizeOf(LocRec^), SearchRef, 0, B_GetEq, false) = 0;
  dispose(LocRec);
end; // LocationExists

//-----------------------------------------------------------------------------------

function NominalCodeExists(NomCode : integer) : boolean;
var
  NomRec : ^TBatchNomRec;
  SearchRef : array[0..255] of char;
begin
  new(NomRec);
  StrPCopy(SearchRef, IntToStr(NomCode));
  Result := Ex_GetGLAccount(NomRec, SizeOf(NomRec^), SearchRef, 0, B_GetEq, false) = 0;
  dispose(NomRec);
end;

//-----------------------------------------------------------------------------------

function TheirCodeForUsToCustSuppCode(TheirCodeForUs : string; IsCustomer : boolean;
  var CustSuppCode : string) : integer;
// Pre  : TheirCodeForUs = code to search for
//        IsCustomer - true => customer; false => supplier
// Post : CustSuppCode is populated with the last found code matching TheirCodeForUs
//        Result = Number of duplicate instances found, 0 => none found
var
  CustSuppRec : ^TBatchCURec;
  SearchRef : array[0..255] of char;
  CustSuppIndex,
  Status : integer;
begin
  //PR: 02/08/2011 Moved Result := 0 to beginning of func (Result contains number of accounts found) and
  //checked that TheirCodeForUs isn't blank - if it is then the function will find all accounts with
  //a blank TheirCodeForUs.  ABSEXCH-9625
  Result := 0;

  if Trim(TheirCodeForUs) <> '' then
  begin
    new(CustSuppRec);
    Try
      StrPCopy(SearchRef, Trim(TheirCodeForUs));
      if IsCustomer then
        CustSuppIndex := 1
      else
        CustSuppIndex := 2;
      // Need to use a B_GetGEq as the index on 'Their A/C for Us' may contain
      // extraneous spaces from the way it was being stored in Enterprise
      Status := Ex_GetAccount(CustSuppRec, SizeOf(CustSuppRec^), SearchRef, 9, B_GetGEq,
        CustSuppIndex, false);

      //PR: 25/02/2009 Added Trim to both sides of comparison to deal with padding from returned search key.
      while (Status = 0) and (Trim(SearchRef) = Trim(TheirCodeForUs)) do
      begin
        CustSuppCode := CustSuppRec^.CustCode;
        inc(Result);
        Status := Ex_GetAccount(CustSuppRec, SizeOf(CustSuppRec^), SearchRef, 9, B_GetNext,
          CustSuppIndex, false);
      end;
    Finally
      dispose(CustSuppRec);
    End;
  end;
end; // TheirCodeForUsToCustSuppCode

//-----------------------------------------------------------------------------------

function BASDATaxToEntTaxCode(BASDATaxCode : char) : char;
begin
  Result := #0;
  if BASDATaxCode in [BASDA_STANDARD_VAT, BASDA_ZERO_VAT, BASDA_EXEMPT_VAT] then
    Result := BASDATaxCode;

  case BASDATaxCode of
    BASDA_LOWER_RATE_VAT : Result := '1';
    BASDA_HIGHER_RATE_VAT : Result := '2';
    BASDA_NO_VAT : Result := 'E';
  end;
end;

//-----------------------------------------------------------------------------------

function VATCodeToIndex(VATCode : char) : integer;
// Pre  : VATCode = Enterprise single letter VAT code
// Post : Returns the array index that the letter represents; -1 if not found
var
  Index : integer;
begin
  Result := -1;
  // Map VAT codes that have a shared index
  if VATCode = '3' then VATCode := 'A';
  if VATCode = '4' then VATCode := 'D';

  for Index := Low(VAT_CODES) to High(VAT_CODES) do
    if VAT_CODES[Index] = VATCode then
      Result := Index;
end; // VATCodeToIndex

//-----------------------------------------------------------------------------------

function DateOK(Date : string) : boolean;
// Pre  : Date in format yyyymmdd
// Post : Returns true if date is valid
begin
  Result := true;
  try
    EncodeDate(StrToInt(copy(Date,1,4)), StrToInt(copy(Date,5,2)), StrToInt(copy(Date,7,2)));
  except
    on EConvertError do
      Result := false;
  end;
end; // DateOK

//-----------------------------------------------------------------------------------

function AltStockToEntStockCode(const AltStockCode, TraderCode : string) : string;
// Pre  : AltStockCode = An alternative stock code
//        TraderCode = Customer or supplier code
// Post : Returns standard Enterprise stock code, a specific one for the trader
//        otherwise a generic one. Blank means none found.
var
  AltStockInfo : ^TBatchSkAltRec;
  SearchCode : array[0..255] of char;
  Status : integer;
  Found : boolean;
begin
  new(AltStockInfo);
  FillChar(AltStockInfo^, SizeOf(AltStockInfo^), 0);
  StrPCopy(SearchCode, AltStockCode);

  Found := false;
  Result := '';
  Status := Ex_GetStkAlt(AltStockInfo, SizeOf(AltStockInfo^), SearchCode, 0, B_GetEq, false);
  while (Status = 0) and (Trim(AltStockInfo^.AltCode) = Trim(AltStockCode)) and not Found do
  begin
    // Default to generic alternative stock code
    if Trim(AltStockInfo^.SuppCode) = '' then
      Result := AltStockInfo^.StockCode;
    Found := Trim(AltStockInfo^.SuppCode) = Trim(TraderCode);
    if Found then
      Result := AltStockInfo^.StockCode;
    Status := Ex_GetStkAlt(AltStockInfo, SizeOf(AltStockInfo^), SearchCode, 0, B_GetNext, false);
  end;

  dispose(AltStockInfo);
end; // AltStockToEntStockCode

//-----------------------------------------------------------------------------------

function BarCodeToEntStockCode(const BarCode : string) : string;
var
  StockRec : ^TBatchSKRec;
  SearchCode : array[0..255] of char;
begin
  Result := '';
  if Trim(BarCode) <> '' then
  begin
    new(StockRec);
    FillChar(StockRec^, SizeOf(StockRec^), 0);
    StrPCopy(SearchCode, BarCode);
    if Ex_GetStock(StockRec, SizeOf(StockRec^), SearchCode, 8, B_GetEq, false) = 0 then
      Result := StockRec^.StockCode;
    dispose(StockRec);
  end;
end; // BarCodeToEntStockCode

//-----------------------------------------------------------------------------------

function StockCodeExists(const Code : string) : boolean;
// Pre  : Code = Enterprise stock code
// Post : Returns true if the stock code exists
var
  StockRec : ^TBatchSKRec;
  SearchCode : array[0..255] of char;
begin
  new(StockRec);
  FillChar(StockRec^, SizeOf(StockRec^), 0);
  FillChar(SearchCode, Sizeof(SearchCode), 0);
  StrPCopy(SearchCode, Code);
  //PR: 09/02/2009 Added check that Stock Record isn't a Group
  Result := (Ex_GetStock(StockRec, SizeOf(StockRec^), SearchCode, 0, B_GetEq, false) = 0) and (StockRec^.StockType <> 'G');
  dispose(StockRec);
end;

//-----------------------------------------------------------------------------------
{$IFNDEF StandAlone}

{$IFDEF EXTERNALIMPORT}
function ExternalTaxToEntTaxCode(const TaxCode, CompanyCode, CompanyPath, TradCode : string) : char;
{$ELSE}
function ExternalTaxToEntTaxCode(const TaxCode, CompanyCode, TradCode : string) : char;
{$ENDIF}

// Pre  : TaxCode = TaxCode to lookup for an external system
//        CustSuppCode = Customer / Supplier code for that
// Post : Returns the Enterprise translated Enterprise tax code, if available via lookup
//        Customer / supplier by preference, otherwise a global lookup value
var
{  VATLookup : PLookupGeneric;
  Code : string;
  i,}
  Status : integer;
{ begin
 new(VATLookup);
  Result := #0;
  for i := 1 to 2 do
    if Result = #0 then
    begin
      if i = 1 then
        Code := CustSuppCode
      else
        Code := '';

      Status := ReadNoLockEBusLookup(VATLookup, LOOKUP_TYPE_VAT, LOOKUP_SUBTYPE_NONE,
        Code, Trim(TaxCode), lkuToOurCode);
      if (Status = 0) and (length(VATLookup^.OurCode) > 0) then
        Result := VATLookup^.OurCode[1]
    end;
  dispose(VATLookup);}

begin
  with TEBusBtrieveLookupVat.Create(true) do
  try
    {$IFDEF EXTERNALIMPORT}
      FileLocation := IncludeTrailingBackSlash(IncludeTrailingBackSlash(
                      GetCompanyDirFromCode(CompanyCode, CompanyPath)) + EBUS_DIR);
    {$ELSE}
      FileLocation := IncludeTrailingBackSlash(IncludeTrailingBackSlash(
                      GetCompanyDirFromCode(CompanyCode)) + EBUS_DIR);
    {$ENDIF}

    OpenFile;
    TheirVatCode := TaxCode;
    OurTraderCode := TradCode;
    UseTheirItemCode;
    Status := FindRecord;
    if Status = 0 then
      Result := OurVatCode
    else
      Result := #0;
    CloseFile;
  finally
    Free;
  end;
end;

//end;
{$ENDIF}
//-----------------------------------------------------------------------------------

function LoadXMLDocument(DocName : string; var XMLDoc : IXMLDOMDocument) : boolean;
// Pre   : DocName = Name of file representing xml document to load
// Post  : XMLDoc  = DOM document instance generated
//         Returns true if document loaded OK
// Notes : If an xml document has processing instructions in it, for example specifying
//         an XSL style-sheet, but the style-sheet is unavailable then the document won't
//         load.  To circumvent this pre-read into a StringList, parse out all the
//         processing instructions and pass the result onto the XML COM object.
{PR 16/07/03 Loading the file into a stringlist wouldn't handle UTF-16 encoded xml files so
             replaced by loading file directly into the xmldocument and setting resolveExternal to
             false so that lack of a style-sheet won't be a problem.} 
{const
  PROCESS_INST_START = '<?';
  PROCESS_INST_END = '?>';
var
  StartPos,
  EndPos    : integer;
  Doc       : string;}
begin
(*  with TStringList.Create do
    try
      LoadFromFile(DocName);
      Doc := Text;
      // Remove all processing instructions
      StartPos := Pos(PROCESS_INST_START, Doc);
      while StartPos > 0 do
      begin
        EndPos := Pos(PROCESS_INST_END, Doc);
        System.Delete(Doc, StartPos, EndPos - StartPos + 2);
        StartPos := Pos(PROCESS_INST_START, Doc);
      end;

      // Remove any extraneous characters from end of file -
      // seem to appear when XML document sent as E-mail attachment
      EndPos := Length(Doc);
      StartPos := Length(Doc);
      while Doc[StartPos] <> '>' do
        dec(StartPos);
      System.Delete(Doc,StartPos+1,EndPos);
*)
      XMLDoc := CoDOMDocument.Create;
      XMLDoc.resolveExternals := False;
      {$IFNDEF VCXML}
        XMLDoc.async := false;
      {$ENDIF}
//      Result := XMLDoc.LoadXML(TrimLeft(Doc));
      Result := XMLDoc.Load(DocName);
{    finally
      Free;
    end;}
end; // LoadXMLDocument

//-----------------------------------------------------------------------------------

procedure PostProcessHTML(DocName : string);
// Pre   : DocName = Name of file representing xml document to load
// Notes : The Microsoft XML COM object produces HTML which includes empty
//         tags and certain entities which are not processed correctly by non-
//         Interner Explorer browsers.  These need to be replaced with values
//         that are generally acceptable.
//         The affected tags are: area, base, basefont, br, col, frame, hr,
//         img, input, isindex, link, meta and param.  Also non-breaking spaces are
//         displayed as ASCII character 194.
type
  TTagReplace =
    record
      T1 : string;
      T2 : string;
    end;
const
  MAX_TAGS = 2;
  REPLACEMENT_TAGS : array [1..MAX_TAGS] of TTagReplace =
    ((T1: '/>'; T2: '>'), (T1: chr(194); T2 : '&nbsp;'));
var
  Doc : string;
  i : integer;
begin
  with TStringList.Create do
    try
      try
        LoadFromFile(DocName);
        Doc := Text;
        for i := 1 to MAX_TAGS do
          Doc := StringReplace(Doc, REPLACEMENT_TAGS[i].T1, REPLACEMENT_TAGS[i].T2,
            [rfReplaceAll, rfIgnoreCase]);
        Text := Doc;
        SaveToFile(DocName);
      except
        // Trap exceptions as the generated HTML will work, although it won't
        // look as nice as it would have had it been processed.
      end;
    finally
      Free;
    end;
end; // LoadXMLDocument

//-----------------------------------------------------------------------------------


//Methods for TGetSender Details

{$IFNDEF StandAlone}
procedure TGetSenderDetails.ReadEmailSettings(XMLFileName :  String);

Var
  FileIO   :  Text;
  IOR      :  Integer;
  NewFileName
           :  String;



Begin
  Inherited;

  NewFileName:=ChangeFileExt(XMLFileName,EBUS_EML_EXT);


  If (FileExists(NewFileName)) then
  Begin
    {$I-}

    AssignFile(FileIO,NewFileName);

    Try

      IOR:=IOresult;

      Report_IOError(IOR,NewFileName);

      If (IOR=0) then
      Begin
        Reset(FileIO);

        IOR:=IOresult;

        Report_IOError(IOR,NewFileName);

        If (IOR=0) then
        Begin
          Readln(FileIO,fOriginator);
          ReadLn(FileIO,fOrigAddr);
          Readln(FileIO,fSubject);

          IOR:=IOresult;

          Report_IOError(IOR,NewFileName);
        end;
      end;
    finally
      CloseFile(FileIO);

    end;
  {$I+}
  end
  else
  Begin
    fOriginator:='';
    fOrigAddr:='';
    fSubject:='';
  end;


end;

{$ENDIF}
function GetAddressDetails(const ALines : TAddressLines;
                           const ACountryCode : string) : TAddressDetails;
begin
  FillChar(Result, SizeOf(Result), 0);
  Move(ALines, Result.Lines, SizeOf(ALines));
  Result.CountryCode := CountryCodeUtils.CountryCode2ToCountryCode3(ACountryCode);
  Result.CountryName := CountryCodeName(ifCountry3, Result.CountryCode);
end;

end.






