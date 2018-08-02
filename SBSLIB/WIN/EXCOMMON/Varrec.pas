{**************************************************************}
{                                                              }
{             ====----> E X C H E Q U E R <----===             }
{                                                              }
{                      Created : 18/10/92                      }
{                                                              }
{                  Variable Record Definitions                 }
{                                                              }
{               Copyright (C) 1992 by EAL & RGS                }
{        Credit given to Edward R. Rought & Thomas D. Hoops,   }
{                 &  Bob TechnoJock Ainsbury                   }
{**************************************************************}




  { ========= Customer Record ============== }

  (*  customer record definition *)

  { == Cust/Trader Details == }


  CustF       =  1;

  CustCodeK   =  0;
  CustCompK   =  1;
  CustCntyK   =  2;
  CustTelK    =  3;
  CustAltK    =  4;
  ATCodeK     =  5;
  ATCompK     =  6;
  ATAltK      =  7;
  CustPCodeK  =  8;
  CustRCodeK  =  9;
  CustInvToK  = 10;
  CustEmailK  = 11;

  //PR: 21/08/2013 MRD1.1.01 Added 4 new indexes for consumers
  CustACCodeK = 12; //SubType + AcCode
  CustLongACCodeK
              = 13; //SubType + LongAcCode
  CustNameK   = 14; //SubType + Company Name
  CustAltCodeK= 15; //SubType + AltCode

  CNofKeys    =  16; //12
  CNofSegs    =  26; //18


Type
  // MH 05/05/2015 v7.0.14 ABSEXCH-16284: PPD Mods
  TTraderPPDMode = ( pmPPDDisabled = 0,
                     pmPPDEnabledWithAutoJournalCreditNote = 1,
                     pmPPDEnabledWithAutoCreditNote = 2,
                     pmPPDEnabledWithManualCreditNote = 3 );

  //RB 14/11/2017 2018-R1 ABSEXCH-19346: GDPR - CustSupp Database Changes
  TEntityAnonymisationStatus = ( asNotRequested = 0,
                                 asPending = 1,
                                 asAnonymised = 2 );

  //SSK 15/11/2017 ABSEXCH-19352 : this enumerator added for GDPR Employee Changes
  TEmployeeStatus = (emsOpen = 0,
                     emsClosed = 1);
  //------------------------------

  CustRec = record
   {002}      CustCode   : string[10];    (*  customer code *)
   {012}      CustSupp   : Char;          {* Customer / Supplier Flag *}
   {014}      Company    : string[45];    (*  Company Name *)

   {060}      AreaCode   : String[4];     {* Free Type Sort Field *}
   {065}      RepCode    : String[4];     {*   "   "    "     "   *}
   {070}      RemitCode  : String[10];    {* Account Code of Remit Account *}
   {081}      VATRegNo   : String[30];    {* VAT Registration No.  *}

   {112}      Addr       : AddrTyp;       {* Addr1-4 (Don't forget to alter Imp/Export) *}

   {266}      DespAddr   : Boolean;       {* Seaparete Despatch Address *}
   {268}      DAddr      : AddrTyp;       {* Despatch Addr1-4 *}
   {423}      Contact    : String[25];    {* Contact Name *}
   {449}      Phone      : string[30];    {* Phone No. *}
              Fax        : string[30];    {* Phone No. *}
              RefNo      : String[10];    {* Our Code with them *}
              TradTerm   : Boolean;       {* Special Terms *}
              STerms     : TradeTermType; {* 2 Lines of Terms *}

              {* Defaults *}

              Currency   : Byte;
              VATCode    : Char;
              PayTerms   : SmallInt;
              CreditLimit: Real;
              Discount   : Real;

              {* Anal *}

              CreditStatus
                         : SmallInt;

              CustCC     : String[3];

              CDiscCh    : Char;
              OrdConsMode
                         : Byte;

              DefSetDDays: SmallInt;     {* Default Settlement discount Number of Days *}

              Spare5     : Array[1..2] of Byte;

              Balance    : Real;

              CustDep    : String[3];

              EECMember  : Boolean;       {* VAT Inclusion for EEC *}

              NLineCount : LongInt;       {* Note Line Count       *}
              IncStat    : Boolean;       {* Include in Statement  *}

              DefNomCode : LongInt;       {* Default Nominal Code  *}
              DefMLocStk : String[3];     {* Default Multi Loc Stock *}
              AccStatus  : Byte;          {* On Hold, Closed, See notes *}
              PayType    : Char;          {* [B]acs,[C]ash *}

              { CJS 2013-09-09 - ABSEXCH-14598 - SEPA/IBAN - copy from MRD branch }
              OldBankSort   : String[15];     {* Bank Sort Code *}
              OldBankAcc    : String[20];     {* Bank Account No. *}

              BankRef    : String[28];    {* Bank additional ref, ie Build Soc.Acc *}
              AvePay     : SmallInt;       {* Average payment pattern *}

              Phone2     : String[30];    {* Second Phone No. *}
              DefCOSNom  : LongInt;       {* Override COS Nominal *}
              DefCtrlNom : LongInt;       {* Override Default Ctrl Nominal *}
              LastUsed   : LongDate;      {* Date last updated *}
              UserDef1,
              UserDef2   : String[30];    {* User Definable strings *}
              SOPInvCode : String[10];    {* Ent SOP Invoice Code *}
              SOPAutoWOff: Boolean;       {* Auto write off Sales Order *}
              FDefPageNo : Byte;          {* Use form def page for forms *}
              BOrdVal    : Double;        {* Heinz Book order value *}
              DirDeb     : Byte;          {* Current Direct Debit Mode *}
              CCDSDate   : LongDate;      {* Credit Card Start Date *}
              CCDEDate   : LongDate;      {* Credit Card End Date *}
              CCDName    : String[50];    {* Name on Credit Card *}
              CCDCardNo  : String[30];    {* Credit Card No. *}
              CCDSARef   : String[4];     {* Credit Card Switch Ref *}
              DefSetDisc : Double;        {* Default Settlement Discount *}

              StatDMode: Byte;          {* Statement/Remittance delivery mode. 0 = Printed.
                                                                               1 = Fax
                                                                               2 = email *}
              Spare2   : String[50];
              EmlSndRdr: Boolean;       {* On next email transmnision, send reader & reset *}
              ebusPwrd : String[20];    {* ebusiness module web password *}
              PostCode : String[20];    {* Seperate postcode ** Add index *}
              CustCode2: String[20];    {* Alternative look up code, can be blank *}
              AllowWeb : Byte;          {* Allow upload to Web *}
              EmlZipAtc: Byte;          {* Default Zip attachement 0=no, 1= pkzip, 2= edz *}
              UserDef3,
              UserDef4 : String[30];    {* User Definable strings *}

              WebLiveCat
                       :    String[20];         {Web current catalogue entry}
              WebPrevCat
                       :    String[20];         {Web previous catalogue entry}

              TimeChange
                       :  String[6];    {* Time stamp for record Change *}

              VATRetRegC                {* Country of VAT registration *}
                       : String[5];
              SSDDelTerms
                       : String[5];     {*     "     Delivery Terms }

              CVATIncFlg
                       : Char;

              SSDModeTr: Byte;

              PrivateRec
                       : Boolean;

              LastOpo
                       : String[10];

              InvDMode : Byte;   {Invoice delivery mode}
              EmlSndHTML
                       : Boolean;{When sending XML, send HTML}

              EmailAddr: String[100];    {* Email address for Statment/ Remittance *}

              SOPConsHO: Byte;           {* If Head office, consolidate committed value *}
              DefTagNo : Byte;           {* Default Tag No for SOP/WOP *}

              // CJS 2011-09-29: ABSEXCH-11706 - New user-defined fields
              UserDef5  : String[30];
              UserDef6  : String[30];
              UserDef7  : String[30];
              UserDef8  : String[30];
              UserDef9  : String[30];
              UserDef10 : String[30];

              { CJS 2013-09-09: ABSEXCH-14598 - SEPA/IBAN Changes }
              acBankSortCode: string[22];       // Sort code / BIC (encrypted)
              acBankAccountCode: string[54];    // Account Code / IBAN Code (encrypted)
              acMandateID: string[54];          // Direct Debit Mandate Id (encrypted)
              acMandateDate: LongDate;          // Direct Debit Mandate Date

              // MH - 14/10/2013 - MRD2.5.01 - Delivery Post code
              acDeliveryPostCode: string[20];

              //PR: 21/08/2013 MRD1.1.01 Fields added to handle consumers
              acSubType : Char; //'C' - customer, 'S' - supplier, 'U' - consumer
              acLongACCode : string[30];

              // MH 21/07/2014: Order Payments
              acAllowOrderPayments: Boolean;
              acOrderPaymentsGLCode: LongInt;

              // MH 19/11/2014 Order Payments Credit Card ABSEXCH-15836: Added ISO Country Codes
              acCountry : String[2];            // Normal address Country Code (ISO 3166-1 alpha-2)
              acDeliveryCountry : String[2];    // Delivery address Country Code (ISO 3166-1 alpha-2)

              // MH 05/05/2015 v7.0.14 ABSEXCH-16284: PPD Mods
              acPPDMode : TTraderPPDMode;

              // CJS 2015-12-15 - 2016 R1 - Intrastat - A1.2 - new Trader Record field
              acDefaultToQR : Boolean;

              // MH 21/03/2016 2016-R2 ABSEXCH-17379: New Tax Region field for Multi-Region Tax
              acTaxRegion : LongInt;

              //RB 14/11/2017 2018-R1 ABSEXCH-19346: GDPR - CustSupp Database Changes
              acAnonymisationStatus : TEntityAnonymisationStatus;
              acAnonymisedDate : LongDate;    //YYYYMMDD
              acAnonymisedTime : String[6];   //HHMMSS
              {****************************************************************************}
              {**                                                                        **}
              {**  NOTE: Always add new fields into:                                     **}
              {**                                                                        **}
              {**          \Entrprse\Funcs\SQLTraders.pas                                **}
              {**                                                                        **}
              {****************************************************************************}
              Spare     : Array[1..294] of Char;
            end;




  Cust_FileDef = Record
          RecLen,
          PageSize,
          NumIndex  :  SmallInt;
          NotUsed   :  LongInt;
          Variable  :  SmallInt;
          Reserved  :  array[1..4] of Char;
          KeyBuff   :  array[1..CNofSegs] of KeySpec;
          AltColt   :  AltColtSeq;
        end;



  Const
    { ======= Document Constants ======= }

    InvF       =  2;

    
    InvRNoK    =  0;
    InvCustK   =  1;
    InvOurRefK =  2;
    InvFolioK  =  3;
    InvCDueK   =  4;
    InvVATK    =  5;
    InvYrRefK  =  6;
    InvBatchK  =  7;
    InvLYRefK  =  8;
    InvDateK   =  9;
    InvYrPrK   = 10;
    InvOSK     = 11;
    InvCISK    =  12;
    InvCustLedgK = 13;  // MHCL
    // MH 21/03/2016 2016-R2 ABSEXCH-17379: New Tax Region Index for Multi-Region Tax
    InvTaxRegionK = 14;  // thTaxRegion + VATPostDate + OurRef

    INofKeys   =  15;  // MH 21/03/2016 2016-R2 ABSEXCH-17379: New Tax Region Index for Multi-Region Tax

    INofSegs   =  30;  // MH 21/03/2016 2016-R2 ABSEXCH-17379: New Tax Region Index for Multi-Region Tax

    GECu       =  05; {* Normaly a String is -2, but inorder for it to recognise this
                         as part of the key, and thus not search until the end of the file
                         must be presented as an array of Str *}
    GEINA      =  15;
    GEIYr      =  32;
    GEIPr      =  33;
    GEICr      =  31;
    GEIAl      =  98;  {* Get Extended Allocation status *}
    GEIRN      =  00;  {* Get Etended Run No *}
    GEIOR      =  17;  {* Match on Run No *}
    GEIAD      = 524;  {* Setting for Until Date *}
    GEICS      =  61;  {* Cust Supp Filter *}


    // MH 21/07/2014: Order Payments - Constants for thOrderPaymentFlags bit field values
    // PKR. 24/07/2015. thopfCreditCardAuthorisationTaken now means Card Authentication.
    thopfPaymentTaken                 = 1;  // Payment Taken
    thopfCreditCardAuthorisationTaken = 2;  // Credit Card Authentication done
    thopfCreditCardPaymentTaken       = 4;  // Credit Card Payment Taken

  Type
    // MH 21/07/2014: Order Payments
    enumOrderPaymentElement = (
                                opeNA = 0,
                                opeOrder = 1,
                                opeDeliveryNote = 2,
                                opeInvoice = 3,
                                opeOrderPayment = 4,
                                opeDeliveryPayment = 5,
                                opeInvoicePayment = 6,
                                opeOrderRefund = 7,
                                opeInvoiceRefund = 8
                              );

  Const
    OrderPayment_PaymentSet = [opeOrderPayment, opeDeliveryPayment, opeInvoicePayment];
    OrderPayment_RefundSet = [opeOrderRefund, opeInvoiceRefund];
    OrderPayment_PaymentAndRefundSet = OrderPayment_PaymentSet + OrderPayment_RefundSet;

  Type
    // MH 05/05/2015 v7.0.14 ABSEXCH-16284: PPD Mods
    TTransactionPPDTakenStatus = ( ptPPDNotTaken = 0,
                                   ptPPDTaken = 1,
                                   ptPPDTakenOutsideTerms = 2 );

    //------------------------------

    InvRec = record
      {001}     RunNo     :  Longint;     { Posted Run No.
                                           -100   = Temp holding line for Multiple Dr/Cr Ctrl Accounts
                                            -62   = WOP, Posted WOR
                                            -60   = WOP, Unposted WOR. 

                                            -53   = POP Temp store during auto generation
                                            -52   = POP Daybook posted
                                            -51   = POP Daybook Auto unposted
                                            -50   = POP Daybook unposted

                                            -43   = SOP Temp store during auto generation
                                            -42   = SOP Daybook Posted
                                            -41   = SOP Daybook Auto Unposted
                                            -40   = SOP Daybook unposted

                                            -35   = Posted Time Sheet Entry

                                            -30   = Posted Stk Adj Doc Header.
                                            -21   = Stk Valuation line
                                            -20   = Stk Valuation reverse line
                                            -19   = Self Billing Temp store during auto generation
                                            -18   = Timesheet post Temp lines
                                            -17   = Job Close Nom

                                            -11   = Posted Batch Header
                                            -10   = Doc Batch Member

                                            -5    = PayIn Id Ctrl RunNo

                                            -1/-2 = auto Item,

                                            0     = Daybook,

                                            >0    = posted run }

      {006}     CustCode  :  String[10];  { Lookup Cust Code }
      {016}     NomAuto   :  Boolean;     { Auto Day book flag }
      {018}     OurRef    :  String[10];  { Doc Number }
      {028}     FolioNum  :  Longint;     { Audit No.}
      {032}     Currency  :  Byte;        { Currency of Document }
      {033/034} AcYr,AcPr :  Byte;        { Posting Period & Yr }
      {036}     DueDate   :  LongDate;    { Date DocDue }
      {045}     VATPostDate
                          :  LongDate;    { Vat Period Posting Date }

      {054}     TransDate :  LongDate;    { Doc Date }
      {062}     CustSupp  :  Char;        { Cust/Supplier char, to differentiate between Payments / Reciepts Due }
                                          {Normaly, 'C' ,or 'S' for fin trans. 'O', 'P' for ?OR. 'J' for J?A, K for J?T}
      {063}     CXrate    :  CurrTypes;   { Co/VAT Rates }
      {076}     OldYourRef   :  String[10];  { Customers Ref before v6.00}
                
      {087}     BatchLink :  String[12];  { Batch No. Link Up Key }
                                          { Used also on SPOP to reprint Delivery notes/Invoices by runno }
                                          { and On time sheets to record employee code }
                                          { and on J?? to record employee}

      {099}     AllocStat :  Char;        { Allocation status for shorter Search , P=Purch unalloc}
      {100}     ILineCount:  LongInt;     { SOP Mode Invoice line count }
      {104}     NLineCount:  LongInt;     { Notes Line count }

      {108}     InvDocHed :  DocTypes;    { Document Type }

      {109}     InvVatAnal:  Array[VATType] of
                             Real;        { Analysis of VAT Anal }

      {211}     InvNetVal :  Real;        { Total Posting Value of Doc }

      {247}     InvVat    :  Real;        { Total VAT Content }

      {253}     DiscSetl  :  Real;        { Discount Avail/Take }
      {259}     DiscSetAm :  Real;        { Actual Value of Setle Discount }
      {265}     DiscAmount:  Real;        { Discount Amount     }
      {271}     DiscDays  :  SmallInt;     { No Days Disc Avail }
      {273}     DiscTaken :  Boolean;     { Discount Taken }

      {274}     Settled   :  Real;        { Amount Paid Off }
      {280}     AutoInc   :  SmallInt;     { Automatic Document Increment }

      {281}     UnYr,UnPr :  Byte;        { Auto Until Period }
      {282}     TransNat  :  Byte;        { VAT Nature of Transaction }
      {283}     TransMode :  Byte;        { VAT Mode of Transport     }
      {285}     RemitNo   :  String[10];  { Doc No of Coressponding Payment / Recipt / Order }

      {295}     AutoIncBy :  Char;        { Type of Automatic Increment Date or Period }

      {296}     HoldFlg   :  Byte;        { Hold Status }
      {297}     AuditFlg  :  Boolean;     { Is Doc Purgable }
      {298}     TotalWeight
                          :  Real;        { Order Weight Details }
      {305}     DAddr     :  AddrTyp;     { Delivery Address }
      {459}     Variance  :  Real;        { Currency Exchabge Loss/ Gain }

                                          { Order Details on Invoice }
      {465}     TotalOrdered,             { Receipt / NTxfr, Unrounded Base Equivalent of line totals , used to suggest value }
      {471}     TotalReserved,            {    "    Total amount of Variance }
      {477}     TotalCost,                { Total value of cost prices for profitablity *}
      {483}     TotalInvoiced             { Receipt Total rounded Base Equivalent of line totals, used to calculate Required }
                          :  Real;
      {490}     TransDesc :  String[20];  { Free format text }

      {511}     UntilDate :  LongDate;    { Auto Until Date  }

      {519}     NOMVATIO  :  Char;        { * Determins if a NOM is an input ot output journal. N/A=0, I=1, O=2 VAT}



      {520}     ExternalDoc
                          :  Boolean;     {* This is an externaly created Document, no edit allowed *}

      {521}     PrintedDoc
                          :  Boolean;     {* This Document has been printed *}

      {522}     ReValueAdj:  Real;        {* Adjustment needed to make
                                             Base Equiv = Total+VAT @ Co. Rate
                                             after revaluation *}
      {528}     CurrSettled
                          :  Real;        {* Docs Own Setttled rate *}

      {534}     SettledVAT
                          :  Real;        {* Amount recorded as settled during last VAT Return (Cash Accounting) *}

      {540}     VATClaimed
                          :  Real;        {* Total VAT presented as at last VAT Return (Cash Accounting) *}

      {546}     BatchNom  :  LongInt;     {* Batch Payment Nominal *}

      {550}     AutoPost  :  Boolean;     {* Pickup Auto item on Daybook post  *}
                                          {* Also used to indicate Nom Generated automaticly by system *}

      {551}     ManVAT    :  Boolean;     {* If Set, prevents re-calclation of VAT *}

      {553}     DelTerms  :  String[3];   {* VAT Delivery Terms *}

      {558}     OnPickRun :  Boolean;     {* Included in picking run
                                           v5.52. For Auto items indicates date is to be maintained by period increment*}

      {560}     OpName    :  String[10];  {* Operators User Name *}

      {570}     NoLabels  :  SmallInt;     {* No. of labels to print *}

      {571}     {$IFDEF WIN32}
                  Tagged    :  Byte;         {* Doc Marked for something *}
                {$ELSE}
                  Tagged    :  Boolean;
                {$ENDIF}

      {572}     PickRunNo :  LongInt;     {* Flag to indicate inclusion on picking list *}

      {576}     OrdMatch  :  Boolean;     {* Flag to indicate we have a match on order set up *}

      {578}     DeliverRef:  String[10];  {* Store Delivery notes Number link *}

      {588}     VATCRate  :  CurrTypes;   {* Exchange Rate for Calculating VAT if VAT return is in any
                                             currency other than 0 *}

      {600}     OrigRates :  CurrTypes;

      {612}     PostDiscAm:  Double;      {* Posted Discount taken/given *}
      {620}     FRNomCode :  LongInt;     {* Spare *}
      {624}     PDiscTaken:  Boolean;     {* Posted Settlement Discount Taken *}

      {625}     CtrlNom   :  Longint;     {* Debtor/Creditor Control Nominal *}

      {627}     DJobCode  :  String[10];  {* Default Document Job Code *}
      {638}     DJobAnal  :  String[10];  {* Default Document Anal Code *}

      {648}     TotOrdOS  :  Real;        {* Value of Order Outstanding/ Temp Aged Debt Value *}

      {654}     FRCCDep   :  CCDepType;   {* Spare *}

      {636}     DocUser1,
      {647}     DocUser2  : String[30];   {* User def fields *}

      {687}     DocLSplit : Array[1..6] of{* Store makeup of line totals *}
                            Double;

      {735}     LastLetter: Byte;
      {736}     BatchNow,
                BatchThen
                          : Double;       {* Part allocation value in Batch payments *}
      {752}     UnTagged  : Boolean;      {* Exclude from BACS Indicator, also used on NOMs to indicate
                                             auto reversing from v4.31+ *}

      {753}     OBaseEquiv: Double;       {* Pre EMU conversion base value }
      {761}     UseORate  : Byte;         {* Forces the conversion routines to apply non tri rules *}
      {762}     OldORates : CurrTypes;    {* After euro conversion, very original rates are shown *}
      {774}     SOPKeepRate
                          : Boolean;      {* When converting through SOP process, use original order rate *}

      {776}     DocUser3,
      {797}     DocUser4  : String[30];   {* User def fields *}
      {818}     SSDProcess: Char;         {* SSD process flag *}
      {819}     ExtSource : Byte;         {* If transaction created externaly where from *}

      {820}     CurrTriR  : TriCurType;   {* Details of Main Triangulation *}

      {841}     VATTriR   : TriCurType;   {* Details of VAT Triangulation *}

      {862}     OrigTriR  : TriCurType;   {* Details of Orig Triangulation *}

      {883}     OldORTriR : TriCurType;   {* Details of Old pre euro base Triangulation *}

      {905}     PostDate  : LongDate;     {* Date posted, used for EC + SSD *}

      {913}     PORPickSOR: Boolean;      {* Back to Back SOR/POR auto picks SOR *}

      {914}     BDiscount : Double;       {* Amount of discount applied via batch *}

      {922}     PrePostFlg: Byte;         {* Used to indicate on Noms if posting should generate any associated
                                             transactions, for example, if an auto reversing NOM should generate
                                             its auto reversal *}
      {923}     AuthAmnt  : Double;       {* Amount authorised when last stored *}

      {932}     TimeChange: String[6];    {* Last time transaction changed}
      {939}     TimeCreate: String[6];    {* Time transaction created}


        {945}    CISTax   : Double;       {*Total amount of CIS tax to be deducted *}
        {953}    CISDeclared
                          : Double;       {* Total amount of CIS declared on vouchers, correlates to
                                             Currsettled at time of voucher production *}
        {961}    CISManualTax
                          : Boolean;      {* Tax was overridden by manual adjustment, do not auto calculate *}
        {963}    CISDate  : LongDate;     {* Date of next voucher run *}
        {971}    TotalCost2
                          : Double;       {* Cost appotrionment from outside costs, included in GP *}
        {980}    CISEmpl  : String[10];   {* Employe code used for this CIS Entry *}

        {990}    CISGross : Double;       {* Basis of CIS Tax *}

        {998}    CISHolder: Byte;         {* >0 Document is a CIS carrier generated from another process like
                                             self billing (2) or retentions (1) or Applications 3.
                                             Has no lines of its own which would generate CIS, but is required
                                             to place in CIS returns *}
         {999}   THExportedFlag
                        : Boolean;      {* Flag to indicate timesheet exported *}

         {1000}   CISGExclude         {* Amount to be exluded from gross calucaltion *}
                        : Double;
//         {1008}   Spare5   : Array[1..64] of Byte;        {* !! *}

                  // MH 01/02/2010 (v6.3) Added new fields for Web Extensions
                  thWeekMonth : SmallInt;
                  thWorkflowState : LongInt;

                  // MH 11/10/2010 v6.5: Added for Override Location (for LIVE)
                  thOverrideLocation : String[3];

                  Spare5   : Array[1..54] of Byte;

                  YourRef   :  String[20];  { Customers Ref from v6.00}

                  // CJS 2011-09-29: ABSEXCH-11712/ABSEXCH-11719 - New Transaction Header Udef Fields
                  DocUser5  : String[30];   {* User def fields *}
                  DocUser6  : String[30];   {* User def fields *}
                  DocUser7  : String[30];   {* User def fields *}
                  DocUser8  : String[30];   {* User def fields *}
                  DocUser9  : String[30];   {* User def fields *}
                  DocUser10 : String[30];   {* User def fields *}

                  // MH 14/10/2013 - MRD2.5.02 - Delivery Post code
                  thDeliveryPostCode: string[20];

                  // MH 14/10/2013 - MRD2.6.02 - Transaction Originator
                  thOriginator   : String[36]; // Exchequer User Id
                  thCreationTime : String[6];  // HHMMSS
                  thCreationDate : String[8];  // YYYYMMDD

                  // MH 21/07/2014 Exch2015R1: Order Payments
                  thOrderPaymentOrderRef : String[10];              // OurRef of parent Order for SDN/SIN/SRC in Order Payments subsystem
                  thOrderPaymentElement : enumOrderPaymentElement;  // The type of transaction in Order Payments subsystem, e.g. Order Payment
                  thOrderPaymentFlags : Byte;                       // bit field - see thopfXXX constants above for values
                  thCreditCardType : String[4];                     // Credit Card Payment Details (on Payment SRC only)
                  thCreditCardNumber : String[4];                   // Credit Card Payment Details (on Payment SRC only) - Last 4 digits only
                  thCreditCardExpiry : String[4];                   // Credit Card Payment Details (on Payment SRC only) - MMYY format
                  thCreditCardAuthorisationNo : String[20];         // Credit Card Payment Details (on Payment SRC only)
                  thCreditCardReferenceNo : String[70];             // Credit Card Payment Details (on Payment SRC, and SOR after Card Authentication)
                  thCustomData1 : String[30];                       // for bespoke

                  // MH 19/11/2014 Exch2015R1 ABSEXCH-15836: Added ISO Country Code
                  thDeliveryCountry : String[2];                    // Delivery address Country Code (ISO 3166-1 alpha-2)

                  // MH 20/03/2015 v7.0.14 ABSEXCH-16284: Added new fields for Prompt Payment Discount
                  thPPDPercentage : Double;   // Discount Percentage - Note: 0.1 = 10%
                  thPPDDays       : SmallInt; // Number of days discount offer is valid for
                  thPPDGoodsValue : Double;   // Goods Value of Discount (if taken) in Transaction Currency
                  thPPDVATValue   : Double;   // VAT Value of Discount (if taken) in Transaction Currency
                  // MH 05/05/2015 v7.0.14 ABSEXCH-16284: PPD Mods
                  thPPDTaken      : TTransactionPPDTakenStatus;  // Indicates if Prompt Payment Discount was given
                  thPPDCreditNote : Boolean;                     // TRUE if this is a Credit Note created for PPD
                  thBatchPayPPDStatus : Byte;                    // PPD Status Flag for Batch Payments (0 = not flagged for give/take, 1 = flagged for give/take)

                  // CJS 2015-12-15 - 2016 R1 - Intrastat - A1.3 - new Transaction Header (Document) field
                  thIntrastatOutOfPeriod : Boolean;   // Intrastat Out of Period Transaction

                  // MH 21/03/2016 2016-R2 ABSEXCH-17378: New Udef Fields for eRCT
                  thUserField11 : String[30];   {* User def fields *}
                  thUserField12 : String[30];   {* User def fields *}

                  // MH 21/03/2016 2016-R2 ABSEXCH-17379: New Tax Region field for Multi-Region Tax
                  thTaxRegion : LongInt;

                  //RB 17/11/2017 2018-R1 ABSEXCH-19347: GDPR - Document.Dat Database Changes
                  // Transaction has been anonymised
                  thAnonymised : Boolean;
                  thAnonymisedDate : LongDate;     // YYYYMMDD
                  thAnonymisedTime : String[6];    // HHMMSS 

                  {****************************************************************************}
                  {**                                                                        **}
                  {**  NOTE: Always add new fields into:                                     **}
                  {**                                                                        **}
                  {**          \Entrprse\Funcs\SQLTransactions.pas                           **}
                  {**          \Entrprse\Funcs\SQLReorderQuery.pas                           **}
                  {**                                                                        **}
                  {****************************************************************************}
                  Spare600  : Array[1..273] of Byte;        {* !! *}
              end;

   //------------------------------

   Inv_FileDef = Record
          RecLen,
          PageSize,
          NumIndex  :  SmallInt;
          NotUsed   :  LongInt;
          Variable  :  SmallInt;
          Reserved  :  array[1..4] of Char;
          KeyBuff   :  array[1..INofSegs] of KeySpec;
          AltColt   :  AltColtSeq;
        end;




   { ===============   Detail Line  ==================== }


Const

  IdetailF   =  3;

  IdNofKeys  =  13;   // SSK 07/05/2018 2018 R1.1 ABSEXCH-19886: noOfIndexes changes from 10 to 13 to include indexes added later on
  IdFolioK   =  0;
  IdRunK     =  1;
  IdNomk     =  2;
  IdStkK     =  3;
  IdAnalK    =  4;
  IdLinkK    =  5;
  IdCAnalK   =  6;
  IdReconK   =  7;
  IdStkLedgK =  8; // MHSL
  IdServiceK =  9; // v6.2 EC & Reverse Charge Services
  // CJS 2014-01-06 - ABSEXCH-14854 - new indexes (10 - 12)
  IdCustCodeK = 10; // Trader Code
  IdDocPRefK  = 11; // Document Ref
  IdYrPrK     = 12; // Year/Period

  IdNofSegs  =  32;

  {* Field Pos for Get Extended Filtering 1 less normal count *}


  GEPostedRun=  08;
  GENomCode  =  12;
  GECC       =  24; {* 1 extra less for string, as search is always padded to full length *}
  GEDep      =  20; {*     "               "         "                                    *}
  GEPYr      =  18;
  GEPPr      =  19;
  GEPCr      =  17;
  GEPNm      =  16;
  GEStkC     =  29; {* Only -1 since no match on Str len takes place *}
  GEIDCU     = 117;
  GEIDDE     = 141; {* Only -1 since no match on Str len takes place *}
  GEIDRC     =  96;
  GEIDLT     =  53;
  GEIDLN     =  04;
  GEIDML     = 259; {* 1 extra, as search always padded to 3 including STR len *}
  GEIDRD     = 308;


  {Note as of v4.31.005, the back to back wizard uses temprary line numbers in the range -2E6 to -1E6 to create
  the Purchase kit marker lines}

Type


   IDetail = Record
    {01}      FolioRef   :  LongInt;     { Link to Doc Header }
    {05}      LineNo     :  LongInt;     { Array / Line No}
    {09}      PostedRun  :  LongInt;     { Posting Run No }
    {13}      NomCode    :  LongInt;     { Nominal Code }
    {17}      NomMode    :  Byte;        { Nominal Analysis Used to determine what appears inside Nom Reconciliation }
    {18}      Currency   :  Byte;        { Doc Currency }
    {19}      PYr,
    {20}      PPr        :  Byte;        { Period & Year }

    {22}      CCDep      :  CCDepType;   { Cost Center / Analysis }
    {26}


    {30}      StockCode  :  String[20];  { Stock Code }
    {50}      ABSLineNo  :  LongInt;     { Absolute, non moveable line no. *}
    {54}      LineType   :  Char;        { Index Filtering system }
    {55}      IdDocHed   :  DocTypes;    { Document Type }
    {56}      DLLUpdate  :  Byte;        { Flag to indicated rec being editied by DLL Toolkit! }
    {57}      OldSerQty  :  SmallInt;     { No of Serial Items Required }

    {59}      Qty        :  Real;        { Qty!}
    {65}      QtyMul     :  Real;        { Item Multiplier Factor }
    {71}      NetValue   :  Real;        { Line Total Sans VAT }
    {77}      Discount   :  Real;        { Amount/% }
    {83}      VATCode    :  Char;        { VATCode }
    {84}      VAT        :  Real;        { Line Content }
    {90}      Payment    :  Char;        { Line Type ie iNvoice, paY, Journal .. }
    {91}      OldPBal    :  Real;        { Nominal Value Before Posting as of v4.31, now spare! }
                                         { Also used to temporarily store the amount picked on bom
                                           Control lines during a picking run}
    {97}      Reconcile  :  Byte;        { Status of item for reconciling ie cleared etc }
    {98}      DiscountChr:  Char;        { Flag to indicate if disc is amount or % }
    {99}      QtyWOFF,                   { Total Qty WOFF }
   {105}      QtyDel,                    { Total Qty Physicaly delivered +WOFF - Qty = OS }
   {111}      CostPrice  :  Real;
   {118}      CustCode   :  String[10];  { Trader Code }
   {129}      PDate      :  LongDate;
   {138}      Item       :  String[3];
   {142}      Desc       :  String[60];  { Line Desc }
   {203}      JobCode    :  String[10];  { Job Code }
   {214}      AnalCode   :  String[10];  { Job AnalCode }
   {224}      CXrate     :  CurrTypes;   { Co/VAT Rates }
   {236}      LWeight    :  Real;        { Weight of Sales Unit }
   {242}      DeductQty  :  Real;
   {248}      KitLink    :  LongInt;     { Folio No. of parent Stock code for kit line }
   {252}      SOPLink    :  LongInt;     { Folio No. of Parent Order Line *}
   {256}      SOPLineNo  :  LongInt;     { Folio No. of Prarent ABSLineNo *}
                                         { Also used to store the ABS line it is connected to in hidden BOM Lines}
   {261}      MLocStk    :  String[3];   { Multi stock location code *}
   {264}      QtyPick,                   { Qty picked this run }
   {270}      QtyPWOff   :  Real;
   {276}      UsePack    :  Boolean;     { Include Qty Mul in Line Calc }
   {277}      SerialQty  :  Real;        { Serial Qty }
   {283}      COSNomCode :  LongInt;     { COS Nominal Code to post stock to }
   {288}      DocPRef    :  String[10];  { Parent OurRef }
   {298}      DocLTLink  :  Byte;        { Doc Line Type Link }
   {299}      PrxPack    :  Boolean;     { Price is a total price }
   {300}      QtyPack    :  Double;      { Qriginal Qty in Case }
   {309}      ReconDate  :  LongDate;    { Date Reconciled }
   {317}      ShowCase   :  Boolean;
   {318}      sdbFolio   :  LongInt;     { Link to Alt db Code }
   {322}      OBaseEquiv :  Double;      { Pre EMU conversion base value }
   {330}      UseORate   :  Byte;        {* Forces the conversion routines to apply non tri rules *}
   {332}      LineUser1  :  String[30];  {* Line user def 1 *}
   {363}      LineUser2  :  String[30];  {* Line user def 2 *}
   {394}      LineUser3  :  String[30];  {* Line user def 3 *}
   {425}      LineUser4  :  String[30];  {* Line user def 4 *}
   {455}      SSDUplift  :  Double;      {* Intrastat uplift % *}
                                         {* Also used in hidden BOM lines to store temp cost price *}
   {464}      SSDCountry :  String[5];   {*     "     Country of origin *}
   {469}      VATIncFlg  :  Char;        {* Rate on line is inclusive of this rate *}
   {471}      SSDCommod  :  String[10];  {* SSD Commodity code *}
   {481}      SSDSPUnit  :  Double;      {* SSD unit into sales unit *}
   {489}      PriceMulx  :  Double;      {* Price rate multiplier to get price per *}
   {497}      B2BLink    :  Longint;     {* Back to back folio link *}
                                         {* Also used in ADJ lines to point to Nom folio used for stock valuation}
   {501}      B2BLineNo  :  LongInt;     {* Back to Back line link *}
   {506}      CurrTriR   :  TriCurType;  {* Details of Main Triangulation *}
   {527}      SSDUseLine :  Boolean;     {* Take the ssd values from the line *}
   {528}      PreviousBal:  Double;      {* New Double based previous bal  Nominal Value Before Posting  *}
   {536}      LiveUplift :  Boolean;     {* Flag to tell recon report to include any uplift *}
   {537}      COSConvRate
                         : Double;       {* Daily rate COS was posted at *}
                                          {* Do not need a Tri record as we can use CurrTriR *}
   {545}      IncNetValue
                         : Double;       {Original inclusive figure we are aiming to achieve}

     {553}  AutoLineType
                       : Byte;         {Line has been auto manufactured. 0 = Not auto line.
                                                                         1 = via customisation
                                                                         2 = via CIS routine
                                                                         3 = via RCT Reverse VAT}
     {554}  CISRateCode: Char;         {Valid CIS Tax rate code}
     {555}  CISRate    : Double;       {CIS % rate aplied}
     {563}  CostApport : Double;       {Cost apportionment value, to be added to InvRec.TotalCost2}

     {571}  NOMIOFlg :  Byte;        {Indicates if Nom Line is  0 = N/A. 1 = auto calced line. 2 = Manual line *}

     {572}  BinQty  :  Double;     {Qty required to satisfy bin qty}

     {580}  CISAdjust  :  Double;   {Additional amounts to be taken off line total due to other discounts/deductions}
     {588}  JAPDedType :  Byte;     {Deduction type. 0 = Normal. 1 = Apply after all other deductions. 2 = Treat as Contra}

     {589}  SerialRetQty
                     :  Double;   {Amount returned to stock via serial nos}
     {597}  BinRetQty:  Double;   {           "         "   into multi bins}

     // MH 23/03/2009: Added new fields for Advanced Discounts
     {605}  Discount2     : Real48;  // Multi-Buy Discount
     {613}  Discount2Chr  : Char;    // #0=Amount, %=Percentage
     {614}  Discount3     : Real48;  // Transaction Based Discount (TTD/VBD)
     {622}  Discount3Chr  : Char;    // #0=Amount, %=Percentage
     {623}  Discount3Type : Byte;    // 0=Undefined, 1=TTD, 2=VBD, 255=Discount Info Line

            // MH 19/08/2009: Added new fields for v6.2 EC Sales / VAT Return changes
            ECService          : Boolean;
            ServiceStartDate   : LongDate;
            ServiceEndDate     : LongDate;
            ECSalesTaxReported : Double;
            PurchaseServiceTax : Double;

            // MH 01/02/2010 (v6.3): Added new fields for Web Extensions
            tlReference : String[20];
            tlReceiptNo : String[20];
            tlFromPostCode : String[15];
            tlToPostCode : String[15];

            // CJS 2011-09-29: ABSEXCH-11716/ABSEXCH-11721 - New Transaction Line Udef Fields
            LineUser5  : String[30];  {* Line user def *}
            LineUser6  : String[30];  {* Line user def *}
            LineUser7  : String[30];  {* Line user def *}
            LineUser8  : String[30];  {* Line user def *}
            LineUser9  : String[30];  {* Line user def *}
            LineUser10 : String[30];  {* Line user def *}

            // MH 01/03/2012 v6.10 ABSEXCH-12596: Added Threshold Code for LIVE
            tlThresholdCode : String[12];  // LIVE Threshold Code

            // CJS 2014-02-12 - ABSEXCH-14946 - JSA Retention and CIS Tax
            //                                  Calculation
            tlMaterialsOnlyRetention: Boolean; // For JSA/JST transactions

            // CJS 2015-12-15 - 2016 R1 - Intrastat - A1.4 - new Transaction Line (Details) field
            tlIntrastatNoTC : String[2];   // Intrastat Nature of Transaction Code

            // MH 21/03/2016 2016-R2 ABSEXCH-17379: New Tax Region field for Multi-Region Tax
            tlTaxRegion : LongInt;

            {********************************************************************************}
            {**                                                                            **}
            {**  NOTE: Always add new fields into \Entrprse\Funcs\SQLTransactionLines.pas  **}
            {**                                                                            **}
            {********************************************************************************}
            Spare2     : Array[1..152] of Byte;
   End; // IDetail

   Idetail_FileDef = Record
          RecLen,
          PageSize,
          NumIndex  :  SmallInt;
          NotUsed   :  LongInt;
          Variable  :  SmallInt;
          Reserved  :  array[1..4] of Char;
          KeyBuff   :  array[1..IdNofSegs] of KeySpec;
          AltColt   :  AltColtSeq;
        end;



        { ================== Memory Contents of Invoice ================== }

  {$IFNDEF ExWin}



     MemInvDetail = Record
                  Item    :  String[3];  { Manual Item No. }
                  Qty     :  Real;       { Individual Qty }
                  QtyMul  :  Real;       { No Items in Case }
                  Desc    :  String[60]; { Descriptions }
                  Disc    :  Real;       { Disc for 1 unit <1=% }
                  NetValue:  Real;       { Price for One Unit}
                  IncNetValue
                          :  Double;
                  VATCode :  Char;       { VATCode }

                  VAT     :  Real;       { VAT Content}
                  NomCode :  Longint;    { Nominal Code }
                  StockCode
                          :  String[20]; { Product Code }
                  PBrk    :  Boolean;    { Page Break Indicator }
                  DiscCh  :  Char;       { % or figure discount indicator }

                  CCDep   :  CCDepType;  { Cost Center / Analysis }

                  KitLink :  LongInt;    { Sub Assy Kit Link }

                  CostPrice
                          :  Real;       { Line Cost }

                  LWeight :  Real;       { Line Weight }

                  UsePack :  Boolean;    { Use Qty Mul in Line Tot }
                  PrxPack :  Boolean;    { Price x Pack }
                  ShowCase:  Boolean;    { Show as Case In Force }
                  QtyPack :  Double;     { Original Qty in a pack }

                  JobCode :  String[10]; { Job Code }

                  AnalCode:  String[10]; { Job Analysis Code }

                  DocLTLink
                          :  Byte;

                  VATIncFlg
                          :  Char;       { VAT Incusive Flag }

                  sdbFolio:  LongInt;

                  PriceMulX
                          :  Double;

                  {$IFNDEF SOP}
                    DLLUpdate
                            :  Byte;
                  {$ENDIF}
               end;

  {$ENDIF}


Const
    { ====================== Nominal Record =========================== }



  NomF       =   4;

  NNofKeys   =   5;
  NomCodeK   =   0;                   
  NomDescK   =   1;
  NomCatK    =   2;
  NomAltK    =   3;
  NomCodeStrK =  4;

  NNofSegs   =   6;



Type

     NominalRec   = Record
                      NomCode    :    Longint;   {  }
                      Desc       :    String[40];
                      Cat        :    LongInt;   { Parent Code }
                      NomType    :    Char;      { Heading / A,B,C }
                      NomPage    :    Boolean;   { Page At end of this }
                      SubType    :    Boolean;   { Sub Total at end }
                      Total      :    Boolean;   { Show Balance only or Cr/Dr }
                      CarryF     :    LongInt;   { Nom Code to Carry Forward to }
                      ReValue    :    Boolean;   { Code is to be revalued }
                      AltCode    :    String[50];{ Alternative look up code}
                    {$IFDEF EXWin}
                      PrivateRec :    Byte;
                      DefCurr    :    Byte;      { Validation currency associated with this G/L. 0= All}
                      ForceJC    :    Boolean;   { Force a JC when using this G/L code }
                      HideAC     :    Byte;      { 1 = Hide from transactions }
                      NomClass   :    Byte;      { Optional Nom Classifier
                                                   10 = Bank Account
                                                   20 = Closing Stock
                                                   30 = Finished Goods
                                                   40 = Stock Value
                                                   50 = Stock (WOP) Work in Progress
                                                   60 = Overheads
                                                   70 = Misc
                                                   80 = Sales Return
                                                   90 = Purchase Return
                                                 }
                      Spare      :    Array[1..47] of Byte;
                    {$ELSE}
                      Spare      :    Array[1..52] of Byte;
                    {$ENDIF}

                      NomCodeStr : Str20;       // String equivalent of NomCode
                      Spare600   :  Array[1..153] of Byte;
                    end;


     Nominal_FileDef = Record
          RecLen,
          PageSize,
          NumIndex  :  SmallInt;
          NotUsed   :  LongInt;
          Variable  :  SmallInt;
          Reserved  :  array[1..4] of Char;
          KeyBuff   :  array[1..NNofSegs] of KeySpec;
          AltColt   :  AltColtSeq;
        end;



  {$IFDEF EXWIN}

    { ================ Nominal View File ============= }

    {RecPFix = NVRCode                      =  'N';
     SubType = NVVSCode                     =  'V'; For View Lines
               NVCSCode                     =  'C'; For the View Ctrl records}

    Const
      NomViewF    =     16;

      NVNofKeys   =     5;

      NVCodeK     =     0;
      NVViewIdxK  =     1;
      NVCatK      =     2;
      NVAltK      =     3;
      NVDescK     =     4;

      NVNofSegs   =     11;



    Type
        { ================ Nominal View Record ================ }


        NomViewType   = Record
                    {002} NVCode1    :  String[60];{Str rep of Index 0}
                    {063} NVCode2    :  String[10];{Str rep of Index 1}
                    {074} NVCode3    :  String[20];{Str rep of Index 2}
                    {095} NVCode4    :  String[60];{Str rep of Index 3}
                    {155} NomViewNo  :  LongInt;   {Index to separate different views}
                    {160} Desc       :  String[100];{Long description}
                    {261} ViewCode   :  String[50];{View ref code}
                    {311} ViewIdx    :  LongInt;   {Longint version of Viewcode for hierarchy}
                    {315} ViewCat    :  LongInt;   {Hierarchy parent}
                    {319} ViewType   :  Char;      {Item or subtotalling group}
                    {320} CarryF     :  LongInt;   {Carry forward totals to item below for reporting}
                    {325} AltCode    :  String[50];{Alternative code}
                    {375} LinkView   :  LongInt;   {Linked to another view}
                    {379} LinkGL     :  LongInt;   {Linked to original G/L}
                    {384} LinkCCDep  :  CCDepType; {Linked to CC/Dep balance if CC/Dep history enabled}
                    {390} IncBudget  :  Boolean;   {Include Budget history}
                    {391} IncCommit  :  Boolean;   {Include committed history}
                    {392} IncUnposted:  Byte;      {Include not posted items within balance.0 = No. 1 = unposted only.
                                                    2= both posted and unposted}
                    {393} AutoDesc   :  Boolean;   {Link desc from source}
                    {394} LinkType   :  Char;      {Original history type}
                    {395} ABSViewIdx :  LongInt;   {Original View Idx, used to link to history so re calc is not necessary}
                    {399} Spare      :  Array[1..367] of Byte;
                        end;

        { ================ View Ctrl Record ================ }


      ViewCtrlType    = Record
                   {002} VCCode1    :  String[60];{Str rep of Index 0}
                   {063} VCCode2    :  String[10];{Str rep of Index 1}
                   {074} VCCode3    :  String[20];{Str rep of Index 2}
                   {095} VCCode4    :  String[60];{Str rep of Index 3}
                   {155} IndexLInt  :  LongInt;   {Index padder}
                   {160} ViewDesc   :  String[100];{* Index pos so cannot move *}
                   {260} DefCurr    :  Byte;      {View default Currency}
                   {261} DefPeriod  :  Byte;      {  "     "    Period }
                   {262} DefPeriodTo:  Byte;      {  "     "       " To}
                   {263} DefYear    :  Byte;      {  "     "    Year}
                   {264} ViewCtrlNo :  LongInt;   {Linked to another views structure}
                   {268} LastPeriod :  Byte;      {Period item last updated}
                   {269} LastYear   :  Byte;      {Year     "    "     "}
                   {271} LinkCCDep  :  CCDepType; {Linked to CC/Dep balance if CC/Dep history enabled}
                   {278} IncBudget  :  Boolean;   {Include Budget history}
                   {279} IncCommit  :  Boolean;   {Include committed history}
                   {280} IncUnposted:  Byte;      {Include not posted items within balance.0 = No. 1 = unposted only.
                                                   2= both posted and unposted}
                   {281} AutoStruct :  Boolean;   {As part of update keep in synch with View Parent}
                   {282} LastPRunNo :  LongInt;   {Posted run number last time update happended}
                   {286} SparePad   :  Array[1..29] of Byte;
                   {316} LastUpdate :  LongDate;
                   {325} LastOpo    :  String[10];
                   {335} InActive   :  Boolean;
                   {336} DefCurrTx  :  Boolean;
                   {337} DefYTD     :  Boolean;
                   {338} DefUseF6   :  Boolean;
                   {33?} LoadedOk   :  Boolean;
                   {339} Spare      :  Array[1..427] of Byte;

                        end;



        NomViewPtr   =  ^NomViewRec;


        NomViewRec   =  Record
                          RecPfix   :  Char;         {  Record Prefix }
                          SubType   :  Char;         {  Subsplit Record Type }



                          Case SmallInt of

                            1  :  (NomViewLine   :  NomViewType);
                            2  :  (ViewCtrl      :  ViewCtrlType);


                        end;


        NomView_FilePtr   =   ^NomView_FileDef;

        NomView_FileDef   =   Record
                                 RecLen,
                                 PageSize,
                                 NumIndex  :  SmallInt;
                                 NotUsed   :  LongInt;
                                 Variable  :  SmallInt;
                                 Reserved  :  array[1..4] of Char;
                                 KeyBuff   :  array[1..NVNofSegs] of KeySpec;
                                 AltColt   :  AltColtSeq;
                               end;

  {$ENDIF}



Const
    { ====================== Stock Record =========================== }



  StockF     =   5;
  STNofKeys  =   9;
  StkCodeK   =   0;
  StkFolioK  =   1;
  StkCATK    =   2;
  StkDescK   =   3;
  StkMinK    =   4;
  StkValK    =   5;
  StkAltK    =   6;
  StkBinK    =   7;
  StkBarCK   =   8;

  STNofSegs  =   13;



  NofSBands  =   10;
  NofSDesc   =   06;
  NofSNoms   =   05;






Type


     StockRec  = Record
       {002}       StockCode    :    String[20];         { Stock Code }

       {023}       Desc         :    Array[1..NofSDesc] of      { Multiple Descriptions }
                                       String[35];

       {239}       AltCode      :    String[20];         { Secondary Lookup Key }
       {260}       SuppTemp     :    String[10];         { Preferred Supplier }

       {270}                                             { 4 Balance Sheet Nominal }
       {274}       NomCodeS     :    Array[1..NofSNoms]  { 1 Sales Nominal Code }
       {278}                           Of LongInt;       { 3 Profit & Loss Closing Stock }
       {282}                                             { 2 Cost of Sales Nominal }
       {286}                                             { 5 Fin Goods Code }

       {290}       ROFlg,                                { Interactive ROL Flag }
       {291}       MinFlg       :    Boolean;            { Min ROL Flag }
       {292}       StockFolio   :    LongInt;            { Numerical Equivalent Code }
       {297}       StockCat     :    String[20];         { Code of Parent on Tree }
       {317}       StockType    :    Char;               { History & Tree Type }
       {319}       UnitK        :    String[10];         { Descriptive Stocking Unit Qty }
       {330}       UnitS        :    String[10];         {      "      Selling    "   "  }
       {341}       UnitP        :    String[10];         {      "      Purchase   "   "  }
       {351}       PCurrency    :    Byte;               { Cost Price Currency }
       {352}       CostPrice    :    Real;               { Last Cost Price / Stock Valuation Price }

       {358}       SaleBands    :    SaleBandAry;        { Multiple Selling Bands A-J }

       {428}       SellUnit     :    Real;               { Selling Qty Multiple }
       {434}       BuyUnit      :    Real;               { Purchase Qty   "     }
       {441}       Spare        :    String[10];         { !! }
       {451}       VATCode      :    Char;               { Default VAT Lookup }
       {453}       CCDep        :    CCDepType;          { Cost Centre / Dep Anal }
       {460}       QtyInStock,                           { Physical Stock }
       {466}       QtyPosted,                            { Physical Posted Stock }
       {472}       QtyAllocated,                         { Backorder Qty }
       {478}       QtyOnOrder,                           { OnOrder Qty }
       {484}       QtyMin,                               { Min Stock Level Qty }
       {490}       QtyMax,                               { Max   "     "    "  }
       {496}       ROQty        :    Real;               { Qty Orded this order }
       {502}       NLineCount   :    LongInt;            { Notes Line Count }
       {506}       SubAssyFlg   :    Boolean;            { Is a Parent Code }
       {507}       ShowasKit    :    Boolean;            { Don't hide lines on invoice }
       {508}       BLineCount   :    LongInt;            { Bill Mat Line count }
       {513}       CommodCode   :    String[10];         { VAT Commodity Code }
       {523}       SWeight      :    Real;               { Sales  Unit Weight }
       {529}       PWeight      :    Real;               { Purchase "    "    }
       {536}       UnitSupp     :    String[10];         { Supplimentry unit }
       {546}       SuppSUnit    :    Real;               { No Units in Sales unit }
       {553}       BinLoc       :    String[10];         { Physical location in stores }
       {563}       StkFlg       :    Boolean;            { Stock Take flag, means needs adjsutment }
       {564}       CovPr        :    SmallInt;            { Amount of periods to scn back to calc cover }
       {566}       CovPrUnit    :    Char;               { Period calc unit of measure, D/W/M }
       {567}       CovMinPr     :    SmallInt;            { Amount of Cover required in periods }
       {569}       CovMinUnit   :    Char;               { Cover amount unit D/W/M }
       {571}       Supplier     :    String[10];         { Master Supplier Reference }
       {581}       QtyFreeze    :    Double;             { Frozen Stock level prior to a stock take }
       {589}       CovSold      :    Double;             { Qty sold over cover period }
       {597}       UseCover     :    Boolean;            { Use Cover on this record }
       {598}       CovMaxPr     :    SmallInt;            { Amount of Max Cover required }
       {600}       CovMaxUnit   :    Char;               { Unit of Max Cover }
       {601}       ROCurrency   :    Byte;               { Purchase Order Currency }
       {602}       ROCPrice     :    Double;             { Purchase Order Cost Price }
       {611}       RODate       :    LongDate;           {     "      "   Delivery Date }
       {619}       QtyTake      :    Double;             { Qty Counted }
       {627}       StkValType   :    Char;               { Stk Valuation Type C,L,F,S,A,R,E }
       {628}       HasSerNo     :    Boolean;            { Flag to determine using SNO }
       {629}       QtyPicked    :    Double;             { Count of Qty Picked so Far }
       {638}       LastUsed     :    LongDate;           { Date Last updated }
       {646}       CalcPack     :    Boolean;            { Apply pack price formula }
       {648}       JAnalCode    :    String[10];         { Default Job AnalCode }
       {659}       StkUser1     :    String[20];
       {680}       StkUser2     :    String[20];
       {701}       BarCode      :    String[20];
       {722}       ROCCDep      :    CCDepType;
       {731}       DefMLoc      :    String[3];
       {734}       PricePack    :    Boolean;            {Price per pack}
       {735}       DPackQty     :    Boolean;            {Show Qty as cases}
       {736}       KitPrice     :    Boolean;            {Use BOM price, ignore component price}
       {737}       KitOnPurch   :    Boolean;            {Explode kit on Purch transactions}
       {738}       StkLinkLT    :    Byte;               {Default Line Type on Invoice}
       {739}       QtyReturn    :    Double;             {Qty Returned on SRN}
       {747}       QtyAllocWOR  :    Double;             {Qty allocated to WOR}
       {755}       QtyIssueWOR  :    Double;             {Qty issued to WOR}
       {763}       WebInclude   :    Byte;               {Include on Web export}
       {765}       WebLiveCat   :    String[20];         {Web current catalogue entry}
       {786}       WebPrevCat   :    String[20];         {Web previous catalogue entry}
       {807}       StkUser3     :    String[30];         {Stk User Def 3}
       {838}       StkUser4     :    String[30];         {Stk User Def 4}
       {868}       SerNoWAvg    :    Byte;               {Determins if average is to be used with snos}
       {869}       StkSizeCol   :    Byte;               {Flag to state if group is size/color container}
       {870}       SSDDUplift   :    Double;             {Intrastat Uplift Dispatch default %}
       {879}       SSDCountry   :    String[5];          {    "     Country of origin }
       {885}       TimeChange   :    String[6];          {* Time stamp for record Change *}
       {891}       SVATIncFlg   :    Char;               {* Inc VAT Default *}
       {892}       SSDAUpLift   :    Double;             {Intrastat Uplift Arrivals default %}
       {900}       PrivateRec   :    Byte;               {Mark as private}
       {902}       LastOpo      :    String[10];         {Last operator}
       {913}       ImageFile    :    String[30];         {Associated bitmap image}
       {944}       TempBLoc     :    String[10];         {Temp Bin Loc}
       {954}       QtyPickWOR   :    Double;             {Qty issued now, but not processed}
       {962}       WOPWIPGL     :    LongInt;            {WIP GL Code}
       {966}       ProdTime     :    LongInt;            {Time to asseble a BOM}
       {970}       Leadtime     :    LongInt;            {Re-Order lead time}
       {974}       CalcProdTime :    Boolean;            {Work out production time}
       {975}       BOMProdTime  :    LongInt;            {Total production time of any sub boms+This one}
       {979}       MinEccQty    :    Double;             {The minimum qty qorth building as a BOM}

       {987}       MultiBinMode
                              :    Boolean;              {Flag to indicate Multi bins exist for stock}

       // CJS 2011-09-29: ABSEXCH-11709 - New Stock Udef Fields. Removed
       //                 EXWIN directive, and consolidated spare fields.
       {988}     SWarranty  :    Byte;                 {Standard warranty count in months or years}
       {989}     SWarrantyType
                            :    Byte;                 {Standard warranty Type 0 months or 1 years}
       {990}     MWarranty  :    Byte;                 {Manufacturers warranty count in months or years}
       {991}     MWarrantyType
                            :    Byte;                 {Manufacturers warranty Type 0 months or 1 years}
       {992}     QtyPReturn :    Double;               {Qty Returned on PRN}
      {1000}     ReturnGL   :    LongInt;              {G/L code used for G/L movement}
      {1004}     ReStockPcnt:    Double;               {ReStock pcnt auto applied as an additional cost}
      {1012}     ReStockGL  :    LongInt;              {ReStock G/L code on auto line}
      {1016}     BOMDedComp :    Boolean;              {Override behaviour of deduct comp if no stock}
      {1017}     PReturnGL  :    LongInt;              {Keep G/L code seperate for Purchase return levels}
      {1021}     ReStockPChr:    Char;                 {Indicator to show Restock value is percentage}

      {1022}     LastStockType
                            :    Char;                 {Last Stock Type, preserved to prevent Desc only items reappearing i
                                                        n stk val report}

                 // CJS 2011-09-29: ABSEXCH-11709 - New Stock Udef Fields.
                 StkUser5  : String[30]; {Stk User Def 5}
                 StkUser6  : String[30]; {Stk User Def 6}
                 StkUser7  : String[30]; {Stk User Def 7}
                 StkUser8  : String[30]; {Stk User Def 8}
                 StkUser9  : String[30]; {Stk User Def 9}
                 StkUser10 : String[30]; {Stk User Def 10}

                 // CJS 2014-09-08 - ABSEXCH-15052 - New field for EC Services
                 stIsService: Boolean;

                 Spare_2   : Array[1..633] of Byte; {!!}
     end;


     Stock_FileDef = Record
          RecLen,
          PageSize,
          NumIndex  :  SmallInt;
          NotUsed   :  LongInt;
          Variable  :  SmallInt;
          Reserved  :  array[1..4] of Char;
          KeyBuff   :  array[1..STNofSegs] of KeySpec;
          AltColt   :  AltColtSeq;
        end;





   { =================== Numerical History Record =================== }

   { History classes used so far :-

     A B C D E G H I J K M O P S T U V W X Z \ [ 1 2 3 4 5 6

     Also.. Add #159 to these for profiling/extended history

     M has been doubled up and used for BOM stk history, and Commitment accounting.
     Due to the make up of the commitment history code there will not be
     any chance of duplication.
     This was chosen to control the temporary live commited balance and is ideal as there is no chance of any
     YTD carry forwards.

   }


  Const

    NHistF      =     6;

    NHNofKeys   =     1;
    NHK         =     0;

    NHNofSegs   =     3;

  Type

       HistoryRec   =   Record
                          Code           : Str20;     {  Code of Hist Link, Move longint for this }
                          ExCLass        : Char;
                          Cr             : Byte;      {  Currency of History }
                          Yr             : Byte;      {  Yr/Period }
                          Pr             : Byte;
                          Sales          : Double;    {  Dr  }
                          Purchases      : Double;    {  Cr  }
                          Budget         : Double;    {      }
                          Cleared        : Double;    {  Cleared Balance for that Nominal in Cr Currency }
                          RevisedBudget1 : Double;    // MH 03/05/2016 2016-R2 ABSEXCH-17353: Renamed from Budget2
                          Value1         : Double;
                          Value2         : Double;
                          Value3         : Double;
                          RevisedBudget2 : Double;    // MH 03/05/2016 2016-R2 ABSEXCH-17353: Renamed from SpareV[1]
                          RevisedBudget3 : Double;    // MH 03/05/2016 2016-R2 ABSEXCH-17353: Renamed from SpareV[2]
                          RevisedBudget4 : Double;    // MH 03/05/2016 2016-R2 ABSEXCH-17353: Renamed from SpareV[3]
                          RevisedBudget5 : Double;    // MH 03/05/2016 2016-R2 ABSEXCH-17353: Renamed from SpareV[4]
                          SpareV         : Double;
                          Spare          : Array[1..30] of Byte;
                        end;



       Hist_FileDef = Record
            RecLen,
            PageSize,
            NumIndex  :  SmallInt;
            NotUsed   :  LongInt;
            Variable  :  SmallInt;
            Reserved  :  array[1..4] of Char;
            KeyBuff   :  array[1..NHNofSegs] of KeySpec;
            AltColt   :  AltColtSeq;
          end;




     { ================ Numerical Sequence Counts ================ }

  {v4.32, please note that the windows rebuild system has a hard coded record structure for this.
          If it ever changes, this needs to be reflected in the
          windows version}

Const
  INCF         =    7;

  IncNofKeys   =    1;
  IncK         =    0;

  IncNofSegs   =    1;


Type
   // MH 09/07/2015 v7.0.14 ABSEXCH-15920: Moved structure out to ExchqNumRec.pas so
   // that it can be easily re-used in the Exchequer Document Numbers Reporting Utility
   {$I ExchqNumRec.pas}

   Increment_FileDef = Record
                         RecLen,
                         PageSize,
                         NumIndex  :  SmallInt;
                         NotUsed   :  LongInt;
                         Variable  :  SmallInt;
                         Reserved  :  array[1..4] of Char;
                         KeyBuff   :  array[1..IncNofSegs] of KeySpec;
                         AltColt   :  AltColtSeq;
                       end;


    { ================ Password Control File ============= }

Const
  PWrdF     =     8;

  PwNofKeys =     2;

  PWK       =     0;
  HelpNdxK  =     1;

  PWNofSegs =     4;



Type
    { Other Password types in VARREC2U.PAS }

    { ================ Bacs Ctrl Record =============== }

    BacsCType= Record
              {002}   TagCode   :  String[12];      {  '!'+RunNo }

              {014}   Spare1    :  Array[1..10] of Byte;

              {025}   Spare3K   :  String[10];      {  Spare K }

              {035}   TagRunNo  :  LongInt;         {  Tag Run Ctrl}

              {039}   PayType   :  Char;            {  Bacs/Cq Run}

              {040}   BankNom   :  LongInt;         {  Bank Nominal }

              {044}   PayCurr   :  Byte;            {  Pay In Currency }

              {045}   InvCurr   :  Byte;            {  Inv Currency }

              {046}   CQStart   :  LongInt;         {  CQ Number Start }

              {050}   AgeType   :  Byte;            {  Ageing Type  }

              {051}   AgeInt    :  SmallInt;         {  Ageing Interval }

              {053}   TagStatus :  Boolean;         {  Has Report been finished }

              {054}   TotalTag  :  BACSAnalType;    {  Total Tagged & OS }

              {095}   TagAsDate :  LongDate;        {  Tagged As At }

              {103}   TagCount  :  LongInt;         {  Total No. of Items in List }

              {108}   TagCCDep  :  CCDepType;       {  Default CC/DEP }

              {112}   {Dep Addr}

              {116}   TagRunDate:  LongDate;        {  Date of Payment }
              {124}   TagRunYr  :  Byte;            {  Year of Payment }
              {125}   TagRunPr  :  Byte;            {  Period of Payment }
              {126}   SalesMode :  Boolean;         {  Run as Sales Mode }
              {127}   LastInv   :  LongInt;
              {132}   SRCPIRef  :  Str10;           {  Paying In Ref }
              {142}   LastTagRunNo
                                :  LongInt;         {  Last Run No }
              {146}   TagCtrlCode
                                :  LongInt;         {  Multiple DC Ctrl Account }
              {150}   UseAcCC   :  Boolean;         {  Apply individual account cc to PPY }
              {151}   SetCQatP  :  Boolean;         {  Leave Form designer to set CQ No }
              {152}   IncSDisc  :  Boolean;         {  Include settlement discount in calcualtion }
              {153}   SDDaysOver:  SmallInt;        {  Max number of days allowed to go over }
              {155}   ShowLog   :  Boolean;         {  Show exceptions Log}
              {156}   UseOsNdx  :  Boolean;         {  Switch to determine if o/s index should be used }
              {157}   LIUCount  :  LongInt;         {  On Going count of users }

                      // MH 08/07/2010 v6.4 ABSEXCH-10017: Added YourRef field into Batch Payments/Receipts Wizard
                      YourRef   :  String[20];      // YourRef to be put on resulting SRC's/PPY's

                      // MH 05/05/2015 v7.0.14 ABSEXCH-16284: PPD Mods
                      ApplyPPD               : Boolean;
                      IntendedPaymentDate    : LongDate;
                      PPDExpiryToleranceDays : Byte;

                      Spare2    :  Array[1..88] of Byte;
                   end;


    { ================ Bank Ctrl Record =============== }

    BankCType= Record
              {002}   BankCode  :  String[12];      {  Bank Nom+Currency+! }

              {014}   Spare1    :  Array[1..10] of Byte;

              {025}   Spare3K   :  String[10];      {  Spare K }

              {035}   TagRunNo  :  LongInt;         {  Tag Run Ctrl}

              {039}   BankNom   :  LongInt;         {  Bank Nominal }

              {043}   BankCr    :  Byte;            {  Session Currency }

              {045}   ReconOpo  :  String[10];      {  Last Operator in }

              {055}   EntryTotDr,
              {063}   EntryTotCr
                                :  Double;          {  Screen Totals }

              {072}   EntryDate :  LongDate;        {  Session Start Date }

              {080}   NomEntTyp :  Char;            {  Record Nominal Type }

              {081}   AllMatchOk:  Boolean;         {  Flag to indicate all entries are matched }

              {082}   MatchCount:  LongInt;         {  Count of Total Entries }

              {086}   MatchOBal :  Double;          {  Opening Balance }

              {094}   ManTotDr,
              {102}   ManTotCr  :  Double;

              {110}   ManRunNo  :  LongInt;         {  Posted Run as when manual rec run }

              {114}   ManChange :  Boolean;         {  Flag to indicate update required }

              {115}   ManCount  :  LongInt;         {  Count of manual Items }

              {119}   Spare2    :  Array[1..162] of Byte;


                   end;





    { ================ Export Last File =============== }

    ExportFileType =  Record

              {002}     ExportCode
                                  :  String[12];

              {014}     Spare1    :  Array[1..10] of
                                       Byte;

              {025}     SecondKey :  String[10];

              {035}     LastPath  :  String[80];     {* Last File Path Used *}

              {115}     Spare2    :  Array[1..166] of Byte;

                      end;



    { ================ Temp Stock Allocation File =============== }

    AllocFileType =  Record

              {002}     AllocCode
                                  :  String[12];

              {014}     Spare1    :  Array[1..10] of
                                       Byte;

              {025}     SecondKey :  String[10];

              {034}     AllocSF   :  Real;

              {040}     Spare2    :  Array[1..241] of Byte;

                      end;




    { ================ Cost Center Record =============== }

    CostCtrType= Record
              {002}   PCostC    :  String[12];      {  Cost Center Code }

              {014}   Spare1    :  Array[1..10] of Byte;

              {025}   CCDesc    :  String[30];      {  Cost Centre Description }

              {055}   CCTag     :  Boolean;         {  Tagged for Report }

              {057}   LastAccess:  LongDate;        {  Last time external module accessed this cc/dep *}

              {065}   NLineCount:  LongInt;         {  Notes LineCount }
            {$IFDEF EXWin}
              {069}   HideAC     :    Byte;      { 1 = Hide from transactions }

              {070}   Spare2    :  Array[1..211] of Byte;
            {$ELSE}
              {069}   Spare2    :  Array[1..212] of Byte;
            {$ENDIF}


                    end;


    PassWordRec  =  Record
                      RecPfix   :  Char;         {  Record Prefix }
                      SubType   :  Char;         {  Subsplit Record Type }



                      Case SmallInt of
                        1  :  (PassEntryRec  :  PassEntryType);
                        2  :  (PassListRec   :  PassListType);
                        3  :  (HelpRec       :  HelpType);
                        4  :  (NotesRec      :  NotesType);
                        5  :  (MatchPayRec   :  MatchPayType);
                        6  :  (BillMatRec    :  BillMatType);
                        7  :  (BacsCRec      :  BacsCtype);
                        8  :  (BankCRec      :  BankCtype);
                        9  :  (ExportFileRec :  ExportFileType);
                       10  :  (AllocFileRec  :  AllocFileType);
                       11  :  (CostCtrRec    :  CostCtrType);
                       12  :  (MoveNomRec    :  MoveNomType);
                       13  :  (MoveStkRec    :  MoveStkType);
                       14  :  (VSecureRec    :  VSecureType);

                       {$IFDEF EXWin}
                         
                         15  :  (BacsURec      :  BacsUtype);

                         16 :  (MoveCtrlRec :  MoveCtrlType);


                       {$ENDIF}



                    end;


    PassWord_FileDef   =   Record
                             RecLen,
                             PageSize,
                             NumIndex  :  SmallInt;
                             NotUsed   :  LongInt;
                             Variable  :  SmallInt;
                             Reserved  :  array[1..4] of Char;
                             KeyBuff   :  array[1..PwNofSegs] of KeySpec;
                             AltColt   :  AltColtSeq;
                           end;




    { ================ Stock Misc File ============= }

Const
  MiscF     =     9;

  MINofKeys =     3;

  MIK       =     0;
  MiscNdxK  =     1;
  MiscBtcK  =     2;

  MINofSegs =     6;



Type

    { ================ Qty Discount db =============== }

    QtyDiscType =  Record

              {002}     DiscQtyCode
                                  :  String[26];   {* Stock Folio + Currency + Numeric version of TQB *}

              {029}     SecondKey :  String[20];   {* Perhaps use as global update access *}

              {050}     ThirdKey  :  String[10];   {* Spare! *}

              {060}     FQB,
              {068}     TQB       :  Double;       {* Qty from & too *}

              {076}     QBType    :  Char;         {* Qty break type *}

              {077}     QBCurr    :  Byte;         {* Qty Break Currency *}

              {078}     QSPrice   :  Double;       {*    "      Special selling price *}

              {086}     QBand     :  Char;         {*    "      Use price band *}

              {087}     QDiscP    :  Double;       {*    "      Discount % *}

              {095}     QDiscA    :  Double;       {*    "      Unit Discount amount *}

              {103}     QMUMG     :  Double;       {*    "      Markup/Margin information *}

              {111}     QStkFolio :  LongInt;      {*    "      Stock Folio link back *}

              {116}     QCCode    :  String[10];   {*    "      N/U *}

              {127}     Spare3    :  String[10];   {*    "      Update/.Source Filter *}
             {$IFDEF EXWin}
              {137}     QUseDates :  Boolean;
              {139}     QStartD   :  LongDate;
              {148}     QEndD     :  LongDate;

              {156}     Spare2    :  Array[1..199] of Byte;
             {$ELSE}
              {137}     Spare2    :  Array[1..218] of Byte;

             {$ENDIF}
                          Spare600 : Array[1..176] of Byte;
                      end;





    { ================ Discount Record ================ }


    CustDiscType = Record
               {002}  DiscCode  :  String[26];   {  Account+StockCode+QBCurr }
               {029}  QStkCode  :  String[20];   {  Discount StockCode }
               {050}  Spare3K   :  String[10];   {  Spare K }
               {061}  DCCode    :  String[10];   {  Discount CustCode }
               {071}  QBType    :  Char;         {      "    Type}
               {072}  QBCurr    :  Byte;         {      "    Currency }
               {073}  QSPrice   :  Double;       {      "    Special Price }
               {081}  QBand     :  Char;         {      "    Set Band      }
               {082}  QDiscP    :  Double;       {      "    Discount % }
               {090}  QDiscA    :  Double;       {      "        "    Amount of unit }
               {098}  QMUMG     :  Double;       {      "      Markup/Margin information *}
             {$IFDEF EXWin}
               {106} CUseDates  :  Boolean;
               {108} CStartD    :  LongDate;
               {117} CEndD      :  LongDate;

               {125}  QtyBreakFolio
                                :  LongInt;      //PR: 07/02/2012 Linked to by qty break records in the new file.
               {129}  Spare     :  Array[1..226] of Byte;
             {$ELSE}
               {106}  Spare     :  Array[1..249] of Byte;
             {$ENDIF}

                       Spare600 : Array[1..176] of Byte;
                   end;


    { ================ Stock Location Record =============== }

    MultiLocType= Record
              {002}   MlocC     :  String[10];      {  Multi Loc Code }

              {012}   Spare1    :  Array[1..16] of Byte;

              {029}   LocDesc   :  String[20];      {  Location Description }

              {050}   Spare3K   :  String[10];      {  Spare K }

              {060}   LocTag    :  Boolean;         {  Tagged for Report }

              {062}   LocFDesc  :  String[30];      {  Description for Report }

              {092}   LocRunNo  :  LongInt;         {  Last Run No. }

              {096}   Spare2    :  Array[1..259] of Byte;

                       Spare600 : Array[1..176] of Byte;
                   end;



    { ================ FiFO Valuation Record =============== }

    FiFoType= Record
              {002}   FIFOCode  :  String[12];      {  Stk Folio + LongDate }

              {014}   Spare1    :  Array[1..14] of Byte;

              {029}   DocFolioK :  String[20];      {  DocCode + Stk Folio +Doc LineNo for easy updating }

              {050}   Spare3K   :  String[10];      {  Spare K }

              {060}   StkFolio  :  LongInt;         {  Stock Link }

              {064}   DocABSNo  :  LongInt;         {  Doc ABS Line No. }

              {069}   FIFODate  :  LongDate;        {  Date of Costing }

              {077}   QtyLeft   :  Double;          {  Amount Left }

              {086}   DocRef    :  String[10];      {  Doc Link }

              {096}   FIFOQty   :  Double;          {  }

              {104}   FIFOCost  :  Double;          { Doc Currency Cost }

              {112}   FIFOCurr  :  Byte;            { Currency of FIFO }

              {114}   FIFOCust  :  String[10];      { CustCode }

              {125}   FIFOMLoc  :  String[10];      { Link to Location }

              {135}   FIFOCRates:  CurrTypes;       { Currency rates of Fifo Entry }

              {147}   FUseORate :  Byte;        {* Forces the conversion routines to apply non tri rules *}

              {148}   FIFOTriR  :  TriCurType;   {* Details of Main Triangulation *}

              {169}   Spare2    :  Array[1..186] of Byte;

                       Spare600 : Array[1..176] of Byte;
                   end;


    { ================ SOP Default Process Values Record =============== }

    SOPInpRec  =  Record
               {01} PickTag   {$IFDEF EXWIN}  :   Byte;  {$ELSE}, {$ENDIF}
               {02} PickAuto,
               {03} PickSing,
               {04} PickCon     :   Boolean;
               {05} DelTag    {$IFDEF EXWIN}  :   Byte;  {$ELSE}, {$ENDIF}
               {06} DelCons     :   Boolean;
               {07} InvTag    {$IFDEF EXWIN}  :   Byte;  {$ELSE}, {$ENDIF}
               {08} InvCons,
               {09} PickEBOM    :   Boolean;
               {10} DelPrn      :   Array[1..4] of Boolean;

               {14} DocPrn      :   Array[1..4] of Byte;
               {19} PickUDate   :   LongDate;
               {28} SOPMLoc     :   Str5;
               {33} Sor2Inv     :   Boolean;
               {34} PrnScrn     :   Boolean;
               {35} PapChange   :   Boolean;
               {37} WPrnName    :   Array[1..4] of String[20];
              {121} PickExc     :   Boolean;
              {122} ShowAllBins :   Boolean;
              {123} ExcNonPick  :   Boolean;
              {124}
                  end;


    SOPInpDefType= Record
              {002}   SOPInpCode
                                :  String[10];      {  AccessKey, Mode+StopK }

              {012}   Spare1    :  Array[1..16] of Byte;

              {029}   SecondKey :  String[20];      {  Not Used}

              {050}   ThirdK    :  String[10];

              {060}   Spare     :  Byte;

              {061}   SOPInpVal :  SOPInpRec;

                {097}   Spare2    :  Array[1..172] of Byte;

                       Spare600 : Array[1..176] of Byte;
                   end;


    {*EN431MB2B*}

    {$IFDEF EXWIN}


        { ================ SOP Default Process Values Record =============== }

        B2BInpRec  =  Record
                   {01} MultiMode,
                   {02} ExcludeBOM,
                   {03} UseOnOrder  :   Boolean;
                   {04} IncludeLT   :   LongInt;
                   {08} ExcludeLT   :   LongInt;
                   {12} QtyMode     :   Byte;
                   {13} SuppCode    :   String[10];
                   {24} LocOR       :   String[10];
                   {35} AutoPick    :   Boolean;
                   {36} GenOrder    :   Byte;
                   {37} PORBOMMode  :   Boolean;
                   {39} WORBOMCode  :   String[20];
                   {60} WORRef      :   String[20];
                   {81} LocIR       :   String[10];
                   {91} BuildQty    :   Double;
                   {99} BWOQty,
                  {100} LessFStk    :   Boolean;
                  {101} AutoSetChilds
                                    :   Byte;
                  {102} ShowDoc,
                  {103} CopyStkNote,
                  {104} UseDefLoc,
                  {105} UseDefCCDep :   Boolean;
                  {106} WORTagNo    :   Byte;
                  {108} DefCCDep    :   CCDepType;
                  {117} WCompDate   :   LongDate;
                  {125} WStartDate  :   LongDate;
                  {133} KeepLDates  :   Boolean;
                  {134} CopySORUDF  :   Boolean;
                  {135} LessA2WOR   :   Boolean;
                  {136} Spare       :   Array[1..64] of char;
                   {200}Loaded      :   Boolean;
                   {201}
                          Spare600  :   Array[1..270] of Byte;
                      end;

        B2BLineRec  =  Record
                   {01} OrderFolio  :   LongInt;
                   {05} OrderLineNo :   LongInt;
                   {09} LineSCode   :   String[10];
                   {20} DelLineAfter:   Boolean;
                   {21} UseKPath    :   Smallint;
                   {23} OrderLinePos:   LongInt;
                   {27} OrderAbsLine:   LongInt;
                   {31} OrderLineAddr
                                    :   LongInt;
                   {35} Spare       :   Array[1..165] of char;
                   {200}Loaded      :   Boolean;
                   {201}
                          Spare600  :   Array[1..270] of Byte;
                      end;


        B2BProcType= Record
                  {002}   B2BInpCode
                                    :  String[10];      {  AccessKey, SOPFolio+SuppCode }

                  {012}   Spare1    :  Array[1..16] of Byte;

                  {029}   SecondKey :  String[20];      {  Not Used}

                  {050}   ThirdK    :  String[10];

                  {060}   Spare     :  Byte;

                  {061}   Case SmallInt of
                             1  :  (B2BInpVal :  B2BInpRec);
                             2  :  (B2BLine   :  B2BLineRec);

                  {261}
                       end;


                 { ================ Account Allocation Record =============== }

        AllocSType= Record
                  {002}   ariKey    :  String[26];      {  CustSupp + CustCode + SortKey[10] +SortKey [9]}

                  {029}   Spare2K   :  String[20];      {  CustSupp + CustCode + OurRef}

                  {050}   Spare3K   :  String[10];      {  Spare K }

                  {061}   ariCustCode
                                    :  String[10];      {  Supplier Code }
                  {071}   ariCustSupp
                                    :  Char;            { C/S}
                  {073}   ariOurRef :  String[10];      { Link to original transaction}

                    {084}   ariOldYourRef:  String[10];      {Old Show YourRef}

                  {095}   ariDueDate:  LongDate;        {Due Date}

                  {104}   ariTransDate
                                    :  LongDate;        {Trans Date}
                  {112}   ariOrigVal:  Double;          {Original value}
                  {120}   ariOrigCurr
                                    :  Byte;            {Original currency}
                  {121}   ariBaseEquiv
                                    :  Double;          {Base equivalent}
                  {129}   ariOrigSettle
                                    :  Double;          {Amount settled base currency}
                  {137}   ariOrigOCSettle
                                    :  Double;          {Amount settled own currency}
                  {145}   ariSettle :  Double;          {Amount settled this screen}
                  {153}   ariCXRate :  CurrTypes;       {Exchange rate of transaction}
                  {165}   ariSetDisc:  Double;          {Amount of settlement discount to take}
                  {173}   ariVariance
                                    :  Double;          {Amount of variance}
                  {181}   ariOrigSetDisc
                                    :  Double;          {Settlement discount present at scan time}

                  {189}   ariOutstanding
                                    :  Double;          {Amount currently o/s}
                  {198}   ariCurrOS :  Double;          {Amount O/S own currency}
                  {207}   ariSettleOwn
                                    :  Double;          {Amount settled this screen}

                  {215}   ariBaseOS :  Double;          {Amount o/s in base}

                  {223}   ariDiscOR :  Double;          {Amount over discount added to make allocation balance, base}

                  {231}   ariOwnDiscOR                  {Amount over discount added to make allocation balance, own currency}
                                    :  Double;

                  {239}   ariDocType:  DocTypes;        {Document Type}

                  {240}   ariTagMode:  Byte;            {1 : Full or 2 : part allocate tag item}

                  {241}   ariReValAdj,                  {Amount of revaluation to include in allocation when settled}
                          ariOrigReValAdj               {Original amount of revaluation adjustment present at scan time}
                                    :  Double;

                  {257}   Spare2    :  Array[1..98] of Byte;


                  {356}   ariYourRef:  String[20];      {Show YourRef}

                          // MH 05/05/2015 v7.0.14 ABSEXCH-16284: PPD Mods
                          ariPPDStatus : Byte;         // PPD Status Flag for Allocation Wizard

                          Spare600 : Array[1..156] of Byte;
                       end;



    {$ENDIF}

    { ================ Bacs Supplier Ctrl Record =============== }

    BacsSType= Record
              {002}   TagSuppK  :  String[10];      {  RunNo+CustCode }

              {012}   Spare1    :  Array[1..16] of Byte;

              {029}   Spare2K   :  String[20];      {  }

              {050}   Spare3K   :  String[10];      {  Spare K }

              {060}   TagRunNo  :  LongInt;         {  Tag Run Ctrl}

              {065}   TagCustCode
                                :  String[10];      {  Supplier Code }

              {075}   TotalOS   :  BACSAnalType;    {  Ageing O/S }

              {115}   TotalTagged
                                :  BACSAnalType;    {  Tagged Ageing /OS }

              {155}   HasTagged :  Array[0..NoBACSTot] of
                                     Boolean;       {  Easy Flag for Tagged Status }

              {160}   TagBal    :  Double;          {  Supp Balance as at Scan }

              {161}   SalesCust :  Boolean;         {  Is a Customer }

              {169}   TotalEx   :  BACSAnalType;    {  Amount Excluded }

                      // MH 05/05/2015 v7.0.14 ABSEXCH-16284: PPD Mods
                      TraderPPDPercentage : Double;
                      TraderPPDDays : SmallInt;

              {214}   Spare2    :  Array[1..136] of Byte;

                      Spare600 : Array[1..176] of Byte;
                   end;



        { ================ Serial No. Record ================ }


    SerialType= Record
               {002}  SerialCode:  String[26];   {  STK Folio+Sold+Serial No }
               {029}  SerialNo  :  String[20];   {  Actual Serial No. }
               {050}  BatchNo   :  String[10];   {  Seperate Batch No.}
               {061}  InDoc     :  String[10];   {  Input Doc No. }
               {072}  OutDoc    :  String[10];   {  Output Doc No.}
               {082}  Sold      :  Boolean;      {  Sold Status }
               {084}  DateIn    :  LongDate;     {  Date In }
               {092}  SerCost   :  Double;       {  CostPrice}
               {100}  SerSell   :  Double;       {  Selling Price }
               {108}  StkFolio  :  LongInt;      {  StkFolio }
               {113}  DateOut   :  LongDate;     {  Date Sold }
               {121}  SoldLine  :  LongInt;      {  ABS Line No of Doc Sold }
               {125}  CurCost   :  Byte;         {  Currency Cost Price }
               {126}  CurSell   :  Byte;         {      "    Sell Price }
               {127}  BuyLine   :  LongInt;      {  Purchase Line       }
               {131}  BatchRec  :  Boolean;      {  Indicates this is soley a batch record }
               {132}  BuyQty    :  Double;       {  Original Batch Qty }
               {140}  QtyUsed   :  Double;       {  Amount Used from  Batch }
               {148}  BatchChild:  Boolean;      {  Auto generated item to record sale doc for batch }
               {150}  InMLoc    :  String[10];   {  Location Filter }
               {161}  OutMLoc   :  String[10];   {  Location Filter }
               {171}  SerCRates :  CurrTypes;    {  Cost Rate }
               {184}  InOrdDoc  :  String[10];   {  Original In Order}
               {195}  OutOrdDoc :  String[10];   {  Original Out Order }
               {205}  InOrdLine :  LongInt;      {  Line Number of original order }
               {209}  OutOrdLine:  LongInt;      {  Line Number of original order }
               {213}  NLineCount:  LongInt;      {  Notes Line Count }
               {217}  NoteFolio :  LongInt;      {  Unique Folio to attach notes to }
               {222}  DateUseX  :  LongDate;     {  Use by Date }
               {230}  SUseORate :  Byte;        {* Forces the conversion routines to apply non tri rules *}
               {231}  SerTriR   :  TriCurType;   {* Details of Main Triangulation *}
               {252}  ChildNFolio
                                :  LongInt;     {* Child Batch link back to exact parent *}

               {257}  InBinCode
                              :  String[10];

               {$IFDEF ExWin}
                 {267}  ReturnSNo  :  Boolean; {* Flagged as came back via returns module *}
                 {268}  BatchRetQty:  Double;  {* Amount of batch child returned *}
                 {277}  RetDoc     :  String[10]; { Sales Return Reference for match }
                 {287}  RetDocLine :  LongInt; { Line No. of Return }
                 {291}  Spare      :  Array[1..64] of  Byte;
               {$ELSE}
                 {267}  Spare     :  Array[1..88] of  Byte;
               {$ENDIF}

                        Spare600 : Array[1..176] of Byte;
                   end;


        { ================ Bank Match Ctrl Record =============== }

    BankMType= Record
              {002}   BankMatch :  String[10];      {  Bank NomCode + Currency + !}

              {012}   Spare1    :  Array[1..16] of Byte;

              {029}   Spare2K   :  String[20];      {  }

              {050}   Spare3K   :  String[10];      {  Spare K }

              {061}   BankRef   :  String[40];      {  Bank Matching Reference }

              {101}   BankValue :  Double;          {  Statement value }

              {110}   MatchDoc  :  String[10];      {  Doc Ref }

              {120}   MatchFolio:  LongInt;         {  Folio }

              {124}   MatchLine :  LongInt;         {  Detail Line No. }

              {128}   BankNom   :  LongInt;         {  Nominal Code }

              {132}   BankCr    :  Byte;            {  Currency }

              {134}   EntryOpo  :  String[10];      {  Entered by }

              {145}   EntryDate :  LongDate;        {  Entry Date }

              {153}   EntryStat :  Byte;            {  Entry Status; 0 = unprocessed.
                                                                                   1 = Matched ok.
                                                                     2 = No Match Found.
                                                                     3 = Right Ref Wrong Value.
                                                                     4 = Matched already. }
              {154}   UsePayIn  :  Boolean;         {  Link to payin in display }

              {155}   MatchAddr :  LongInt;         {  Physical record address of Matched line *}

              {159}   MatchRunNo:  LongInt;         {  Posting Run when bank rec first started }

              {163}   Tagged    :  Boolean;         {  Manual Recon Tagged Status }

              {164}   MatchDate :  Boolean;         {  Force a match on date as well }

              {165}   MatchABSLine
                             :  LongInt;         {  ABS Line No of  Matched line *}

              {169}   Spare2    :  Array[1..186] of Byte;


                      Spare600 : Array[1..176] of Byte;
                   end;


{$IFDEF ExWin}

    btCustomType  = Record
              {002}   CustomKey :  String[20];      {  CompName+UserName}

              {022}   Spare1    :  Array[1..6] of Byte;

              {029}   UserKey   :  String[20];      {  UserName + CompName }

              {050}   Spare3K   :  String[10];      {  Spare K }

              {060}   BkgColor  :  TColor;         {  General Background Colour }

              {065}   FontName  :  String[32];      {  Font Name }

              {097}   FontSize  :  Integer;         {  Font Size }

              {101}   FontColor :  TColor;         {  Font Color }

              {105}   FontStyle :  TFontStyles;      {}

              {109}   FontPitch :  TFontPitch;      {}

              {113}   FontHeight:  Integer;         {}

              {117}   LastColOrder
                                :  LongInt;         {}

              {121}   Position  :  TRect;           {Last coordinates}

              {138}   CompName  :  String[63];      {Component name}

              {192}   UserName  :  String[10];      {Login code}

              {202}   HighLight,
                      HighText  :  TColor;          {Highlighted bar colors}

              {210}   Spare     :  Array[1..41]  of Byte;

                      Spare600 : Array[1..276] of Byte;
                   end;

    btLetterDocType = (DocWord95,
                       lnkDoc,        { Document }
                       lnkFax,        { Fax }
                       lnkImage,      { Bitmap, GIF, etc }
                       lnkPres,       { Presentation }
                       lnkProgram,    { Program }
                       lnkSound,      { Sound file }
                       lnkVideo,      { Video Clip }
                       lnkOther,      { Unknown }
                       lnkSpreadSh,   { Spreadsheet }
                       lnkInternet);  { Internet Document }
    { Update DocTypeName in LettrDlg.Pas when more added }

    btLetterType  = Record
              {002}   CustomKey : String[20];          {  AccCode(6) + Date(8) + Time(6) }
              {022}   Spare1    : Array[1..6] of Byte;
              {029}   UserKey   : String[20];          {  UserName + CompName }
              {050}   Spare3K   : String[10];          {  Spare K }

              {061}   AccCode   : String[10];          {  Cust/Supp Account Code }
              {071}   LtrDate   : LongDate;            {  Date letter added }
              {079}   LtrTime   : TimeTyp;             {  Time letter added }
              {085}   LtrDescr  : String[100];         {  Users Description of letter }
              {186}   LtrPath   : String[12];          {  Filename of letter: eg. COMP01.001 }
              {199}   UserCode  : String[10];          {  Login ID of User who added letter }
              {209}   Version   : btLetterDocType;     {  Version Id of Letter creation method }
              {210}
                      Spare600 : Array[1..313] of Byte;
    End;

    btLinkType = Record
              {002}   CustomKey : String[20];          {  AccCode(6) + Date(8) + Time(6) }
              {022}   Spare1    : Array[1..6] of Byte;
              {029}   UserKey   : String[20];          {  UserName + CompName }
              {050}   Spare3K   : String[10];          {  Spare K }

              {062}   AccCode   : String[10];          {  Cust/Supp Account Code }
       { Must be same as btLetterType until Here }
              {073}   LtrDescr  : String[60];         {  Users Description of letter }
              {134}   LtrPath   : String[84];          {  Filename of letter: eg. COMP01.001 }
       { Version must be in same position as in btLetterType }
              {219}   Version   : btLetterDocType;     {  Version Id of Letter creation method }
              {220}   UserCode  : String[10];          {  Login ID of User who added letter }
              {231}   LtrDate   : LongDate;            {  Date letter added }
              {240}   LtrTime   : TimeTyp;             {  Time letter added }
              {251}
                      Spare600 : Array[1..281] of Byte;
    End;


    rtLReasonType  = Record
              {002}   CustomKey :  String[20];      { ReasonCount padded to 4}

              {022}   Spare1    :  Array[1..6] of Byte;

              {029}   UserKey   :  String[20];      {  Desc }

              {050}   Spare3K   :  String[10];      {  Spare K }

              {061}   ReasonDesc:  String[60];      {Reason text}

              {121}   ReasonCount: LongInt;         {Reason Order}

              {125}   Spare     :  Array[1..126]  of Byte;

                      Spare600 : Array[1..280] of Byte;
                   end;


{$ENDIF}





    MiscRecPtr  =  ^MiscRec;

    MiscRec  =  Record
                  RecMfix   :  Char;         {  Record Prefix }
                  SubType   :  Char;         {  Subsplit Record Type }



                      Case SmallInt of
                        1  :  (CustDiscRec   :  CustDiscType);
                        2  :  (MultiLocRec   :  MultiLocType);
                        3  :  (FIFORec       :  FIFOType);
                        4  :  (SOPInpDefRec  :  SOPInpDefType);
                        5  :  (QtyDiscRec    :  QtyDiscType);
                        6  :  (BacsSRec      :  BacsStype);
                        7  :  (SerialRec     :  SerialType);
                        8  :  (BankMRec      :  BankMType);
                        9  :  (IrishVATRec   :  IrishVATType);

                        {$IFDEF ExWin}

                          10 :  (btCustomREc :  btCustomType);
                          11 :  (btLetterRec :  btLetterType);
                          12 :  (btLinkRec   :  btLinkType);

                          13  : (B2BInpDefRec  :  B2BProcType);

                          14  : (AllocSRec     :  allocstype);

                          15  :  (rtReasonRec  :   rtLReasonType);

                        {$ENDIF}

                    end;


    Misc_FilePtr   =   ^Misc_FileDef;

    Misc_FileDef   =   Record
                         RecLen,
                         PageSize,
                         NumIndex  :  SmallInt;
                         NotUsed   :  LongInt;
                         Variable  :  SmallInt;
                         Reserved  :  array[1..4] of Char;
                         KeyBuff   :  array[1..MINofSegs] of KeySpec;
                         AltColt   :  AltColtSeq;
                       end;




    { ================ Job Misc Control File ============= }

Const
  JMiscF    =     10;

  JMNofKeys =     3;

  JMK       =     0;
  JMSecK    =     1;
  JMTrdK    =     2;

  JMNofSegs =     6;



Type
    { ================ Employee Record ================ }


    EmplType    = Record
               {002}  EmpCode   :  String[10];   {  Variable Key }

               {012}  Spare     :  Array[1..4] of Byte;

               {017}  Surname   :  String[20];   {  Auto Extracted Surname }
               {038}  Supplier  :  String[10];   {  Link to Supplier Record if Subcontracter.}
               {049}  EmpName   :  String[30];   {  Full Employee Name }

               {080}  Addr      :  AddrTyp;      {  Employee's Address  }
               {111   2}
               {142   3}
               {173   4}
               {204   5}
               {235}  Phone     :  String[20];   {  }
               {256}  Fax       :  String[20];   {  }
               {277}  Phone2    :  String[20];   {  Mobile Phone }
               {297}  EType     :  Byte;         {  Employee Type relates to O/P/S }
               {298}  TimeDR    :  Array[BOff..BOn] of
                                   LongInt;      {Time Sheet Debit (Off)/Credit (On)}

               {307}  CCDep     :  CCDepType;    {  Default CC/Dep  }
               {315}  PayNo     :  String[10];   {  External payroll No.}
               {326}  CertNo    :  String[30];   {  714 Cert No.}
               {357}  CertExpiry:  LongDate;     {  715 Cert Expiry }
               {365}  JETag     :  Boolean;      {  Record Tagged }

               {$IFDEF EXWin}

                 {366}  UseORate  :  Byte;      {  Use pay rates setup for employee only.
                                                   0 = Global/Own/Job
                                                   1 = Own Only
                                                   2 = Global/Job/Own
                                                   3 = Job Only }

               {$ELSE}

                 {366}  UseORate  :  Boolean;      {  Use pay rates setup for employee only }

               {$ENDIF}

               {368}  UserDef1  :  String[20];         { User def 1 string }
               {389}  UserDef2  :  String[20];         { User def 2 string }
               {409}  NLineCount:  LongInt;      {  Notepad line count }
               {413}  GSelfBill
                                :  Boolean;      {  }
               {414}  GroupCert :  Boolean;      {  Link Cert to all same suppliers employees}
               {415}  CISType   :  Byte;         {  Link to CIS reporting }
                                                 {  0 = N/A
                                                    1 = CIS4T. = IRL C2 No RCT47. Take tax
                                                    2 = CIS5. = IRL C2 + RCT47. No Tax.
                                                    3 = CIS6   No tax
                                                    4 = CIS4P. No Expiry
                                                    5 = CIS5 Partner}
               {417}  UserDef3  :  String[20];         { User def 3 string }
               {438}  UserDef4  :  String[20];         { User def 4 string }

               {459}  ENINo     :  String[10];   {National Ins No. Uk/ Serial No. IRL}

               {469}  LabPLOnly :  Boolean;      {For sub contractors, block time sheets as labour comes from PL}

               {471}  UTRCode   :  String[10];   {Unique Tax Ref}

               {482}  VerifyNo  :  String[13];   {HMRC Verification No.}

               {495}  Tagged    :  Byte;         {Tag for process}

               {496}  CISSubType:  Byte;         {CIS340 Subcontractor Type. 0 = N/A. 1 = Soletrader. 2 = Partnership. 3 = Trust. 4 = Company}

                      // MH 01/02/2010 (v6.3): Added new fields for Web Extensions
                      emEmailAddr : String[100];
                      //SSK 15/11/2017 ABSEXCH-19352 : Added new fields for GDPR
                      emStatus : TEmployeeStatus;                               {Employee Open/Closed status}
                      emAnonymisationStatus : TEntityAnonymisationStatus;       {Employee anonymisation status}
                      emAnonymisedDate : LongDate;                              {Anonymised Date[YYYYMMDD]}
                      emAnonymisedTime : String[6];                             {Anonymised Time[HHMMSS]}
                      Spare600    : Array[1..285] of Char;
(*
               {497}  Spare2    :  Array[1..14] of Byte;

                      Spare600    : Array[1..390] of Char;
*)
                    end;


    { ================ Job Type Record ================ }

    JobTypeType  = Record
               {002}  JobType   :  String[10];   {  Variable Key }

               {012}  Spare     :  Array[1..4] of Byte;

               {017}  JTNameCode:  String[20];   {  Job Type Name NDX }
               {038}  Spare3    :  String[10];   {  }

               {049}  JTypeName :  String[30];   {  Full Job Type Name }

               {079}  JTTag     :  Boolean;

               {080}  Spare2    :  Array[1..431] of Byte;
                        Spare600    : Array[1..390] of Char;
                    end;


    { ================ Job Analysis Record ================ }

    JobAnalType  = Record
               {002}  JAnalCode :  String[10];   {  Variable Key }

               {012}  Spare     :  Array[1..4] of Byte;

               {017}  JANameCode:  String[20];   {  Job Anal Name NDX }
               {038}  JMNDX3    :  String[10];   {  }

               {049}  JAnalName :  String[30];   {  Full Job Anal Name }

               {079}  JAType    :  SmallInt;      {  Relates to R/M/O/L }
               {081}  WIPNom    :  Array[BOff..BOn] of
                                   LongInt;      {  WIP Nom (Off)/ PLNom (On) }

               {089}  AnalHed   :  SmallInt;      {  Relates to 1-10 Major Anal Headings }

               {091}  JATag     :  Boolean;      {  Tagged Flag }

               {092}  JLinkLT   :  Byte;         { Link to Line Type }

               {$IFDEF ExWin}
                 {093}  CISTaxRate  :  Char;     {Taxable activity CIS Rate}
                 {094}  UpliftP     :  Double;   {Uplift on cost %}
                 {102}  UpliftGL    :  LongInt;  {Uplift GL Code + reversal}
                 {106}  RevenueType :  Byte;     {Link to Revenue activity for valuation}

                 {107}  JADetType   :  Byte;     {Deduction type, 0=% or 1=value}
                 {108}  JACalcB4Ret :  Boolean;  {Deduction calculated before Retnetion applied}
                 {109}  JADeduct    :  Double;   {Deduction value}
                 {117}  JADedApply  :  Byte;     {Deduction applied to Anal types. 0= All. 1 Labour. 2= Materials.
                                                  3= Lab & Mat. 4 = Overheads}
                 {118}  JARetType   :  Byte;     {Retnetion type. 0=Standrad, 1=Interim, 2=Practical, 3=Final}
                 {119}  JARetValue  :  Double;   {% Value of retnetion}
                 {127}  JARetExp    :  Byte;     {Basis of Retentiopn expiry. 0= Months. 1 = Years. 2 = On Practical
                                                  3 = On Final Application}
                 {128}  JARetExpInt :  Byte;     {Expity inerval 1-12}
                 {129}  JARetPres   :  Boolean;  {Preserve through to retentions}
                 {130}  JADedComp   :  Byte;     {Calculate deduction as 0, Normal, 1 compound deduction, 2 Contra}
                 {132}  JAPayCode   :  String[5]; {Link to payroll deduction code}
                 {136}  Spare2      :  Array[1..374] of Byte;

                 
               {$ELSE}

                 {093}  Spare2    :  Array[1..418] of Byte;

               {$ENDIF}

                        Spare600    : Array[1..390] of Char;
                    end;






    JobMiscPtr   =  ^JobMiscRec;


    JobMiscRec   =  Record
                      RecPfix   :  Char;         {  Record Prefix }
                      SubType   :  Char;         {  Subsplit Record Type }



                      Case SmallInt of

                        1  :  (EmplRec       :  EmplType);
                        2  :  (JobTypeRec    :  JobTypeType);
                        3  :  (JobAnalRec    :  JobAnalType);


                    end;


    JobMisc_FilePtr   =   ^JobMisc_FileDef;

    JobMisc_FileDef   =   Record
                             RecLen,
                             PageSize,
                             NumIndex  :  SmallInt;
                             NotUsed   :  LongInt;
                             Variable  :  SmallInt;
                             Reserved  :  array[1..4] of Char;
                             KeyBuff   :  array[1..JMNofSegs] of KeySpec;
                             AltColt   :  AltColtSeq;
                           end;





Const
    { ====================== Job Header Record =========================== }



  JobF       =   11;

  JRNofKeys  =   8;
  JobCodeK   =   0;
  JobFolioK  =   1;
  JobCatK    =   2;
  JobDescK   =   3;
  JobCompCK  =   4;
  JobCompDK  =   5;
  JobAltK    =   6;
  JobCustK   =   7;


  JRNofSegs  =   11;



Type

     JobRecPtr  = ^JobRecType;

     JobRecType = Record
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
       {159}       StartDate    :    LongDate;           { Start Date }
       {168}       EndDate      :    LongDate;           { End Date }
       {177}       RevEDate     :    LongDate;           { Revised completion date }
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

       // CJS 2011-09-29: ABSEXCH-11711 - New Job Record Udef Fields.  Removed
       //                 EXWIN directive, and consolidated spare fields.

       {317}  DefRetCurr  :  Byte;       {Default currency to use on retentions}

       {319}  JPTOurRef   :  String[10]; {Stored JPT Reference}
       {330}  JSTOurRef   :  String[10]; {Stored JST Reference}
       {341}  JQSCode     :  String[20]; {QS Code}
       UserDef5  : String[30];
       UserDef6  : String[30];
       UserDef7  : String[30];
       UserDef8  : String[30];
       UserDef9  : String[30];
       UserDef10 : String[30];
       // Job has been anonymised //HV 16-11-2017 2018 R1, ABSEXCH-19348: GDPR - JobHead Database Changes
       jrAnonymised : Boolean;
       jrAnonymisedDate : LongDate;     // YYYYMMDD
       jrAnonymisedTime : String[6];    // HHMMSS  
       Spare2    : Array[1..87] of Byte;
     end;



     JobRec_FilePtr = ^JobRec_FileDef;

     JobRec_FileDef = Record
          RecLen,
          PageSize,
          NumIndex  :  SmallInt;
          NotUsed   :  LongInt;
          Variable  :  SmallInt;
          Reserved  :  array[1..4] of Char;
          KeyBuff   :  array[1..JRNofSegs] of KeySpec;
          AltColt   :  AltColtSeq;
        end;



    { ================ Job Details File ============= }

Const
  JDetlF    =     12;

  JDNofKeys =     7;

  JDLedgerK =     0;
  JDAnalK   =     1;
  JDStkK    =     2;
  JDEmpK    =     3;
  JDPostedK =     4;
  JDLookK   =     5;
  JDHedK    =     6;

  JDNofSegs =     17;



  GERPPos   =     0;   // RecPFix + SubType
  GEJDLPos  =     3;   // LedgerCode
  GEJDAPos  =     28;  // AnalKey   {* Less 1 extra for length byte *}
  GEJDSPos  =     49;  // StockKey  {       "                       *}
  GEJDEPos  =     87;  // EmplKey
  GEJDHPos  =    152;  // HedKey    {*      "                       *}
  GEJDCPos  =    166;  // ActCr
  GEJDYPos  =    167;  // ActYr
  GEJDPPos  =    168;  // ActPr
  GEJDOPos  =    169;  // LineFolio
  GEJDIPos  =    254;  // Invoiced
  GEJDJPos  =    277;  // PostedRun



Type
    { ================ Job Actuals Record ================ }

    { RecPFix:=JBRCode;

      SubType:=JBECode;}

    JobActType    = Record
               {002}  LedgerCode   :  String[21];   {  JobCode + Posted + Currency +Invoiced + Date }

               {023}  Spare        :  Array[1..3] of Byte;

               {027}  AnalKey      :  String[20];   {  JobCode + AnalCode }
               {048}  StockKey     :  String[26];   {  JobCode + StockCode }
               {075}  AnalCode     :  String[10];   {  Link to Anal Record }
               {086}  EmplKey      :  String[21];   {  EmplCode + Matched + JobCode + }
               {108}  RunKey       :  String[22];   {  PostedRun + JobCode + Date }
               {131}  LookKey      :  String[19];   {  LineFolio + LineNo + Stop}
               {151}  HedKey       :  String[14];   {  JobCode + JAType}
               {165}  ActCurr      :  Byte;         {  Line Currency }
               {166}  ActYr        :  Byte;         {  Line Year }
               {167}  ActPr        :  Byte;         {  Line Period }
               {168}  Posted       :  Boolean;      {  Line Posted }
               {169}  LineFolio    :  LongInt;      {  Folio Number of Lined Line }
               {173}  LineNo       :  LongInt;      {  Line No. of Linked Line }
               {178}  LineORef     :  String[10];   {  Doc No. of original Doc}
               {189}  JobCode      :  String[10];   {  Parent JobCode }
               {200}  StockCode    :  String[20];   {  Optional Stock Code}
               {221}  JDate        :  LongDate;     {  Entry Date }
               {229}  Qty          :  Double;       {  Original Qty }
               {237}  Cost         :  Double;       {  Original Price }
               {245}  Charge       :  Double;       {  Charge out Price}
               {253}  Invoiced     :  Boolean;      {  Been on Invoice }
               {255}  InvRef       :  String[10];   {  Doc Link to Sales Invoice }
               {266}  EmplCode     :  String[10];   {  Employee Code }
               {276}  JAType       :  Byte;         {  Anal Line Type 1-10 }
               {277}  PostedRun    :  LongInt;      {  Line Posted Status }
               {281}  Reverse      :  Boolean;      {  Reverse WIP element }
               {282}  ReconTS      :  Boolean;      {  Reconcilled against time sheet }
               {283}  Reversed     :  Boolean;      {  Line has been reversed }
               {284}  JDDT         :  DocTypes;     {  Document Type }
               {285}  CurrCharge   :  Byte;         {  Currency of Charge }
               {287}  ActCCode     :  String[10];   {  Line Account Code }
               {297}  HoldFlg      :  Byte;         {  Line being held }
               {298}  Post2Stk     :  Boolean;      {  Posted ok to stk budget }
               {299}  PCRates      :  CurrTypes;    {  Currency rate at posting time }
               {311}  Tagged       :  Boolean;      {  Tagged for invoicing }
               {312}  OrigNCode    :  LongInt;      {  Nominal Code Job detail posted to }
               {316}  JUseORate    :  Byte;         {  Forces the conversion routines to apply non tri rules *}
               {317}  PCTriR       :  TriCurType;   {* Details of Main Triangulation *}
               {338}  JPriceMulX   :  Double;       {  Actual price multiplier }

               {$IFDEF ExWin}
                 {346}  UpliftTotal
                                 :  Double;       {Value of uplift contained within Cost}
                 {354}  UpliftGL :  LongInt;      {GL code to be used as part of reversal}

                 {358}  Spare2       :  Array[1..126] of Byte;

               {$ELSE}

                 {346}  Spare2       :  Array[1..138] of Byte;

               {$ENDIF}

                        Spare600    : Array[1..353] of Char;
                    end;


    { ================ Job Retention Record ================ }

    {RecPfix:=JARCode;

     SubType:=JBPCode;}


    JobRetType    = Record
               {002}  RetenCode    :  String[21];   {  JobCode + Currency + Invoiced + Date }

               {023}  Spare        :  Array[1..3] of Byte;

               {027}  InvoiceKey   :  String[20];   {  Invoiced + Due Date + JobCode  }
               {048}  SpareNDX1    :  String[26];   {  JobCode + StockCode + Currency }
               {075}  AnalCode     :  String[10];   {  Analysis Link to a revenue code }
               {086}  SpareNDX2    :  String[21];   {  EmplCode + Matched + JobCode + }
               {108}  SpareNDX3    :  String[22];   {  PostedRun + JobCode + Date }
               {131}  SpareNDX4    :  String[19];   {  JobCode + LineFolio + LineNo + Stop}
               {151}  SpareNDX5    :  String[14];   {  JobCode + JAType}
               {165}  OrgCurr      :  Byte;         {  Line Currency }
               {166}  RetYr        :  Byte;         {  Line Year }
               {167}  RetPr        :  Byte;         {  Line Period }
               {168}  Posted       :  Boolean;      {  Line Posted }
               {169}  RetDisc      :  Double;       {  Retention % }
               {177}  RetCurr      :  Byte;         {  Retention currency }
               {178}  RetValue     :  Double;       {  Value of Retention }
               {187}  JobCode      :  String[10];   {  Parent JobCode }
               {198}  RetCrDoc     :  String[10];   {  Retention Auto Generated Credit Doc }
               {209}  RetDate      :  LongDate;     {  Retention trigger Date }
               {218}  RetDoc       :  String[10];   {  Doc Retention is against can be blank }
               {228}  Invoiced     :  Boolean;      {  Been on Invoice }
               {230}  RetCustCode  :  String[10];   {  Account code for Doc }
               {241}  OrigDate     :  LongDate;     {  Entry Date }
               {250}  RetCCDep     :  CCDepType;    {  Default CC/Dep Type }
               {256}  AccType      :  Char;         {  Account Type Cust/Supp }
               {257}  DefVATCode   :  Char;         {  Default VAT code to be used on Retention *}

               {$IFDEF ExWin}

                 {258}  RetCISTax    :  Double;       {  Amount of CIS Tax to retain }
                 {266}  RetCISGross  :  Double;       {  Corresponding CIS Gross }
                 {275}  RetCISEmpl   :  String[10];   {  CIS Empl Code }

                  {285}  RetAppMode  :  Byte;       {Special indicator pertaining to retnetions via applications
                                                     0 = Normal. 1 = One sided retention. 2 = VAT deferment retention}
                  {286}  Spare2       :  Array[1..197] of Byte;
                 
               {$ELSE}

                 {258}  Spare2       :  Array[1..225] of Byte;

               {$ENDIF}

                        Spare600    : Array[1..353] of Char;
                    end;


    {$IFDEF ExWin}

      {RecPFix:=JATCode;

       SubType:=JBSCode;}

         { ================ Job CIS Voucher Record ================ }

        JobCISType    = Record
               {002}  CISvCode1    :  String[21];   {  EmplCode + CISDate}

               {023}  Spare        :  Array[1..3] of Byte;

               {027}  CISvCode2    :  String[20];   {  CISDate + EmplCode + CIS Type}
               {048}  CISCertNo    :  String[26];   {  Voucher No. }
               {075}  CISVORef     :  String[10];   {  Link to single transaction }

               {086}  CISvDateS    :  String[21];   {  Date of CIS Period + SuppCode +CIS Type }
               {108}  CISFolio     :  String[10];   {  CISvFolio + Stopk }
               {119}  CISVNINo     :  String[11];   {  NI No }

               {131}  CISVSDate    :  String[19];   {  SuppCode + CISDate }
               {151}  CISVCert     :  String[14];   {  Employee's cert no at time of voucher production }


	       {165}  NdxFill1     :  Array[1..3] of Char;  {Must be set as some indexs depend on this being non #0)
               {168}  Spare3       :  Array[1..5] of Byte;
	       {173}  CISvGrossTotal
                                   :  Double;	  {Amount of material in run}
	       {181}  CISvManualTax:  Boolean;	  {Tax was overridden}
	       {189}  CISvAutoTotalTax
                                   :  Double;	  {Calculated value of tax from transactions}
               {197}  CISTaxableTotal
                                   :  Double;     {Amount tax based on}
               {205}  CISCType     :  Byte;       {CIS Type 4,5,6}
               {206}  CISCurr      :  Byte;       {VAT Currency at time of generation}

               {207}  Spare1	   :  Array[1..2] of byte;

	       {209}  CISvNlineCount
                                   :  LongInt;	  {Notes Line Counter}
               {214}  CISAddr      :  AddrTyp;    { Address of sub contractor}
               {369}  CISBehalf    :  String[80]; {Note on behalf of memo}
               {449}  CISCorrect   :  Boolean;    {This is a correction and should be noted as such}
               {450}  CISvTaxDue   :  Double;	  {Amount to be reported, could be manual}

               {459}  CISVERNo  :  String[13];  {* CIS 340 verification no. *}
               {472}  CISHTax   :  Byte;        {* CIS 340 High tax indicator 1=High, 4 = Low all others = zero rate*}
               {473}  Spare2       :  Array[1..11] of Byte;

                 Spare600    : Array[1..360] of Char;
             end;
    {$ENDIF}


    JobDetlPtr   =  ^JobDetlRec;


    JobDetlRec   =  Record
                      RecPfix   :  Char;         {  Record Prefix }
                      SubType   :  Char;         {  Subsplit Record Type }



                      Case SmallInt of

                        1  :  (JobActual     :  JobActType);
                        2  :  (JobReten      :  JobRetType);

                        {$IFDEF ExWin}
                          3  :  (JobCISV   :  JobCISType);
                        {$ENDIF}

                    end;


    JobDetl_FilePtr   =   ^JobDetl_FileDef;

    JobDetl_FileDef   =   Record
                             RecLen,
                             PageSize,
                             NumIndex  :  SmallInt;
                             NotUsed   :  LongInt;
                             Variable  :  SmallInt;
                             Reserved  :  array[1..4] of Char;
                             KeyBuff   :  array[1..JDNofSegs] of KeySpec;
                             AltColt   :  AltColtSeq;
                           end;











    { ================ Job Ctrl File ============= }

Const
  JCtrlF    =     13;

  JCNofKeys =     2;

  JCK       =     0;
  JCSecK    =     1;

  JCNofSegs =     4;



Type
    { ================ Job Budget Record ================ }


    JobBudgType    = Record
               {002}  BudgetCode   :  String[27];   {  JobCode +Anal Code/Stock Code+ Currency }

               {029}  Spare        :  Array[1..4] of Byte;

               {034}  Code2Ndx     :  String[21];   {  Second Index }
               {056}  AnalCode     :  String[10];   {  Link to Anal Record }
               {066}  HistFolio    :  LongInt;      {  Anal Folio Number for History }

               {071}  JobCode      :  String[10];   {  Parent JobCode }
               {082}  StockCode    :  String[20];   {  Optional Stock Code}
               {102}  BType        :  Byte;         {  Relates to R/O/L/M }
               {103}  ReCharge     :  Boolean;      {  Charge Item On }
               {104}  OverCost     :  Double;       {  Overhead on Cost }
               {112}  UnitPrice    :  Double;       {  Charging Price }
               {120}  BoQty        :  Double;       {  Original Qty }
               {128}  BRQty        :  Double;       {  RevisedQty }
               {136}  BoValue      :  Double;       {  Original Value }
               {144}  BRValue      :  Double;       {  Revised Value }
               {152}  CurrBudg     :  Byte;         {  Budget Currency Not used - forms part of index}
               {153}  PayRMode     :  Boolean;      {  PayRate Mode }
               {154}  CurrPType    :  Byte;         {  PayRate Currency }
               {155}  AnalHed      :  Byte;         {  Major Heading Type 1-10 }

               {$IFDEF ExWin}
                 {156}  OrigValuation
                                 :  Double;       {Initial valuation}
                 {164}  RevValuation
                                 :  Double;       {Revised valaution}

                 {172}  JBUpliftP:  Double;       {Uplift override}

                 {180}  JAPcntApp:  Double;       {% of budget to be applied for on next valuation}
                 {188}  JABBasis :  Byte;         {Basis of valuation. 0 = incremental. 1 = Gross/YTD}


                 {$IFDEF EX601}

                   {189}  JBudgetCurr
                                   :  Byte;       {  Budget Currency of Original and Revised budgets }

                   {190}  Spare2   :  Array[1..65] of Byte;

                 {$ELSE}

                   {189}  Spare2   :  Array[1..66] of Byte;

                 {$ENDIF}

               {$ELSE}
                 {156}  Spare2       :  Array[1..99] of Byte;

               {$ENDIF}
                    end;

    { ================ Employee Pay Rates Record ================ }


    EmplPayType    = Record
               {002}  EmplCode     :  String[27];   {  EmpCode +Anal Code/Stock Code+ Currency}

               {029}  Spare        :  Array[1..4] of Byte;

               {034}  ECodeNdx     :  String[21];   {  EmpCode + Currency + Anal Code/Stock Code}
               {056}  EAnalCode    :  String[10];   {  Link to Anal Record }

               {067}  EmpCode      :  String[10];   {  Parent JobCode }
               {078}  EStockCode   :  String[20];   {  Optional Stock Code}
               {099}  PayRDesc     :  String[30];   {  Pay Rate Description }
               {129}  Cost         :  Double;       {  Employee Cost }
               {137}  ChargeOut    :  Double;       {  Charging Price }
               {145}  CostCurr     :  Byte;         {  Cost Currency }
               {146}  ChargeCurr   :  Byte;         {  Charge Currency }
               (* MH 07/01/97 - changed to smallint
               {147}  PayRFact     :  Integer;      {  Payroll factor }
               {149}  PayRRate     :  Integer;      {    "     Rate }
               *)
               {147}  PayRFact     :  SmallInt;      {  Payroll factor }
               {149}  PayRRate     :  SmallInt;      {    "     Rate }
               {151}  Spare2    :  Array[1..104] of Byte;


                    end;



    JobCtrlPtr   =  ^JobCtrlRec;


    JobCtrlRec   =  Record
                      RecPfix   :  Char;         {  Record Prefix }
                      SubType   :  Char;         {  Subsplit Record Type }



                      Case SmallInt of

                        1  :  (JobBudg       :  JobBudgType);
                        2  :  (EmplPay       :  EmplPayType);


                    end;


    JobCtrl_FilePtr   =   ^JobCtrl_FileDef;

    JobCtrl_FileDef   =   Record
                             RecLen,
                             PageSize,
                             NumIndex  :  SmallInt;
                             NotUsed   :  LongInt;
                             Variable  :  SmallInt;
                             Reserved  :  array[1..4] of Char;
                             KeyBuff   :  array[1..JCNofSegs] of KeySpec;
                             AltColt   :  AltColtSeq;
                           end;



     { =================== Report Scratch Record =================== }




Const
  ReportF     =     17;


  RpNofKeys   =     1;
  RpK         =     0;

  RpNofSegs   =     1;


  {* RepScr Modes used so far

             1    =  SOP Picking List, non re-entrant
             3-4  =  Back Order Report SQU-SOR
             6    =  Prod Break down & Stock Recon report.
             7    =  Serial Number Invoice printout, Invoice in Bin Loc +Stk Code order
             8    =  Product labels.
             9    =  Job Costing Detailed Anal Report
            10    =  Job Costing Customer Exposure Report
            11    =  Purchase Order Print Queue.
            12    =  MDC Ageing Report File
            13    =  Extended VAT Report File
            14    =  Intrastat Report File
            15    =  Stock Valuation Report
            16    =  WOR Print Queue.
            17-19 =  WOR Shortages + Status Reports.
            20    =  Sales Accrual report
            21    =  CIS EOY Return report
            22    =  MC Revaluation
            23    =  Bin Reports
            24    =  Job Costing Application reports
            25    =  Job Costing Payments due report
            26    =  Finished Goods G/L Code driver for FG Recon report.
            27    =  Returns Report
     2000-3000    =  SOP Match on line
     9000-9999    =  Report Generator

  *}

Type

     RepScrPtr   =  ^RepScrRec;

     RepScrRec   =   Record
                   {002}   AccessK   :  String[100];
                   {102}   RepFolio  :  LongInt;
                   {106}   FileNo    :  SmallInt;
                   {108}   KeyPath   :  SmallInt;
                   {110}   RecAddr   :  LongInt;
                   {115}   KeyStr    :  String[100];
                   {215}   UseRad    :  Boolean;
                   {216}   Spare     :  Array[1..41] of
                                          Byte;
                     end;



     Rep_FilePtr = ^Rep_FileDef;

     Rep_FileDef = Record
          RecLen,
          PageSize,
          NumIndex  :  SmallInt;
          NotUsed   :  LongInt;
          Variable  :  SmallInt;
          Reserved  :  array[1..4] of Char;
          KeyBuff   :  array[1..RpNofSegs] of KeySpec;
          AltColt   :  AltColtSeq;
        end;




    { ===================== System Set-up Control Record ==================== }


Const
  { == System Constants == }

  SysF         =  15;

  SNofKeys     =  1;
  SysK         =  0;


  SNofSegs     =  1;

  MaxForms     = 120;

  {v4.32, please note that the windows rebuild system has a hard coded record structure for this.
          If it ever changes, this needs to be reflected in the
          windows version}

Type

  VATRec = Record
              VAT       :  Array[VATType] of
                          Record
                            Code  :  Char;
                            Desc  :  String[10];
                            Rate  :  Real;
                            Spare :  Byte;
                            Include           {Include Gross Figures}
                                  : Boolean;
                            Spare2: Byte;
                            Spare3: Byte;
                          end;
              // MH 25/10/2011 v6.9: User Defined Fields configuration moved to new table
              _HideUDF   :   Array[7..11] of Boolean;

              Spare2
                        :   Array[0..1] of Byte;{ Date Last Return }
              VATInterval
                        :   Byte;       { No Months between returns }
              Spare3
                        :   Array[0..6] of Byte; { Last Return + Interval }

              VATScheme :   Char;       { VAT Scheme type }


              OLastECSalesDate           { Record date of last EC Sales Report }
                        :   Date;

              VATReturnDate
                        :   LongDate;   { Date Last Return }

              LastECSalesDate           { Record date of last EC Sales Report }
                        :   LongDate;

              CurrPeriod
                        :   LongDate;       { Last Return + Interval }

              // MH 25/10/2011 v6.9: User Defined Fields configuration moved to new table
              _UDFCaption:   Array[1..22] of String[15];  {* Store user definable label headings
                                                            1 = Acc UD1
                                                            2 = Acc UD2
                                                            3 = Doc UD1
                                                            4 = Doc UD2
                                                            5 = Stock 1
                                                            6 = Stock 2
                                                            7 = Line Type 1
                                                            8 =     "     2
                                                            9 =     "     3
                                                           10 =     "     4
                                                           11 = Acc 3
                                                           12 = ACC 4
                                                           13 = DOC 3
                                                           14 = DOC 4
                                                           15 = Stk 3
                                                           16 = Stk 4
                                                           17 = Line 1
                                                           18 = Line 2
                                                           19 = Line 3
                                                           20 = Line 4
                                                           21 = JC 1
                                                           22 = JC 2

                                                          *}

              // MH 25/10/2011 v6.9: User Defined Fields configuration moved to new table
              _HideLType
                        :   Array[0..6] of Boolean;

              ReportPrnN:   String[50];
              FormsPrnN :   String[50];

              EnableECServices : Boolean;    // Enable EC Services support on transaction lines
              ECSalesThreshold : Double;    // EC Sales Threshold in VAT Currency

              //PR: 07/05/2013 ABSEXCH-13793 v7.0.4 User ID and Password for HMRC website to allow
              //                                    uploading VAT100 report as XML.
              //                                    Change spare from 735 to 647.
              VAT100UserID     : String[32];
              VAT100Password   : String[54];
              VAT100SenderType : String[30];

              Spare     :   Array[1..616] of Byte;
            end;


  VATRecT   =  Record
                 IDCode     :   String[3];
                 VATRAtes   :   VATRec;
               end; {Rec..}


  Curr1PType  =  Array[0..Currency1Page] of
               Record
                 SSymb  :  String[3];
                 Desc   :  String[11];
                 CRates :  CurrTypes;
                 PSymb  :  String[3];
               end;


  Curr1PRec   =  Record
                   IDCode     :   String[3];
                   Currencies :   Curr1PType;
                 end; {Rec..}



  GCur1PType   =  Record
                   TriRates   :   Array[0..Currency1Page] of Double;
                   TriEuro    :   Array[0..Currency1Page] of Byte;
                   TriInvert  :   Array[0..Currency1Page] of Boolean;
                   TriFloat   :   Array[0..Currency1Page] of Boolean;

                   Spare      :   Array[1..651] of Byte;
                   Spare600 : Array[1..791] Of Byte;
                 end; {Rec..}

  GCur1PRec   =  Record
                   IDCode     :   String[3];
                   GhostRates :   GCur1PType;
                 end; {Rec..}





  EDI1Type  =  Record
                 { == VAT EDI Details == }
                 VEDIMethod :   Byte;    { 0 = Disk, 1 = VAN, 2 = Email }
                 VVanMode   :   Byte;    { 0 = AT&T. 1 = BT. 2 = GEIS. 3 = IBM. 4 = INS }
                 VEDIFACT   :   Byte;    { 0 = SEMDEC. 1 = INSTAT }
                 VVANCEId   :   Str50;  { VAN C&E Id }
                 VVANUId    :   Str50;  { Van user Id}
                 VUseCRLF   :   Boolean; { Apply CR/LF to each line for debug }
                 VTestMode  :   Boolean; { Sets test mode to output }
                 VDirPAth   :   String[150]; { File output path }
                 VCompress  :   Boolean; { Apply compresion. Ent only }
                 VCEEmail   :   Str255;  { C&E email address }
                 VUEmail    :   Str255;  { Users Return email address }
                 VEPriority :   Byte;    { Send under what priority }
                 VESubject  :   Str100;  { Email subject heading }
                 VSendEmail :   Boolean; { Send email direct from Enterprise }
                 VIEECSLP   :   String[2];{IE EC SalesList Period}
                 Spare      :   Array[1..109] of Byte;
                 Spare600 : Array[1..797] Of Byte;
               end; {Rec..}

  EDI1Rec   =  Record
                 IDCode     :   String[3];
                 EDI1Value  :   EDI1Type;
               end; {Rec..}


  EDI2Type  =  Record
                 { == Fax/Email Setup == }

                 EmName     :   Str255;   { Email Sender Name }
                 EmAddress  :   Str255;   { Email Sender return address }
                 EmSMTP     :   Str255;   { Email SMTP Server address }
                 EmPriority :   Byte;     { Email Priority }
                 EmUseMAPI  :   Boolean;  { Direct Email via MAPI}
                 FxUseMAPI  :   Byte;     { Direct Fax via 0)eComms, 1)MAPI, 3+)others}
                 FaxPrnN    :   Str50;    { Fax Default Printer }
                 EmailPrnN  :   Str50;    { Email Attachment printer }

                 FxName     :   Str40;    { Fax Header Name }
                 FxPhone    :   Str25;    { Fax Header Phone Number }
                 emAttchMode:   Byte;     { Attachment mode. 0= RPro, 1 = PDF}
                 FaxDLLPath :   String[60];{ Path to call Ent Faxing DLL }
                 Spare      :   Array[1..50] of Byte;
                 Spare600 : Array[1..731] Of Byte;
               end; {Rec..}

  EDI2Rec   =  Record
                 IDCode     :   String[3];
                 EDI2Value  :   EDI2Type;
               end; {Rec..}

  EDI3Type  =  Record
                 { == Spare == }

                 Spare      :   Array[1..992] of Byte;
                 Spare600 : Array[1..791] Of Byte;
               end; {Rec..}

  EDI3Rec   =  Record
                 IDCode     :   String[3];
                 EDI3Value  :   EDI3Type;
               end; {Rec..}


  CustomFType  =  Record
                   // MH 25/10/2011 v6.9: User Defined Fields configuration moved to new table
                   _fCaptions  :  Array[1..100] of String[15];
                   _fHide      :  Array[1..100] of Boolean;

                   { == Spare == }

                   Spare      :   Array[1..7] of Byte;
                   Spare600 : Array[1..76] Of Byte;
                 end; {Rec..}

  CustomFRec   =  Record
                   IDCode     :   String[3];
                   CustomSettings
                              :   CustomFType;
                 end; {Rec..}


  {Custom settings. Page 1

   1    = JC UD 3
   2    = JC UD4
   3-10 = SRC TH 1-4, TL,1-4
   11-18= SOR TH 1-4, TL,1-4
   19-26= PIN TH 1-4, TL,1-4
   27-34= PPY TH 1-4, TL,1-4
   35-42= PPR TH 1-4, TL,1-4
   43-50= NOM TH 1-4, TL,1-4
   51-54= Suppler UD 1-4
   55-58 = ProMan Purchase Prospect UD 1-4  (Caption + Hide)
   59-62 = ProMan Sales Prospect UD 1-4  (Caption + Hide)
   63-66 = Purchase Opportunity (POP) TH UD 1-4  (Caption + Hide)
   67-70 = Purchase Opportunity (POP) TL UD 1-4  (Caption + Hide)
   71-74 = Sales Opportunity (SOP) TH UD 1-4  (Caption + Hide)
   75-78 = Sales Opportunity (SOP) TL UD 1-4  (Caption + Hide)

   Page 2;
   1-8 = ADJ TH 1-4, TL,1-4
   9-17= WOR TH 1-4, TL,1-4
   18-24=TSH TH 1-4, TL,1-4
   25-32=SQU TH 1-4, TL,1-4
   33-40=PQU TH 1-4, TL,1-4
   41-44=EMPL UD1-4

   }

  DEFType   =  Array[1..100] of String[8];
                {  Definition Files
                   1 - Invoice Layout
                   2 - Remittance Advice
                   3 - Statement Layout
                   4 - Quotation
                   5 - Credit Note
                   6 - Customer History
                   7 - Debt Chase 1
                   8 - Debt Chase 2
                   9 - Debt Chase 3
                  10 - Spare! Debt4?
                  11 - Reciept
                  12 - Purchase Quotation
                  13 - Purchase Invoice
                  14 - Purchase Credit Note
                  15 - Nominal Transfers
                  16 - Account Label
                  17 - Account Details inc Notes
                  18 - Batch Entry List
                  19 - Sales Order
                  20 - Sales ProForma
                  21 - Sales Delivery Note
                  22 - Stock Record (Inc Bill Mat)
                  23 - Stock Adjustment Transaction
                  24 - Picking List Consolidated
                  25 - Picking List Single
                  26 - Consignment Note
                  27 - Delivery Label
                  28 - Purchase Order
                  29 - SRI
                  30 - SRF
                  31 - Stock Details
                  32 - Product Labels

                  }


  DEFRec    =  Record
                 Names      :   DEFType;

                 Spare      :   Array[1..85] of Byte;

                 Spare600 : Array[1..798] Of Byte;
               end; {Rec..}



  DEFRecT   =  Record

                 IDCode     :   String[3];

                 DEFFiles   :   DEFRec;

               end; {Rec..}

  JobSRec = Record
              EmployeeNom
                        :   Array[1..6,BOff..BOn] of LongInt;  {O/P/S Dr(Off),Cr(On)}

              GenPPI    :   Boolean;                         { Flag to indicate
                                                               generation of PPI
                                                               instead of NOM}

              PPIAcCode :   String[10];                      { If GenPPI set, specify A/C code }

              SummDesc  :   Array[0..20] of String[20];      { Major Heading Descriptions }

              PeriodBud :   Boolean;
              JCChkACode:   Array[1..5] of                    {1=WIP, 2=S.Ret, 3=P.Ret, 4=Rev 5 Receipts }
                              String[10];                      { Use as auto checking analysis control accounts }

              JWKMthNo	: SmallInt;
              JTSHNoF	: String[9];
              JTSHNoT	: String[9];
              JFName	: String[30];

              JCCommitPin
                        :   Boolean;

              JAInvDate
                        :   Boolean;

              JADelayCert
                        :   Boolean;                         { Do not apply certified values to committed unless
                                                               App marked as certified }
              Spare     :   Array[1..367] of Byte;

              Spare600 : Array[1..803] Of Byte;
            end;




  JobSRecT   =  Record
                 IDCode     :   String[3];

                 JobSetup   :   JobSRec;

               end; {Rec..}


  FormDefsType = Record
    PrimaryForm   : Array [1..MaxForms] Of Str8;
    Descr         : Str30;
    Spare         : Array[1..5] Of Char;
    Spare600 : Array[1..667] Of Byte;
  End; { FormDefsType }

  FormDefsRecType = Record
    IDCode   : String[3];
    FormDefs : FormDefsType;
  end; {Rec..}


// MH 10/01/2017 2017R1 ABSEXCH-17996: Added constants for Module Release Code array entries
Const
  mrcMultiCurrency = 1;          // Multi-Currency
  mrcJobCosting = 2;             // Job Costing
  mrcReportWriter = 3;           // Windows Report Writer
  mrcToolkitRuntime = 4;         // Toolkit DLL / COM Toolkit
  mrcTeleSales = 5;              // Telesales
  mrcAccountStockAnalysis = 6;   // Account Stock Analysis
  mrcEBusiness = 7;              // E-Business
  mrcPaperless = 8;              // Paperless
  mrcOLESave = 9;                // OLE Save Functions
  mrcCommitmentAccounting = 10;  // Commitment Accounting
  mrcTradeCounter = 11;          // Trade Counter
  mrcStdWOP = 12;                // Standard Works Order Processing
  mrcProWOP = 13;                // Professional Works Order Processing
  mrcSentimail = 14;             // Sentimail
  mrcEnhancedSecurity = 15;      // Enhanced Security
  mrcCISRCT = 16;                // CIS/RCT
  mrcAppsVals = 17;              // Applications & Valuations
  mrcFullStock = 18;             // Full Stock Control
  mrcVisualReportWriter = 19;    // Visual Report Writer
  mrcGoodsReturns = 20;          // Goods Returns
  mrcEBanking = 21;              // eBanking
  mrcOutlookDD = 22;             // Outlook Dynamic Dashboard
  mrcImporter = 23;              // Importer

Type
  ModuleRelType = Record
      ModuleSec     : Array[1..50,BOff..BOn] of String[10];
      RelDates      : Array[1..50] of Real;
    CompanyID     : LongInt;
    CompanySynch  : Byte;
    TKLogUCount   : SmallInt;             { Number of users logged into Company through Toolkit / COM Toolkit }
    TrdLogUCount  : SmallInt;             { Number of users logged into Company through Trade Counter }
    CompanyDataType : Byte;                 // MH 30/11/06: Dataset Type - 0=Blank Data, 1=Demo Data

    Spare           : Array[1..46] Of Char;

    Spare600 : Array[1..327] Of Byte;
  End; { ModuleRelType }

  ModRelRecType = Record
    IDCode   : String[3];
    ModuleRel: ModuleRelType;
  end; {Rec..}


{$IFDEF ExWin}


  CISCRec = Record
            CISRate
                     :  Array[CISTaxType] of
                        Record
                          Code  :  Char;
                          Desc  :  String[10];
                          Rate  :  Double;
                          GLCode:  LongInt;
                          RCCDep:  CCDepType;
                          Spare :  Array[1..10] of Byte;

                          {Total 11x42 = 462}
                        end;

            CISInterval
                      :   Byte;       { No Months between returns }
            CISAutoSetPr
                      :   Boolean;    { Auto set date relative to date allocated }
            CISVATCode:   Char;       {Default VAT code to be used on auto tax line}

            // CJS 2014-03-05 - ABSEXCH-15114 - system switch for CIS calculation
            CalcCISOnGross: Boolean;

            Spare3
                      :   Array[0..3] of Byte;

            CISScheme :   Char;       { CIS Scheme type, Not used }

            CISReturnDate
                      :   LongDate;   { Date Last Return }

            CurrPeriod
                      :   LongDate;   { Last Return + Interval }

            CISLoaded :   Boolean;    {CIS Page loaded marker}

            CISTaxRef :   String[20]; {CIS Reporting scheme number}

            CISAggMode:   Byte;       {Aggregate Vouchers by Sub contractor (0) or Payment (1)}
            CISSortMode
                      :   Byte;       {Sort voucher list by Sub contrcator (0) or by Date (1)}
            CISVFolio :   LongInt;    {Internal folio counter}

            CISVouchers
                      :  Array[4..6] of
                         Record
                           Prefix :  String[5];
                           Counter:  Int64;
                           Spare  :  Array[1..10] of Byte;

                           {Total 3x24 = 72}
                         end;

            IVANMode  :   Byte;      { 0 = AT&T. 1 = BT. 2 = GEIS. 3 = IBM. 4 = INS }
            IVANIRId  :   Str50;     {IR EDI Id}
            IVANUId   :   Str50;     {User EDI Id}
            IVANPw    :   Str15;     {VAN Password}
            IIREDIRef :   String[35];{IR EDI Ref for conttractor, defualt to ZZZ9}
            IUseCRLF  :   Boolean;   {Use CRLF for debugging}
            ITestMode :   Boolean;   {Send as test mode}
            IDirPath  :   String[150]; {Output path for file}
            IEDIMethod:   Byte;      {Output to Floppy, EDI, email}
            ISendEmail:   Boolean;   {Send email from wizard}
            IEPriority:   Byte;      {Email priority}

            JCertNo   :  String[20];   {  714 Cert No.}
            JCertExpiry
                      :  LongDate;     {  715 Cert Expiry }
            JCISType  :  Byte;

          {$IFDEF EX603}
            RCTRCV1   :  Char;       {* RCT Reverse Charge Trigger 1*}
            RCTRCV2   :  Char;       {*          "       "         2*}
            RCTUseRCV :  Boolean;    {* RCT Use Reverse Charge calculation *}

    {879}   Spare     :   Array[1..5] of Byte;

          {$ELSE}

    {876}   Spare     :   Array[1..8] of Byte;

          {$ENDIF}


            Spare600 : Array[1..844] Of Byte;
          end;


CISRecT   =  Record
               IDCode     :   String[3];
               CISRates   :   CISCRec;
             end; {Rec..}


CIS340Rec = Record

              CISCNINO  :   String[20];{Contractors NINO}
              CISCUTR   :   String[20];{Contractors UTR}
              CISACCONo :   String[20];{     "      Accounts office No.}

              IGWIRId   :   Str50;     {IR Gateway Id}
              IGWUId    :   Str50;     {User Gateway Id}
              IGWTO     :   Str15;     {Gateway Password}
              IGWIRef   :   String[35];{IR Gateway Ref for contractor, defualt to ZZZ9}
              IXMLDirPath
                        :   String[150]; {Output path for file}

              IXTestMode:   Boolean;    {Force a test mode}
              IXConfEmp :   Boolean;    {Confirm all subcontractors}
              IXVerSub  :   Boolean;    {Verify all subcontractors}
              IXNoPay   :   Boolean;    {No payments due within 6 months}
              IGWTR     :   Str10;
              IGSubType :   Byte;       {Gateway submitter type}
      {384}   Spare     :   Array[1..502] of Byte;

              Spare600 : Array[1..897] Of Byte;
            end;


CIS340RecT = Record
               IDCode     :   String[3];
               CIS340     :   CIS340Rec;
             end; {Rec..}


{$ENDIF}

  SysRec = Record

             IDCode    :  String[3];  {  Select System Set up }

                          Case SmallInt of
                            1  :  (  Opt      :   Char;       {  Option Control       }

                                     OMonWk1  :   Date;       {  Date Financial Yr Start }

                                     PrinYr   :   Byte;       {  No Periods in year }

                                     FiltSNoBinLoc            {Auto filter serial and bin lists when picking by location}
                                              :   Boolean;
                                     KeepBinHist              {Retain bin history when multi bin used }
                                              :   Boolean;
                                     UseBKTheme
                                              :   Boolean;
                                     {Spare5   :   Array[1..1] of Byte;}

                                     UserName :   String[45];{  Registered Users Name }

                                     AuditYr,
                                     AuditPr  :   Byte;

                                     Spare6   :   Byte;

                                     ManROCP  :   Boolean;   {  Manually update RO last price }

                                     VATCurr  :   Byte;      {  Currency of VAT Control }

                                     NoCosDec :   Byte;

                                     CurrBase :   Byte;

                                     MuteBeep :   Boolean;   {  Beep Controller }

                                     ShowStkGP:   Boolean;   {  Show Stock prices as GP }

                                     AutoValStk
                                              :   Boolean;   {  Auto Value Stock by Posting }

                                     DelPickOnly
                                              :   Boolean;

                                     UseMLoc  : Boolean;
                                     EditSinSer
                                              : Boolean;
                                     WarnYRef : Boolean;
                                     UseLocDel: Boolean;
                                     PostCCNom: Boolean;
                                     AlTolVal : Double;
                                     AlTolMode: Byte;
                                     DebtLMode: Byte;
                                     AutoGenVar,
                                     AutoGenDisc,
                                     UseModuleSec,
                                     ProtectPost,
                                     UsePick4All,
                                     BigStkTree,
                                     BigJobTree,
                                     ShowQtySTree,
                                     ProtectYRef,
                                     PurchUIDate,
                                     UseUpliftNC,
                                     UseWIss4All,
                                     UseSTDWOP,
                                     UseSalesAnal,
                                     PostCCDCombo,
                                     UseClassToolB
                                              : Boolean;


                                     WOPStkCopMode
                                              :   Byte;
                                     USRCntryCode
                                              :   String[3];


                                     NoNetDec :   Byte;                  {  No. Dec places on Unit price }

                                     DebTrig  :   Array[1..3] of Byte;   {  No Wks Due before Trigger }


                                     
                                     BKThemeNo:   Byte;

                                     UseGLClass
                                              :   Boolean;

                                     Spare4   :   Array[1..1] of Byte;

                                     
                                     NoInvLines: Byte;       { No Lines to Invoice for page break display }
                                     WksODue   : Byte;       { No Wks before considered odue }
                                     CPr,CYr   : Byte;       { Current Period & Yr }
                                     OAuditDate: Date;       { Date of Last Audit }

                                     TradeTerm : Boolean;    { Flag to Indicate if Trade terms exsist }

                                     { Flags }
                                     { ~~~~~ }
                                     StaSepCr  : Boolean;    { Statement seperate currency }
                                     StaAgeMthd: Byte;       { Statement Ageing Method }
                                     StaUIDate : Boolean;    { Use Invoice date instead of Due date for ageing purposes }
                                     SepRunPost: Boolean;    { Seperate out posting run ctrl lines }
                                     QUAllocFlg: Boolean;    { Sets QU's to allocate stock }
                                     DeadBOM   : Boolean;    { Force BOM to go -ve if no stk }
                                     AuthMode  : Char;       { Authorisation mode, <N>one, <M>anual, <A>uto}

                                     IntraStat
                                               : Boolean;    { Switch IntraStat anal On }

                                     AnalStkDesc
                                               : Boolean;    { analyse Desc Only Product codes via tree ? }
                                     AutoStkVal
                                               : Char;       { Determine Stock Valuation Method,
                                                               0=(S)td, 1=Last (C)ost, 2=(F)IFO, 3=(L)IFO }

                                     AutoBillUp
                                               : Boolean;    { Warn Bill needs updating }
                                     AutoCQNo
                                               : Boolean;    { Suggest Automatic CQ Nos }
                                     IncNotDue
                                               : Boolean;    { Only Include Invoices which are due on Statements }
                                     UseBatchTot
                                               : Boolean;    { Force Batch Totals }
                                     UseStock
                                               : Boolean;    { Switch Stock Control On }
                                     AutoNotes
                                               : Boolean;    { AutoUpdate Notes from Statements & Debt Letters }

                                     HideMenuOpt
                                               : Boolean;    { Hide non password protected menu items }

                                     UseCCDep
                                               : Boolean;    { Stop Use of Cost Centers / Dep }

                                     NoHoldDisc
                                               : Boolean;    { Stop auto until alloc mode }

                                     AutoPrCalc
                                               : Boolean;    { Calculate Period from Date }

                                     StopBadDr
                                               : Boolean;    { Stop Invoice Entry of Bad Debtor }

                                     UsePayIn
                                               : Boolean;    { Paying In Mode Trigger }

                                     UsePasswords
                                               : Boolean;    { Prompt for password Control }

                                     PrintReciept
                                               : Boolean;    { Allow Reciepts to be printed }

                                     ExternCust
                                               : Boolean;    { Addition / Deletion of Customers Controlled Externally }

                                     NoQtyDec
                                               : Byte;       { No Dec Places Qty should be Displayed to }

                                     ExternSIN
                                               : Boolean;    { Addition / Editing of SIN & SCR Controlled Externally }
                                     PrevPrOff
                                               : Boolean;    { Prevent Posting to Previous Periods }
                                     DefPcDisc
                                               : Boolean;    { Discount to be a '%' Only }
                                     TradCodeNum
                                               : Boolean;    { All Supplier & Customer Codes are numeric or end in a digit }
                                     UpBalOnPost
                                               : Boolean;    { Update Customer Balances on Post instead of Real Time }

                                     ShowInvDisc
                                               : Boolean;    { Display Discounted Line of Invoice Screen }

                                     SepDiscounts
                                               : Boolean;    { Post Discounts to separete Nominal }
                                     UseCreditChk
                                               : Boolean;    { Warn if Wks odue }
                                     UseCRLimitChk
                                               : Boolean;    { Warn if Over Credit }

                                     AutoClearPay
                                               : Boolean;    { Auto Mark all items as cleared }

                                     TotalConv : Char;       { Use Co or Xchg rate in level 0 calcs }

                                     DispPrAsMonths
                                               : Boolean;    { Display periods as months, only avail if no pr =12 }


                                     { Constants }
                                     { ~~~~~~~~~ }

                                     NomCtrlCodes
                                               : Array[NomCtrlType] of
                                                 LongInt;


                                     DetailAddr: AddrTyp;

                                     { Defaults }
                                     { ~~~~~~~~ }

                                     DirectCust: String[10];
                                     DirectSupp: String[10];

                                     TermsofTrade
                                               : TradeTermType;

                                     NomPayFrom: LongInt;     { Direct Paymeny auto suggest Code }
                                     NomPayToo : LongInt;     { Direct Reciept   "     "      "  }
                                     // MH 19/06/2015 v7.0.14: Remove old Settlement Discount fields
                                     _Obsolete_SettleDisc: Real;        { Default Settle Discount }
                                     _Obsolete_SettleDays: SmallInt;     {    "       "   Days }
                                     NeedBMUp  : Boolean;     { Flag to determine if Costings update required }

                                     IgnoreBDPW: Boolean;     { Ignore system password }

                                     InpPack   : Boolean;     { Switch Pack input on }

                                     Spare32   : Boolean;     { Include QtyMul in Linr tot Calculation }

                                     VATCode   : Char;        { Default VATCode }
                                     PayTerms  : SmallInt;    {    "    No Days }

                                     OTrigDate : Date;    {  Trigger Date         }

                                     StaAgeInt : SmallInt;    { Statement Ageing Interval }

                                     QuoOwnDate: Boolean;     { Quotes to retain date when converting }

                                     FreeExAll : Boolean;     { Free Stock to exclude allocated figure }

                                     DirOwnCount
                                               : Boolean;     { Directs to have own count }

                                     StaShowOS : Boolean;     { Statements show OS }

                                     LiveCredS : Boolean;     { Credit Status is updated upon ledger entry }

                                     BatchPPY  : Boolean;     { Generate PPY's via Batch payments only }

                                     WarnJC    : Boolean;     { Warn over budget }

                                     TxLateCR  : Boolean;     { Use Enter as Tab }

                                     ConsvMem  : Boolean;     { Start conserving memory by detroying list pages }

                                     DefBankNom               { Default bank account as suggested on PPY }
                                               : LongInt;
                                     UseDefBank: Boolean;

                                     HideExLogo
                                               : Boolean;

                                     AMMThread : Boolean;
                                     AMMPreview: Array[BOff..BOn] of Boolean;
                                     EntULogCount
                                               : LongInt;
                                     DefSRCBankNom             { Default bank account as suggested on SRC }
                                               : LongInt;

                                     SDNOwnDate: Boolean;     { Delivery notes to retain date when converting }

                                     EXISN     : ISNArrayType;
                                     ExDemoVer : Boolean;

                                     DupliVSec : Boolean;      { Signifies duplicate security has been set }

                                     LastDaily : LongInt;      { Time and Date last daily password was used }

                                     { CJS 2013-09-09 - ABSEXCH-14598 - SEPA/IBAN - copy from MRD branch }
                                     OldUserSort  : String[15];
                                     OldUserAcc   : String[20];
                                     
                                     UserRef   : String[28];

                                     SpareBits : array[1..31] of Byte;

                                     GracePeriod : Byte;       // IAO Activation/Grace Period Flag - 0=Activation, 1=Grace


                                     MonWk1,
                                     AuditDate,
                                     TrigDate  : LongDate;    { Dates Various }

                                     ExUsrSec  : String[10];
                                     ExUsrRel  : String[10];
                                     UsrRelDate: Real;
                                     UsrLogCount
                                               : LongInt;
                                     BinMask   : String[10];  {Input Mask for Bin Code}
                                     Spare5a   : String[4];
                                     Spare6a   : String[18];
                                     UserBank  : String[25];

                                     ExSecurity: String[10];  { Automatic Security code }
                                     ExRelease : String[10];  { Matching coded Release Code }

                                     RelDate   : Real;        { Julian Security Release Date }

                                     LastExpFolio
                                               : LongInt;

                                     DetailTel : String[15];  {  User Tel No. }
                                     DetailFax : String[15];  {  User Fax No. }
                                     UserVATReg: String[30];  {  User VAT Reg No. }

                                     // MH 23/03/2009: Added new fields for Advanced Discounts
                                     EnableTTDDiscounts : Boolean;  // SPOP - Enable TTD Discounts
                                     EnableVBDDiscounts : Boolean;  // SPOP - Enable VBD Discounts

                                     // MH 11/10/2010 v6.5: Added for Override Location on TH (for LIVE)
                                     EnableOverrideLocations : Boolean;

                                     //PR: 18/06/2012 v7.0 ABSEXCH-11528 Flag to indicate whether VAT is included in Committed Balances in History.
                                     IncludeVATInCommittedBalance : Boolean;

                                     { CJS 2013-09-09: ABSEXCH-14598 - SEPA/IBAN Changes }
                                     ssBankSortCode: string[22];       // Sort code / BIC (encrypted)
                                     ssBankAccountCode: string[54];    // Account Code / IBAN Code (encrypted)
                                     
                                     //PR: 21/08/2013 MRD1.1.01
                                     ssConsumersEnabled : Boolean;

                                     // MH 21/07/2014: Order Payments
                                     ssEnableOrderPayments : Boolean;

                                     Spare600 : Array[1..714] Of Byte;

                                   );
                            2  :   ( VATRates  : VATRec;
                                   );
                            3   :  ( Currencies: Curr1PType;
                                   );
                            4   :  ( DefFile   : DefRec;
                                   );
                            5   :  ( JobSet    : JobSRec;
                                   );
                            6   :  ( FormDefs  : FormDefsType;
                                   );
                            7   :  ( Modules   : ModuleRelType;
                                   );
                            8   :  ( GhostEuro : GCur1PType;
                                   );
                            9   :  ( EDI1Defs  : EDI1Type;
                                   );
                           10   :  ( EDI2Defs  : EDI2Type;
                                   );
                           11   :  ( EDI3Defs  : EDI3Type;
                                   );
                           12   :  ( CustomFDefs
                                               : CustomFType;
                                   );
                           {$IFDEF ExWin}
                             13  :   ( CISRates  : CISCRec;);
                             14  :   ( CIS340  : CIS340Rec;);

                           {$ENDIF}


           end;



          Sys_FileDef = Record
                  RecLen,
                  PageSize,
                  NumIndex  :  SmallInt;
                  NotUsed   :  LongInt;
                  Variable  :  SmallInt;
                  Reserved  :  array[1..4] of Char;
                  KeyBuff   :  array[1..SNofSegs] of KeySpec;

                end;



                { ============= Preserve Global Variables During a PopUp =========== }

  PopGlobVars    =  Record
                      LocalFn,
                      LocalWrapLen
                                  :  SmallInt;

                      LocalAddch  :  Char;
                      LocalElded,
                      LocalNumOnly,
                      LocalBlindOn,
                      LocalNoAbort,
                      LocalDateInp,
                      LocalWrapRnd
                                  :  Boolean;

                      LocalReal1  :  Real;

                      LocalReal2  :  Real;

                      LocalHelpNo :  LongInt;

                      LocalAtt    :  Byte;


                      { ====== Records ====== }

                      LocalNom    :  ^NominalRec;

                      LocalNHist  :  ^HistoryRec;

                      LocalInv    :  ^InvRec;

                      LocalId     :  ^Idetail;

                      LocalCust   :  ^CustRec;

                      LocalStock  :  ^StockRec;

                      {$IFDEF JC}

                        LocalJobRec
                                  :  JobRecPtr;

                        LocalJobMisc
                                  :  JobMiscPtr;

                        LocalJobCtrl
                                  :  JobCtrlPtr;

                        LocalJobAct
                                  :  JobDetlPtr;

                      {$ENDIF}

                    end;





  NomRepRecPtr  =  ^NomRepRec;
  
                  { ============= Nominal Report Control =========== }

  NomRepRec  =  Record
                  Mode,
                  CommitMode,
                  Fnum,Keypth  :  SmallInt;

                  RPr,RYr,
                  FCr,FTxCr    :  Byte;

                  Pg,Ln        :  SmallInt;

                  F2YrPr       :  NomPrAry;
                  Level,
                  RepLimit,
                  PaLS,PaLE,
                  PBFCompCode,
                  PBFHedCode   :  LongInt;

                  NCCDep       :  CCDepType;

                  DocWant      :  Str10;

                  NTotals,
                  GTotals,
                  BSTotals,
                  PBFTotals    :  Totals;

                  Reptit,
                  CCRepTit     :  Str100;

                  NCCMode      :  Boolean;
                  Ok2Print,
                  NoBotD,
                  IncludeAll,
                  QuoteMode,
                  HasValue,
                  JustNDet,
                  InPaL,
                  OldReport,
                  PaLOn,
                  CCDpTag,
                  TYTDD        :  Boolean;

                  //PR: 22/10/2009 Added to indicate that the report should print its parameters.
                  PrintParameters : Boolean;


                end;

{$IFDEF EXWIN}
  TNHCtrlRec  =  Record
                   NHMode,
                   NBMode,
                   NHPr,
                   NHPrTo,
                   NHYr,
                   NHCr,
                   NHDDRecon,
                   NHFilterMode,
                   NHCommitView,
                   NHTxCr   :  Byte;

                   NHKeyLen :  Integer;

                   NHNomCode:  LongInt;

                   NHYTDMode,
                   NHOSFilt,
                   NHCCMode,
                   NHCCDDMode,
                   NHSDDFilt,
                   NHCuIsaC,
                   NHCommitMode,
                   NHUnpostMode,
                   NHNeedGExt,
                   NHForceYTDNCF
                            :  Boolean;

                   NHKeyCode,
                   NHCCode  :  Str20;

                   NHCDCode,
                   NHLocCode,
                   NHCuCode
                            :  Str10;
                   MainK,
                   AltMainK :  Str255;
                 end;
{$ENDIF}

