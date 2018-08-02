const
  CustF       =  1;
  CNofKeys    =  6;
  CustCodeK   =  0;  {* Note swap of club & Cust k's *}
  CustCompK   =  1;
  CustClubK   =  2;
  CustAvalK   =  3;
  CustEditK   =  4;
  CustMTypK   =  5;
  CNofSegs    =  10;
type
  CustRec = record
{1}    CustCode    : string[10];    (* customer code *)
{13}    Company     : string[30];    (* Surname *)
{44}    FirstName   : string[20];    (* First Name*)
    UseNext     : Boolean;       (* Absolute Till No has become available *)
    TillNo      : Longint;       (* Internal Till No. *)
    ClubNo      : string[10];    (* Equivalent Club Systems No. *)
    CustSupp    : Char;          {* Customer / Supplier Seperator *}
    Addr        : AddrTyp;       {* Addr1-5 *}
    Phone       : string[25];
    Title       : string[20];
    DespAddr    : Boolean;       {* Separate Despatch Address *}
    ChrisName   : string[20];    {* Full First Name *}
    ChangeFlag  : Byte;          {* Update Till Marker *}
    VectronCardType : LongInt;       {* Membership Type }
    DOB         : Str8;          {* Date of Birth *}
    JoinDate    : Str8;          {* Original Joining Date *}
    JHandi      : string[10];    {* Original HandiCap *}
    CHandi      : string[10];    {* Current HandiCap *}
    MembStatus  : Byte;          {* Member Status *}
    Sex         : Char;          {* Member Sex *}
    OtherLink   : array[1..5] of string[10];
    LockerNo    : string[10];    {* Member Locker Number *}
    HomePhone   : string[20];    {* Home Tel No. *}
    Fax         : string[20];    {* Phone No. *}
    Hold        : Byte;
    CreditLimit : Real;
    CurrBalance : Real;          {* Calculated Balance *}
    PrevCBal    : Real;
    PrevBalls   : Real;
    Spare       : array[1..04] of Real;  {* Tmp Bal used during update *}
    CSRecNo     : LongInt;       {* Club Systems Record Addr *}
    Spare2      : array[1..2] of Byte;
    CSpent      : Real;          {* Spent This Yr to Date *}
    CPaid       : Real;          {* Paid In this Year *}
    LastDisc    : Real;          {* Record of Last Discount Used *}
    BBallBal    : Real;
    DRLimit     : Real;          {* Driving Range Limit *}
    PrevGBal    : Real;          {* Last Guest Usage Balance *}
    GuestBal    : Real;          {* Current Guest Balance *}
    GuestLimit  : Real;          {* Guest Usage Limit *}
    LineCount   : LongInt;       {* Notes Order Count *}
    EODFlg      : Boolean;
    SpecTit     : Boolean;       {* N/U *}
    Spare3      : array[1..3] Of Char;
    ClubCat     : string[2];     { Club Category }
    OrdDate     : Str8;          {* Date Last Ordered *}
    AllowCredit : Boolean;      { Allow card to go into debt without being put on hold }
    LastClubBal : Real;
    IssueNumber : byte;
    Spare8      : array[1..32] of Byte;          {* N/U *}
  end;

  Cust_FileDef = record
    RecLen    :  SmallInt;
    PageSize  :  SmallInt;
    NumIndex  :  SmallInt;
    NotUsed   :  LongInt;
    Variable  :  SmallInt;
    Reserved  :  array[1..4] of Char;
    KeyBuff   :  array[1..CNofSegs] of KeySpec;
    AltColt   :  AltColtSeq;
  end; { Cust_FileDef }

{ ============= Invoice Record ============== }

const
  InvF       =  2;
  INofKeys   =  6;
  InvCustK   =  0;
  InvOurRefK =  1;
  InvFolioK  =  2;
  InvInvDteK =  3;
  InvRunNoK  =  4;
  InvCustDK  =  5;
  INofSegs   =  10;
  EODInvCust = 'EODTIL';
  EODDocName = 'EOD';

type
  DocTypes = (SIN,SRC,SCR,SJI,SJC,SRF,SRI,SQU,SOA,SDN,SDG,NDG,OVT,DEB,PIN
  ,PPY,PCR,PJI,PJC,PRF,PPI,PQU,POR,PDN,SDT,NDT,IVT,CRE,NMT,ADJ,RUN,FOL,AFL
  ,ADC,ACQ,API,SKF);

const
  DocCodes      : array[DocTypes] of string[3]
                   = ('SIN','SRC','SCR','SJI','SJC','SRF','SRI','SQU','SOA','SDN','SDG',
                      'NDG','OVT','DEB','PIN','PPY','PCR','PJI','PJC','PRF','PPI','PQU',
                      'POR','PDN','SDT','NDT','IVT','CRE','NOM','ADJ','RUN','FOL','AFL',
                      'ADC','ACQ','API','SKF');

type
  InvSourceType = (isUnknown, isEodSpend, isEodVoid, isEodTopup, isFuncBook
  , isBillSplit, isEodTot);

  { Update Posting Report if changes made to this type }
  EodNumsType = (enNetTl,     enCaid,     enTopup,      enCQid,
                  enCd1,       enCd2,      enCd3,        enCd4,
                  enTaxAmt0,   enTaxAmt1,  enTaxAmt2,    enTaxAmt3,
                  enTaxAmt4,   enTax1,     enTax2,       enTax3,
                  enTax4,      en17,       en18,         en19,
                  en20,        en21,       en22,         en23,
                  en24,        en25,       en26,         en27);

  InvRec = record
     {02}     CustCode  :  string[10];  { Lookup Cust Code }
     {13}     OurRef    :  string[10];  { Doc Number }
     {23}     FolioNum  :  Longint;     { Audit No.}
     {28}     TransDate :  Str8;        { Doc Date }
     {35}     DueDate   :  Str8;        { Date DocDue }
     {41}     RunNo     :  LongInt;     { Invoice Run Number }
     {45}     FBookCat : Byte;
     {48}     Invoiced  :  Boolean;     { Picking List Flag }
              ILineCount:  LongInt;     { No of Lines for Positioning }
              InvDocHed :  DocTypes;    { Document Type }
              InvNetVal :  Real;        { Total Posting Value of Doc }
              InvVat    :  Real;        { Total VAT Content }
              Discount  :  Real;        { Discount Avail      }
              DiscAmount:  Real;        { Discount Amount     }
              PrevBal   :  Real;        { Previous Bal        }
              BBallPBal :  Real;        { Previous Bucket of Ball Balance }
              BBalls    :  Real;        { No. Balls used }
              Settled   :  Real;        { Amount Paid Off }
              HoldFlg   :  Byte;        { Master Order Status }
              PayType   :  Char;        { Payment Type }
              BGuestBal :  Real;        { Guest Usage }
              DiscSpent :  Real;        { Discount Spent }
              Spare2    :  string[4];  { !! }
              TransDesc :  string[30];  { Free format text }
              FBookCust :  string[6];   { CustCode for function booking }
              SpareReal :  Real;        { Discount allocated by split discounting }
              SepDisc   :  Boolean;     { Show discount separately in the incentive column }
              NomRef    :  string[10];  { reference to the NOM posted into Enterprise}
              Expansion :  string[37];  { Spare }
              { Has to be here so it is already 0, and is compatible with EODInvRec }
              Source    :  InvSourceType; { Source of Document }
            end;

   EodInvRec = record
     {02}     CustCode  :  string[10];    { Lookup Cust Code - EODInvCust }
     {13}     OurRef    :  string[10];    { Doc Number - EODDocName + Run Number }
     {23}     FolioNum  :  Longint;       { Audit No.}
     {28}     TransDate :  Str8;          { Doc Date }
     {35}     Spare     :  array [1..9] of Char;
     {41}     RunNo     :  LongInt;       { -ve Run Number }
              EODNums   :  array [enNetTl..en27] of Real;
              Source    :  InvSourceType; { Source of Document }
   end; { EodInvRec }

   Inv_FileDef = record
     RecLen,
     PageSize,
     NumIndex  :  SmallInt;
     NotUsed   :  LongInt;
     Variable  :  SmallInt;
     Reserved  :  array[1..4] of Char;
     KeyBuff   :  array[1..INofSegs] of KeySpec;
     AltColt   :  AltColtSeq;
   end;

{****************************************************************}
{*                                                              *}
{* Sales Details Record Definition                              *}
{*                                                              *}
{****************************************************************}
const
  sdNofKeys   = 5;
  sdFolioK    = 0;
  sdCardDateK = 1;
  sdTypeNoK   = 2;
  sdRunCardK  = 3;
  sdCardItemK = 4;
  sdNofSegs   = 14;
  SalesDetF   = 3;   { Unique to this program }

type
  SalesDetRecType = record
{2} sdCard     : string [6];
{8} sdFolioNum : LongInt;
{12}sdRunNo    : LongInt;
{17}sdDate     : Str8;
{25}sdType     : Char;
{26}sdNumber   : LongInt;
{31}sdName     : string [16];
{47}sdQuantity : Real;
{53}sdValue    : Real;
{59}sdDiscRate : Real;
{65}sdDiscount : Real;
{71}sdOrder    : SmallInt;
{73}sdPrevBal  : Real;
{79}sdSpare    : array [1..24] of Char;
  end; { SalesDetRecType }

  SalesDet_FileDef = record
    RecLen    : SmallInt;
    PageSize  : SmallInt;
    NumIndex  : SmallInt;
    NotUsed   : LongInt;
    Variable  : SmallInt;
    Reserved  : array [1..4] of Char;
    KeyBuff   : array [1..sdNofSegs] of KeySpec;
    AltColt   : AltColtSeq;
  end; { SalesDet_FileDef }


{****************************************************************}
{*                                                              *}
{* System Record Definition                                     *}
{*                                                              *}
{****************************************************************}
const
  SysF = 4;   { Unique to this program }
  NoCtrlNoms = 20;     { 6 in 1.xx versions }
  SNofKeys     =  0;
  SNofSegs     =  0;
  MaxNoTills     =  10;

type
  VatModeType = (vmNorm, vmAdv, vmDisc);

  TillDetRec = record
    Name    : string [15];
    IdCode  : string [8];
    Comms   : string [20];
  end; { TillDetRec }


  SysRec = record
    MonWk1     : Str8;         { Date Fin Year Started }
    NoDays     : smallint;      { Payment Terms }
    VatMode    : VatModeType;  { Vat Mode: Bormal, Advanced, Discounted }
    CSValNo    : Byte;         { Club systems Value field }
    Password   : string[8];    { Admin password }
    OpPassW    : string[8];    { Operator password }
    Opt        : Char;         { Timebomb flag }
    MergePath  : string[30];   { Club Systems path }
    ExPath     : string[30];   { Exchequer Path }
    CNoms      : array [1..NoCtrlNoms] of LongInt; { Control Nominals:
                                                       1     Cash Receipts
                                                       2     Renewals
                                                       3     Card Corrections
                                                       4     Forfeits
                                                       5     Members Card account
                                                       6     Discounts
                                                       7     Till Deposits
                                                       8     Sales
                                                       9..20 Unused}
    DefFiles   : array[1..3] of string[8];{  Definition Files
                                             1 - Spare
                                             2 - Spare
                                             3 - Statement Layout}
    TrigDate   : string[6];    { Trigger date for timebomb }
    UserName   : string[30];   { System username }
    NGuest     : LongInt;      { Next guest }
    MaxGuest   : LongInt;      { max guests }
    Markup     : Real;         { % bonus }
    NoTills    : smallint;      { no. of tills }
    ProTill    : smallint;      { Till no. for pro till }
    Till       : array[1..MaxNoTills] of TillDetRec;
    DummyFolio : LongInt;      { run no }
    MplxChar   : Char;         { control char for mux 1 }
    Mux2Char   : Char;         { Control char for mux 2 }
    DefDrLimit : smallint;      { Driving Range limit }
    DefGuLimit : smallint;      { Guest Limit }
    GuestTill  : Byte;         { Till no. for guest till }
    UpRead     : Boolean;
    UpWrite    : Boolean;
    UpPost     : Boolean;
    CSLPayAddr : Longint;      { Club - last payment address }
    AdvAccCode : string[6];
    EODTime    : string[5];    { auto eod time }
    BookCount  : Word;         { Temporary count for bookings to make index unique }
    UseMemBill : Boolean;
    UseSplDisc : Boolean;
    TopupDept  : LongInt;
    TopupDesc  : string[30];
    UseMarkup  : Boolean;      { Use markup as % on receipts }
    DefCredit  : Boolean;      { Default allow credit flag for users }
    HideEodLog : Boolean;      { Hide the EOD Error Log when printing the EOD reports }
    PrnGrSales : Boolean;      { Print Group Sales Report after EOD }
    ODDisc     : Boolean;      { Give discount when card is overdrawn }

    { MH: Added 23/07/96 for Club 2000 Link }
    Club2000     : Boolean;    { Using Club 2000 }
    LastEventIn  : LongInt;    { last event number imported }
    LastEventOut : LongInt;    { last event number exported }
    ImpLowerCase : Boolean;    { Allow lowercase in import }

    { MH: Added 09/02/97 for Check Invoice Details }
    ChkLastFolio : LongInt;

    { MH: Added 12/05/97 for Security Release Code }
    ExSecurity   : string[10];
    ExRelease    : string[10];
    RelDate      : Real;
    SecSet       : Boolean;    { Security has been initialised }

    { MH: Added 09/06/98 as a bodge for Blackmoor }
    GrSalCalcDisc: Boolean;    { Force Discount Calculation on Group Sales }

    { HM 16/10/98: Added new fields for use in v4.10 }
    LinkToExch   : Boolean;

    { HM 28/10/98: Added flag for new 4MB EPROMS }
    FourMbEproms : Boolean;

    { HM 17/11/98: Added ability to hide expired members on card reports }
    HideExpired  : Boolean;

    { HM 21/04/99: Added switch for 4Mb discounts }
    FourMbDiscs  : Boolean;

    { HM 25/05/99: Added switch to allow operator to perform Auto-EOD }
    OpoDoAutoEOD : Boolean;

    { HM 02/02/00: Added switch for Windows EOD to specify if PLU/Dept }
    {              are automatically downloaded prior to EOD           }
    EODDLoadPLU  : Boolean;

    { HM 14/03/00: Added switch for Windows EOD to do Till Sales reports }
    EODTillReps  : Boolean;

    { NF 10/10/00: Added switch for Card Toolkit - stops TillTran.Dat from being created}
    UsingCardToolkit  : Boolean;

    { NF 13/03/01: Added switch for Windows EOD to run Open Table report }
    EODShowTableRep : Boolean;

    DefaultCC : string[3];      {default cost centre for enterprise posting}
    DefaultDept : string[3];    {default department for enterprise posting}

    AssumeMUXSwitchesOK : boolean;

    UseIssueNumbers : boolean;

    Spare        : String[102];  { SPARE }
  End; { SysRec }

  Sys_FileDef = record
    RecLen    :  smallint;
    PageSize  :  smallint;
    NumIndex  :  smallint;
    NotUsed   :  LongInt;
    Variable  :  smallint;
    Reserved  :  array [1..4] of Char;
  end; { Sys_FileDef }


{****************************************************************}
{*                                                              *}
{* Saleable Items Record Definition                             *}
{*                                                              *}
{****************************************************************}
Const
  SiNofKeys  =  3;
  siTypeK    =  0;
  siGroupK   =  1;
  siNameK    =  2;
  siNofSegs  =  6;
  ItemF = 5;   { Unique to this program }

Type
  ItemRecType = Record
    siType     : Char;
    siNumber   : LongInt;
    siGroup    : LongInt;
    siName     : String [16];
    siOverride : Boolean;
    siDiscount : Real;
    siPrice    : Double;
//    siSpare    : Array [1..24] Of Char;
    siSpare    : Array [1..16] Of Char;
  End; { ItemRecType }

  Item_FileDef = Record
    RecLen    : smallint;
    PageSize  : smallint;
    NumIndex  : smallint;
    NotUsed   : LongInt;
    Variable  : smallint;
    Reserved  : Array [1..4] of Char;
    KeyBuff   : Array [1..siNofSegs] of KeySpec;
    AltColt   : AltColtSeq;
  End; { Item_FileDef }

{****************************************************************}
{*                                                              *}
{* Saleable Groups Record Definition                            *}
{*                                                              *}
{****************************************************************}
Const
  GrNofKeys  =  3;
  GrArrayK   =  0;
  GrNumberK  =  1;
  GrNameK    =  2;
  GrNofSegs  =  3;
  GroupF = 6;       { Unique to this program }


Type
  GroupRecType = Record
    grArrayNo  : LongInt;
    grName     : String [12];
    grNumber   : LongInt;
    grDiscount : Real;
    grSpare    : Array [1..24] Of Char;
  End; { GroupRecType }

  Group_FileDef = Record
    RecLen    : smallint;
    PageSize  : smallint;
    NumIndex  : smallint;
    NotUsed   : LongInt;
    Variable  : smallint;
    Reserved  : Array [1..4] of Char;
    KeyBuff   : Array [1..GrNofSegs] of KeySpec;
    AltColt   : AltColtSeq;
  End; { Group_FileDef }


{============================================ TILL SALES RECORD ====================================}

Const
  tsNofKeys  =  2;
  tsMainK   =  0;
  tsPLUK  =  1;
  tsNofSegs  =  4;
  TillSalesF = 7;       { Unique to this program }

type
  TillSalesPLU = Record
    tpGroupNo : byte;
    tpPLUNo : smallint;
    tpRunNo : LongInt;
    tpTillNo : byte;
    tpQty : double;
    tpAmount : double;
    tpDescription : string16;
    tpIndex2 : String20;
  end;{TillSalesPLU}

  TillSalesHourly = Record
    thHourNo : byte;
    thRunNo : LongInt;
    thTillNo : byte;
    thQty : double;
    thAmount : double;
    thSpare : array[1..19] of byte;
    thIndex2 : String20;
  end;{TillSalesHourly}

  TillSalesClerk = Record
    tcClerkNo : byte;
    tcRunNo : LongInt;
    tcDataType : byte;
    tcTillNo : byte;
    tcQty : double;
    tcAmount : double;
    tcDescription : string8;
    tcSpare : array[1..9] of byte;
    tcIndex2 : String20;
  end;{TillSalesClerk}

  TillSalesTrans = Record
    ttTillNo : byte;
    ttRunNo : LongInt;
    ttTransNo : smallint;
    ttQty : double;
    ttAmount : double;
    ttSpare : array[1..18] of byte;
    ttIndex2 : String20;
  end;{TillSalesTrans}

  TillSalesRec = record
    tsType    : char;
    tsIndex1 : String20;

    Case byte of
      1 : (tsPLU : TillSalesPLU;); {PLU Record}
      2 : (tsHourly : TillSalesHourly;); {Hourly Sales}
      3 : (tsClerk : TillSalesClerk;); {Clerk Data}
      4 : (tsTrans : TillSalesTrans;); {Transaction Data}
  end;{TillSalesRec}

  TillSales_FileDef = Record
    RecLen    : smallint;
    PageSize  : smallint;
    NumIndex  : smallint;
    NotUsed   : LongInt;
    Variable  : smallint;
    Reserved  : Array [1..4] of Char;
    KeyBuff   : Array [1..tsNofSegs] of KeySpec;
    AltColt   : AltColtSeq;
  End; { TillSales_FileDef }
