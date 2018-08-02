unit uBTRecords;

interface

{$ALIGN 1}

type
  AddrTyp   =  Array[1..5] of String[30];
  Str80   =  String[80];
  LongDate =  String[8];
  Str255  =  String[255];
  //End GlobVar;

  TCustRec = record
    CustCode     : string[10];    (*  customer code *)
    CustSupp     : Char;          {* Customer / Supplier Flag *}
    Company      : string[45];    (*  Company Name *)
    AreaCode     : String[4];     {* Free Type Sort Field *}
    RepCode      : String[4];     {*   "   "    "     "   *}
    RemitCode    : String[10];    {* Account Code of Remit Account *}
    VATRegNo     : String[30];    {* VAT Registration No.  *}
    Addr         : AddrTyp;       {* Addr1-4 (Don't forget to alter Imp/Export) *}
    DespAddr     : Boolean;       {* Seaparete Despatch Address *}
    DAddr        : AddrTyp;       {* Despatch Addr1-4 *}
    Contact      : String[25];    {* Contact Name *}
    Phone        : string[30];    {* Phone No. *}
    Fax          : string[30];    {* Phone No. *}
    RefNo        : String[10];    {* Our Code with them *}
    TradTerm     : Boolean;
    STerms       : Array[1..2] of Str80;
    Currency     : Byte;
    VATCode      : Char;
    PayTerms     : SmallInt;
    CreditLimit  : Real;
    Discount     : Real;
    CreditStatus : SmallInt;
    CustCC       : String[3];
    CDiscCh      : Char;
    OrdConsMode  : Byte;
    DefSetDDays  : SmallInt;     {* Default Settlement discount Number of Days *}
    Spare5       : Array[1..2] of Byte;
    Balance      : Real;
    CustDep      : String[3];
    EECMember    : Boolean;       {* VAT Inclusion for EEC *}
    NLineCount   : LongInt;       {* Note Line Count       *}
    IncStat      : Boolean;       {* Include in Statement  *}
    DefNomCode   : LongInt;       {* Default Nominal Code  *}
    DefMLocStk   : String[3];     {* Default Multi Loc Stock *}
    AccStatus    : Byte;          {* On Hold, Closed, See notes *}
    PayType      : Char;          {* [B]acs,[C]ash *}
    BankSort     : String[15];     {* Bank Sort Code *}
    BankAcc      : String[20];     {* Bank Account No. *}
    BankRef      : String[28];    {* Bank additional ref, ie Build Soc.Acc *}
    AvePay       : SmallInt;       {* Average payment pattern *}
    Phone2       : String[30];    {* Second Phone No. *}
    DefCOSNom    : LongInt;       {* Override COS Nominal *}
    DefCtrlNom   : LongInt;       {* Override Default Ctrl Nominal *}
    LastUsed     : LongDate;      {* Date last updated *}
    UserDef1,
    UserDef2     : String[30];    {* User Definable strings *}
    SOPInvCode   : String[10];    {* Ent SOP Invoice Code *}
    SOPAutoWOff  : Boolean;       {* Auto write off Sales Order *}
    FDefPageNo   : Byte;          {* Use form def page for forms *}
    BOrdVal      : Double;        {* Heinz Book order value *}
    DirDeb       : Byte;          {* Current Direct Debit Mode *}
    CCDSDate     : LongDate;      {* Credit Card Start Date *}
    CCDEDate     : LongDate;      {* Credit Card End Date *}
    CCDName      : String[50];    {* Name on Credit Card *}
    CCDCardNo    : String[30];    {* Credit Card No. *}
    CCDSARef     : String[4];     {* Credit Card Switch Ref *}
    DefSetDisc   : Double;        {* Default Settlement Discount *}
    StatDMode    : Byte;
    Spare2       : String[50];
    EmlSndRdr    : Boolean;       {* On next email transmnision, send reader & reset *}
    ebusPwrd     : String[20];    {* ebusiness module web password *}
    PostCode     : String[20];    {* Seperate postcode ** Add index *}
    CustCode2    : String[20];    {* Alternative look up code, can be blank *}
    AllowWeb     : Byte;          {* Allow upload to Web *}
    EmlZipAtc    : Byte;          {* Default Zip attachement 0=no, 1= pkzip, 2= edz *}
    UserDef3,
    UserDef4     : String[30];    {* User Definable strings *}
    WebLiveCat   : String[20];         {Web current catalogue entry}
    WebPrevCat   : String[20];         {Web previous catalogue entry}
    TimeChange   : String[6];    {* Time stamp for record Change *}
    VATRetRegC   : String[5];
    SSDDelTerms  : String[5];     {*     "     Delivery Terms }
    CVATIncFlg   : Char;
    SSDModeTr    : Byte;
    PrivateRec   : Boolean;
    LastOpo      : String[10];
    InvDMode     : Byte;
    EmlSndHTML   : Boolean;
    EmailAddr    : String[100];
    SOPConsHO    : Byte;
    DefTagNo     : Byte;
    Spare        : Array[1..109] of Char;
  End; { CustRec }

  CCDepType =  Array[False..True] of String[3];  {  CC/Dep Type }

  TJobRec = record
 {002}       JobCode      :    String[10];         { Job Code }

 {013}       JobDesc      :    String[30];         { Job Short Description }

 {043}       JobFolio     :    LongInt;            { Unique Folio Number }
 {048}       CustCode     :    String[10];         { Customer }

 {059}       JobCat       :    String[10];         { Code of Parent on Tree }

 {070}       JobAltCode   :    String[10];         { Alternative search code}

 {080}       Completed    :    LongInt;            { Completed Status }
 {085}       Contact,
 {111}       JobMan       :    String[25];         { Contact/Job Manager's name }
 {136}       ChargeType   :    SmallInt;            { Numerical Equivalent of Charge type. T+M,+C,FP}
 {139}       Spare        :    String[10];         { Code of Parent on Tree }
 {149}       QuotePrice   :    Double;             { Fixed price quoted  }
 {157}       CurrPrice    :    Byte;               { Currency of fixed price }
 {159}       StartDate    :    String[8];           { Start Date }
 {168}       EndDate      :    String[8];           { End Date }
 {177}       RevEDate     :    String[8];           { Revised completion date }
 {186}       SORRef       :    String[10];         { Sales Order Number}

 {196}       NLineCount   :    LongInt;            { Note LineCount }
 {200}       ALineCount   :    LongInt;            { Anal LineCount }
 {205}       Spare3       :    String[10];         { !! }
 {215}       VATCode      :    Char;               { Default VAT Lookup }
 {217}       CCDep        :    CCDepType;          { Cost Centre / Dep Anal }
 {225}       JobAnal      :    String[3];          { Link to Job Type db }
 {228}       JobType      :    Char;               { Contract / Job / Phase }
 {229}       JobStat      :    LongInt;            { Visual Status }
 {234}       UserDef1     :    String[20];         { User def 1 string }
 {255}       UserDef2     :    String[20];         { User def 2 string }
 {276}       UserDef3     :    String[20];         { User def 3}
 {297}       UserDef4     :    String[20];         { User def 4}
 {317}       Spare2       :    Array[1..196] of Byte; {!!}
  end;

  DefMLNomType  =  Array[1..10] of LongInt;

  SaleBandsRec =  Record
    Currency   :  Byte;    { Currency of Band }
    SalesPrice :  Real;    { Price of Band    }
  end;

  SaleBandAry  =  Array[1..10] of SaleBandsRec;

  CurrTypes      =  Array[False..True] of Real;       {  CoRate/VATRate }

  { ================ Master Location Record ================ }
  {RecPFix = NoteTCode}
  MLocLocType    = Record
   {002}  loCode       :  String[10];   { Master Location Code }
   {012}  Spare        :  Array[1..20] of Byte;
   {033}  loName       :  String[45];   {    "       "    Name }
   {079}  Spare1       :  String[31];
   {111}  loAddr       :  array[1..5] of String[30];      { Address }
   {266}  loTel        :  String[25];   { Tel     }
   {292}  loFax        :  String[25];   { Fax     }
   {318}  loemail      :  String[100];  { email   }
   {419}  loModem      :  String[25];   {modem number }
   {445}  loContact    :  String[30];   { Contact   }
   {475}  loCurrency   :  Byte;         { Def Currency }
   {477}  loArea       :  String[5];    { Report Area }
   {483}  loRep        :  String[5];    { Report Rep  }
   {488}  loTag        :  Boolean;      { Tagged }
   {489}  loNominal    :  DefMLNomType; { Def Nom }
   {530}  loCCDep      :  CCDepType;    { Def CC Dep }
   {536}  loUsePrice   :  Boolean;      { Override Price }
   {537}  loUseNom     :  Boolean;      { Override Noms }
   {538}  loUseCCDep   :  Boolean;      { Override CCDep}
   {539}  loUseSupp    :  Boolean;      { Override Supplier}
   {540}  loUseBinLoc  :  Boolean;      { Override Bin Loc }
   {541}  loNLineCount :  LongInt;      { Notes Line Count }
   {545}  loUseCPrice  :  Boolean;      { Use Locations own cost price}
   {546}  loUseRPrice  :  Boolean;      { Use Locations own re-order price}
   {547}  loWOPWIPGL   :  LongInt;      { Override WIP GL}
   {551}  Spare2       :  Array[1..215] of Byte;
   {766}
  end;

  { ================ Stock Location Record ================ }
  {RecPFix = NoteTCode}
  MStkLocType    = Record
   {002}  lsCode1      :  String[30];   { Stock Code + Loc Code }
   {033}  lsCode2      :  String[45];   { Loc Code + Stock Code }
   {079}  lsCode3      :  String[31];   { Supplier + PCurrency + Stock Code }
   {111}  lsStkCode    :  String[20];   { Stock Code }
   {131}  lsStkFolio   :  LongInt;      {    "  Folio }
   {136}  lsLocCode    :  String[10];   { Loc Code }
   {146}  lsQtyInStock :  Double;       { Actual Stock }
   {154}  lsQtyOnOrder :  Double;       { OnOrder }
   {162}  lsQtyAlloc   :  Double;       { Allocated }
   {170}  lsQtyPicked  :  Double;       { Picked }
   {178}  lsQtyMin     :  Double;       { Min    }
   {186}  lsQtyMax     :  Double;       { Max    }
   {194}  lsQtyFreeze  :  Double;       { Freeze Qty }
   {202}  lsRoQty      :  Double;       { Re-Order Qty }
   {211}  lsRoDate     :  String[8];     { Re-Order Date }
   {220}  lsRoCCDep    :  CCDepType;    { Re-Order CC/Dep}
   {229}  lsCCDep      :  CCDepType;    { Default CC/Dep}
   {238}  lsBinLoc     :  String[10];   { Bin Location }
   {248}  lsSaleBands  :  SaleBandAry;  { Pricing }
   {318}  lsRoPrice    :  Double;       { Re-Order Price}
   {326}  lsRoCurrency :  Byte;         {     "    Currency}
   {327}  lsCostPrice  :  Double;       { Last Cost Price }
   {335}  lsPCurrency  :  Byte;         {     "     Currency}
   {336}  lsDefNom     :  DefMLNomType;
   {406}  lsStkFlg     :  Boolean;      { In Stk Take }
   {407}  lsMinFlg     :  Boolean;      { Below min Flg}
   {409}  lsTempSupp   :  String[10];   { Temp Supplier }
   {420}  lsSupplier   :  String[10];   { Main Suppplier}
   {431}  lsLastUsed   :  String[8];     { Last used rec }
   {439}  lsQtyPosted  :  Double;       { Posted loc qty }
   {447}  lsQtyTake    :  Double;       { Stock Take Qty }
   {455}  lsROFlg      :  Boolean;      { RO Flg }
   {457}  lsLastTime   :  String[6];    { Time last used }
   {463}  lsQtyAllocWOR:  Double;       { Allocated to WOR}
   {471}  lsQtyIssueWOR:  Double;       { Issued to WOR}
   {479}  lsQtyPickWOR :  Double;       { Picked on WOR}
   {487}  lsWOPWIPGL   :  LongInt;      { WIPGLCode}
   {491}  Spare2       :  Array[1..280] of Byte;
   {766}
  end;


  {RecPFix = NoteTCode}
  SdbStkType    = Record
   {002}  sdCode1      :  String[30];   { Supplier Stk Code }
   {033}  sdCode2      :  String[45];   { Stk Folio + sdCode1}
   {079}  sdCode3      :  String[31];   { sdFolio + Stock Folio}
   {110}  sdStkFolio   :  LongInt;      { Stock Link Folio }
   {114}  sdFolio      :  LongInt;      { Own Folio Link }
   {119}  sdSuppCode   :  String[10];   { Supplier Code}
   {130}  sdAltCode    :  String[20];   { Supplier Own Stock Code}
   {150}  sdROCurrency :  Byte;         { Re Order Curency }
   {151}  sdRoPrice    :  Double;       { Re-Order Price}
   {159}  sdNLineCount :  LongInt;      { Note Count }
   {164}  sdLastUsed   :  String[8];     { Last used }
   {172}  sdOverRO     :  Boolean;      { Overrride RO Price }
   {174}  sdDesc       :  String[35];   { General Description }
   {210}  sdLastTime   :  String[6];    { Updated Time }
   {216}  Spare2       :  Array[1..550] of Byte;
   {766}
  end;

  {RecPFix = MatchTCode}
  CuStkType    = Record
   {002}  csCode1      :  String[30];   { CustCode + Line No }
   {033}  csCode2      :  String[45];   { CustCode + Stock Code}
   {079}  csCode3      :  String[31];   { StockCode + CustCode }
   {111}  csCustCode   :  String[10];   { CustCode }
   {122}  csStockCode  :  String[20];   { Stock Code}
   {142}  csStkFolio   :  LongInt;      { Stock Folio}
   {146}  csSOQty      :  Double;       { Repeat Order }
   {155}  csLastDate   :  String[8];     { Last date accessed }
   {163}  csLineNo     :  LongInt;      { Display Order }
   {167}  csLastPrice  :  Double;       { Last unit price paid}
   {175}  csLPCurr     :  Byte;         { Last price currency }
   {177}  csJobCode    :  String[10];   { Line Job Code }
   {188}  csJACode     :  String[10];   {  "    "  Anal }
   {199}  csLocCode    :  String[5];    {  "   Loc Code }
   {204}  csNomCode    :  LongInt;      {  }
   {209}  csCCDep      :  CCDepType;
   {213}
   {216}  csQty        :  Double;
   {224}  csNetValue   :  Double;
   {232}  csDiscount   :  Double;
   {240}  csVATCode    :  Char;
   {241}  csCost       :  Double;
   {250}  csDesc       :  Array[1..6] of      { Multiple Descriptions }
                            String[35];
   {465}  csVAT        :  Double;
   {473}  csPrxPack    :  Boolean;
   {474}  csQtyPack    :  Double;
   {482}  csQtyMul     :  Double;
   {490}  csDiscCh     :  Char;
   {491}  csEntered    :  Boolean;
   {492}  csUsePack    :  Boolean;
   {493}  csShowCase   :  Boolean;
   {494}  csLineType   :  Byte;
   {495}  csPriceMulX  :  Double;
   {503}  csVATIncFlg  :  Char;        {* Rate on line is inclusive of this rate *}
   {504}  Spare2       :  Array[1..262] of Byte;
   {766}
  end;

  {RecPFix = MatchTCode}
  TeleCustType    = Record
   {002}  tcCode1      :  String[30];   { CustCode + Opo }
   {033}  tcCode2      :  String[45];   { NU }
   {079}  tcCode3      :  String[31];   { NU }
   {111}  tcCustCode   :  String[10];   { CustCode }
   {121}  tcDocType    :  Byte;         { Document Types }
   {122}  tcCurr       :  Byte;         { TeleSales Currency }
   {123}  tcCXrate     :  Array[false..true] of Real;  { Co/VAT Rates }
   {136}  tcYourRef    :  String[10];   { YourRef }
   {147}  tcLYRef      :  String[20];   { Long YourRef }
   {168}  tcCCDep      :  CCDepType;    { CC/Dep Defaults }
   {172}
   {176}  tcLocCode    :  String[5];    { Loc Code }
   {182}  tcJobCode    :  String[10];   { Job Code }
   {193}  tcJACode     :  String[10];   { Job Anal Code }
   {204}  tcDAddr      :  Array[1..5] of String[30];      { Delivery Address }
   {359}  tcTDate      :  String[8];     { Trans Date }
   {368}  tcDelDate    :  String[8];     { Delivery Date }
   {376}  tcNetTotal   :  Double;
   {384}  tcVATTotal   :  Double;
   {392}  tcDiscTotal  :  Double;
   {401}  tcLastOpo    :  String[10];
   {411}  tcInProg     :  Boolean;      { Internal still being processed flag }
   {412}  tcTransNat   :  Byte;        { VAT Nature of Transaction }
   {413}  tcTransMode  :  Byte;        { VAT Mode of Transport     }
   {415}  tcDelTerms   :  String[3];   {* VAT Delivery Terms *}
   {418}  tcCtrlCode   :  LongInt;     {* Dr Ctrl Code *}
   {422}  tcVATCode    :  Char;        {* Cust Default VAt Code *}
   {423}  tcOrdMode    :  Byte;        {* Default anal mode *}
   {424}  tcScaleMode  :  Byte;        {* Default Scale Mode *}
   {425}  tcLineCount  :  LongInt;     {* Total number of lines to be processed (}
   {429}  tcWasNew     :  Boolean;     {* Was new *}
   {430}  tcUseORate   :  Byte;        {* Forces the conversion routines to apply non tri rules *}
   {431}  tcDefNomCode :  LongInt;     {* Default G/L Nom Code *}
   {435}  tcVATIncFlg  :  Char;
   {436}  tcSetDisc    :  Double;      {* Default Settlement Discount *}
   {444}  tcGenMode    :  Byte;        {* 0 = Order, 1=Inv, 2=Quo *}
   {445}  Spare2       :  Array[1..321] of Byte;
   {766}
  end;

  {RecPFix = 'E' }
  EMUCnvType    = Record
   {002}  emCode1      :  String[30];   { FullNomKey / Account code }
   {033}  emCode2      :  String[45];   { Spare              }
   {079}  emCode3      :  String[31];   { Spare                }
   {110}  emWasCurr    :  LongInt;      { Original Currency }
   {114}  emWasCXRate  :  Array[false..true] of Real;      {    Orig  "    Rate }
   {126}  emNowRate    :  Array[false..true] of Real;      {    New   "    Rate }
   {139}  emDocRef     :  String[10];   { Doc Ref / Account Code}
   {149}  emNomCode    :  LongInt;      {G/L Reference }
   {153}  emOrigValue  :  Double;       { Its original base value }
   {161}  Spare        :  Array[1..605] of Byte;  {// Added missing of char (byte ?)}
   {766}
  end;

  {RecPFix = PassUCode }
  { == User default page  Use PassUCode +'D' to store == }
  tPassDefType  =  Record
  {002}   Login  :  String[30];
  {033}   Spare1    :  String[45];
  {079}   Ndx2      :  String[31];
  {110}   PWExpMode :  Byte;  { PW Expiry mode. 0= never, 1 = every x days, 2= expired}
  {111}   PWExPDays :  SmallInt; {No Days expiry interval}
  {114}   PWExpDate :  String[8]; {Date PW due to expire next}
  {123}   DirCust   :  String[10]; {Default Direct Cust}
  {134}   DirSupp   :  String[10]; {Default Direct Supplier}
  {144}   MaxSalesA :  Double;     {Max Authorised Sales value}
  {152}   MaxPurchA :  Double;     {Max Authorised Purch value}
  {161}   CCDep     :  CCDepType;  {Def Cc/Dep}
  {168}   Loc       :  String[10];
  {178}   SalesBank :  LongInt;    {Default SRC Bank}
  {182}   PurchBank :  LongInt;    {Default PPY Bank}
  {187}   ReportPrn :  String[50]; {Default Report Printer}
  {238}   FormPrn   :  String[50]; {Default Form Prn}
  {288}   OrPrns    :  Array[1..2] of Boolean;  {Force override of PRN's}
  {290}   CCDepRule :  Byte;  {CC/Dep override rules}
  {291}   LocRule   :  Byte;  {Loc Override Rules}
  {293}   emailAddr :  String[100]; {For paperless, send from email address}
  {393}   PWTimeOut :  SmallInt;  {Time out login after x mins, 0 = disabled}
  {395}   Loaded    :  Boolean;   {Record was found}
  {397}   UserName  :  String[50];
  {447}   UCPr      :  Byte;      {Users local period}
  {448}   UCYr      :  Byte;      {Users Local Year}
  {449}   UDispPrMnth  :  Boolean;   {Local display as months}
  {450}   Spare2    :  Array[1..316] of Byte;
  end;

  { ================ Allocation Ctrl Record =============== }
  {RecPFix =     MBACSCode   }
  {SubType = MBACSCtl}
  AllocCType= Record
  {002}   arcCode1     :  String[30];   { CustSupp + Custcode}
  {033}   arcCode2     :  String[45];   { Not used}
  {079}   arcCode3     :  String[31];   { Not used}
  {110}   arcBankNom   :  LongInt;      {  Bank Nominal }
  {114}   arcCtrlNom   :  LongInt;      {  MDC Control G/L}
  {118}   arcPayCurr   :  Byte;         {  Pay In Currency }
  {119}   arcInvCurr   :  Byte;         {  Filter Ledger Currency }
  {120}   Spare1       :  Array[1..4] of Byte;      {  CQ Number Start }
  {125}   arcCCDep     :  CCDepType;    {  Default CC/DEP }
  {129}   {Dep pos}
  {132}   arcSortBy    :  Byte;         {Sort ledger by. 0 = Transdate.
                                                         1 = DueDate
                                                         2 = Value A
                                                         3 = YourRef
                                                         4 = Currency
                                                         5 = OurRef}
  {133}   arcAutoTotal :  Boolean;      { Indicates that list will be
                                          caluclating total automatically based on allocations }
  {134}   arcSDDaysOver:  SmallInt;     {  Days we will go over settlemnt discount }
  {136}   arcFromTrans :  Boolean;      {  Are we allocating against an existing transaction }
  {138}   arcYourRef   :  String[10];
  {149}   arcChequeNo2 :  String[10];
  {159}   Spare3       :  Array[1..10] of Byte;
  {169}   arcForceNew  :  Boolean;      {Used to reset allocation databse when an incomplete
                                         allocation is restored}
  {170}   arcSort2By   :  Byte;         {Sort ledger by. 0 = Transdate.
                                                         1 = DueDate
                                                         2 = Value A
                                                         3 = Value D
                                                         4 = YourRef
                                                         5 = Currency
                                                         6 = OurRef}
  {171}   arcTotalOwn  :  Double;       {  Total allocated in own currency }
  {179}   arcTransValue:  Double;       {  Total value of amount to be allocated }
  {187}   arcTagCount  :  LongInt;      {  Total No. of Items in List }
  {192}   arcTagRunDate:  String[8];     {  Date of Payment }
  {200}   arcTagRunYr  :  Byte;         {  Year of Payment }
  {201}   arcTagRunPr  :  Byte;         {  Period of Payment }
  {203}   arcSRCPIRef  :  String[10];   {  Paying In Ref }
  {213}   arcIncSDisc  :  Boolean;      {  Include settlement discount in calcualtion }
  {214}   arcTotal     :  Double;       { Total allocated}
  {222}   arcVariance  :  Double;       { Total Variance available}
  {230}   arcSettleD   :  Double;       { Amount of settlement discount}
  {239}   arcTransDate :  String[8];     { Transaction date}
  {248}   arcUD1       :  String[30];   { User defined fields 1-4 }
  {279}   arcUD2       :  String[30];
  {310}   arcUD3       :  String[30];
  {341}   arcUD4       :  String[30];
  {372}   arcJobCode   :  String[10];   {Link to project code}
  {383}   arcAnalCode  :  String[10];   {Link to anal code}
  {394}   arcDelAddr   :  array[1..5] of String[30];      {Addional payment details}
  {549}   arcIncVar    :  Boolean;      {Allow over allocation for variance}
  {551}   arcOurRef    :  String[10];   {Link to ourref if called from ledger}
  {561}   arcCxRate    :  CurrTypes;    {Exchange rate of transaction}
  {574}   arcOpoName   :  String[10];   {Login current owner name}
  {585}   arcStartDate :  String[8];     {Date allocation commenced }
  {594}   arcStartTime :  String[6];    {Time allocation commenced }
  {601}   arcWinLogIn  :  String[50];   {Windows login}
  {651}   arcLocked    :  Byte;         {Flag to indicate allocation in progress by another user (2),
                                         or stored incomplete (1)}
  {652}   arcSalesMode :  Boolean;      {Cust or Supp}
  {654}   arcCustCode  :  String[10];   {Account Code}
  {664}   arcUseOSNdx  :  Boolean;      {Use new index}
  {665}   arcOwnTransValue  :  Double;       {Total of transaction in own currency}
  {673}   arcOwnSettleD  :  Double;       {Total of settlement discount in own currency}
  {681}   arcFinVar    :  Boolean;      {Take any surplus as variance}
  {682}   arcFinSetD   :  Boolean;      {Take any surplus as settlement Discount}
  {683}   arcSortD     :  Boolean;      {Sort Descending}
  {684}   Spare2       :  Array[1..5] of Byte;       {When dealing in form mode, amount originally settled
                                                      for sanity check}
  {689}   arcAllocFull :  Boolean;      {Indicates we are allocating all of the receipt to avoid anu rounding}
  {690}   arcCheckFail :  Boolean;      {Set when check has discovered altered tagged entries}
  {691}   arcCharge1GL :  LongInt;      {Additional charges split}
  {695}   arcCharge2GL :  LongInt;      {Additional charges split}
  {699}   arcCharge1Amt:  Double;       {Additional charges split}
  {707}   arcCharge2Amt:  Double;       {Additional charges split} 
  {715}   Spare        :  Array[1..51] of Byte;
  {766}
  end;

  TMLocRec = Record
    RecPfix   :  Char;         {  Record Prefix }
    SubType   :  Char;         {  Subsplit Record Type }

    Case SmallInt of
      1  :  (MLocLoc       :  MLocLocType);
      2  :  (MStkLoc       :  MStkLocType);
      3  :  (SdbStkRec     :  sdbStkType);
      4  :  (CuStkRec      :  CuStkType);
      5  :  (TeleSRec      :  TeleCustType);
      6  :  (EMUCnvRec     :  EMUCnvType);
      7  :  (PassDefRec    :  tPassDefType);
      8  :  (AllocCRec:  AllocCType);
  end;

implementation

end.
