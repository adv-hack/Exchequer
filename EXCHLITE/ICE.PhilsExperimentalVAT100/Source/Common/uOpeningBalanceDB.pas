unit uOpeningBalanceDB;
{
  Database creation and access routines for the temporary database files
  used by the Opening Balance.
}
interface

uses
  Classes, SysUtils,
  // Exchequer units
  GlobVar,
  VarConst,
  BtrvU2,
  ComnUnit,
  Enterprise01_Tlb,
  EnterpriseBeta_Tlb;

const
  AccumF         = 16;
  AccumNoOfSegs  = 18;
  AccumNoOfKeys  =  3;

  DiscF          = 17;
  DiscNoOfSegs   =  1;
  DiscNoOfKeys   =  1;

  OrigF          = 18;
  OrigNoOfSegs   =  3;
  OrigNoOfKeys   =  2;

  OBalF          = 19;
  OBalNoOfSegs   =  1;
  OBalNoOfKeys   =  1;

  OBMatchF        = 20;
  OBMatchNoOfSegs =  4;
  OBMatchNoOfKeys =  1;

  OBRefF          = 21;
  OBRefNoOfSegs   =  2;
  OBRefNoOfKeys   =  2;

type
  AccumRec = Record
    OBalCode    : Str10;    // Link to Opening Balance record.
    CtrlGL      : LongInt;  // Debtors/Creditors control G/L, from transaction header.
    PaymentMode : Char;     // For SRIs and PPIs -- I = Invoice, P = Payment, otherwise blank.
    Outstanding : Boolean;  // Transaction is unallocated or partially allocated.
    VATIO       : Byte;     // VAT Input/Output type (0, 1, 2)
    Id          : Idetail;  // Transaction Line record.
  end;

  Accum_FileDef = Record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of Char;
    KeyBuff   :  array[1..AccumNoOfSegs] of KeySpec;
    AltColt   :  AltColtSeq;
  end;

  DiscountRec = record
    OBalCode:  Str10;
    DocType:   DocTypes;
    CustCode:  String[10];
    Currency:  Byte;
    DiscSetAm: Real;
    OurRef:    String[10];
  end;

  Disc_FileDef = Record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of Char;
    KeyBuff   :  array[1..DiscNoOfSegs] of KeySpec;
    AltColt   :  AltColtSeq;
  end;

  OriginatorRec = record
    OBalCode  : Str10;    // Link to Opening Balance header.
    FolioNum  : LongInt;  // Link to original Transaction header.
    OurRef    : Str10;    // OurRef of original Transaction.
    LineNo    : Integer;  // Original line number.
    IsInvoice : Boolean;
    IsVariance: Boolean;
  end;

  Originator_FileDef = record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of Char;
    KeyBuff   :  array[1..OrigNoOfSegs] of KeySpec;
    AltColt   :  AltColtSeq;
  end;

  OBalRec = record
    OBalCode    : Str10;     // Unique identifier
    Inv         : InvRec;
    Outstanding : Boolean;
  end;

  OBal_FileDef = record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of Char;
    KeyBuff   :  array[1..OBalNoOfSegs] of KeySpec;
    AltColt   :  AltColtSeq;
  end;

  OBMatchRec = record
    DocCode     : Str10;
    PayRef      : Str10;
    DocValue    : Double;
    DocCurrency : SmallInt;
    PayValue    : Double;
    PayCurrency : SmallInt;
    BaseValue   : Double;
    DocYourRef  : Str10;
  end;

  OBMatch_FileDef = record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of Char;
    KeyBuff   :  array[1..OBMatchNoOfSegs] of KeySpec;
    AltColt   :  AltColtSeq;
  end;

  { Cross-reference file between Opening Balance Codes and the OurRef values
    assigned to the transactions raised for them. Used on import to allow
    the imported Matching records to locate the transactions that they should
    actually refer to. }
  OBRefRec = record
    OBalCode : Str10;
    OurRef   : Str10;
  end;

  OBRef_FileDef = record
    RecLen,
    PageSize,
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of Char;
    KeyBuff   :  array[1..OBRefNoOfSegs] of KeySpec;
    AltColt   :  AltColtSeq;
  end;

var
  Accum:          AccumRec;
  AccumFile:      Accum_Filedef;
  Discount:       DiscountRec;
  DiscountFile:   Disc_FileDef;
  Originator:     OriginatorRec;
  OriginatorFile: Originator_FileDef;
  OBal:           OBalRec;
  OBalFile:       OBal_FileDef;
  OBMatching:     OBMatchRec;
  OBMatchFile:    OBMatch_FileDef;
  OBRef:          OBRefRec;
  OBRefFile:      OBRef_FileDef;
  DripFeedYear:   Byte;
  PrecedingPeriod:Byte;

type
  { TOBAccumulator holds the accumulated transaction lines, with one record
    for each DocType + CustCode + Currency + CtrlGL + CostCentre + Dept + NomCode. }
  TOBAccumulator = class(TObject)
  public
    function CreateFile(DataPath: string): LongInt;
    function InitFile: LongInt;
  end;

  { TOBDiscount holds the Settlement Discount for Opening Balance transactions.

    Settlement Discount percentages and amounts are stored in the transaction
    header, but for the Opening Balance the transaction lines are separated
    from their original transactions, and accumulated against different Opening
    Balance transactions. Because the discount applies to the total for
    transactions, applying the discount percentage to the individual lines
    would result in round errors.

    Instead, the line values are stored without the discount, and the discount
    settlement for each transaction is stored in this database file. When the
    Opening Balance transactions are exported, all the discount settlements
    for transactions summarised in that Opening Balance are totalled, and the
    result is added as an extra transaction line. }
  TOBDiscount = class(TObject)
    function CreateFile(DataPath: string): LongInt;
    function InitFile: LongInt;
    function Add(DocType: DocTypes; Amount: Double; OurRef: Str10): LongInt;
  end;

  { TOBOriginator holds a list of the original transactions that were
    accumulated into each Accumulator line. There will be one or more
    records for each DocType + CustCode + Currency + CtrlGL. }
  TOBOriginator = class(TObject)
    function CreateFile(DataPath: string): LongInt;
    function InitFile: LongInt;
    function Add(OurRef: Str10; OriginalDocType: DocTypes; IsVariance: Boolean): LongInt;
  end;

  { TOpeningBalance is the Opening Balance transaction header file. This will
    use the Accumulator file as its transaction line file, linking the records
    via the Opening Balance OurRef. There will be one Opening Balance record
    for each DocType + CustCode + Currency + CtrlGL. }
  TOBOpeningBalance = class(TObject)
    function CreateFile(DataPath: string): LongInt;
    function InitFile: LongInt;
    function Add(Trans: ITransaction): LongInt;
    function AddFromTransaction(OurRef: Str10; FolioNum: LongInt): LongInt;
  end;

  { TOBMatchLink holds the matching records for each Opening Balance record. The
    records are built by tracing back through the Originator file to the
    original transactions and their associated matching records, and
    accumulating all the records which match to the same pair of Opening
    Balance records. }
  TOBMatchLink = class(TObject)
    function CreateFile(DataPath: string): LongInt;
    function InitFile: LongInt;
    function Add(OriginalMatch: IMatching; OBInvoice, OBReceipt: OBalRec): LongInt;
    procedure Update(FromMatching: IMatching);
  end;

  TOBCrossReference = class(TObject)
    function CreateFile(DataPath: string): LongInt;
    function InitFile: LongInt;
    function Add(OBalCode, OurRef: Str10): LongInt;
    function OurRef(ForOBalCode: Str10): Str10;
  end;

  { TCodeMap

    Each Opening Balance has to be assigned a unique code -- this will
    eventually (when imported) be replaced by an OurRef, but at the point of
    export we don't know what the OurRef will be. The Opening Balances are
    divided by DocType, Customer/Supplier Code, Currency, and Control G/L, so
    for each combination of these that is found, a unique code is generated
    and added to the code map -- the code map can then return the correct code
    for a specific combination of the identifying fields.

    NOTE: Originally the Opening Balance Export created a code by simply
          combining the identifying fields, unfortunately the result needs
          to be assigned to the DocCode and PayRef fields for Matching
          records, which are only 10 bytes in length. }
  TCodeMap = class(TObject)
  private
    LastCode: Integer;
    List: TStringList;
    procedure Add(ID: string);
  public
    constructor Create;
    destructor Destroy; override;
    { Code() returns the unique code matching the specific identifying values,
      creating a new code if this is the first time this particular set of
      values has been found. }
    function Code(DocType: DocTypes; CustCode: Str10; Currency: Byte;
                  CtrlGL: Integer; Year: Byte): Str10;
    { Reset() clears the existing list of codes }
    procedure Reset;
  end;

  EUnknownValue = class(Exception)
  end;

function BuildOBalCode(DocType: DocTypes; CustCode: Str10; Currency: Byte;
                       CtrlGL: Integer; Year: Byte): Str10; overload;
function BuildOBalCode: Str10; overload;

implementation

uses
  ETStrU,
  BtKeys1U,
  CurrncyU,
  uCommon
  ;

const
  // This array cross-references the TLB Document Type constants with the
  // Enterprise DocTypes constants.  -1 indicates that the COM Toolkit does
  // not support the transaction type
  TKDocTypeVal : Array[DocTypes] of SmallInt =
               //  SIN,   SRC,   SCR,   SJI    SJC,   SRF,   SRI,   SQU,
                  (dtSIN, dtSRC, dtSCR, dtSJI, dtSJC, dtSRF, dtSRI, dtSQU,
               //  SOR    SDN,   SBT    SDG    NDG    OVT    DEB    PIN,
                   dtSOR, dtSDN, dtSBT, -1,    -1,    -1,    -1,    dtPIN,
               // PPY     PCR    PJI    PJC    PRF    PPI    PQU,   POR,
                  dtPPY,  dtPCR, dtPJI, dtPJC, dtPRF, dtPPI, dtPQU, dtPOR,
               // PDN,    PBT,   SDT,   NDT,   IVT,   CRE,   NOM,   RUN,
                  dtPDN,  dtPBT, -1,    -1,    -1,    -1,    dtNMT, -1,
               // FOL,    AFL,   ADC,   ADJ,   ACQ,   API,   SKF,   JBF,
                  -1,     -1,    -1,    dtADJ, -1,    -1,     -1,    -1,
               // WOR,    TSH,   JRN,   WIN,   SRN,   PRN
                  dtWOR,  dtTSH, -1,    -1,    dtSRN, dtPRN,
               // JCT,    JST,   JPT,   JSA,   JPA
                  dtJCT,  dtJST, dtJPT, dtJSA, dtJPA
                  );

var
  FCodeMap: TCodeMap;

{ Returns the singleton instance of TCodeMap used by the routines in this
  module (mainly the BuildOBalCode routines). }
function CodeMap: TCodeMap;
begin
  if (FCodeMap = nil) then
    FCodeMap := TCodeMap.Create;
  Result := FCodeMap;
end;

// -----------------------------------------------------------------------------

{ OBalCode is a unique identifier for Opening Balance records, and is used
  as the link between Opening Balance records and Opening Balance lines (in
  the Accumulator), Exported Matching records, and Originator records. }
function BuildOBalCode(DocType: DocTypes; CustCode: Str10; Currency: Byte;
  CtrlGL: Integer; Year: Byte): Str10; overload;
begin
  Result := CodeMap.Code(DocType, CustCode, Currency, CtrlGL, Year);
end;

// -----------------------------------------------------------------------------

function BuildOBalCode: Str10; overload;
{ Returns an Opening Balance Code based on the current record in the
  Accumulator. }
begin
  Result := BuildOBalCode(
    Accum.Id.IdDocHed,
    Accum.Id.CustCode,
    Accum.Id.Currency,
    Accum.CtrlGL,
    Accum.Id.PYr
  );
end;

// -----------------------------------------------------------------------------

function TLBDocTypeToTKDocType(const TLBDocType: TDocTypes): DocTypes;
{ Converts a Type Library DocType constant into a Toolkit DocType constant }
var
  I : DocTypes;
  Found: Boolean;
begin
  Result := JPA;
  Found := False;
  { Run through Enterprise DocCodes list looking for matching TLB DocType }
  for I := Low(TKDocTypeVal) to High(TKDocTypeVal) do
  begin
    if (TKDocTypeVal[I] = TLBDocType) then
    begin
      Found := True;
      Result := I;
      Break;
    end;
  end;
  if not Found then
    raise EUnknownValue.Create('Invalid Document Type ' + IntToStr(Ord(TLBDocType)));
end;

// =============================================================================
// TOBAccumulator
// =============================================================================

function TOBAccumulator.CreateFile(DataPath: string): LongInt;
{ InitFile must be called first.

  DataPath should be the Exchequer/Office installation directory.

  Returns 0 if the create was successful, otherwise returns a Btrieve error
  code. }
const
  Idx = AccumF;
begin
  if FileExists(DataPath + FileNames[Idx]) then
    DeleteFile(DataPath + FileNames[Idx]);

  Result := Make_File(F[Idx], DataPath + FileNames[Idx], FileSpecOfs[Idx]^,
                      FileSpecLen[Idx]);
end;

// -----------------------------------------------------------------------------

function TOBAccumulator.InitFile: LongInt;
{ Initialises the file and indexes.

  Returns 0 if successful, otherwise returns 255. }
const
  Idx = AccumF;
begin
  Result := 0;
  try
    { The Accumulator file almost the same structure as the Transaction
      Lines file, so we include the same record structure to define the fields.
      The indexes, however, are different, so we are using a new record structure
      for the index definitions. }
    FillChar(AccumFile, FileSpecLen[Idx], 0);
    with AccumFile do
    begin
      FileSpecLen[Idx] := Sizeof(AccumFile);
      RecLen           := Sizeof(Accum);
      PageSize         := DefPageSize;
      NumIndex         := AccumNoOfKeys;

      Variable := B_Variable + B_Compress + B_BTrunc; {* Used for max compression *}

      { Key Definitions }

      { 00 - OBalCode + CostCentre + Dept + NomCode + PaymentMode }
      KeyBuff[1].KeyPos     := BtKeyPos(@Accum.OBalCode, @Accum) + 1;
      KeyBuff[1].KeyLen     := SizeOf(Accum.OBalCode) - 1;
      KeyBuff[1].KeyFlags   := DupModSeg;

      KeyBuff[2].KeyPos     := BtKeyPos(@Accum.Id.CCDep[True], @Accum) + 1;
      KeyBuff[2].KeyLen     := SizeOf(Accum.Id.CCDep[True]) - 1;
      KeyBuff[2].KeyFlags   := DupModSeg;

      KeyBuff[3].KeyPos     := BtKeyPos(@Accum.Id.CCDep[False], @Accum) + 1;
      KeyBuff[3].KeyLen     := SizeOf(Accum.Id.CCDep[False]) - 1;
      KeyBuff[3].KeyFlags   := DupModSeg;

      KeyBuff[4].KeyPos     := BtKeyPos(@Accum.Id.NomCode, @Accum);
      KeyBuff[4].KeyLen     := SizeOf(Accum.Id.NomCode);
      KeyBuff[4].KeyFlags   := DupModSeg + ExtType;
      KeyBuff[4].ExtTypeVal := BInteger;

      KeyBuff[5].KeyPos     := BtKeyPos(@Accum.PaymentMode, @Accum);
      KeyBuff[5].KeyLen     := SizeOf(Accum.PaymentMode);
      KeyBuff[5].KeyFlags   := DupMod;

      { 01 - DocType + Yr + Pr + Currency + CostCentre + Dept + VatCode + NomCode }
      KeyBuff[6].KeyPos     := BtKeyPos(@Accum.Id.IdDocHed, @Accum);
      KeyBuff[6].KeyLen     := SizeOf(Accum.Id.IdDocHed);
      KeyBuff[6].KeyFlags   := DupModSeg;

      KeyBuff[7].KeyPos     := BtKeyPos(@Accum.Id.PYr, @Accum);
      KeyBuff[7].KeyLen     := SizeOf(Accum.Id.PYr);
      KeyBuff[7].KeyFlags   := DupModSeg;

      KeyBuff[8].KeyPos    := BtKeyPos(@Accum.Id.PPr, @Accum);
      KeyBuff[8].KeyLen    := SizeOf(Accum.Id.PPr);
      KeyBuff[8].KeyFlags  := DupModSeg;

      KeyBuff[9].KeyPos    := BtKeyPos(@Accum.Id.Currency, @Accum);
      KeyBuff[9].KeyLen    := SizeOf(Accum.Id.Currency);
      KeyBuff[9].KeyFlags  := DupModSeg;

      KeyBuff[10].KeyPos    := BtKeyPos(@Accum.Id.CCDep[True], @Accum) + 1;
      KeyBuff[10].KeyLen    := SizeOf(Accum.Id.CCDep[True]) - 1;
      KeyBuff[10].KeyFlags  := DupModSeg;

      KeyBuff[11].KeyPos    := BtKeyPos(@Accum.Id.CCDep[False], @Accum) + 1;
      KeyBuff[11].KeyLen    := SizeOf(Accum.Id.CCDep[False]) - 1;
      KeyBuff[11].KeyFlags  := DupModSeg;

      KeyBuff[12].KeyPos    := BtKeyPos(@Accum.Id.VatCode, @Accum);
      KeyBuff[12].KeyLen    := SizeOf(Accum.Id.VatCode);
      KeyBuff[12].KeyFlags  := DupModSeg;

      KeyBuff[13].KeyPos     := BtKeyPos(@Accum.Id.NomCode, @Accum);
      KeyBuff[13].KeyLen     := SizeOf(Accum.Id.NomCode);
      KeyBuff[13].KeyFlags   := DupMod + ExtType;
      KeyBuff[13].ExtTypeVal := BInteger;

      { 00 - OBalCode + CostCentre + Dept + NomCode + PaymentMode }
      KeyBuff[14].KeyPos     := BtKeyPos(@Accum.OBalCode, @Accum) + 1;
      KeyBuff[14].KeyLen     := SizeOf(Accum.OBalCode) - 1;
      KeyBuff[14].KeyFlags   := DupModSeg;

      KeyBuff[15].KeyPos     := BtKeyPos(@Accum.Id.CCDep[True], @Accum) + 1;
      KeyBuff[15].KeyLen     := SizeOf(Accum.Id.CCDep[True]) - 1;
      KeyBuff[15].KeyFlags   := DupModSeg;

      KeyBuff[16].KeyPos     := BtKeyPos(@Accum.Id.CCDep[False], @Accum) + 1;
      KeyBuff[16].KeyLen     := SizeOf(Accum.Id.CCDep[False]) - 1;
      KeyBuff[16].KeyFlags   := DupModSeg;

      KeyBuff[17].KeyPos     := BtKeyPos(@Accum.Id.NomCode, @Accum);
      KeyBuff[17].KeyLen     := SizeOf(Accum.Id.NomCode);
      KeyBuff[17].KeyFlags   := DupModSeg + ExtType;
      KeyBuff[17].ExtTypeVal := BInteger;

      KeyBuff[18].KeyPos     := BtKeyPos(@Accum.PaymentMode, @Accum);
      KeyBuff[18].KeyLen     := SizeOf(Accum.VATIO);
      KeyBuff[18].KeyFlags   := DupMod;

      AltColt := UpperALT;   { Definition for AutoConversion to UpperCase }

    end; { with AccumFile do... }

    FileRecLen[Idx]  := Sizeof(Accum);
    RecPtr[Idx]      := @Accum;
    FileSpecOfs[Idx] := @AccumFile;
    FileNames[Idx]   := 'SWAP\OB_LINES.DAT';

    FillChar(Accum, FileRecLen[Idx], 0);
  except
    on E:Exception do
    begin
      Result := 255;
    end;
  end;
end;

// =============================================================================
// TOBDiscount
// =============================================================================

function TOBDiscount.Add(DocType: DocTypes; Amount: Double;
  OurRef: Str10): LongInt;
begin
  { Add the discount record }
  FillChar(Discount, SizeOf(Discount), 0);
  Discount.OBalCode  := BuildOBalCode(DocType, Id.CustCode, Id.Currency, Accum.CtrlGL, Id.PYr);
  Discount.DocType   := DocType;
  Discount.CustCode  := LJVar(Id.CustCode, SizeOf(Id.CustCode));
  Discount.Currency  := Id.Currency;
  Discount.DiscSetAm := Amount;
  Discount.OurRef    := OurRef;
  Result := Add_Rec(F[DiscF], DiscF, Discount, 0);
end;

// -----------------------------------------------------------------------------

function TOBDiscount.CreateFile(DataPath: string): LongInt;
{ InitFile must be called first.

  DataPath should be the Exchequer/Office installation directory.

  Returns 0 if the create was successful, otherwise returns a Btrieve error
  code. }
const
  Idx = DiscF;
begin
  if FileExists(DataPath + FileNames[Idx]) then
    DeleteFile(DataPath + FileNames[Idx]);

  Result := Make_File(F[Idx], DataPath + FileNames[Idx], FileSpecOfs[Idx]^, FileSpecLen[Idx]);
end;

// -----------------------------------------------------------------------------

function TOBDiscount.InitFile: LongInt;
{ Initialises the file and indexes.

  Returns 0 if successful, otherwise returns 255. }
const
  Idx = DiscF;
begin
  Result := 0;
  try
    FillChar(DiscountFile, FileSpecLen[Idx], 0);
    with DiscountFile do
    begin
      FileSpecLen[Idx] := Sizeof(DiscountFile);
      RecLen           := Sizeof(Discount);
      PageSize         := DefPageSize;
      NumIndex         := DiscNoOfKeys;

      Variable := B_Variable + B_Compress + B_BTrunc; {* Used for max compression *}

      { Key Definitions }

      { 00 - OBalCode }
      KeyBuff[1].KeyPos     := BtKeyPos(@Discount.OBalCode, @Discount) + 1;
      KeyBuff[1].KeyLen     := SizeOf(Discount.OBalCode) - 1;
      KeyBuff[1].KeyFlags   := DupMod;

      AltColt := UpperALT;   { Definition for AutoConversion to UpperCase }

    end; { with DiscountFile do... }

    FileRecLen[Idx]  := Sizeof(Discount);
    RecPtr[Idx]      := @Discount;
    FileSpecOfs[Idx] := @DiscountFile;
    FileNames[Idx]   := 'SWAP\OB_DISC.DAT';

    FillChar(Discount, FileRecLen[Idx], 0);
  except
    on E:Exception do
    begin
      Result := 255;
    end;
  end;
end;

// =============================================================================
// TOBOriginator
// =============================================================================

function TOBOriginator.Add(OurRef: Str10; OriginalDocType: DocTypes; IsVariance: Boolean): LongInt;
{ Adds a new Originator record, based on the current contents of the
  Accumulator record, provided a record does not already exist against
  the current details.

  This should be called when the first Transaction Line from a Transaction is
  added to the Accumulator, so that the Originator builds up a list of all
  the Transactions against each accumulated transaction. }

  function IsInvoice: Boolean;
  begin
    Result := (OriginalDocType in [SIN, PIN]);
  end;

var
  Key: Str255;
  FuncRes: Integer;
begin
  Key := LeftJustify(Accum.OBalCode, #0, 10) + LeftJustify(OurRef, #0, 10);
  Result := Find_Rec(B_GetEq, F[OrigF], OrigF, Originator, 0, Key);
  if ((Result = 4) or (Result = 9)) then
  begin
    FillChar(Originator, SizeOf(Originator), 0);
    Originator.FolioNum   := Accum.Id.FolioRef;
    Originator.LineNo     := Accum.Id.LineNo;
    Originator.OBalCode   := Accum.OBalCode;
    Originator.IsInvoice  := IsInvoice;
    Originator.IsVariance := IsVariance;
    Originator.OurRef     := OurRef;
    FuncRes := Add_Rec(F[OrigF], OrigF, Originator, 0);
    Result := FuncRes;
  end;
end;

// -----------------------------------------------------------------------------

function TOBOriginator.CreateFile(DataPath: string): LongInt;
const
  Idx = OrigF;
begin
  if FileExists(DataPath + FileNames[Idx]) then
    DeleteFile(DataPath + FileNames[Idx]);

  Result := Make_File(F[Idx], DataPath + FileNames[Idx], FileSpecOfs[Idx]^, FileSpecLen[Idx]);
end;

// -----------------------------------------------------------------------------

function TOBOriginator.InitFile: LongInt;
{ Initialises the file and indexes.

  Returns 0 if successful, otherwise returns 255. }
const
  Idx = OrigF;
begin
  Result := 0;
  try
    FillChar(OriginatorFile, FileSpecLen[Idx], 0);
    with OriginatorFile do
    begin
      FileSpecLen[Idx] := Sizeof(OriginatorFile);
      RecLen           := Sizeof(Originator);
      PageSize         := DefPageSize;
      NumIndex         := OrigNoOfKeys;

      Variable := B_Variable + B_Compress + B_BTrunc; {* Used for max compression *}

      { Key Definitions }

      { 00 - OBalCode + OurRef }
      KeyBuff[1].KeyPos     := BtKeyPos(@Originator.OBalCode, @Originator) + 1;
      KeyBuff[1].KeyLen     := SizeOf(Originator.OBalCode) - 1;
      KeyBuff[1].KeyFlags   := ModSeg;

      KeyBuff[2].KeyPos     := BtKeyPos(@Originator.OurRef, @Originator) + 1;
      KeyBuff[2].KeyLen     := SizeOf(Originator.OurRef) - 1;
      KeyBuff[2].KeyFlags   := Modfy;

      { 01 - DocCode }
      KeyBuff[3].KeyPos     := BtKeyPos(@Originator.OurRef, @Originator) + 1;
      KeyBuff[3].KeyLen     := SizeOf(Originator.OurRef) - 1;
      KeyBuff[3].KeyFlags   := DupMod;

      AltColt := UpperALT;   { Definition for AutoConversion to UpperCase }

    end; { with OriginatorFile do... }

    FileRecLen[Idx]  := Sizeof(Originator);
    RecPtr[Idx]      := @Originator;
    FileSpecOfs[Idx] := @OriginatorFile;
    FileNames[Idx]   := 'SWAP\OB_ORIG.DAT';

    FillChar(Originator, FileRecLen[Idx], 0);
  except
    on E:Exception do
    begin
      Result := 255;
    end;
  end;
end;

// =============================================================================
// TOBOpeningBalance
// =============================================================================

function TOBOpeningBalance.Add(Trans: ITransaction): LongInt;
{ Adds a new Opening Balance record, based on the current contents of the
  Accumulator record. }
var
  Key: Str255;
begin
  Key := Accum.OBalCode;  // BuildOBalCode;
  Result := Find_Rec(B_GetEq, F[OBalF], OBalF, OBal, 0, Key);
  if ((Result = 4) or (Result = 9)) then
  begin
    FillChar(OBal, SizeOf(OBal), 0);
    OBal.OBalCode       := Accum.OBalCode;
    OBal.Outstanding    := False;
    OBal.Inv.CtrlNom    := Accum.CtrlGL;
    OBal.Inv.InvDocHed  := Accum.Id.IdDocHed;
    OBal.Inv.CustCode   := Accum.Id.CustCode;
    OBal.Inv.Currency   := Accum.Id.Currency;
    OBal.Inv.AcPr       := Accum.Id.PPr;
    OBal.Inv.AcYr       := Accum.Id.PYr;
    OBal.Inv.CXrate[True] := Trans.thDailyRate;
    OBal.Inv.CXrate[False] := Trans.thCompanyRate;
    OBal.Inv.InvNetVal  := 0.00;                  // These values will be calculated
    OBal.Inv.InvVat     := 0.00;                  // later.
    Result := Add_Rec(F[OBalF], OBalF, OBal, 0);
  end;
end;

// -----------------------------------------------------------------------------

function TOBOpeningBalance.AddFromTransaction(OurRef: Str10; FolioNum: LongInt): LongInt;
{ Adds a new Opening Balance record, based on the current contents of the
  supplied Transaction object. }
var
  Key: Str255;
begin
  { Try to find an existing Opening Balance. Use the Folio Number as the
    Opening Balance Code }
  Key := FullOurRefKey(OurRef);
  Result := Find_Rec(B_GetEq, F[OBalF], OBalF, OBal, 0, Key);
  { If no Opening Balance is found, add a new record }
  if ((Result = 4) or (Result = 9)) then
  begin
    { Find the original transaction }
    Key := FullNomKey(FolioNum);
    Result := Find_Rec(B_GetEq, F[InvF], InvF, Inv, InvFolioK, Key);
    if (Result = 0) then
    begin
      { Copy the details and save }
      FillChar(OBal, SizeOf(OBal), 0);
      OBal.OBalCode     := OurRef;
      OBal.Inv          := Inv;
      OBal.Outstanding  := True;
      Result := Add_Rec(F[OBalF], OBalF, OBal, 0);
    end;
  end;
end;

// -----------------------------------------------------------------------------

function TOBOpeningBalance.CreateFile(DataPath: string): LongInt;
const
  Idx = OBalF;
begin
  if FileExists(DataPath + FileNames[Idx]) then
    DeleteFile(DataPath + FileNames[Idx]);

  Result := Make_File(F[Idx], DataPath + FileNames[Idx], FileSpecOfs[Idx]^, FileSpecLen[Idx]);
end;

// -----------------------------------------------------------------------------
function TOBOpeningBalance.InitFile: LongInt;
const
  Idx = OBalF;
begin
  Result := 0;
  try
    FillChar(OBalFile, FileSpecLen[Idx], 0);
    with OBalFile do
    begin
      FileSpecLen[Idx] := Sizeof(OBalFile);
      RecLen           := Sizeof(OBal);
      PageSize         := DefPageSize;
      NumIndex         := OBalNoOfKeys;

      Variable := B_Variable + B_Compress + B_BTrunc; {* Used for max compression *}

      { Key Definitions }

      { 00 - OBalCode }
      KeyBuff[1].KeyPos     := BtKeyPos(@OBal.OBalCode, @OBal) + 1;
      KeyBuff[1].KeyLen     := SizeOf(OBal.OBalCode) - 1;
      KeyBuff[1].KeyFlags   := Modfy;

      AltColt := UpperALT;   { Definition for AutoConversion to UpperCase }

    end; { with OBalFile do... }

    FileRecLen[Idx]  := Sizeof(OBal);
    RecPtr[Idx]      := @OBal;
    FileSpecOfs[Idx] := @OBalFile;
    FileNames[Idx]   := 'SWAP\OB_TRANS.DAT';

    FillChar(OBal, FileRecLen[Idx], 0);
  except
    on E:Exception do
    begin
      Result := 255;
    end;
  end;
end;

// =============================================================================
// TOBMatchLink
// =============================================================================

function TOBMatchLink.Add(OriginalMatch: IMatching; OBInvoice, OBReceipt: OBalRec): LongInt;
var
  Key: Str255;
  BaseValue: Double;
  PayValue: Double;
begin
  Key := LeftJustify(OBInvoice.OBalCode, #0, SizeOf(OBMatching.DocCode) - 1) +
         LeftJustify(OBReceipt.OBalCode, #0, SizeOf(OBMatching.PayRef) - 1);
  { Search for an existing record }
  Result := Find_Rec(B_GetEq, F[OBMatchF], OBMatchF, OBMatching, 0, Key);

  { If no record found, add a new record }
  if (Result <> 0) then
  begin
    FillChar(OBMatching, FileRecLen[OBMatchF], 0);
    OBMatching.DocCode     := OBInvoice.OBalCode;
    OBMatching.PayRef      := OBReceipt.OBalCode;
    OBMatching.DocCurrency := OriginalMatch.maDocCurrency;  // OBInvoice.Inv.Currency;
    OBMatching.PayCurrency := OriginalMatch.maPayCurrency;  // OBReceipt.Inv.Currency;
    Result := Add_Rec(F[OBMatchF], OBMatchF, OBMatching, 0);
  end;

  if Result = 0 then
  begin

    BaseValue := OriginalMatch.maBaseValue;  // OriginalMatch.maDocValue;
    if (OBMatching.DocCurrency > 1) then
      PayValue := CurrncyU.Conv_TCurr(
                  BaseValue,
                  OBReceipt.Inv.CXrate[(Syss.TotalConv=XDayCode)],
                  OBMatching.PayCurrency,
                  0,
                  True
      )
    else
      PayValue := BaseValue;


    { Accumulate the values }
    OBMatching.DocValue    := OBMatching.DocValue + OriginalMatch.maDocValue;
    OBMatching.PayValue    := OBMatching.PayValue + PayValue; // OriginalMatch.maPayValue;
{
    if (OBMatching.DocCurrency > 1) then
      BaseValue := CurrncyU.Conv_TCurr(
                     BaseValue,
                     OBReceipt.Inv.CXrate[(Syss.TotalConv=XDayCode)],
                     OBReceipt.Inv.Currency,
                     0,
                     False
                   );
}
    OBMatching.BaseValue   := OBMatching.BaseValue + BaseValue;
    Result := Put_Rec(F[OBMatchF], OBMatchF, OBMatching, 0);
  end;

end;

// -----------------------------------------------------------------------------

function TOBMatchLink.CreateFile(DataPath: string): LongInt;
const
  Idx = OBMatchF;
begin
  if FileExists(DataPath + FileNames[Idx]) then
    DeleteFile(DataPath + FileNames[Idx]);

  Result := Make_File(F[Idx], DataPath + FileNames[Idx], FileSpecOfs[Idx]^, FileSpecLen[Idx]);
end;

// -----------------------------------------------------------------------------

function TOBMatchLink.InitFile: LongInt;
const
  Idx = OBMatchF;
begin
  Result := 0;
  try
    FillChar(OBMatchFile, FileSpecLen[Idx], 0);
    with OBMatchFile do
    begin
      FileSpecLen[Idx] := Sizeof(OBMatchFile);
      RecLen           := Sizeof(OBMatching);
      PageSize         := DefPageSize;
      NumIndex         := DiscNoOfKeys;

      Variable := B_Variable + B_Compress + B_BTrunc; {* Used for max compression *}

      { Key Definitions }

      { 00 - DocCode + PayRef }
      KeyBuff[1].KeyPos     := BtKeyPos(@OBMatching.DocCode, @OBMatching) + 1;
      KeyBuff[1].KeyLen     := SizeOf(OBMatching.DocCode) - 1;
      KeyBuff[1].KeyFlags   := ModSeg;

      KeyBuff[2].KeyPos     := BtKeyPos(@OBMatching.PayRef, @OBMatching) + 1;
      KeyBuff[2].KeyLen     := SizeOf(OBMatching.PayRef) - 1;
      KeyBuff[2].KeyFlags   := Modfy;

      AltColt := UpperALT;   { Definition for AutoConversion to UpperCase }

    end; { with OBMatchFile do... }

    FileRecLen[Idx]  := Sizeof(OBMatching);
    RecPtr[Idx]      := @OBMatching;
    FileSpecOfs[Idx] := @OBMatchFile;
    FileNames[Idx]   := 'SWAP\OB_MATCH.DAT';

    FillChar(OBMatching, FileRecLen[Idx], 0);
  except
    on E:Exception do
    begin
      Result := 255;
    end;
  end;
end;

// -----------------------------------------------------------------------------

procedure TOBMatchLink.Update(FromMatching: IMatching);
{ Updates the totals in the current Matching record, based on the totals from
  the supplied original Matching record }
begin

end;

// -----------------------------------------------------------------------------

// =============================================================================
// TCodeMap
// =============================================================================

procedure TCodeMap.Add(ID: string);
{ Adds a new entry against the specified ID, and assigns a unique code to it.
  Returns the index of the newly-added entry. }
var
  BaseCode: string;
  Code: string;
begin
  LastCode := LastCode + 1;
  BaseCode := Copy(ID, 1, 3);
  { Pad the code with 'A' rather than '0' so that there is no danger of
    conflicting with the OurRef of actual transactions }
  Code := BaseCode + RightJustify(IntToStr(LastCode), 'A', 7);
  List.Add(ID + '=' + Code);
end;

// -----------------------------------------------------------------------------

function TCodeMap.Code(DocType: DocTypes; CustCode: Str10; Currency: Byte;
  CtrlGL: Integer; Year: Byte): Str10;
var
  ID: string;
  Entry: Integer;
begin
  { Compile the supplied parameters into a single identifying code. }
  ID :=
    DocCodes[DocType] +
    RightJustify(CustCode, '0', 6) +
    IntToStr(Currency) +
    LeftJustify(IntToStr(CtrlGL), '0', 10) +
    LeftJustify(IntToStr(Year), '0', 3);

  { Locate an existing entry. }
  Entry := List.IndexOfName(ID);

  { If no entry is found, create a new code and add it to the list. }
  if (Entry = -1) then
    Add(ID);

  { Return the code. }
  Result := List.Values[ID];

end;

// -----------------------------------------------------------------------------

constructor TCodeMap.Create;
begin
  inherited Create;
  List := TStringList.Create;
end;

// -----------------------------------------------------------------------------

destructor TCodeMap.Destroy;
begin
  List.Free;
  inherited;
end;

// -----------------------------------------------------------------------------

procedure TCodeMap.Reset;
begin
  List.Clear;
  LastCode := 0;
end;

// =============================================================================
// TOBCrossReference
// =============================================================================

function TOBCrossReference.Add(OBalCode, OurRef: Str10): LongInt;
var
  Key: Str255;
begin
  Key := OBalCode;
  Result := Find_Rec(B_GetEq, F[OBRefF], OBRefF, OBRef, 0, Key);
  if ((Result = 4) or (Result = 9)) then
  begin
    FillChar(OBRef, SizeOf(OBRef), 0);
    OBRef.OBalCode  := OBalCode;
    OBRef.OurRef    := OurRef;
    Result := Add_Rec(F[OBRefF], OBRefF, OBRef, 0);
  end;
end;

// -----------------------------------------------------------------------------

function TOBCrossReference.CreateFile(DataPath: string): LongInt;
const
  Idx = OBRefF;
begin
  if FileExists(DataPath + FileNames[Idx]) then
    DeleteFile(DataPath + FileNames[Idx]);

  Result := Make_File(F[Idx], DataPath + FileNames[Idx], FileSpecOfs[Idx]^, FileSpecLen[Idx]);
end;

// -----------------------------------------------------------------------------

function TOBCrossReference.InitFile: LongInt;
const
  Idx = OBRefF;
begin
  Result := 0;
  try
    FillChar(OBRefFile, FileSpecLen[Idx], 0);
    with OBRefFile do
    begin
      FileSpecLen[Idx] := Sizeof(OBRefFile);
      RecLen           := Sizeof(OBRef);
      PageSize         := DefPageSize;
      NumIndex         := OBRefNoOfKeys;

      Variable := B_Variable + B_Compress + B_BTrunc; {* Used for max compression *}

      { Key Definitions }

      { 00 - OBalCode }
      KeyBuff[1].KeyPos     := BtKeyPos(@OBRef.OBalCode, @OBRef) + 1;
      KeyBuff[1].KeyLen     := SizeOf(OBRef.OBalCode) - 1;
      KeyBuff[1].KeyFlags   := Modfy;

      { 01 - OurRef }
      KeyBuff[2].KeyPos     := BtKeyPos(@OBRef.OurRef, @OBRef) + 1;
      KeyBuff[2].KeyLen     := SizeOf(OBRef.OurRef) - 1;
      KeyBuff[2].KeyFlags   := Modfy;

      AltColt := UpperALT;   { Definition for AutoConversion to UpperCase }

    end; { with OBRefFile do... }

    FileRecLen[Idx]  := Sizeof(OBRef);
    RecPtr[Idx]      := @OBRef;
    FileSpecOfs[Idx] := @OBRefFile;
    FileNames[Idx]   := 'SWAP\OB_REF.DAT';

    FillChar(OBRef, FileRecLen[Idx], 0);
  except
    on E:Exception do
    begin
      Result := 255;
    end;
  end;
end;

// -----------------------------------------------------------------------------

function TOBCrossReference.OurRef(ForOBalCode: Str10): Str10;
{ Returns the OurRef stored against the specified Opening Balance Code. Returns
  an empty string if no match can be found. }
var
  Key: Str255;
  FuncRes: LongInt;
begin
  Key := ForOBalCode;
  FuncRes := Find_Rec(B_GetEq, F[OBRefF], OBRefF, OBRef, 0, Key);
  if (FuncRes = 0) then
    Result := OBRef.OurRef
  else
    Result := '';
end;

// =============================================================================

initialization


  FCodeMap := nil;

// -----------------------------------------------------------------------------

finalization

  if (FCodeMap <> nil) then
  begin
    FCodeMap.Free;
    FCodeMap := nil;
  end;

// -----------------------------------------------------------------------------

end.
